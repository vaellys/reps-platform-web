<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/commons/tags.jsp"%>
<!DOCTYPE HTML>
<html>
<head>
	<title>教师信息修改</title>
	<reps:theme />
</head>
<body>
<reps:container>
	<reps:panel id="myform" dock="none" action="edit.mvc" formId="xform" validForm="true">
		<div class="block_container">
			<div class="block_title">
				<h3>个人信息</h3>
				<reps:formcontent style="width:950px;">
					<input type="hidden" name="teacher.id" value="${tschool.teacher.id}">
					<input type="hidden" name="teacher.person.id" value="${tschool.teacher.person.id}">
					<input type="hidden" name="teacher.person.validRecord" value="${tschool.teacher.person.validRecord.value}">
					<input type="hidden" name="teacher.person.lastVersion" value="${tschool.teacher.person.lastVersion}">
					<input type="hidden" name="teacher.person.oldIcType" value="${tschool.teacher.person.icType}">
					<input type="hidden" name="teacher.person.oldIcNumber" value="${tschool.teacher.person.icNumber}">
					<reps:formfield label="姓名" labelStyle="width:18%" textStyle="width:30%">
						<reps:input name="teacher.person.name" minLength="2" maxLength="36" required="true">${tschool.teacher.person.name}</reps:input>
					</reps:formfield>
					<reps:formfield label="性别" labelStyle="width:18%" textStyle="width:34%">
						<sys:dictionary src="sex" name="teacher.person.sex" headerValue="" headerText="" required="true">${tschool.teacher.person.sex}</sys:dictionary>
					</reps:formfield>
					<reps:formfield label="英文名">
						<reps:input name="teacher.person.enName" maxLength="60">${tschool.teacher.person.enName}</reps:input>
					</reps:formfield>
					<reps:formfield label="曾用名">
						<reps:input name="teacher.person.oldName" maxLength="36">${tschool.teacher.person.oldName}</reps:input>
					</reps:formfield>
					<reps:formfield label="民族">
						<sys:dictionary src="ethnicity" name="teacher.person.ethnicity" headerValue="" headerText="">${tschool.teacher.person.ethnicity}</sys:dictionary>
					</reps:formfield>
					<reps:formfield label="出生日期">
						<reps:datepicker name="teacher.person.birthday" format="yyyy-MM-dd">
							<fmt:parseDate value="${fn:trim(tschool.teacher.person.birthday)}" var="birthday" pattern="yyyyMMdd" />
							<fmt:formatDate value="${birthday}" pattern="yyyy-MM-dd" />
						</reps:datepicker>
					</reps:formfield>
					<reps:formfield label="证件号码">
						<reps:input name="teacher.person.icNumber" dataType="alphanumeric" maxLength="20" required="true">${tschool.teacher.person.icNumber}</reps:input>
					</reps:formfield>
					<reps:formfield label="证件类型">
						<sys:dictionary src="ic_type" name="teacher.person.icType">${tschool.teacher.person.icType}</sys:dictionary>
					</reps:formfield>
					<reps:formfield label="证件有效起始日期">
						<reps:datepicker name="teacher.person.icValidDateBegin" format="yyyy-MM-dd">
							<fmt:parseDate value="${fn:trim(tschool.teacher.person.icValidDateBegin)}" var="icValidDateBegin" pattern="yyyyMMdd" />
							<fmt:formatDate value="${icValidDateBegin}" pattern="yyyy-MM-dd" />
						</reps:datepicker>
					</reps:formfield>
					<reps:formfield label="证件有效截止日期">
						<reps:datepicker name="teacher.person.icValidDateEnd" format="yyyy-MM-dd">
							<fmt:parseDate value="${fn:trim(tschool.teacher.person.icValidDateEnd)}" var="icValidDateEnd" pattern="yyyyMMdd" />
							<fmt:formatDate value="${icValidDateEnd}" pattern="yyyy-MM-dd" />
						</reps:datepicker>
					</reps:formfield>
					<reps:formfield label="籍贯">
						<reps:input name="teacher.person.nativePlace" minLength="2" maxLength="20">${tschool.teacher.person.nativePlace}</reps:input>
					</reps:formfield>
					<reps:formfield label="出生地">
						<sys:dictionary src="district" id="birthPlace" name="teacher.person.birthPlace" type="input" style="width:158px;float:left;"
							headerValue="${tschool.teacher.person.birthPlace}" headerText="${tschool.teacher.person.birthPlace}">
							${tschool.teacher.person.birthPlace}
						</sys:dictionary>
						<reps:dialog cssClass="btnLook" style="margin-left:-22px;" width="300" height="370" id="dlgBirthPlace" iframe="true" 
							url="${ctx}/reps/sys/district/tree.mvc?callback=setBirthPlace&code=${tschool.teacher.person.birthPlace}" title="选择行政区" value="请选择行政区" />
					</reps:formfield>
					<reps:formfield label="国籍">
						<sys:dictionary src="country" name="teacher.person.nationality" headerValue="" headerText="">${tschool.teacher.person.nationality}</sys:dictionary>
					</reps:formfield>
					<reps:formfield label="文化程度">
						<sys:dictionary src="education_degree" name="teacher.person.educationDegree" headerValue="" headerText="">${tschool.teacher.person.educationDegree}</sys:dictionary></reps:formfield>
					<reps:formfield label="婚姻状况">
						<sys:dictionary src="marital_status" name="teacher.person.maritalStatus" headerValue="" headerText="">${tschool.teacher.person.maritalStatus}</sys:dictionary>
					</reps:formfield>
					<reps:formfield label="政治面貌">
						<sys:dictionary src="politics_status" name="teacher.person.politicsStatus" headerValue="" headerText="">${tschool.teacher.person.politicsStatus}</sys:dictionary>
					</reps:formfield>
					<reps:formfield label="宗教信仰">
						<sys:dictionary src="religion" name="teacher.person.religion" headerValue="" headerText="">${tschool.teacher.person.religion}</sys:dictionary>
					</reps:formfield>
					<reps:formfield label="港澳台侨胞">
						<sys:dictionary src="gotqw" name="teacher.person.gotqw" headerValue="" headerText="">${tschool.teacher.person.gotqw}</sys:dictionary>
					</reps:formfield>
					<reps:formfield label="健康状况">
						<sys:dictionary src="health_status" name="teacher.person.healthStatus" headerValue="" headerText="">${tschool.teacher.person.healthStatus}</sys:dictionary>
					</reps:formfield>
					<reps:formfield label="血型">
						<sys:dictionary src="blood_type" name="teacher.person.bloodType" headerValue="" headerText="">${tschool.teacher.person.bloodType}</sys:dictionary>
					</reps:formfield>
					<reps:formfield label="是否为独生子女" fullRow="true">
						<reps:select name="teacher.person.onlyChild" jsonData="{'0':'否','1':'是'}">${tschool.teacher.person.onlyChild}</reps:select>
					</reps:formfield>
					<reps:formfield label="备注" fullRow="true">
						<reps:input name="teacher.person.note" multiLine="true" maxLength="100" style="width:620px;height:50px">${tschool.teacher.person.note}</reps:input>
					</reps:formfield>
				</reps:formcontent>
			</div>
			
			<div class="block_title">
				<h3>教籍信息</h3>
				<reps:formcontent style="width:950px;">
					<input type="hidden" name="id" value="${tschool.id}">
					<input type="hidden" name="organizeId" value="${tschool.organizeId}">
					<input type="hidden" name="teacherId" value="${tschool.teacherId}">
					<reps:formfield label="学校" labelStyle="width:18%" textStyle="width:30%">${tschool.organize.name}</reps:formfield>
					<reps:formfield label="工号" labelStyle="width:18%" textStyle="width:34%">
						<reps:input name="teacher.jobNo" maxLength="20">${tschool.teacher.jobNo}</reps:input>
					</reps:formfield>
					<reps:formfield label="参加工作年月">
						<reps:datepicker name="teacher.firstWorkDate" format="yyyy-MM">
							<fmt:parseDate value="${fn:trim(tschool.teacher.firstWorkDate)}" var="firstWorkDate" pattern="yyyyMM" />
							<fmt:formatDate value="${firstWorkDate}" pattern="yyyy-MM" />
						</reps:datepicker>
					</reps:formfield>
					<reps:formfield label="从教年月">
						<reps:datepicker name="teacher.firstTeachingDate" format="yyyy-MM">
							<fmt:parseDate value="${fn:trim(tschool.teacher.firstTeachingDate)}" var="firstTeachingDate" pattern="yyyyMM" />
							<fmt:formatDate value="${firstTeachingDate}" pattern="yyyy-MM" />
						</reps:datepicker>
					</reps:formfield>
					<reps:formfield label="职称">
						<sys:dictionary src="profession_title" name="teacher.professionTitle" headerValue="" headerText="">${tschool.teacher.professionTitle}</sys:dictionary>
					</reps:formfield>
					<reps:formfield label="特长">
						<reps:input name="teacher.skill" maxLength="50">${tschool.teacher.skill}</reps:input>
					</reps:formfield>
					<reps:formfield label="工龄">
						<reps:input name="teacher.workingYears" maxLength="4">${tschool.teacher.workingYears}</reps:input>
					</reps:formfield>
					<reps:formfield label="教龄">
						<reps:input name="teacher.teachWorkingYears" maxLength="4">${tschool.teacher.teachWorkingYears}</reps:input>
					</reps:formfield>
					<reps:formfield label="档案编号">
						<reps:input name="teacher.profileNo" maxLength="10">${tschool.teacher.profileNo}</reps:input>
					</reps:formfield>
					<reps:formfield label="教职工来源">
						<sys:dictionary src="teacher_come_from" name="comeFrom" headerValue="" headerText="" required="true">${tschool.comeFrom}</sys:dictionary>
					</reps:formfield>
					<reps:formfield label="编制状态">
						<reps:select name="regularStatus" jsonData="{'1':'在编','0':'不在编'}">${tschool.regularStatus}</reps:select>
					</reps:formfield>
					<reps:formfield label="编制类别">
						<sys:dictionary src="work_bzlb" name="regularType" headerValue="" headerText="" required="true">${tschool.regularType}</sys:dictionary>
					</reps:formfield>
					<reps:formfield label="来校年月">
						<reps:datepicker name="joinSchoolDate" format="yyyy-MM">
							<fmt:parseDate value="${fn:trim(tschool.joinSchoolDate)}" var="joinSchoolDate" pattern="yyyyMM" />
							<fmt:formatDate value="${joinSchoolDate}" pattern="yyyy-MM" />
						</reps:datepicker>
					</reps:formfield>
					<reps:formfield label="岗位职业">
						<sys:dictionary src="work_role" name="workRole" headerValue="" headerText="">${tschool.workRole}</sys:dictionary>
					</reps:formfield>
					<reps:formfield label="所属学段">
						<sys:dictionary src="grade_group" name="gradeGroup" headerValue="" headerText="" filter="2,3,4">${tschool.gradeGroup}</sys:dictionary>
					</reps:formfield>
					<reps:formfield label="在岗状态" fullRow="true">
						<sys:dictionary src="position_status" name="positionStatus" headerValue="11" headerText="在职" required="true">${tschool.positionStatus}</sys:dictionary>
					</reps:formfield>
				</reps:formcontent>
			</div>
			<div class="block_title">
				<h3>账户信息</h3>
				<reps:formcontent style="width:950px;">
					<input type="hidden" name="account.id" value="${user.account.id}">
					<input type="hidden" name="account.loginName" value="${user.account.loginName}">
					<input type="hidden" name="account.nickname" value="${user.account.nickname}">
					<input type="hidden" name="account.email" value="${user.account.email}">
					<input type="hidden" name="account.mobile" value="${user.account.mobile}">
					<reps:formfield label="登录名" labelStyle="width:18%" textStyle="width:30%">
						${user.account.loginName}
					</reps:formfield>
					<reps:formfield label="适用范围" labelStyle="width:18%" textStyle="width:34%">
						<sys:dictionary src="account_scope" name="scope">${user.scope}</sys:dictionary>
					</reps:formfield>
				</reps:formcontent>
			</div>
		</div>
		<br/>
		<reps:formbar>
			<reps:ajax cssClass="btn_save" type="button" formId="xform" callBack="my" messageCode="add.button.save" />
			<reps:button type="button" cssClass="btn_cancel" onClick="back()" messageCode="add.button.cancel"></reps:button>
		</reps:formbar>
		<br/><br/>
	</reps:panel>
</reps:container>
<script type="text/javascript">
	var teacherSchoolId = "${tschool.id}";
	var temp = "";
	
	function back() {
		window.location.href= "list.mvc";
	}
	
	var my = function(data){
		messager.message(data, function(){ back(); });
	};
	
	var setBirthPlace = function(code, name){
		$("input[name='teacher.person.birthPlace']").val(code);
		$("#birthPlace").val(name);
		$.pdialog.closeDialog();
	}
</script>
</body>
</html>
