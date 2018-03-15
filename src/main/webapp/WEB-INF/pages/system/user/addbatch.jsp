<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/commons/tags.jsp"%>
<!DOCTYPE HTML>
<html>
<head>
	<title>添加用户</title>
	<reps:theme/>
</head>
<body>
<reps:container>
	<reps:panel id="myform" formId="xform" dock="none" action="batchadd.mvc" title="批量添加用户" validForm="true">
		<div class="block_container">
			<div class="block_title">
				<h3>批量添加管理员账号</h3>
				<reps:formcontent style="width:950px;">
					<reps:formfield label="用户身份" fullRow="true">
						<input type="checkbox" id="identity1" name="identity" value="1"><label for="identity1">&nbsp;区县管理员</label>
						<input type="checkbox" id="identity2" name="identity" value="2"><label for="identity2">&nbsp;学校管理员</label>
					</reps:formfield>
					<reps:formfield label="区县教育局" fullRow="true">
						<reps:select id="orgId" name="organizeId" dictionaryItem="${districtList}" required="true"></reps:select>
					</reps:formfield>
					<reps:formfield label="初始密码" fullRow="true">
						<reps:input id="password" name="account.password" required="true" minLength="6" maxLength="18" />
					</reps:formfield>
					
				</reps:formcontent>
	   	<br/>
		<reps:formbar>
			<reps:ajax cssClass="btn_save" type="button" formId="xform" callBack="my" messageCode="add.button.save" />
			<reps:button cssClass="btn_cancel" type="button" onClick="back()" messageCode="add.button.cancel" />
	   	</reps:formbar>
			</div>
		</div>
   	</reps:panel>
</reps:container>
<script type="text/javascript">
	function back() {
		window.location.href= "list.mvc";
	}
	
	var my = function(data){
		messager.message(data, function(){ back(); });
	};

</script>
</body>
</html>
