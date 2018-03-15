<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<input type="hidden" id="deskLayout" value="${layout}" />
<input type="hidden" id="isChange" value="false" />
<input type="hidden" id="moduleSort" />
<div id="module_l" class="groupWrapper w250-index">
<c:forEach var="item" items="${leftDesk}">
  <%@ include file="groupItem.jsp" %>
</c:forEach>
</div>
<div id="module_m" class="groupWrapper w500-index">
<c:forEach var="item" items="${midDesk}">
  <%@ include file="groupItem.jsp" %>
</c:forEach>
</div>
<div id="module_r" class="groupWrapper w250-index">
<c:forEach var="item" items="${rightDesk}">
  <%@ include file="groupItem.jsp" %>
</c:forEach>
</div>
