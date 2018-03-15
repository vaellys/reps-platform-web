<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/commons/tags.jsp"%>
<!DOCTYPE HTML>
<html>
<head>
	<title>查看用户</title>
	<reps:theme/>
</head>
<body>
<reps:container>
	<reps:panel id="myform" formId="xform" dock="none" action="edit.mvc" title="修改用户" validForm="true">
		<div class="block_container">
			<div class="block_title">
				<h3>用户信息</h3>
				<reps:formcontent style="width:950px;">
					<reps:formfield label="工作单位" labelStyle="width:18%" textStyle="width:30%">${user.organize.name}</reps:formfield>
					<reps:formfield label="用户身份" labelStyle="width:18%" textStyle="width:34%">
						<sys:dictionary src="user_identity">${user.identity}</sys:dictionary>
					</reps:formfield>
					<reps:formfield label="用户状态">
						${user.userStatus.value eq 1 ? '启用' : '禁用'}
					</reps:formfield>
					<reps:formfield label="适用范围">
						<sys:dictionary src="account_scope">${user.scope}</sys:dictionary>
					</reps:formfield>
				</reps:formcontent>
			</div>
			<c:if test="${user.identity ne '00'}">
			<div class="block_title">
				<h3>个人信息</h3>
				<reps:formcontent style="width:950px;">
					<reps:formfield label="姓名" labelStyle="width:18%" textStyle="width:30%">
						${user.account.person.name}
					</reps:formfield>
					<reps:formfield label="性别" labelStyle="width:18%" textStyle="width:34%">
						<sys:dictionary src="sex">${user.account.person.sex}</sys:dictionary>
					</reps:formfield>
					<reps:formfield label="英文名">${user.account.person.enName}</reps:formfield>
					<reps:formfield label="曾用名">${user.account.person.oldName}</reps:formfield>
					<reps:formfield label="民族"><sys:dictionary src="ethnicity">${user.account.person.ethnicity}</sys:dictionary></reps:formfield>
					<reps:formfield label="出生日期">
						<fmt:parseDate value="${fn:trim(user.account.person.birthday)}" var="birthday" pattern="yyyyMMdd" />
						<fmt:formatDate value="${birthday}" pattern="yyyy-MM-dd" />
					</reps:formfield>
					<reps:formfield label="证件号码">${user.account.person.icNumber}</reps:formfield>
					<reps:formfield label="证件类型"><sys:dictionary src="ic_type">${user.account.person.icType}</sys:dictionary></reps:formfield>
					<reps:formfield label="证件有效起始日期">
						<fmt:parseDate value="${fn:trim(user.account.person.icValidDateBegin)}" var="icValidDateBegin" pattern="yyyyMMdd" />
						<fmt:formatDate value="${icValidDateBegin}" pattern="yyyy-MM-dd" />
					</reps:formfield>
					<reps:formfield label="证件有效截止日期">
						<fmt:parseDate value="${fn:trim(user.account.person.icValidDateEnd)}" var="icValidDateEnd" pattern="yyyyMMdd" />
						<fmt:formatDate value="${icValidDateEnd}" pattern="yyyy-MM-dd" />
					</reps:formfield>
					<reps:formfield label="籍贯">${user.account.person.nativePlace}</reps:formfield>
					<reps:formfield label="出生地">
						<sys:dictionary src="district">${user.account.person.birthPlace}</sys:dictionary>
					</reps:formfield>
					<reps:formfield label="国籍"><sys:dictionary src="country">${user.account.person.nationality}</sys:dictionary></reps:formfield>
					<reps:formfield label="文化程度"><sys:dictionary src="education_degree">${user.account.person.educationDegree}</sys:dictionary></reps:formfield>
					<reps:formfield label="婚姻状况"><sys:dictionary src="marital_status">${user.account.person.maritalStatus}</sys:dictionary></reps:formfield>
					<reps:formfield label="政治面貌"><sys:dictionary src="politics_status">${user.account.person.politicsStatus}</sys:dictionary></reps:formfield>
					<reps:formfield label="宗教信仰"><sys:dictionary src="religion">${user.account.person.religion}</sys:dictionary></reps:formfield>
					<reps:formfield label="港澳台侨胞"><sys:dictionary src="gotqw">${user.account.person.gotqw}</sys:dictionary></reps:formfield>
					<reps:formfield label="健康状况"><sys:dictionary src="health_status">${user.account.person.healthStatus}</sys:dictionary></reps:formfield>
					<reps:formfield label="血型"><sys:dictionary src="blood_type">${user.account.person.bloodType}</sys:dictionary></reps:formfield>
					<reps:formfield label="是否为独生子女" fullRow="true">
						${user.account.person.onlyChild eq 1 ? '是' : '否'}
					</reps:formfield>
					<reps:formfield label="备注" fullRow="true">
						${user.account.person.note}
					</reps:formfield>
				</reps:formcontent>
			</div>
			</c:if>
			<div class="block_title">
				<h3>账户信息</h3>
				<reps:formcontent style="width:950px;">
					<reps:formfield label="登录名" labelStyle="width:18%" textStyle="width:30%">
						${user.account.loginName}
					</reps:formfield>
					<reps:formfield label="昵称" labelStyle="width:18%" textStyle="width:34%">
						${user.account.nickname}
					</reps:formfield>
					<reps:formfield label="邮箱">${user.account.email}</reps:formfield>
					<reps:formfield label="手机">${user.account.mobile}</reps:formfield>
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
			<reps:button cssClass="btn_cancel" type="button" onClick="back()" messageCode="edit.button.cancel" />
	   	</reps:formbar>
		</br>
   </reps:panel>
</reps:container>
<script type="text/javascript">
function back() {
	//返回列表页
	window.location.href= "list.mvc";
}
</script>
</body>
</html>
