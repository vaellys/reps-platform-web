package com.reps.platform.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;

import com.reps.core.LoginManager;
import com.reps.core.util.StringUtil;

/**
 * 多用户根据参数设置默认
 * 
 * @author Think
 *
 */
public class ChooseUserFilter implements Filter {

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {

	}

	@Override
	public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) throws IOException, ServletException {
		HttpServletRequest request = (HttpServletRequest) req;
		HttpServletResponse response = (HttpServletResponse) res;
		if (request.getSession().getAttribute("users") != null) {
			if (request.getParameter("uid") != null) {
				LoginManager.setUserId(request.getParameter("uid"));
			} else if(LoginManager.getUserId() == null) {
				String path = request.getContextPath().equals("/") ? "" : request.getContextPath();
				StringBuffer buf = new StringBuffer(request.getRequestURL());
				if (StringUtils.isNotBlank(request.getQueryString())) {
					buf.append("?").append(request.getQueryString());
				}
				response.sendRedirect(path + "/chooseuser.jsp?refer=" + StringUtil.urlEncode(buf.toString()));
				return;
			}
		}
		chain.doFilter(request, response);
	}

	@Override
	public void destroy() {

	}

}
