<%@page import="com.reps.core.modules.MenuNodeCategory"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" trimDirectiveWhitespaces="true" %>
<%@ taglib uri="/reps-tags" prefix="reps"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<% String path = request.getContextPath().equals("/") ? "" : request.getContextPath();%>
<% request.setAttribute("menuNodeCategorySystem", MenuNodeCategory.SYSTEM); %>
<c:set var="path" value="<%=path%>" />
<script type="text/javascript">var path = "${path}";</script>
<script type="text/javascript" src="theme/traditional/loading.js"></script>
<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" /> 
<meta name="renderer" content="webkit">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>${sGlobal.title}</title>
<link href="theme/traditional/index.css" type="text/css" rel="stylesheet" />
<script src="library/base/jquery-1.11.2.min.js" type="text/javascript"></script>
<script src="library/base/jquery.cookie.js" type="text/javascript"></script>
<script src="theme/traditional/reps.core.js" type="text/javascript"></script>
<script src="theme/traditional/reps.navTab.js" type="text/javascript"></script>
<script src="theme/traditional/reps.accordion.js" type="text/javascript"></script>
<script src="theme/traditional/reps.tree.js" type="text/javascript"></script>
<script src="theme/traditional/reps.dialog.js" type="text/javascript"></script>
<script src="theme/traditional/reps.dialogDrag.js" type="text/javascript"></script>
<script src="theme/traditional/reps.drag.js" type="text/javascript"></script>
<script src="theme/traditional/reps.messager.js" type="text/javascript"></script>
<script type="text/javascript" src="theme/traditional/index.js"></script>
<script role="reload" src="theme/traditional/jquery-ui.min.js" type="text/javascript"></script>
<script src="theme/traditional/config.js" type="text/javascript"></script>
<script src="library/base/jQuery.Tip.js" type="text/javascript"></script>
<script type="text/javascript" src="library/jlayout/jquery.sizes.js"></script>
<script type="text/javascript" src="library/jlayout/jlayout.border.js"></script>
<script type="text/javascript" src="library/jlayout/jquery.jlayout.js"></script>
</head>
<body style="height:100%;overflow:hidden;">
<a id="targetUrl" target="navTab" style="display:none;" external="true" ></a>
<div data-layout='{"type": "border", "hgap": 4, "vgap": 1}' class="layout">
  <div class="north">
	<div class="header">
		<div class="logo">
	        <img src="theme/traditional/images/logo.png" style="border: 0px" />
	        <span>${sGlobal.title}</span>
	    </div>
	    <div class="headerPer">
	        <ul class="operation">
	            <!-- <li class="desk"><span></span><a href="usersetting/desk/index.mvc" onclick="$('.home_icon').click()" target="dialog" width="600">主页设置</a></li>
	            <li class="setting"><span></span><a href="usersetting/index.mvc" external="true" target="navTab">个人设置</a></li> -->
				<li class="message"><span></span><a href="${ctx}/reps/sys/message/list.mvc" external="true" target="navTab">消息中心</a></li>
	            <li class="exchange"><span></span><a href="theme.mvc?theme=desktop&uiName=desktop" external="true">切换主题</a></li>
	            <li class="exit"><span></span><a href="logout">退出</a></li>
	        </ul>
	        <span class="administrator">当前登录人:${sGlobal.token.showName}</span>
	    </div>
	</div>
	<div class="headerNav">
		<div class="headerNavLeft">
		  <div id="toggle-west" class="controlbutton"><span></span>菜单控制</div>
		  <div id="toggle-north" class="controlbutton navigate-controller"><span></span>导航控制</div>
		</div>
	    <ul class="navigate">
	    	<c:forEach items="${modules}" var="m" varStatus="index">
	       		   <li id="menunode${index.count}" class="${m.icon}<c:if test="${index.index == 0}"> current</c:if>" menuCode="${m.code}" onclick="main.showMenu(this, '${m.code}', '${m.name}')"><span></span><a href="#">${m.name}</a></li>
		     </c:forEach> 
         	<li class="more"><span></span></li>  
	    </ul>
	</div>
  </div>
  <div class="west">
     <div class="toggleCollapse">
    	<h2 class="-header-menu-name">内容发布</h2>
        <div></div>
    </div>
    <div id="accContent" style="width:100%;border:0px">
    <!-- menu begin-->
      <c:forEach items="${modules}" var="rootCatalog" varStatus="index">
        <div id="menu${rootCatalog.code}" class="accordion" style="display:none">
          <c:forEach items="${rootCatalog.nodes}" var="mNode">
             <div class="accordionHeader"><h2><span>icon</span>${mNode.name}</h2></div>
             <div class="accordionContent">
                  <!-- 这里是具体的内容了 start-->
                   <ul class="tree treeFolder" style="height:93%;width:198px;margin-top: 5px">
		            <c:forEach items="${mNode.nodes}" var="yeye">
		           	 <c:set value="${yeye}" var="parentCatalog" />
		             <c:choose>
		             	<c:when test="${not empty yeye.nodes}">
		             		<!-- 目录 -->
		             		<li><a title="${yeye.name}">${yeye.name}</a>
		             			<ul>
				                <c:forEach items="${yeye.nodes}" var="fuqin">
				                	<c:choose>
						             	<c:when test="${not empty fuqin.nodes}">
						             		<!-- 目录 -->
						             		<li><a title="${fuqin.name}">${fuqin.name}</a>
					             				<ul>
								                <c:forEach items="${fuqin.nodes}" var="erzi">
								                	<c:choose>
										             	<c:when test="${not empty erzi.nodes}">
										             		<!-- 目录 -->
										             		<li><a title="${erzi.name}">${erzi.name}</a>
									             				<ul>
												                <c:forEach items="${erzi.nodes}" var="sunzi">
												                	<!-- 菜单 -->
												                	<c:set value="${sunzi}" var="menu" />
												                	<%@ include file="menuNode.jsp" %>
												                </c:forEach>
									             				</ul>
										                    </li>
										             	</c:when>
										             	<c:otherwise>
										             		<!-- 菜单 -->
										             		<c:set value="${erzi}" var="menu" />
										                	<%@ include file="menuNode.jsp" %>
										             	</c:otherwise>
										             </c:choose>
								                </c:forEach>
					             				</ul>
						                    </li>
						             	</c:when>
						             	<c:otherwise>
						             		<!-- 菜单 -->
						             		<c:set value="${fuqin}" var="menu" />
						                	<%@ include file="menuNode.jsp" %>
						             	</c:otherwise>
						             </c:choose>
				                </c:forEach>
			                	</ul>
		                    </li>
		             	</c:when>
		             	<c:otherwise>
		             		<!-- 菜单 -->
		             		<c:set value="${yeye}" var="menu" />
						    <%@ include file="menuNode.jsp" %>
		             	</c:otherwise>
		             </c:choose>
		           </c:forEach>
		         </ul>
                 <!--end-->
             </div>
         </c:forEach>
	   </div>
	</c:forEach>
    <!-- menu end -->
    </div>
  </div>
  <div class="center">
      <div id="navTab" class="tabsPage">
			<div class="tabsPageHeader">
				<div class="tabsPageHeaderContent"><!-- 显示左右控制时添加 class="tabsPageHeaderMargin" -->
					<ul class="navTab-tab">
						<li tabid="main" class="main"><a href="javascript:;"><span><span class="home_icon">我的主页</span></span></a></li>
					</ul>
				</div>
				<div class="tabsLeft">left</div><!-- 禁用只需要添加一个样式 class="tabsLeft tabsLeftDisabled" -->
				<div class="tabsRight">right</div><!-- 禁用只需要添加一个样式 class="tabsRight tabsRightDisabled" -->
				<div class="tabsMore">more</div>
			</div>
			<ul class="tabsMoreList">
				<li><a href="javascript:;">我的主页</a></li>
			</ul>
			<div class="navTab-panel tabsPageContent layoutBox">
				<div class="page unitBox">
					<div id="userDesk">
						<%@ include file="userDesk.jsp" %>
					</div>
				</div>
			</div>
		</div>
  </div>
 <div class="south"></div>
</div>
<div class="dropdown_menu">
	<div class="cor_corner"></div>
	<ul class="more">
		<c:forEach items="${modules}" var="m" varStatus="index">
     		<li id="menunode${index.count}" class="${m.icon}" menuCode="${m.code}" onclick="main.showMenu(this, '${m.code}', '${m.name}' , true)"><span></span><a href="javascript:void(0);">${m.name}</a></li>
    	</c:forEach>
    </ul>
</div>
<script type="text/javascript" src="theme/traditional/main.js"></script>
<script type="text/javascript">
//清除查询条件保留cookie标识
function clearQueryCookie()
{
	$.cookie('${queryCookieName}', 'false',  {path : '/'});
}
</script>
</body>
</html>