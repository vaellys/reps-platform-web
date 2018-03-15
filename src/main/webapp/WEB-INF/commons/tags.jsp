<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="/system-tags" prefix="sys"%>
<%@ taglib uri="/reps-tags" prefix="reps"%>
<%@ page trimDirectiveWhitespaces="true" %>
<% request.setAttribute("ResBaseUrl", com.reps.core.RepsConstant.getContextProperty("res.httpPath")); %>