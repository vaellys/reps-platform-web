<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/commons/tags.jsp"%>
<% 
String path = request.getContextPath().equals("/") ? "" : request.getContextPath();
String port = request.getServerPort() == 80 ? "" : ":" + request.getServerPort();
String basePath = request.getScheme() + "://" + request.getServerName() + port + path;
%>
<c:set var="path" value="<%=basePath%>" /> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<style type="text/css">
.showmessage { margin: 50px auto; width: 600px; background: #FCF9E6; }
    .showmessage h2 { font-size: 14px; }
    .showmessage .ye_l_b { padding: 15px 20px 20px; }
    .showmessage p { padding: 2em 1em;  font-size: 14px; overflow: hidden; }
    .showmessage .op { font-size: 12px; text-align: right; }
    .ye_r_t,
	.ye_l_t,
	.ye_r_b,
	.ye_r_t { width: 100%; }
	.ye_l_t { padding: 5px 0 0;  }
	.ye_l_b { padding: 0 5px 5px; }
	.ye_r_t,
	.ye_l_t,
	.ye_r_b,
	.ye_l_b{ background: url(${path}/theme/desktop/images/yel_bg.gif) no-repeat; }
	.ye_r_t { width: 100%; background-position: right top; }
	  .ye_l_t { padding: 5px 0 0; background-position: left top; }
	    .ye_r_b { background-position: right bottom; }
	      .ye_l_b { padding: 0 5px 5px; background-position: left bottom; }
</style>
</head>
<body>
	<div class="showmessage">
		<div class="ye_r_t"><div class="ye_l_t"><div class="ye_r_b"><div class="ye_l_b">
			<caption><h2>信息提示</h2></caption>
			<p>${message}</p>
			<p class="op"><c:choose>
				<c:when test="${not empty url_forward}"><a href="${url_forward}">页面跳转中...</a></c:when>
				<c:otherwise><a href="javascript:history.go(-1);">返回上一页</a> | <a href="index.jsp">返回首页</a></c:otherwise>
			</c:choose></p>
		</div></div></div></div>
	</div>
</body>
</html>