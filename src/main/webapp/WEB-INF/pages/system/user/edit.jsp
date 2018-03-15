<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/commons/tags.jsp"%>
<!DOCTYPE HTML>
<html>
<head>
	<title>修改用户</title>
	<reps:theme/>
</head>
<body>
<reps:container>
	<reps:panel id="myform" formId="xform" dock="none" action="edit.mvc" title="修改用户" validForm="true">
		<div class="block_container">
			<div class="block_title">
				<h3>用户信息</h3>
				<reps:formcontent style="width:950px;">
					<input type="hidden" name="id" value="${user.id}">
					<input type="hidden" name="accountId" value="${user.account.id}">
					<input type="hidden" name="organizeId" value="${user.organizeId}">
					<input type="hidden" name="addUser" value="${user.addUser}">
					<input type="hidden" name="userLevel" value="${user.userLevel}">
					<input type="hidden" name="userStatus" value="${user.userStatus}">
					<input type="hidden" name="addTime" value="${user.addTime}">
					<input type="hidden" name="validRecord" value="${user.validRecord.value}">
					<reps:formfield label="工作单位" labelStyle="width:18%" textStyle="width:30%">${user.organize.name}</reps:formfield>
					<reps:formfield label="用户身份" labelStyle="width:18%" textStyle="width:34%">
						<input type="hidden" name="identity" value="${user.identity}">
						<sys:dictionary src="user_identity">${user.identity}</sys:dictionary>
					</reps:formfield>
				</reps:formcontent>
			</div>
			<c:if test="${user.identity ne '00'}">
			<div class="block_title">
				<h3>个人信息</h3>
				<reps:formcontent style="width:950px;">
					<input type="hidden" name="account.person.id" value="${user.account.person.id}">
					<input type="hidden" name="account.person.validRecord" value="${user.account.person.validRecord.value}">
					<input type="hidden" name="account.person.lastVersion" value="${user.account.person.lastVersion}">
					<input type="hidden" name="account.person.oldIcType" value="${user.account.person.icType}">
					<input type="hidden" name="account.person.oldIcNumber" value="${user.account.person.icNumber}">
					<reps:formfield label="姓名" labelStyle="width:18%" textStyle="width:30%">
						<reps:input name="account.person.name" required="true" minLength="2" maxLength="36">${user.account.person.name}</reps:input>
					</reps:formfield>
					<reps:formfield label="性别" labelStyle="width:18%" textStyle="width:34%">
						<sys:dictionary src="sex" name="account.person.sex">${user.account.person.sex}</sys:dictionary>
					</reps:formfield>
					<reps:formfield label="英文名"><reps:input name="account.person.enName" maxLength="60">${user.account.person.enName}</reps:input></reps:formfield>
					<reps:formfield label="曾用名"><reps:input name="account.person.oldName" maxLength="36">${user.account.person.oldName}</reps:input></reps:formfield>
					<reps:formfield label="民族"><sys:dictionary src="ethnicity" name="account.person.ethnicity" headerValue="" headerText="">${user.account.person.ethnicity}</sys:dictionary></reps:formfield>
					<reps:formfield label="出生日期">
						<reps:datepicker name="account.person.birthday" format="yyyy-MM-dd">
							<fmt:parseDate value="${fn:trim(user.account.person.birthday)}" var="birthday" pattern="yyyyMMdd" />
							<fmt:formatDate value="${birthday}" pattern="yyyy-MM-dd" />
						</reps:datepicker>
					</reps:formfield>
					<reps:formfield label="证件号码"><reps:input name="account.person.icNumber" dataType="alphanumeric" maxLength="20" required="true">${user.account.person.icNumber}</reps:input></reps:formfield>
					<reps:formfield label="证件类型"><sys:dictionary src="ic_type" name="account.person.icType">${user.account.person.icType}</sys:dictionary></reps:formfield>
					<reps:formfield label="证件有效起始日期">
						<reps:datepicker name="account.person.icValidDateBegin" format="yyyy-MM-dd">
							<fmt:parseDate value="${fn:trim(user.account.person.icValidDateBegin)}" var="icValidDateBegin" pattern="yyyyMMdd" />
							<fmt:formatDate value="${icValidDateBegin}" pattern="yyyy-MM-dd" />
						</reps:datepicker>
					</reps:formfield>
					<reps:formfield label="证件有效截止日期">
						<reps:datepicker name="account.person.icValidDateEnd" format="yyyy-MM-dd">
							<fmt:parseDate value="${fn:trim(user.account.person.icValidDateEnd)}" var="icValidDateEnd" pattern="yyyyMMdd" />
							<fmt:formatDate value="${icValidDateEnd}" pattern="yyyy-MM-dd" />
						</reps:datepicker>
					</reps:formfield>
					<reps:formfield label="籍贯"><reps:input name="account.person.nativePlace" minLength="2" maxLength="20">${user.account.person.nativePlace}</reps:input></reps:formfield>
					<reps:formfield label="出生地">
						<sys:dictionary src="district" style="width:158px;float:left;background:#fff;" id="birthPlace" name="account.person.birthPlace" type="input" 
							headerValue="${user.account.person.birthPlace}" headerText="${user.account.person.birthPlace}">${user.account.person.birthPlace}</sys:dictionary>
						<reps:dialog cssClass="btnLook" style="margin-left:-22px;" width="300" height="370" id="dlgBirthPlace" iframe="true" 
							url="${ctx}/reps/sys/district/tree.mvc?callback=setBirthPlace&code=${user.account.person.birthPlace}" title="选择行政区" value="请选择行政区" />
					</reps:formfield>
					<reps:formfield label="国籍"><sys:dictionary src="country" name="account.person.nationality" headerValue="" headerText="">${user.account.person.nationality}</sys:dictionary></reps:formfield>
					<reps:formfield label="文化程度"><sys:dictionary src="education_degree" name="account.person.educationDegree" headerValue="" headerText="">${user.account.person.educationDegree}</sys:dictionary></reps:formfield>
					<reps:formfield label="婚姻状况"><sys:dictionary src="marital_status" name="account.person.maritalStatus" headerValue="" headerText="">${user.account.person.maritalStatus}</sys:dictionary></reps:formfield>
					<reps:formfield label="政治面貌"><sys:dictionary src="politics_status" name="account.person.politicsStatus" headerValue="" headerText="">${user.account.person.politicsStatus}</sys:dictionary></reps:formfield>
					<reps:formfield label="宗教信仰"><sys:dictionary src="religion" name="account.person.religion" headerValue="" headerText="">${user.account.person.religion}</sys:dictionary></reps:formfield>
					<reps:formfield label="港澳台侨胞"><sys:dictionary src="gotqw" name="account.person.gotqw" headerValue="" headerText="">${user.account.person.gotqw}</sys:dictionary></reps:formfield>
					<reps:formfield label="健康状况"><sys:dictionary src="health_status" name="account.person.healthStatus" headerValue="" headerText="">${user.account.person.healthStatus}</sys:dictionary></reps:formfield>
					<reps:formfield label="血型"><sys:dictionary src="blood_type" name="account.person.bloodType" headerValue="" headerText="">${user.account.person.bloodType}</sys:dictionary></reps:formfield>
					<reps:formfield label="是否为独生子女" fullRow="true">
						<reps:select id="onlyChild" name="account.person.onlyChild" jsonData="{'0':'否','1':'是'}">${user.account.person.onlyChild}</reps:select>
					</reps:formfield>
					<reps:formfield label="备注" fullRow="true">
						<reps:input name="account.person.note" multiLine="true" maxLength="100" style="width:620px;height:50px">${user.account.person.note}</reps:input>
					</reps:formfield>
				</reps:formcontent>
			</div>
			</c:if>
			<div class="block_title">
				<h3>账户信息</h3>
				<reps:formcontent style="width:950px;">
					<input type="hidden" name="account.id" value="${user.account.id}">
					<input type="hidden" name="account.personId" value="${user.account.personId}">
					<input type="hidden" name="account.isEnabled" value="${user.account.isEnabled}">
					<input type="hidden" name="account.flag" value="${user.account.flag}">
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
			<div class="block_title">
				<h3>权限信息</h3>
				<reps:formcontent style="width:950px;">
					<reps:formfield label="账户权限" fullRow="true">
						<reps:tree id="accountTree" items="${accountAuthorizations}" var="menu" cssClass="treeFolder" checkbox="false" expand="false">
						    <reps:treenode parentKey="${menu.parentCode}" key="${menu.code}">
						       <a href="javascript:void(0);"><span title="${menu.name}">${menu.name}</span></a>
						    </reps:treenode>
						</reps:tree>
		 			</reps:formfield>
					<reps:formfield label="用户权限" fullRow="true">
						<reps:tree id="userTree" items="${userAuthorizations}" var="menu" cssClass="treeFolder" checkbox="false" expand="false">
						    <reps:treenode parentKey="${menu.parentCode}" key="${menu.code}">
						       <a href="javascript:void(0);"><span title="${menu.name}">${menu.name}</span></a>
						    </reps:treenode>
						</reps:tree>
		 			</reps:formfield>
				</reps:formcontent>
			</div>
		</div>
		<reps:formbar>
			<reps:ajax cssClass="btn_edit" type="button" formId="xform" callBack="my" messageCode="edit.button.save" />
			<reps:button cssClass="btn_cancel" type="button" onClick="back()" messageCode="edit.button.cancel" />
	   	</reps:formbar>
		</br>
   </reps:panel>
</reps:container>
<script type="text/javascript">
// $(function(){
// 	var freq = {
// 		'1' : '一级',
// 		'2' : '二级',
// 		'3' : '三级',
// 		'4' : '四级',
// 		'5' : '五级',
// 		'6' : '六级',
// 		'7' : '七级',
// 		'8' : '八级',
// 		'9' : '九级'
// 	};
	
// 	$.each(freq, function(value, text){
// 		var option = new Option(text, value);
// 		if (value == "${user.userLevel}"){
// 			option.selected = true;
// 		}
// 		$('#userLevel').append($(option));
// 	});
// });

function back() 
{
	//返回列表页
	window.location.href= "list.mvc";
}
var my = function(data)
{
	messager.message(data, function(){ back(); });
};

var setBirthPlace = function(code, name){
	$("input[name='account.person.birthPlace']").val(code);
	$("#birthPlace").val(name);
	$.pdialog.closeDialog();
}
</script>
</body>
</html>
