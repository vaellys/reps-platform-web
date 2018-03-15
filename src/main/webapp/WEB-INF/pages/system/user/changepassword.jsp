<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/commons/tags.jsp"%>
<!DOCTYPE HTML>
<html>
<head>
	<title>修改密码</title>
	<reps:theme/>
</head>
<body>
<reps:container>
	<reps:panel id="changepasswordForm" dock="none" action="${ctx}/reps/sys/user/changepassword.mvc" formId="changepasswordxform" validForm="true">
		<reps:formcontent>
			<input type="hidden" name="id" value="${id}" />
			<reps:formfield label="新密码" fullRow="true"><reps:input name="password" type="password" id="password" required="true" minLength="6" maxLength="18" /></reps:formfield>
			<reps:formfield label="重复密码" fullRow="true"><reps:input name="rePassword" type="password" equalTo="#password" required="true" minLength="6" maxLength="18" /></reps:formfield>
		</reps:formcontent>
		<br/><br/>
		<reps:formbar>
			<reps:ajax cssClass="small_btn_save" type="button" id="changepassword" formId="changepasswordxform" callBack="my" messageCode="edit.button.save"/>
		</reps:formbar>
	</reps:panel>
</reps:container>
<script type="text/javascript">
var my = function(data){
	messager.message(data,function(){ 
		$.pdialog.pdialogClose();
	});
};
</script>
</body>
</html>
