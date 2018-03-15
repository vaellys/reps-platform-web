<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/commons/tags.jsp"%>
<!DOCTYPE HTML>
<html>
<head>
	<title>教师详细信息</title>
	<reps:theme />
</head>
<body>
<reps:container>
	<reps:panel id="myform" dock="none" formId="xform" validForm="true" style="width:900px;">
		<div class="block_title">
			<h3>个人信息</h3>
			<reps:detail id="basicinfo" borderFlag="true" textBackgroundFlag="false">
				<reps:detailfield label="姓名" labelStyle="width:22%;" textStyle="width:28%;">${tschool.teacher.person.name}</reps:detailfield>
				<reps:detailfield label="性别" labelStyle="width:22%;" textStyle="width:28%;">
					<sys:dictionary src="sex">${tschool.teacher.person.sex}</sys:dictionary>
				</reps:detailfield>
				<reps:detailfield label="英文名">${tschool.teacher.person.enName}</reps:detailfield>
				<reps:detailfield label="曾用名" >${tschool.teacher.person.oldName}</reps:detailfield>
				<reps:detailfield label="民族"><sys:dictionary src="ethnicity">${tschool.teacher.person.ethnicity}</sys:dictionary></reps:detailfield>
				<reps:detailfield label="出生日期">
					<fmt:parseDate value="${fn:trim(tschool.teacher.person.birthday)}" var="birthday" pattern="yyyyMMdd"/>
					<fmt:formatDate value="${birthday}" pattern="yyyy-MM-dd" />
				</reps:detailfield>
				<reps:detailfield label="证件号码">${tschool.teacher.person.icNumber}</reps:detailfield>
				<reps:detailfield label="证件类型"><sys:dictionary src="ic_type">${tschool.teacher.person.icType}</sys:dictionary></reps:detailfield>
				<reps:detailfield label="证件有效起始日期">
					<fmt:parseDate value="${fn:trim(tschool.teacher.person.icValidDateBegin)}" var="icValidDateBegin" pattern="yyyyMMdd"/>
					<fmt:formatDate value="${icValidDateBegin}" pattern="yyyy-MM-dd" />
				</reps:detailfield>
				<reps:detailfield label="证件有效截止日期">
					<fmt:parseDate value="${fn:trim(tschool.teacher.person.icValidDateEnd)}" var="icValidDateEnd" pattern="yyyyMMdd"/>
					<fmt:formatDate value="${icValidDateEnd}" pattern="yyyy-MM-dd" />
				</reps:detailfield>
				<reps:detailfield label="籍贯">${tschool.teacher.person.nativePlace}</reps:detailfield>
				<reps:detailfield label="出生地"><sys:dictionary src="district">${tschool.teacher.person.birthPlace}</sys:dictionary></reps:detailfield>
				<reps:detailfield label="国籍"><sys:dictionary src="country">${tschool.teacher.person.nationality}</sys:dictionary></reps:detailfield>
				<reps:detailfield label="文化程度"><sys:dictionary src="education_degree">${tschool.teacher.person.educationDegree}</sys:dictionary></reps:detailfield>
				<reps:detailfield label="婚姻状况"><sys:dictionary src="marital_status">${tschool.teacher.person.maritalStatus}</sys:dictionary></reps:detailfield>
				<reps:detailfield label="政治面貌"><sys:dictionary src="politics_status">${tschool.teacher.person.politicsStatus}</sys:dictionary></reps:detailfield>
				<reps:detailfield label="宗教信仰"><sys:dictionary src="religion">${tschool.teacher.person.religion}</sys:dictionary></reps:detailfield>
				<reps:detailfield label="港澳台侨胞"><sys:dictionary src="gotqw">${tschool.teacher.person.gotqw}</sys:dictionary></reps:detailfield>
				<reps:detailfield label="健康状况"><sys:dictionary src="health_status">${tschool.teacher.person.healthStatus}</sys:dictionary></reps:detailfield>
				<reps:detailfield label="血型"><sys:dictionary src="blood_type">${tschool.teacher.person.bloodType}</sys:dictionary></reps:detailfield>
				<reps:detailfield label="是否为独生子女" fullRow="true">${tschool.teacher.person.onlyChild == 1 ? '是' : '否'}</reps:detailfield>
				<reps:detailfield label="备注" fullRow="true">${tschool.teacher.person.note}</reps:detailfield>
			</reps:detail>
		</div> 
		<div class="block_title">
			<h3>教籍信息</h3>
			<reps:detail id="registerinfo" borderFlag="true" textBackgroundFlag="false">
				<reps:detailfield label="工作单位" labelStyle="width:22%" textStyle="width:28%">${tschool.organize.name}</reps:detailfield>
				<reps:detailfield label="工号" labelStyle="width:22%;" textStyle="width:28%;">${tschool.teacher.jobNo}</reps:detailfield>
				<reps:detailfield label="参加工作年月">
					<fmt:parseDate value="${fn:trim(tschool.teacher.firstWorkDate)}" var="firstWorkDate" pattern="yyyyMM"/>
					<fmt:formatDate value="${firstWorkDate}" pattern="yyyy-MM" />
				</reps:detailfield>
				<reps:detailfield label="从教年月">
					<fmt:parseDate value="${fn:trim(tschool.teacher.firstTeachingDate)}" var="firstTeachingDate" pattern="yyyyMM"/>
					<fmt:formatDate value="${firstTeachingDate}" pattern="yyyy-MM" />
				</reps:detailfield>
				<reps:detailfield label="职称">
					<sys:dictionary src="profession_title">${tschool.teacher.professionTitle}</sys:dictionary>
				</reps:detailfield>
				<reps:detailfield label="特长">${tschool.teacher.skill}</reps:detailfield>
				<reps:detailfield label="工龄">${tschool.teacher.workingYears}</reps:detailfield>
				<reps:detailfield label="教龄">${tschool.teacher.teachWorkingYears}</reps:detailfield>
				<reps:detailfield label="档案编号">${tschool.teacher.profileNo}</reps:detailfield>
				<reps:detailfield label="教职工来源">
					<sys:dictionary src="teacher_come_from">${tschool.comeFrom}</sys:dictionary>
				</reps:detailfield>
				<reps:detailfield label="编制状态">${tschool.regularStatus == 1 ? '在编' : '不在编'}</reps:detailfield>
				<reps:detailfield label="编制类别"><sys:dictionary src="work_bzlb">${tschool.regularType}</sys:dictionary></reps:detailfield>
				<reps:detailfield label="来校年月">
					<fmt:parseDate value="${fn:trim(tschool.joinSchoolDate)}" var="joinSchoolDate" pattern="yyyyMM"/>
					<fmt:formatDate value="${joinSchoolDate}" pattern="yyyy-MM" />
				</reps:detailfield>
				<reps:detailfield label="岗位职业"><sys:dictionary src="work_role">${tschool.workRole}</sys:dictionary></reps:detailfield>
				<reps:detailfield label="所属学段"><sys:dictionary src="grade_group">${tschool.gradeGroup}</sys:dictionary></reps:detailfield>
				<reps:detailfield label="在岗状态"><sys:dictionary src="position_status">${tschool.positionStatus}</sys:dictionary></reps:detailfield>
			</reps:detail>
		</div>
		<div class="block_title">
			<h3>账户信息</h3>
			<reps:detail id="accountinfo" borderFlag="true" textBackgroundFlag="false">
				<reps:detailfield label="登录名" labelStyle="width:22%" textStyle="width:28%">${account.loginName}</reps:detailfield>
				<reps:detailfield label="昵称" labelStyle="width:22%" textStyle="width:28%">${account.nickname}</reps:detailfield>
				<reps:detailfield label="邮箱">${account.email}</reps:detailfield>
				<reps:detailfield label="手机">${account.mobile}</reps:detailfield>
			</reps:detail>
		</div>
		<br/>
		<reps:formbar>
			<reps:button type="button" messageCode="detail.button.return"  cssClass="btn_back" onClick="back()"></reps:button>
		</reps:formbar>
		<br/><br/>
	</reps:panel>
</reps:container>
<script type="text/javascript">
	function back(){
		window.location.href="list.mvc";
	}
</script>
</body>
</html>
