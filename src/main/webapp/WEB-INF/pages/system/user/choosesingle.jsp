<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/commons/tags.jsp"%>
<!DOCTYPE HTML>
<html>
<head>
	<title>用户信息查询</title>
	<reps:theme/>
</head>
<body>
<reps:container layout="true">
	<reps:panel id="top" dock="top" method="post" action="${ctx}${actionBasePath}/sys/chooseuser/single.mvc" formId="queryForm">
		<reps:formcontent parentLayout="true" style="width:80%;">
			<input name="dialogId" type="hidden" value="${dialogId}" />
			<input name="showName" type="hidden" value="${showName}" />
			<input name="callBack" type="hidden" value="${callBack}" />
			<input name="hideName" type="hidden" value="${hideName}" />
			<input name="hideNameValue" type="hidden" value="${hideNameValue}" />
			<input name="organizeId" type="hidden" value="${user.organizeId}" />
			<reps:formfield label="姓名">
				<reps:input name="account.person.name">${user.account.person.name}</reps:input>
			</reps:formfield>
			<reps:formfield label="用户名">
				<reps:input name="account.loginName">${user.account.loginName}</reps:input>
			</reps:formfield>
		</reps:formcontent>
		<reps:querybuttons style="margin-right:20px;">
			<reps:ajaxgrid messageCode="manage.button.query" formId="queryForm" gridId="mygrid" cssClass="search-form-a"></reps:ajaxgrid>
		</reps:querybuttons>
	</reps:panel>
	<reps:panel id="mybody" dock="center" border="true">
		<reps:grid id="mygrid" items="${list}" form="queryForm" var="user" pagination="${pager}">
			<reps:gridrow>
				<reps:gridfield title="工作单位">${user.organize.name}</reps:gridfield>
				<reps:gridfield title="姓名">${user.account.person.name}</reps:gridfield>
				<reps:gridfield title="用户名">${user.account.loginName}</reps:gridfield>
				<reps:gridfield title="性别"><sys:dictionary src="sex">${user.account.person.sex}</sys:dictionary></reps:gridfield>
				<reps:gridfield title="用户身份">
					<sys:dictionary src="user_identity">${user.identity}</sys:dictionary>
				</reps:gridfield>
				<reps:gridfield title="选择">
					<a class="btnSelect" href="javascript:chooseUserBack('${user.id}','${user.account.person.name}','${user.account.loginName}','${callBack}');" title="查找带回">选择</a>
				</reps:gridfield>
			</reps:gridrow>
		</reps:grid>
	</reps:panel>
</reps:container>
<script type="text/javascript">
var chooseUserBack = function(id, name, accountLoginName, callBack){
	name = name || accountLoginName;
	$("input[name='"+$("input[name=showName]").val()+"']",window.parent.document).val(name);
	$("input[name='"+$("input[name=hideName]").val()+"']",window.parent.document).val(id);
	var pdialog = $("#dialog"+$("input[name=dialogId]").val()+"",window.parent.document);
	$(pdialog).hide();
	$("div.shadow",window.parent.document).hide();
	$("#dialogBackground",window.parent.document).hide();
	$.pdialog.closeDialog();
	
	if (callBack){
		eval("window.parent." + callBack + "('" + id + "','" + name + "')");
	}
}
</script>
</body>
</html>
