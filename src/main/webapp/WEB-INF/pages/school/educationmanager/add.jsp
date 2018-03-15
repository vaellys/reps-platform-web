<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/commons/tags.jsp"%>
<!DOCTYPE HTML>
<html>
<head>
	<title>教师信息添加</title>
	<reps:theme />
</head>
<body>
<reps:container>
	<reps:panel id="myform" dock="none" action="add.mvc" formId="xform" validForm="true">
		<div class="block_container">
			<div class="block_title" id="divPerson">
				<h3>个人信息</h3>
				<reps:formcontent style="width:950px;">
					<input type="hidden" name="teacher.person.id">
					<input type="hidden" name="teacher.person.lastVersion" value="0">
					<reps:formfield label="姓名" labelStyle="width:18%" textStyle="width:30%">
						<reps:input name="teacher.person.name" minLength="2" maxLength="36" required="true" />
						<reps:dialog cssClass="add-a" id="selectPerson" iframe="true" width="650" height="400"
							url="${ctx}${actionBasePath}/sys/chooseperson/single.mvc?dialogId=selectPerson&callBack=choosePersonBack" value="选择人员"></reps:dialog>
					</reps:formfield>
					<reps:formfield label="性别" labelStyle="width:18%" textStyle="width:34%">
						<sys:dictionary src="sex" name="teacher.person.sex" headerValue="" headerText="" required="true" />
					</reps:formfield>
					<reps:formfield label="英文名"><reps:input name="teacher.person.enName" maxLength="60" /></reps:formfield>
					<reps:formfield label="曾用名"><reps:input name="teacher.person.oldName" maxLength="36" /></reps:formfield>
					<reps:formfield label="民族"><sys:dictionary src="ethnicity" name="teacher.person.ethnicity" headerValue="" headerText="" /></reps:formfield>
					<reps:formfield label="出生日期"><reps:datepicker name="teacher.person.birthday" format="yyyy-MM-dd" /></reps:formfield>
					<reps:formfield label="证件号码"><reps:input name="teacher.person.icNumber" dataType="alphanumeric" maxLength="20" required="true" /></reps:formfield>
					<reps:formfield label="证件类型"><sys:dictionary src="ic_type" name="teacher.person.icType" /></reps:formfield>
					<reps:formfield label="证件有效起始日期"><reps:datepicker name="teacher.person.icValidDateBegin" format="yyyy-MM-dd" /></reps:formfield>
					<reps:formfield label="证件有效截止日期"><reps:datepicker name="teacher.person.icValidDateEnd" format="yyyy-MM-dd" /></reps:formfield>
					<reps:formfield label="籍贯"><reps:input name="teacher.person.nativePlace" minLength="2" maxLength="20" /></reps:formfield>
					<reps:formfield label="出生地">
						<sys:dictionary src="district" id="birthPlace" name="teacher.person.birthPlace" type="input" style="width:158px;float:left;" headerValue="" headerText="" />
						<reps:dialog cssClass="btnLook" style="margin-left:-22px;" width="300" height="370" id="dlgBirthPlace" iframe="true" 
							url="${ctx}${actionBasePath}/sys/district/tree.mvc?callback=setBirthPlace&code=${tschool.teacher.person.birthPlace}" title="选择行政区" value="请选择行政区" />
					</reps:formfield>
					<reps:formfield label="国籍"><sys:dictionary src="country" name="teacher.person.nationality" headerValue="" headerText="" /></reps:formfield>
					<reps:formfield label="文化程度"><sys:dictionary src="education_degree" name="teacher.person.educationDegree" headerValue="" headerText="" /></reps:formfield>
					<reps:formfield label="婚姻状况"><sys:dictionary src="marital_status" name="teacher.person.maritalStatus" headerValue="" headerText="" /></reps:formfield>
					<reps:formfield label="政治面貌"><sys:dictionary src="politics_status" name="teacher.person.politicsStatus" headerValue="" headerText="" /></reps:formfield>
					<reps:formfield label="宗教信仰"><sys:dictionary src="religion" name="teacher.person.religion" headerValue="" headerText="" /></reps:formfield>
					<reps:formfield label="港澳台侨胞"><sys:dictionary src="gotqw" name="teacher.person.gotqw" headerValue="" headerText="" /></reps:formfield>
					<reps:formfield label="健康状况"><sys:dictionary src="health_status" name="teacher.person.healthStatus" headerValue="" headerText="" /></reps:formfield>
					<reps:formfield label="血型"><sys:dictionary src="blood_type" name="teacher.person.bloodType" headerValue="" headerText="" /></reps:formfield>
					<reps:formfield label="是否为独生子女" fullRow="true"><reps:select name="teacher.person.onlyChild" jsonData="{'0':'否','1':'是'}" /></reps:formfield>
					<reps:formfield label="备注" fullRow="true"><reps:input name="teacher.person.note" multiLine="true" maxLength="100" style="width:620px;height:50px" /></reps:formfield>
				</reps:formcontent>
			</div>
			
			<div class="block_title" id="divTeacher">
				<h3>教籍信息</h3>
				<reps:formcontent style="width:950px;">
					<reps:formfield label="工作单位" labelStyle="width:18%" textStyle="width:30%">
						<sys:organize hideId="organizeId" url="${ctx}${actionBasePath}/school/chooseorganize/single.mvc" name="orgName" id="orgName" hideName="organizeId" required="true" readonly="true" callBack="chooseOrganizeBack">
						</sys:organize>
					</reps:formfield>
					<reps:formfield label="工号" labelStyle="width:18%" textStyle="width:34%"><reps:input name="teacher.jobNo" maxLength="20" /></reps:formfield>
					<reps:formfield label="参加工作年月"><reps:datepicker name="teacher.firstWorkDate" format="yyyy-MM" /></reps:formfield>
					<reps:formfield label="从教年月"><reps:datepicker name="teacher.firstTeachingDate" format="yyyy-MM" /></reps:formfield>
					<reps:formfield label="职称"><sys:dictionary src="profession_title" name="teacher.professionTitle" headerValue="" headerText="" /></reps:formfield>
					<reps:formfield label="特长"><reps:input name="teacher.skill" maxLength="50" /></reps:formfield>
					<reps:formfield label="工龄"><reps:input name="teacher.workingYears" maxLength="4" /></reps:formfield>
					<reps:formfield label="教龄"><reps:input name="teacher.teachWorkingYears" maxLength="4" /></reps:formfield>
					<reps:formfield label="档案编号"><reps:input name="teacher.profileNo" maxLength="10" /></reps:formfield>
					<reps:formfield label="教职工来源"><sys:dictionary src="teacher_come_from" name="comeFrom" headerValue="" headerText="" required="true" /></reps:formfield>
					<reps:formfield label="编制状态"><reps:select name="regularStatus" jsonData="{'1':'在编','0':'不在编'}" /></reps:formfield>
					<reps:formfield label="编制类别"><sys:dictionary src="work_bzlb" name="regularType" headerValue="" headerText="" required="true" /></reps:formfield>
					<reps:formfield label="来校年月"><reps:datepicker name="joinSchoolDate" format="yyyy-MM" /></reps:formfield>
					<reps:formfield label="岗位职业"><sys:dictionary src="work_role" name="workRole" headerValue="" headerText="" /></reps:formfield>
					<reps:formfield label="所属学段"><sys:dictionary src="grade_group" name="gradeGroup" headerValue="" headerText="" filter="2,3,4" /></reps:formfield>
					<reps:formfield label="在岗状态" fullRow="true"><sys:dictionary src="position_status" name="positionStatus" headerValue="11" headerText="在职" required="true" /></reps:formfield>
				</reps:formcontent>
			</div>
			<div class="block_title" id="divAccount">
				<h3>账户绑定</h3>
				<reps:formcontent style="width:950px;">
					<input type="hidden" name="account.id">
					<reps:formfield label="登录名" labelStyle="width:18%" textStyle="width:30%">
						<reps:input id="loginName" name="account.loginName" required="true" minLength="3" maxLength="32" />
						<reps:dialog cssClass="add-a" id="selectAccount" iframe="true" width="650" height="400"
							url="${ctx}${actionBasePath}/sys/chooseaccount/single.mvc?dialogId=selectAccount&callBack=chooseAccountBack" value="选择账号"></reps:dialog>
					</reps:formfield>
					<reps:formfield label="适用范围" labelStyle="width:18%" textStyle="width:34%"><sys:dictionary src="account_scope" name="scope" /></reps:formfield>
					<reps:formfield label="密码"><reps:input id="password" name="account.password" type="password" required="true" minLength="6" maxLength="18" /></reps:formfield>
					<reps:formfield label="密码确认"><reps:input name="rePassword" type="password" equalTo="#password" required="true" minLength="6" maxLength="18" /></reps:formfield>
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
	var ccmap = {};
	var cctextmap = {};
	var classesmap = {};
	var coursemap = {};
	var organizeId = "";
	var addclassesUrl = "";
	var chooseAccoutUrl = $("#selectAccount").attr("href");
	$(function(){
		addclassesUrl = $("#selectClasses").attr("href");

		$(".btn_save input").on("click", function(){
			$("span[for='teacher.person.name']").css("margin-left","70px");
			$("span[for='account.loginName']").css("margin-left","70px");
		});

	});
	
	function back() 
	{
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
					var name = objName.replace("teacher.person.", "");
					var value = eval("data." + name);
					
					if ($(this).hasClass('date')){
						if (value){
							value = value.substring(0,4) + "-" + value.substring(4,6) + "-" + value.substring(6);
						}
					}
					$("[name='" + objName + "']").val(value);
				});
				//如果是选择人员，姓名和证件号码不许修改
				$("input[name='teacher.person.name']").attr("readonly", "readonly");
				$("input[name='teacher.person.name']").css("background-color", "rgb(233, 233, 233)");
				$("input[name='teacher.person.icNumber']").attr("readonly", "readonly");
				$("input[name='teacher.person.icNumber']").css("background-color", "rgb(233, 233, 233)");
				
				//限制账户选择范围
				$("#selectAccount").attr("href", chooseAccoutUrl + "&personId=" + $("input[name='teacher.person.id']").val());
				
				//初始化账户信息
				getAccount($("input[name='teacher.person.id']").val());
			}
		});
	};
	
	var chooseOrganizeBack = function(id, name){
		organizeId = id;
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
	
	var hasChoosedSchool = function(){
		if (organizeId == ""){
			messager.info("请先选择学校！");
			return false;
		}
		return true;
	}
	
	var setBirthPlace = function(code, name){
		$("input[name='teacher.person.birthPlace']").val(code);
		$("#birthPlace").val(name);
		$.pdialog.closeDialog();
	}

</script>
</body>
</html>
