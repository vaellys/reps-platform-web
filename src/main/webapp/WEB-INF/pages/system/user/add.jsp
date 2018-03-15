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
	<reps:panel id="myform" formId="xform" dock="none" action="add.mvc" title="添加用户" validForm="true">
		<div class="block_container">
			<div class="block_title">
				<h3>用户信息</h3>
				<reps:formcontent style="width:950px;">
					<input type="hidden" name="userLevel" />
					<reps:formfield label="工作单位" labelStyle="width:18%" textStyle="width:30%">
						<sys:organize hideId="orgId" name="orgName" id="orgname" hideName="organize.id" required="true" readonly="true"></sys:organize>
					</reps:formfield>
					<reps:formfield label="用户身份" labelStyle="width:18%" textStyle="width:34%">
						<reps:select id="identity" name="identity" jsonData="{'':'','00':'管理员','50':'志愿者'}" required="true"></reps:select>
					</reps:formfield>
				</reps:formcontent>
			</div>
			<div class="block_title" id="divPerson">
				<h3>个人信息</h3>
				<reps:formcontent style="width:950px;">
					<input type="hidden" name="account.person.id">
					<input type="hidden" name="account.person.lastVersion" value="0">
					<reps:formfield label="姓名" labelStyle="width:18%" textStyle="width:30%">
						<reps:input id="personName" name="account.person.name" required="true" minLength="2" maxLength="36" />
						<reps:dialog cssClass="add-a" id="selectPerson" iframe="true" width="600" height="400"
							url="${ctx}${actionBasePath}/sys/chooseperson/single.mvc?dialogId=selectPerson&callBack=choosePersonBack&showName=account.person.name" value="选择人员"></reps:dialog>
					</reps:formfield>
					<reps:formfield label="性别" labelStyle="width:18%" textStyle="width:34%">
						<sys:dictionary src="sex" name="account.person.sex"></sys:dictionary>
					</reps:formfield>
					<reps:formfield label="英文名"><reps:input name="account.person.enName" maxLength="60" /></reps:formfield>
					<reps:formfield label="曾用名"><reps:input name="account.person.oldName" maxLength="36" /></reps:formfield>
					<reps:formfield label="民族"><sys:dictionary src="ethnicity" name="account.person.ethnicity" headerValue="" headerText="" /></reps:formfield>
					<reps:formfield label="出生日期"><reps:datepicker name="account.person.birthday" format="yyyy-MM-dd" /></reps:formfield>
					<reps:formfield label="证件号码"><reps:input name="account.person.icNumber" dataType="alphanumeric" maxLength="20" required="true" /></reps:formfield>
					<reps:formfield label="证件类型"><sys:dictionary src="ic_type" name="account.person.icType" /></reps:formfield>
					<reps:formfield label="证件有效起始日期"><reps:datepicker name="account.person.icValidDateBegin" format="yyyy-MM-dd" /></reps:formfield>
					<reps:formfield label="证件有效截止日期"><reps:datepicker name="account.person.icValidDateEnd" format="yyyy-MM-dd" /></reps:formfield>
					<reps:formfield label="籍贯"><reps:input name="account.person.nativePlace" minLength="2" maxLength="20" /></reps:formfield>
					<reps:formfield label="出生地">
						<sys:dictionary src="district" style="width:158px;float:left;" id="birthPlace" name="account.person.birthPlace" type="input" headerValue="" headerText="" />
					</reps:formfield>
					<reps:formfield label="国籍"><sys:dictionary src="country" name="account.person.nationality" headerValue="" headerText="" type="input" /></reps:formfield>
					<reps:formfield label="文化程度"><sys:dictionary src="education_degree" name="account.person.educationDegree" headerValue="" headerText="" /></reps:formfield>
					<reps:formfield label="婚姻状况"><sys:dictionary src="marital_status" name="account.person.maritalStatus" headerValue="" headerText="" /></reps:formfield>
					<reps:formfield label="政治面貌"><sys:dictionary src="politics_status" name="account.person.politicsStatus" headerValue="" headerText="" /></reps:formfield>
					<reps:formfield label="宗教信仰"><sys:dictionary src="religion" name="account.person.religion" headerValue="" headerText="" /></reps:formfield>
					<reps:formfield label="港澳台侨胞"><sys:dictionary src="gotqw" name="account.person.gotqw" headerValue="" headerText="" /></reps:formfield>
					<reps:formfield label="健康状况"><sys:dictionary src="health_status" name="account.person.healthStatus" headerValue="" headerText="" /></reps:formfield>
					<reps:formfield label="血型"><sys:dictionary src="blood_type" name="account.person.bloodType" headerValue="" headerText="" /></reps:formfield>
					<reps:formfield label="是否为独生子女" fullRow="true">
						<reps:select id="onlyChild" name="account.person.onlyChild" jsonData="{'0':'否','1':'是'}" />
					</reps:formfield>
					<reps:formfield label="备注" fullRow="true">
						<reps:input name="account.person.note" multiLine="true" maxLength="100" style="width:620px;height:50px" />
					</reps:formfield>
				</reps:formcontent>
			</div>
			<div class="block_title" id="divAccount">
				<h3>账户绑定</h3>
				<reps:formcontent style="width:950px;">
					<input type="hidden" name="account.id">
					<reps:formfield label="登录名" labelStyle="width:18%" textStyle="width:30%">
						<reps:input id="loginName" name="account.loginName" dataType="userregister" required="true" minLength="3" maxLength="32" />
						<reps:dialog cssClass="add-a" id="selectAccount" iframe="true" width="600" height="400"
							url="${ctx}${actionBasePath}/sys/chooseaccount/single.mvc?dialogId=selectAccount&callBack=chooseAccountBack&showName=account.loginName" value="选择账号"></reps:dialog>
					</reps:formfield>
					<reps:formfield label="适用范围" labelStyle="width:18%" textStyle="width:34%"><sys:dictionary src="account_scope" name="scope" /></reps:formfield>
					<reps:formfield label="密码"><reps:input id="password" name="account.password" type="password" required="true" minLength="6" maxLength="18" /></reps:formfield>
					<reps:formfield label="重复密码"><reps:input name="rePassword" type="password" equalTo="#password" required="true" minLength="6" maxLength="18" /></reps:formfield>
				</reps:formcontent>
			</div>
		</div>
		<reps:formbar>
			<reps:ajax cssClass="btn_save" type="button" formId="xform" callBack="my" messageCode="add.button.save" />
			<reps:button cssClass="btn_cancel" type="button" onClick="back()" messageCode="add.button.cancel" />
	   	</reps:formbar>
	   	<br/>
   	</reps:panel>
</reps:container>
<script type="text/javascript">
	var chooseAccoutUrl = $("#selectAccount").attr("href");
	
	$(function(){
// 		var freq = {
// 			'1' : '一级',
// 			'2' : '二级',
// 			'3' : '三级',
// 			'4' : '四级',
// 			'5' : '五级',
// 			'6' : '六级',
// 			'7' : '七级',
// 			'8' : '八级',
// 			'9' : '九级'
// 		};
// 		$.each(freq, function(value, text){
// 			var option = new Option(text, value);
// 			if (value == "3"){
// 				option.selected = true;
// 			}
// 			$('#userLevel').append($(option));
// 		});
		
		$('#identity').change(function(){
			if ($(this).val() == "00"){
				$('#divPerson').hide();
				$('#selectAccount').hide();
			} else {
				$('#divPerson').show();
				$('#selectAccount').show();
			}
		});
	});
	
	function back() {
		window.location.href= "list.mvc";
	}
	
	var my = function(data){
		messager.message(data, function(){ back(); });
	};

	var choosePersonBack = function(id, name){
		$.ajax({
			type: "GET",
			url: "${ctx}${actionBasePath}/sys/chooseperson/getdetail.mvc",
			dataType: "json",
			data: {"id" : id, "run" : Math.random()},
			success: function(data){
				//初始化人员信息
				$("#divPerson").find(".txtInput,select,input[type=hidden]").each(function(){
					var objName = $(this).attr("name");
					var name = objName.replace("account.person.", "");
					var value = eval("data." + name);
					
					if ($(this).hasClass('date')){
						if (value){
							value = value.substring(0,4) + "-" + value.substring(4,6) + "-" + value.substring(6);
						}
					}
					$("[name='" + objName + "']").val(value);
				});
				//如果是选择人员，姓名和证件号码不许修改
				$("input[name='account.person.name']").attr("readonly", "readonly");
				$("input[name='account.person.name']").css("background-color", "rgb(233, 233, 233)");
				$("input[name='account.person.icNumber']").attr("readonly", "readonly");
				$("input[name='account.person.icNumber']").css("background-color", "rgb(233, 233, 233)");
				
				//限制账户选择范围
				$("#selectAccount").attr("href", chooseAccoutUrl + "&personId=" + $("input[name='account.person.id']").val());
				
				//初始化账户信息
				getAccount($("input[name='account.person.id']").val());
			}
		});
	};

	var chooseAccountBack = function(id, name){
		$.ajax({
			type: "GET",
			url: "${ctx}${actionBasePath}/sys/chooseaccount/getdetail.mvc",
			dataType: "json",
			data: {"id" : id, "run" : Math.random()},
			success: function(data){
				$("#divAccount").find(".txtInput,input[type=hidden]").each(function(){
					var objName = $(this).attr("name");
					var name = objName.replace("account.", "");
					$("[name='" + objName + "']").val(eval("data." + name));
				});
				
				//如果是选择账户，登录名不许修改；密码也不需要输入
				$("input[name='account.loginName']").attr("readonly", "readonly");
				$("input[name='account.loginName']").css("background-color", "rgb(233, 233, 233)");
				
				$("input[name='account.password']").parent().parent().hide();
				$("input[name='account.password']").removeClass("required");
				$("input[name='rePassword']").removeClass("required");
				$("input[name='account.password']").val("");
			}
		});
	};
	
	var getAccount = function(personId){
		$.ajax({
			type: "GET",
			url: "${ctx}${actionBasePath}/sys/chooseaccount/getbypersonid.mvc",
			dataType: "json",
			data: {"personId" : personId, "run" : Math.random()},
			success: function(data){
				if (data == null){
					$("#divAccount").find(".txtInput,input[type=hidden]").each(function(){
						var objName = $(this).attr("name");
						var name = objName.replace("account.", "");
						$("[name='" + objName + "']").val("");
					});
					
					//恢复编辑状态
					$("input[name='account.loginName']").removeAttr("readonly");
					$("input[name='account.loginName']").css("background-color", "");
					
					$("input[name='account.password']").parent().parent().show();
					$("input[name='account.password']").addClass("required");
					$("input[name='rePassword']").addClass("required");
					$("input[name='account.password']").val("");
				}
				else{
					$("#divAccount").find(".txtInput,input[type=hidden]").each(function(){
						var objName = $(this).attr("name");
						var name = objName.replace("account.", "");
						$("[name='" + objName + "']").val(eval("data." + name));
					});
					
					//如果是选择账户，登录名不许修改；密码也不需要输入
					$("input[name='account.loginName']").attr("readonly", "readonly");
					$("input[name='account.loginName']").css("background-color", "rgb(233, 233, 233)");
					
					$("input[name='account.password']").parent().parent().hide();
					$("input[name='account.password']").removeClass("required");
					$("input[name='rePassword']").removeClass("required");
					$("input[name='account.password']").val("");
				}
			}
		});
	};

</script>
</body>
</html>
