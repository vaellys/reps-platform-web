<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% String path = request.getContextPath().equals("/") ? "" : request.getContextPath(); %>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title></title>
		<style type="text/css">
			.wrap-error{ overflow: hidden; padding: 90px 0 20px 0; }
			.wrap-error h1{ text-align: center; }
			.wrap-error h2{ text-align: center; font-size: 22px; line-height: 40px; }
			.wrap-error p{ text-align: center; }
		</style>
	</head>	
	<body>
		<div class="wrap-error">
			<h1><img src="<%=path%>/theme/traditional/images/404.png"></h1>
			<h2>抱歉，您访问的页面不存在</h2>
		</div>
	</body>
</html>
