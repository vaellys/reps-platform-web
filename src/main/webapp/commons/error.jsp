<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<%@ page import="org.slf4j.Logger" %>
<%@ page import="org.slf4j.LoggerFactory" %>
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
			.error-btn{ width: 448px; margin: 0 auto;	}
			.error-btn a{ display: inline-block; color: #71a4b5; border: 1px solid #71a4b5; padding: 5px 10px; border-radius: 5px; }
			.error-text{ width: 600px; margin: 10px auto; color: red; display: none;}
		</style>
	</head>	
	<body>
		<div class="wrap-error">
			<h1><img src="<%=path%>/theme/traditional/images/500.png"></h1>
			<div class="error-btn"><a href="javascript:showerror()">查看详情>></a></div>
			<div class="error-text" id="errorinfo"><%=exception.getLocalizedMessage()%></div>
			<%    
            	final Logger log = LoggerFactory.getLogger(getClass());
				log.error("页面出现异常", exception);    
            %>
		</div>
	</body>
	<script type="text/javascript">
		function showerror() {
			document.getElementById("errorinfo").style.display="block";
		}
	</script>
</html>
