<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/commons/tags.jsp"%>
<!DOCTYPE HTML>
<html>
<head>
	<title>教师学籍管理</title>
	<reps:theme />
</head>
<body>
<reps:container layout="true">
	<reps:panel id="mytop" dock="top" action="list.mvc" method="post" formId="queryForm">
		<input type="hidden" name="type" value="2">
		<reps:formcontent parentLayout="true" style="width:80%;">
			<reps:formfield label="机构名称" labelStyle="width:20%;" textStyle="width:27%;">
				<reps:input name="organize.name">${query.organize.name}</reps:input>
			</reps:formfield>
			<reps:formfield label="姓名" labelStyle="width:23%;" textStyle="width:30%;">
				<reps:input name="teacher.person.name">${query.teacher.person.name}</reps:input>
			</reps:formfield>
			<reps:formfield label="证件号码">
				<reps:input name="teacher.person.icNumber">${query.teacher.person.icNumber}</reps:input>
			</reps:formfield>
			<reps:formfield label="性别">
				<sys:dictionary src="sex" name="teacher.person.sex" headerValue="" headerText="">${query.teacher.person.sex}</sys:dictionary>
			</reps:formfield>
		</reps:formcontent>
		<reps:querybuttons>
			<reps:ajaxgrid messageCode="manage.button.query" formId="queryForm" gridId="mygrid" cssClass="search-form-a"></reps:ajaxgrid>
		</reps:querybuttons>
		<reps:footbar>
			<reps:button menuCode="school050102" cssClass="add-a" messageCode="manage.action.add"></reps:button>
			<reps:button action="#" cssClass="uploading-a" value="导入" onClick="importTeacher()"></reps:button>
		</reps:footbar>
	</reps:panel>
	<reps:panel id="mybody" dock="center">
		<reps:grid id="mygrid" items="${list}" var="tschool" form="queryForm" flagSeq="true" pagination="${pager}">
			<reps:gridrow>
				<reps:gridfield title="姓名" width="8">${tschool.name}</reps:gridfield>
				<reps:gridfield title="性别" width="6" align="center"><sys:dictionary src="sex">${tschool.sex}</sys:dictionary></reps:gridfield>
				<reps:gridfield title="登录名" width="10" align="center">${tschool.loginName}</reps:gridfield>
				<reps:gridfield title="岗位职业" width="10" align="center"><sys:dictionary src="work_role">${tschool.workRole}</sys:dictionary></reps:gridfield>
				<reps:gridfield title="来源" width="10" align="center"><sys:dictionary src="teacher_come_from">${tschool.comeFrom}</sys:dictionary></reps:gridfield>
				<reps:gridfield title="工作单位" width="13">${tschool.organizeName}</reps:gridfield>
				<reps:gridfield title="在岗状态" width="9" align="center"><sys:dictionary src="position_status">${tschool.positionStatus}</sys:dictionary></reps:gridfield>
				<reps:gridfield title="操作" width="24">
					<reps:button messageCode="manage.action.detail" menuCode="school050101" cssClass="detail-table" action="showdetail.mvc?id=${tschool.id}"></reps:button>
					<reps:button messageCode="manage.action.update" menuCode="school050103" cssClass="modify-table" action="toedit.mvc?id=${tschool.id}"></reps:button>
					<sys:authority code="school050104">
						<reps:ajax messageCode="manage.action.delete" id="delete" url="delete.mvc?id=${tschool.id}&teacherId=${tschool.teacherId}"
							cssClass="delete-table" confirm="您确定要删除所选行吗？" redirect="list.mvc"></reps:ajax>
					</sys:authority>
					<sys:authority code="school050105">
						<reps:dialog cssClass="setting-table" type="link" id="changepassword${tschool.id}" iframe="true" 
							width="430" height="200" url="tochangepassword.mvc?id=${tschool.id}" title="${tschool.name}-修改密码" value="修改密码"  />
				    </sys:authority>
				</reps:gridfield>
			</reps:gridrow>
		</reps:grid>
	</reps:panel>
</reps:container>
<script type="text/javascript">

	var importTeacher = function(d){
		window.location.href = "${ctx}/reps/school/executeimport/teacherlist.mvc?orgTypes=61,62,71,72,81,82&isManager=1";
	}

	var exportExcel = function() {
		var total = $("input[name='totalRecord']").val();
		if (total > 10000) {
			alert("数据太多, 导出失败. 请重新筛选数据, 再使用导出功能.");
			return false;
		}
		var schoolName = $("input[name='school.organize.name']").val();
		var teacherName = $("input[name='teacher.person.name']").val();
		var icNumber = $("input[name='teacher.person.icNumber']").val();
		var sex = $("select[name='teacher.person.sex']").val();
		$("#queryForm").attr("action", "export.mvc");
		$("#queryForm").submit();
		$("#queryForm").attr("action", "list.mvc");
	}
</script>
</body>
</html>