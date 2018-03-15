<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page trimDirectiveWhitespaces="true" %>
<% String path = request.getContextPath().equals("/") ? "" : request.getContextPath(); %>
<c:set var="ctx" value="<%=path%>" />
<html>
<head>
<meta charset="utf-8" />
<title>REPS管理平台－桌面风格</title>

<meta http-equiv="X-UA-Compatible" content="IE=edge" /> 
<meta name="renderer" content="webkit">
<link  href="${ctx}/theme/desktop/index.css" rel="stylesheet" type="text/css" />
<script src="${ctx}/library/base/jquery-1.11.2.min.js" type="text/javascript" language="javascript"></script>
<script src="${ctx}/library/base/jquery-migrate-1.1.1.js" type="text/javascript" language="javascript"></script>
<script type="text/javascript" src="${ctx}/theme/desktop/jsLib/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="${ctx}/theme/desktop/jsLib/myLib.js"></script>
<script type="text/javascript">
		   $(function(){
		   		myLib.progressBar();
		   });
		   
		   var logout = function() {
			   if(confirm("确定退出当前系统?")) {
				   location.href = "logout";
			   }
		   }
		   
		   var messageCenter = function(){
			   myLib.desktop.win.newWin({WindowTitle:'消息中心',iframSrc:"${ctx}/reps/sys/message/list.mvc",WindowsId:"welcome",WindowAnimation:'none', QWindowWidth:740,WindowHeight:520});
		   }
		   
		   $.include(['${ctx}/theme/desktop/themes/default/css/desktop.css', '${ctx}/theme/desktop/jsLib/jquery-ui-1.8.18.custom.css', '${ctx}/theme/desktop/jsLib/jquery-smartMenu/css/smartMenu.css' , '${ctx}/theme/desktop/jsLib/jquery-ui-1.8.18.custom.min.js', '${ctx}/theme/desktop/jsLib/jquery.winResize.js', '${ctx}/theme/desktop/jsLib/jquery-smartMenu/js/mini/jquery-smartMenu-min.js', '${ctx}/theme/desktop/jsLib/desktop.js']);
           $(window).load(function(){
		   myLib.stopProgress();
	         
		   //这里本应从数据库读取json数据，这里直接将数据写在页面上
		   var lrBarIconData={
			   'app0':{
					   'title':'门户首页',
					   'url':'${sGlobal.portalUrl}',
					   'winWidth':1100,
					   'winHeight':650
					   },
				'app1':{
					   'title':'资源云',
					   'url':'#',
					   'winWidth':1100,
					   'winHeight':650
					   },
				'app2':{
					   'title':'人人通',
					   'url':'#',
					   'winWidth':1100,
					   'winHeight':650
					   }
		   };
 		   
		   //存储桌面布局元素的jquery对象
		   myLib.desktop.desktopPanel();
 		   
		   //初始化桌面背景
		   myLib.desktop.wallpaper.init("${ctx}/theme/desktop/themes/default/images/blue_glow.jpg");
		   
		   //初始化任务栏
		   myLib.desktop.taskBar.init();
		   
		   var deskIconData={<c:forEach items="${modules}" var="c" varStatus="ci">
			<c:forEach items="${c.nodes}" var="m" varStatus="mi">
			<c:set value="${fn:indexOf(m.action, ';') == -1 ? m.action : fn:substring(m.action, 0, fn:indexOf(m.action, ';'))}" var="action" />
				'${m.code}':{
				   'title':'${m.name}',
				   'url':'${empty m.baseUrl ? (m.category ne 'SYSTEM' ? '' : ctx) : m.baseUrl}${fn:replace(action, "{userId}", login_user_id)}',
				   'winWidth':930,
				   'winHeight':500,
				   'newpage':${m.newpage}
				 }<c:if test="${(ci.last and mi.last) eq false}">,</c:if>
			</c:forEach>
		   </c:forEach>
		   };
		   
		   //初始化桌面图标
		   myLib.desktop.deskIcon.init(deskIconData);
		   
		   //初始化桌面导航栏
		   myLib.desktop.navBar.init();
		   
		   //初始化侧边栏
		   myLib.desktop.lrBar.init(lrBarIconData);
		   
		   //欢迎窗口
		   //myLib.desktop.win.newWin({WindowTitle:'欢迎窗口',iframSrc:"welcome.html",WindowsId:"welcome",WindowAnimation:'none', QWindowWidth:740,WindowHeight:520});
  		  
		  });

		//添加应用函数
		function addIcon(data){
			 myLib.desktop.deskIcon.addIcon(data);
		}
		
		$(function(){
			var processLeft = $("#navBar a").eq(0).offset().left;
			var navSize = $("#navBar a").size();
			$("#navBar .dash").css("left",processLeft);
			$("#navBar .dash").css("width",96*navSize);
			$("#navBar .process").css("left",processLeft);
			$("#navBar .process").css("width",96);
			$("#navBar a").on("click",function(){
				var $this = $(this);
				var index = $this.index();
				var cls = $this.find("div").eq(0).attr("class");
				if("current" != cls){
					$("#navBar a").each(function(){
						var $tis = $(this);
						var cs = $tis.find("div").eq(0).attr("class");
						if("current" == cs){
							var addClass = $tis.attr("options");
							$tis.find("div").eq(0).removeClass().addClass(addClass);
						}
					});
					$this.find("div").eq(0).removeClass().addClass("current");
				}
				$("#navBar .process").css("width",95 * (index - 2 + 1));
			});
		});
		var changeTheme = function(){
			window.location.href = "theme.mvc?theme=traditional&uiName=traditional";
		}
</script>
</head>
<body>
		<div id="wallpapers">
		</div>
		<c:if test="${fn:length(modules) gt 1}">
		<div id="navBar">
			<div class="dash"></div>
			<div class="process"></div>
		<c:forEach items="${modules}" var="c" varStatus="index">
		<c:choose>
			<c:when test="${index.count eq 1}">
				<a href="#" title="${c.name}" options="${c.icon}">
					<div class="current"></div>
					<div class="navName">${c.name}</div>
				</a>
			</c:when>
			<c:otherwise>
				<a href="#" title="${c.name}" options="${c.icon}">
					<div class="${c.icon}"></div>
					<div class="navName">${c.name}</div>
				</a>
			</c:otherwise>
		</c:choose>
		</c:forEach>
		</div>
		</c:if>
		<div id="desktopPanel">
			<div id="desktopInnerPanel">
				<c:forEach items="${modules}" var="c" varStatus="index">
					<ul class="deskIcon${index.count eq 1 ? ' currDesktop' : ''}">
					  <c:forEach items="${c.nodes}" var="m">
					  	<li class="desktop_icon" id="${m.code}"><span class="${empty m.icon ? 'default-icon' : m.icon}"></span> <div class="text" title="${m.name}">${m.name}<s></s></div></li>
					  </c:forEach>
					</ul>
				</c:forEach>
			</div>
		</div>

<div id="taskBarWrap">
	<div id="taskBar">
		  <div id="leftBtn"><a href="#" class="upBtn"></a></div>
		  <div id="rightBtn"><a href="#" class="downBtn"></a> </div>
		  <div id="task_lb_wrap"><div id="task_lb"></div></div>
	</div>
</div>

<div id="lr_bar">
  <ul id="default_app">
	   <li id="app0"><span><img src="${ctx}/theme/desktop/icon/icon1.png" title="门户首页"/></span><div class="text">门户首页<s></s></div></li>
	   <%-- <li id="app1"><span><img src="${ctx}/theme/desktop/icon/icon2.png" title="资源云平台"/></span><div class="text">资源云<s></s></div></li>
	   <li id="app2"><span><img src="${ctx}/theme/desktop/icon/icon3.png" title="人人通"/></span><div class="text">人人通<s></s></div></li> --%>
  </ul>
  <div id="default_tools"> <span id="showZm_btn" title="全屏"></span><span id="theme_btn" onclick="return changeTheme();" title="切换主题"></span></div>
      <div id="start_block">
      <a title="开始" id="start_btn"></a>
	  <div id="start_item">
	      <ul class="item admin">
	        <li><span class="adminImg"></span>${sGlobal.token.showName}</li>
	      </ul>
	      <ul class="item">
	        <!-- <li><span class="sitting_btn"></span>系统设置</li> -->
	        <!--<li><span class="help_btn"></span>使用帮助 <b></b></li>-->
	        <li onclick="messageCenter()"><span class="about_btn"></span>消息中心</li>
	        <li onclick="logout()"><span class="logout_btn"></span>退出系统</li>
	      </ul>
	    </div>
	</div>
</div>
</div>
</body>
</html>