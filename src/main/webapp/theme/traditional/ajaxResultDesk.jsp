<%@page import="com.reps.ui.UIPersonalize"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="/reps-tags" prefix="reps"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<% String path = request.getContextPath().equals("/") ? "" : request.getContextPath();%>
<c:set var="path" value="<%=path%>" />
<script type="text/javascript">
var path = "${path}";
</script>
<%@ page trimDirectiveWhitespaces="true" %>
<!DOCTYPE HTML>
<html>
  <head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
	<script src="${path}/library/base/jquery-1.8.0.min.js" type="text/javascript"></script>
  </head>
  <body>
    <%@ include file="userDesk.jsp" %>
  </body>
</html>
