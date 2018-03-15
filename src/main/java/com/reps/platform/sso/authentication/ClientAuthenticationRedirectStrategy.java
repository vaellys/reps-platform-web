package com.reps.platform.sso.authentication;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.reps.sso.client.authentication.AuthenticationRedirectStrategy;

/**
 * 未登录拦截请求处理
 * 
 * @author YangMing
 * @date 2015年12月3日 上午11:58:05
 *
 */
public class ClientAuthenticationRedirectStrategy implements AuthenticationRedirectStrategy {

	@Override
	public void redirect(HttpServletRequest request, HttpServletResponse response, String potentialRedirectUrl) throws IOException {
		if (isAjax(request)) {
			response.setCharacterEncoding("UTF-8");
			response.setContentType("application/json; charset=utf-8");
			PrintWriter out = null;
			try {
				out = response.getWriter();
				out.print("{\"status\":\"301\", \"redirectUrl\" : \"" + potentialRedirectUrl + "\"}");
				out.flush();
			} catch (IOException e) {
				e.printStackTrace();
			} finally {
				if (out != null) {
					out.close();
				}
			}
			return;
		}
		response.sendRedirect(potentialRedirectUrl);
	}

	/**
	 * 判断ajax请求
	 * 
	 * @param request
	 * @return
	 */
	boolean isAjax(HttpServletRequest request) {
		return (request.getHeader("X-Requested-With") != null && "XMLHttpRequest".equals(request.getHeader("X-Requested-With").toString()));
	}

}
