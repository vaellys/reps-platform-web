/*
 * Copyright 2002-2012 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.springframework.web.method.annotation;

import java.lang.annotation.Annotation;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.MutablePropertyValues;
import org.springframework.core.MethodParameter;
import org.springframework.core.annotation.AnnotationUtils;
import org.springframework.validation.BindException;
import org.springframework.validation.Errors;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.support.WebDataBinderFactory;
import org.springframework.web.bind.support.WebRequestDataBinder;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.method.support.HandlerMethodReturnValueHandler;
import org.springframework.web.method.support.ModelAndViewContainer;

import com.reps.core.RepsConstant;

/**
 * Resolves method arguments annotated with {@code @ModelAttribute} and handles
 * return values from methods annotated with {@code @ModelAttribute}.
 *
 * <p>
 * Model attributes are obtained from the model or if not found possibly created
 * with a default constructor if it is available. Once created, the attributed
 * is populated with request data via data binding and also validation may be
 * applied if the argument is annotated with {@code @javax.validation.Valid}.
 *
 * <p>
 * When this handler is created with {@code annotationNotRequired=true}, any
 * non-simple type argument and return value is regarded as a model attribute
 * with or without the presence of an {@code @ModelAttribute}.
 *
 * @author Rossen Stoyanchev
 * @since 3.1
 */
public class ModelAttributeMethodProcessor implements HandlerMethodArgumentResolver, HandlerMethodReturnValueHandler {

	protected Log logger = LogFactory.getLog(this.getClass());

	private final boolean annotationNotRequired;

	/** 保存查询条件忽略地址 */
	private final String[] ignoreUrl = { 
			RepsConstant.ACTION_BASE_PATH + "/sys/chooseorganize/list.mvc", 
			RepsConstant.ACTION_BASE_PATH + "/sys/chooseperson/list.mvc",
			RepsConstant.ACTION_BASE_PATH + "/sys/chooseuser/list.mvc" 
		};

	final List<String> ignoreUrlList = Arrays.asList(ignoreUrl);

	/**
	 * @param annotationNotRequired
	 *            if "true", non-simple method arguments and return values are
	 *            considered model attributes with or without a
	 *            {@code @ModelAttribute} annotation.
	 */
	public ModelAttributeMethodProcessor(boolean annotationNotRequired) {
		this.annotationNotRequired = annotationNotRequired;
	}

	/**
	 * @return true if the parameter is annotated with {@link ModelAttribute} or
	 *         in default resolution mode also if it is not a simple type.
	 */
	@Override
	public boolean supportsParameter(MethodParameter parameter) {
		if (parameter.hasParameterAnnotation(ModelAttribute.class)) {
			return true;
		} else if (this.annotationNotRequired) {
			return !BeanUtils.isSimpleProperty(parameter.getParameterType());
		} else {
			return false;
		}
	}

	/**
	 * Resolve the argument from the model or if not found instantiate it with
	 * its default if it is available. The model attribute is then populated
	 * with request values via data binding and optionally validated if
	 * {@code @java.validation.Valid} is present on the argument.
	 * 
	 * @throws BindException
	 *             if data binding and validation result in an error and the
	 *             next method parameter is not of type {@link Errors}.
	 * @throws Exception
	 *             if WebDataBinder initialization fails.
	 */
	@Override
	public final Object resolveArgument(MethodParameter parameter, ModelAndViewContainer mavContainer, NativeWebRequest request, WebDataBinderFactory binderFactory) throws Exception {

		String name = ModelFactory.getNameForParameter(parameter);
		Object attribute = (mavContainer.containsAttribute(name)) ? mavContainer.getModel().get(name) : createAttribute(name, parameter, binderFactory, request);

		/************************* 自定义添加Start ********************************/
		MutablePropertyValues mpvs = null;
		// boolean hasCookie = false;
//		HttpServletResponse serlvetResponse = ((NativeWebRequest) request).getNativeResponse(HttpServletResponse.class);
		HttpServletRequest serlvetRequest = ((NativeWebRequest) request).getNativeRequest(HttpServletRequest.class);
		if (serlvetRequest != null) {
			// Map<String, String> map = CookieUtil.getCookies(serlvetRequest);
			// hasCookie =
			// map.containsKey(SystemContext.REPS_QUERY_CACHE_COOKIE_NAME) &&
			// "true".equals(map.get(SystemContext.REPS_QUERY_CACHE_COOKIE_NAME));
			String requestUrl = serlvetRequest.getRequestURI();
			String contextPath = serlvetRequest.getContextPath().equals("/") ? "" : serlvetRequest.getContextPath();
			String path = contextPath.equals("/") ? requestUrl : StringUtils.replace(requestUrl, contextPath, "");
			boolean isList = requestUrl.matches(".*?list.mvc.*?");
			if (!ignoreUrlList.contains(path) && isList) {
				String method = serlvetRequest.getMethod();
				String referer = StringUtils.trimToEmpty(request.getHeader("Referer"));
				if (StringUtils.indexOf(referer, requestUrl) != -1 && "POST".equals(method)) {
					Map<String, String[]> parameterMap = request.getParameterMap();
					if (parameterMap != null && !parameterMap.isEmpty()) {
						// CookieUtil.setCookie(serlvetRequest, serlvetResponse,
						// SystemContext.REPS_QUERY_CACHE_COOKIE_NAME, "true");
						serlvetRequest.getSession().setAttribute(requestUrl, new HashMap<String, String[]>(parameterMap));
					}
				} else {
					Object obj = serlvetRequest.getSession().getAttribute(requestUrl);
					if (obj != null) {
						Map<String, String[]> parameterMap = request.getParameterMap();
						@SuppressWarnings("unchecked")
						Map<String, String[]> sessionParameterMap = (Map<String, String[]>) obj;
						if (!parameterMap.isEmpty()) {
							for (Entry<String, String[]> entry : parameterMap.entrySet()) {
								String parameterStrs[] = entry.getValue();
								if (parameterStrs != null && parameterStrs.length > 0) {
									sessionParameterMap.put(entry.getKey(), entry.getValue());
								}
							}
						}
						mpvs = new MutablePropertyValues(sessionParameterMap);
					}
				}
			}
		}
		/************************* 自定义添加End ********************************/

		WebDataBinder binder = binderFactory.createBinder(request, attribute, name);

		if (binder.getTarget() != null) {
			bindRequestParameters(binder, request);
			validateIfApplicable(binder, parameter);
			if (binder.getBindingResult().hasErrors()) {
				if (isBindExceptionRequired(binder, parameter)) {
					throw new BindException(binder.getBindingResult());
				}
			}
		}

		/********************* 自定义添加Start ***************************/
		// if(mpvs != null && hasCookie)
		if (mpvs != null) {
			binder.bind(mpvs);
		}
		/********************* 自定义添加End *****************************/

		// Add resolved attribute and BindingResult at the end of the model

		Map<String, Object> bindingResultModel = binder.getBindingResult().getModel();
		mavContainer.removeAttributes(bindingResultModel);
		mavContainer.addAllAttributes(bindingResultModel);

		return binder.getTarget();
	}

	/**
	 * Extension point to create the model attribute if not found in the model.
	 * The default implementation uses the default constructor.
	 * 
	 * @param attributeName
	 *            the name of the attribute, never {@code null}
	 * @param parameter
	 *            the method parameter
	 * @param binderFactory
	 *            for creating WebDataBinder instance
	 * @param request
	 *            the current request
	 * @return the created model attribute, never {@code null}
	 */
	protected Object createAttribute(String attributeName, MethodParameter parameter, WebDataBinderFactory binderFactory, NativeWebRequest request) throws Exception {

		return BeanUtils.instantiateClass(parameter.getParameterType());
	}

	/**
	 * Extension point to bind the request to the target object.
	 * 
	 * @param binder
	 *            the data binder instance to use for the binding
	 * @param request
	 *            the current request
	 */
	protected void bindRequestParameters(WebDataBinder binder, NativeWebRequest request) {
		((WebRequestDataBinder) binder).bind(request);
	}

	/**
	 * Validate the model attribute if applicable.
	 * <p>
	 * The default implementation checks for {@code @javax.validation.Valid}.
	 * 
	 * @param binder
	 *            the DataBinder to be used
	 * @param parameter
	 *            the method parameter
	 */
	protected void validateIfApplicable(WebDataBinder binder, MethodParameter parameter) {
		Annotation[] annotations = parameter.getParameterAnnotations();
		for (Annotation annot : annotations) {
			if (annot.annotationType().getSimpleName().startsWith("Valid")) {
				Object hints = AnnotationUtils.getValue(annot);
				binder.validate(hints instanceof Object[] ? (Object[]) hints : new Object[] { hints });
				break;
			}
		}
	}

	/**
	 * Whether to raise a {@link BindException} on validation errors.
	 * 
	 * @param binder
	 *            the data binder used to perform data binding
	 * @param parameter
	 *            the method argument
	 * @return {@code true} if the next method argument is not of type
	 *         {@link Errors}.
	 */
	protected boolean isBindExceptionRequired(WebDataBinder binder, MethodParameter parameter) {
		int i = parameter.getParameterIndex();
		Class<?>[] paramTypes = parameter.getMethod().getParameterTypes();
		boolean hasBindingResult = (paramTypes.length > (i + 1) && Errors.class.isAssignableFrom(paramTypes[i + 1]));

		return !hasBindingResult;
	}

	/**
	 * Return {@code true} if there is a method-level {@code @ModelAttribute} or
	 * if it is a non-simple type when {@code annotationNotRequired=true}.
	 */
	@Override
	public boolean supportsReturnType(MethodParameter returnType) {
		if (returnType.getMethodAnnotation(ModelAttribute.class) != null) {
			return true;
		} else if (this.annotationNotRequired) {
			return !BeanUtils.isSimpleProperty(returnType.getParameterType());
		} else {
			return false;
		}
	}

	/**
	 * Add non-null return values to the {@link ModelAndViewContainer}.
	 */
	@Override
	public void handleReturnValue(Object returnValue, MethodParameter returnType, ModelAndViewContainer mavContainer, NativeWebRequest webRequest) throws Exception {

		if (returnValue != null) {
			String name = ModelFactory.getNameForReturnValue(returnValue, returnType);
			mavContainer.addAttribute(name, returnValue);
		}
	}
}
