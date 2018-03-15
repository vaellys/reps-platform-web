package com.reps.platform.action;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.reps.core.ItemData;
import com.reps.core.LoginToken;
import com.reps.core.RepsConstant;
import com.reps.core.RepsContext;
import com.reps.core.SystemMenuPool;
import com.reps.core.exception.RepsException;
import com.reps.core.modules.MenuNode;
import com.reps.core.modules.MenuNodeType;
import com.reps.ui.UIPersonalize;

/**
 * 首页
 * 
 * @author seastar
 */
@Controller("com.reps.platform.action.IndexAction")
public class IndexAction {

	@RequestMapping(value = "/index")
	public ModelAndView index() throws RepsException {
		String theme = RepsConstant.getContextProperty("global.theme");
		if (StringUtils.isNotBlank(theme)) {
			UIPersonalize.setDefault(theme, theme);
		}
		theme = UIPersonalize.getTheme();
		ModelAndView mav = new ModelAndView("/theme/" + theme + "/index");
		// 提取权限信息,提取所有的功能
		LoginToken token = RepsContext.getToken();
		if (token == null) {
			return showMessage("您的帐号信息出现异常，请联系管理员", RepsConstant.getContextProperty("portal.url", "#"), 5);
		}
		Map<String, ItemData> privileges = token.getPrivileges();
		if(privileges == null || privileges.isEmpty()) {
			return showMessage("您还没有操作当前系统的权限", RepsConstant.getContextProperty("portal.url", "#"), 5);
		}
		Map<String, MenuNode> menuNodes = SystemMenuPool.getInitialize().getMapMenuNodes();

		List<MenuNode> rootMenu = new ArrayList<MenuNode>();
		if (!"desktop".equals(theme)) {
			Map<String, MenuNode> groupMenuMap = new HashMap<String, MenuNode>();
			for (Map.Entry<String, MenuNode> entry : menuNodes.entrySet()) {
				MenuNode menuNode = entry.getValue();
				if (menuNode == null || !token.haveCode(menuNode.getCode())) {
					continue;
				}
				if (menuNode.getType() == MenuNodeType.Group) {
					groupMenuMap.put(menuNode.getCode(), menuNode);
					continue;
				}
				// 操作不加入树
				if (menuNode.getType() != MenuNodeType.Operate) {
					// 跳过分组菜单
					if (groupMenuMap.containsKey(menuNode.getParentCode())) {
						MenuNode groupMenu = groupMenuMap.get(menuNode.getParentCode());
						menuNode.setParentCode(groupMenu.getParentCode());
					}
					if (menuNode.getParentCode().equals(RepsConstant.TREE_ROOT_PARENT_ID)) {
						if (rootMenu.contains(menuNode))
							continue;
						// 根菜单
						rootMenu.add(menuNode);
					} else if (menuNodes.containsKey(menuNode.getParentCode())) {
						// 添加子节点
						menuNodes.get(menuNode.getParentCode()).addNode(menuNode);
					}
				}
			}
		} else {
			// 桌面菜单加载
			for (Map.Entry<String, MenuNode> entry : menuNodes.entrySet()) {
				MenuNode menuNode = entry.getValue();
				if (menuNode == null || !token.haveCode(menuNode.getCode())) {
					continue;
				}
				if (RepsConstant.TREE_ROOT_PARENT_ID.equals(menuNode.getParentCode())) {
					rootMenu.add(menuNode);
				}
				if (menuNode.getType() == MenuNodeType.Action) {
					MenuNode rootMenuNode = getRootMenu(menuNodes, menuNode.getParentCode());
					if (rootMenuNode != null) {
						rootMenuNode.addNode(menuNode);
					}
				}
			}
		}

		Collections.sort(rootMenu, new Comparator<MenuNode>() {
			@Override
			public int compare(MenuNode m1, MenuNode m2) {
				return m1.getShowOrder() - m2.getShowOrder();
			}
		});

		mav.addObject("modules", rootMenu);
		if (StringUtils.isBlank(token.getName())) {
			mav.addObject("login_user_name", token.getLoginName());
		} else {
			mav.addObject("login_user_name", token.getName());
		}
		mav.addObject("login_user_orgname", token.getOrganizeName());
		mav.addObject("login_user_id", token.getUserId());
		mav.addObject("login_account_id", token.getAccountId());
		// 根据权限来获取菜单
		// Thread.CurrentPrincipal.Identity.IsAuthenticated;

		return mav;
	}

	@RequestMapping(value = "/desk", method = RequestMethod.GET)
	public ModelAndView desk() {
		ModelAndView mav = new ModelAndView("/theme/" + UIPersonalize.getTheme() + "/desk");
		return mav;
	}

	@RequestMapping(value = "/theme", method = RequestMethod.GET)
	public String theme(String theme, String uiName) {
		UIPersonalize.setPersonalize(theme, uiName);
		return "redirect:index.mvc";
	}

	private MenuNode getRootMenu(Map<String, MenuNode> menuMap, String code) {
		MenuNode menuNode = menuMap.get(code);
		if (menuNode != null && RepsConstant.TREE_ROOT_PARENT_ID.equals(menuNode.getParentCode())) {
			return menuNode;
		} else if (menuNode != null) {
			return getRootMenu(menuMap, menuNode.getParentCode());
		}
		return null;
	}

	protected ModelAndView showMessage(String message, String forwardURL, int second) {
		ModelAndView mav = new ModelAndView("/showmessage");
		if ("".equals(forwardURL)) {
			forwardURL = null;
		}
		if (forwardURL != null) {
			message = "<a href=\"" + forwardURL + "\">" + message + "</a><script>setTimeout(\"window.location.href ='" + forwardURL + "';\", " + (second * 1000) + ");</script>";
		}
		mav.addObject("url_forward", forwardURL);
		mav.addObject("message", message);
		return mav;
	}
	
}
