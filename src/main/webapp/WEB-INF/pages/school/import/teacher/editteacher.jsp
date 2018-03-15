<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/commons/tags.jsp"%>
<!DOCTYPE HTML>
<html>
<head>
	<title>导入教师信息修改</title>
	<reps:theme />
</head>
<body>
<reps:container>
	<reps:panel id="myform" dock="none" action="${ctx}/reps/school/executeimport/editteacher.mvc" formId="xform" validForm="true">
		<div class="block_container">
			<div class="block_title">
				<h3>教师信息</h3>
				<reps:formcontent style="width:950px;">
					<input type="hidden" name="id" value="${tt.id}">
					<input type="hidden" id="orgTypes" name="orgTypes" value="${orgTypes}">
					<input type="hidden" id="isManager" name="isManager" value="${tt.isManager}">
					<reps:formfield label="姓名" labelStyle="width:18%" textStyle="width:30%">
						<reps:input name="name" minLength="2" maxLength="36" required="true">${tt.name}</reps:input>
					</reps:formfield>
					<reps:formfield label="身份证号">
						<reps:input name="icNumber" dataType="alphanumeric" maxLength="20" required="true">${tt.icNumber}</reps:input>
					</reps:formfield>
					<reps:formfield label="编制状态">
						<reps:select name="regularStatus" jsonData="{'0':'不在编', '1':'在编'}">${tt.regularStatus}</reps:select>
					</reps:formfield>
					<reps:formfield label="职位">
						<reps:select name="workRole" jsonData="{'10':'教师','23':'班主任', '31':'校长', '35':'幼儿园园长', '85':'其他工作'}">${tt.workRole}</reps:select>
					</reps:formfield>
					<reps:formfield label="手机号">
						<reps:input maxLength="11" name="phone">${tt.phone}</reps:input>
					</reps:formfield>
					<reps:formfield label="学校名称">
						${tt.organize.name}
					</reps:formfield>
					<reps:formfield label="失败原因" fullRow="true">
						${tt.reason}
					</reps:formfield>
					
				</reps:formcontent>
			</div>
		<br/>
		<reps:formbar>
			<reps:ajax cssClass="btn_save" type="button" formId="xform" callBack="my" messageCode="add.button.save" />
		</reps:formbar>
		<br/><br/>
	</reps:panel>
</reps:container>
<script type="text/javascript">
	function back() 
	{
		window.location.href= "${ctx}/reps/school/executeimport/teacherlist.mvc";
	}
	
	var my = function(data){
		if (data.statusCode == 200 && data.status == 'OK') {
			messager.confirm("修改成功,是否立即导入修改后的数据", {
				okCall: function(){
					$.ajax({
						type: "GET",
						url: "${ctx}/reps/school/executeimport/saveteacher.mvc",
						data: {"orgTypes" : $("#orgTypes").val(), "ids" : $("#id").val() },
						success: function(data){
							if(data.success) {
								//存在导入失败的数据,查询导入失败的结果
 								if (data.result == false) {
 									messager.confirm("导入过程中存在错误数据,是否查询错误数据", {
 										okCall: function(){
 											window.parent.location.href = "${ctx}/reps/school/executeimport/teacherlist.mvc?orgTypes=" + $("#orgTypes").val() + "&status=" + 2 + "&isManager="+$("#isManager").val();
 										},
										cancelCall:function(){
											window.parent.location.href = "${ctx}/reps/school/executeimport/teacherlist.mvc?orgTypes=" + $("#orgTypes").val() + "&isManager="+$("#isManager").val();
										}
 									});
 								} else {
 									messager.info(data.msg, {
 										okCall:function(){
 											window.parent.location.href = "${ctx}/reps/school/executeimport/teacherlist.mvc?orgTypes=" + $("#orgTypes").val() + "&isManager="+$("#isManager").val();
 										}
 									});
 								}
							} else {
								messager.error(data.msg)
							}
						}
					});
				},
				cancelCall: function(){
					window.parent.location.reload();
				}
			});
		} else {
			messager.error(data.message);
		}
	};
</script>
</body>
</html>
