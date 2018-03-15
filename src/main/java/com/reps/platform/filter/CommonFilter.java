package com.reps.platform.filter;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

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
import com.reps.core.RepsConstant;
import com.reps.core.RepsContext;
import com.reps.ui.UIPersonalize;

public class CommonFilter implements Filter {

	public void init(FilterConfig fc) throws ServletException {
	}

	public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) throws IOException, ServletException {
		HttpServletRequest request = (HttpServletRequest) req;
		HttpServletResponse response = (HttpServletResponse) res;

		if (StringUtils.isBlank(UIPersonalize.getTheme())) {
			String theme = RepsConstant.getContextProperty("global.theme");
			if (StringUtils.isNotBlank(theme)) {
				UIPersonalize.setDefault(theme, theme);
			}
		}

		request.setAttribute("actionBasePath", RepsConstant.ACTION_BASE_PATH);
		request.setCharacterEncoding(RepsConstant.GLOBAL_CHARSET);
		response.setCharacterEncoding(RepsConstant.GLOBAL_CHARSET);

		Map<String, Object> sGlobal = new HashMap<String, Object>();
		sGlobal.put("charset", RepsConstant.GLOBAL_CHARSET);
		sGlobal.put("title", RepsConstant.getGlobalTitle());
		sGlobal.put("portalUrl", RepsConstant.getContextProperty("portal.url"));

		String userId = LoginManager.getUserId();
		if (userId != null) {
			sGlobal.put("uid", userId);
			sGlobal.put("token", RepsContext.getByUserId(userId));
		}
		request.setAttribute("sGlobal", sGlobal);

		chain.doFilter(request, response);
	}

	public void destroy() {
	}
}