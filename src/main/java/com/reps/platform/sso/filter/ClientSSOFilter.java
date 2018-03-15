package com.reps.platform.sso.filter;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;

import com.reps.core.LoginManager;
import com.reps.core.RepsConstant;
import com.reps.core.modules.SystemModulePool;
import com.reps.core.security.AntPathMatcher;
import com.reps.core.security.PatternMatcher;
import com.reps.core.util.StringUtil;
import com.reps.platform.sso.authentication.ClientAuthenticationRedirectStrategy;
import com.reps.sso.client.filter.AbstractClientSSOFilter;
import com.reps.ui.UIPersonalize;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/***
 * SSO 过滤器
 * 
 * @author YangMing
 * @date 2015年12月1日 上午9:37:21
 *
 */
public class ClientSSOFilter extends AbstractClientSSOFilter {

	PatternMatcher patternMatcher = new AntPathMatcher();

	public ClientSSOFilter() {
		super();
		super.setAuthenticationRedirectStrategy(new ClientAuthenticationRedirectStrategy());
	}

	@Override
	protected String getClientUri() {
		return RepsConstant.getContextProperty("sso.clientUri", null);
	}

	@Override
	protected String getClusterNodeUrls() {
		return RepsConstant.getContextProperty("sso.clusterNodeUrls", null);
	}

	@Override
	protected String getServerUrlPrefix() {
		return RepsConstant.getContextProperty("sso.serverUrlPrefix", null);
	}

	@Override
	protected String getTicketValidatorUrlPrefix() {
		return RepsConstant.getContextProperty("sso.ticketValidatorUrlPrefix", null);
	}

	@Override
	protected boolean localFilter(final ServletRequest servletRequest, final ServletResponse servletResponse, final FilterChain filterChain) throws IOException, ServletException {
		final HttpServletRequest request = (HttpServletRequest) servletRequest;
		// 不登录可访问地址过滤
		Set<String> noLogin = SystemModulePool.getNoLoginUrls();
		if (noLogin != null && !noLogin.isEmpty()) {
			for (String url : noLogin) {
				if (patternMatcher.matches(url, request.getServletPath())) {
					filterChain.doFilter(servletRequest, servletResponse);
					return false;
				}
			}
		}
		return true;
	}

	@SuppressWarnings("unchecked")
	public void loginUserInfo(HttpServletRequest request, HttpServletResponse response, Map<String, Object> attributes) {

		String theme = RepsConstant.getContextProperty("global.theme");
		if (StringUtil.isNotBlank(theme)) {
			UIPersonalize.setDefault(theme, theme);
		}

		if (attributes != null && !attributes.isEmpty()) {
			List<Map<String, String>> users = Collections.emptyList();
			if (attributes.get("users") != null) {
				String strUsers = (String) attributes.get("users");
				if (StringUtils.isNotBlank(strUsers)) {
					JSONArray jsonArray = JSONArray.fromObject(strUsers);
					if (jsonArray != null && jsonArray.size() > 0) {
						users = new ArrayList<Map<String, String>>(jsonArray.size());
						for (int i = 0; i < jsonArray.size(); i++) {
							Map<String, String> map = new LinkedHashMap<String, String>(4);
							JSONObject jsonObject = jsonArray.getJSONObject(i);
							for (Iterator<String> iter = jsonObject.keys(); iter.hasNext();) { // 先遍历整个
																								// people
																								// 对象
								String key = (String) iter.next();
								map.put(key, jsonObject.getString(key));
							}
							users.add(map);
						}
					}
				}
			}
			if (users.size() > 1) {
				// 多身份
				request.getSession().setAttribute("users", users);
				request.getSession().setAttribute("hasMoreUser", true);
			} else if (users != null && users.size() == 1) {
				Map<String, String> user = users.get(0);
				String userId = user.get("userId");
				LoginManager.setUserId(userId);
			} else {
				String accountId = (String) attributes.get("accountId");
				LoginManager.setAccountId(accountId);
				// 游客
				request.getSession().setAttribute("noUser", true);
			}

			request.getSession().setAttribute(RepsConstant.LOGIN_USER_SESSION_THEME, RepsConstant.getContextProperty("theme"));
		}
	}

	public void logout(HttpServletRequest request, HttpServletResponse response) {
		// 退出
		LoginManager.logout();
		request.getSession().invalidate();
	}

}
