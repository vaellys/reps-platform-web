<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/commons/tags.jsp"%>
<!DOCTYPE HTML>
<html>
<head>
	<title>用户管理</title>
	<reps:theme/>
</head>
<body>
	<reps:container layout="true">
		<reps:panel id="top" dock="top" method="post" action="list.mvc" formId="queryForm">
			<reps:formcontent parentLayout="true" style="width:85%;" columns="3">
				<input type="hidden" name="execQuery" value="${execQuery}">
				<reps:formfield label="姓名" labelStyle="width:15%;">
					<reps:input name="account.person.name" style="width:120px">${user.account.person.name}</reps:input>
				</reps:formfield>
				<reps:formfield label="登录名">
					<reps:input name="account.loginName" style="width:120px">${user.account.loginName}</reps:input>
				</reps:formfield>
				<reps:formfield label="身份">
					<sys:dictionary id="identity" src="user_identity" name="identity" headerValue="" headerText="" style="width:120px">${user.identity}</sys:dictionary>
				</reps:formfield>
				<reps:formfield label="工作单位">
					<sys:organizeSearch id="organizeNameId" name="organize.name" hideIdName="organizeId" width="120">${user.organize.name}</sys:organizeSearch>
				</reps:formfield>
				<reps:formfield label="所属行政区">
					<reps:select id="district" name="organize.district" dictionaryItem="${districtList}" headerText="" headerValue="" style="width:126px">${user.organize.district}</reps:select>
				</reps:formfield>
				<reps:formfield label="用户状态">
					<reps:select id="district" name="userStatus" jsonData="{'':'','1':'启用','0':'禁用'}" style="width:120px">${user.userStatus}</reps:select>
				</reps:formfield>
			</reps:formcontent>
			<reps:querybuttons>
				<reps:ajaxgrid messageCode="manage.button.query" formId="queryForm" gridId="mygrid" cssClass="search-form-a"></reps:ajaxgrid>
			</reps:querybuttons>
			<reps:footbar>
			    <sys:authority code="sys010501">
					<reps:button messageCode="manage.action.add" action="toadd.mvc" cssClass="add-a"></reps:button>
				</sys:authority>
			    <sys:authority code="sys010509">
					<reps:button value="批量添加" action="tobatchadd.mvc" cssClass="add-a"></reps:button>
				</sys:authority>
				<reps:button onClick="exportExcel()" cssClass="export-a" value="导出Excel"></reps:button>
			</reps:footbar>
		</reps:panel>
		<reps:message code="manage.label.enabled" var="labelEnabled" />
		<reps:message code="manage.label.disable" var="labelDisable" />
		<reps:message code="manage.label.deleted" var="labelDeleted" />
		<reps:panel id="mybody" dock="center" border="false">
			<reps:grid id="mygrid" items="${list}" form="queryForm" var="user" pagination="${pager}" flagSeq="true">
				<reps:gridrow>
					<reps:gridfield title="姓名" width="11">${user.account.person.name}</reps:gridfield>
					<reps:gridfield title="工作单位" width="20">${user.organize.name}</reps:gridfield>
					<reps:gridfield title="登录名" width="14">${user.account.loginName}</reps:gridfield>
					<reps:gridfield title="身份" width="7" align="center"><sys:dictionary src="user_identity">${user.identity}</sys:dictionary></reps:gridfield>
					<reps:gridfield title="用户状态" width="8" align="center">
						<c:if test="${user.userStatus.value eq 1}">${labelEnabled}</c:if>
						<c:if test="${user.userStatus.value eq 0}">${labelDisable}</c:if>
					</reps:gridfield>
					<reps:gridfield title="最后登录时间" width="15" align="center">
						<fmt:formatDate value="${user.account.lastLoginTime}" pattern="yyyy-MM-dd HH:mm"/>
					</reps:gridfield>
					<reps:gridfield title="操作" width="25">
						<c:set var="userLoginName" value=",${user.account.loginName}," />
						<sys:authority code="sys010508">
						   <reps:button cssClass="detail-table" messageCode="manage.action.detail" action="detail.mvc?id=${user.id}"></reps:button>
						</sys:authority>
						<sys:authority code="sys010502" userId="${user.id}">
						   <reps:button cssClass="modify-table" messageCode="manage.action.update" action="toedit.mvc?id=${user.id}"></reps:button>
						</sys:authority>
						<c:choose>
							<c:when test="${user.userStatus.value eq 1}">
							    <sys:authority code="sys010506">
								  <reps:ajax cssClass="stop-use-table" confirm="${labelDisable}用户?" type="link" redirect="list.mvc" url="disable.mvc?id=${user.id}" value="${labelDisable}"></reps:ajax>
							    </sys:authority>
							</c:when>
							<c:otherwise>
							    <sys:authority code="sys010505">
								   <reps:ajax cssClass="start-use-table" confirm="${labelEnabled}用户?" type="link" redirect="list.mvc" url="enabled.mvc?id=${user.id}" value="${labelEnabled}"></reps:ajax>
							    </sys:authority>
							</c:otherwise>
						</c:choose>
						<sys:authority code="sys010503">
						<c:if test="${not fn:contains(admins,user.account.loginName)}">
							<reps:ajax cssClass="delete-table" confirm="${labelDeleted}用户?" type="link" redirect="list.mvc" url="delete.mvc?id=${user.id}" value="${labelDeleted}"></reps:ajax>
						</c:if>
						</sys:authority>
						<sys:authority code="sys010507">
						<reps:dialog cssClass="setting-table" type="link" id="changepassword${account.id}" iframe="true" 
							width="430" height="200" url="tochangepassword.mvc?id=${user.id}" title="${user.account.loginName}-修改密码" value="修改密码"  />
					    </sys:authority>
					</reps:gridfield>
				</reps:gridrow>
			</reps:grid>
		</reps:panel>
</reps:container>
</body>
<script type="text/javascript">
function assign(userId, childrenObj)
{
	var roleIds = "";
	$("input[name=ROLE_code]:checked" ,childrenObj).each(function(i, obj){
		roleIds += $(obj).val() + ";";
	});
	var positionIds = "";
	$("input[name=POSITION_code]:checked" ,childrenObj).each(function(i, obj){
		positionIds += $(obj).val() + ";";
	});
	$.ajax({
	  url: "assign.mvc",
	  type: "POST",
	  dataType: "json",
	  data : {"userId" : userId, "roleIds" : roleIds, "positionIds" : positionIds, "run" : Math.random()},
	  async: true,
	  success: function(data){
		 messager.message(data, function(){ });
	  }
	 });
}
function exportExcel(){
		$("#queryForm").attr("action", "export.mvc");
		$("#queryForm").submit();
		$("#queryForm").attr("action", "list.mvc");
}
</script>
</html>
