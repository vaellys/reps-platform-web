<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/commons/tags.jsp"%>
<!DOCTYPE HTML>
<html>
<head>
	<title>导入学生信息修改</title>
	<reps:theme />
</head>
<body>
<reps:container>
	<reps:panel id="myform" dock="none" action="${ctx}/reps/school/executeimport/editstu.mvc" formId="xform" validForm="true">
		<div class="block_container">
			<div class="block_title">
				<h3>学生信息</h3>
				<reps:formcontent style="width:950px;">
					<input type="hidden" name="id" value="${ts.id}">
					<input type="hidden" id="orgTypes" name="orgTypes" value="${orgTypes}">
					<reps:formfield label="姓名" labelStyle="width:18%" textStyle="width:30%">
						<reps:input name="name" minLength="2" maxLength="36" required="true">${ts.name}</reps:input>
					</reps:formfield>
					<reps:formfield label="身份证号">
						<reps:input name="icNumber" dataType="alphanumeric" maxLength="20" required="true">${ts.icNumber}</reps:input>
					</reps:formfield>
					<reps:formfield label="学籍号">
						<reps:input name="studyNo" minLength="2" maxLength="32" required="true">${ts.studyNo}</reps:input>
					</reps:formfield>
					<reps:formfield label="就读性质">
						<sys:dictionary src="student_jdxz" name="jdxz">${ts.jdxz}</sys:dictionary>
					</reps:formfield>
					<reps:formfield label="班级名称">
						${ts.classes.name}
					</reps:formfield>
					<reps:formfield label="学校名称">
						${ts.organize.name}
					</reps:formfield>
					<reps:formfield label="失败原因" fullRow="true">
						${ts.reason}
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
		window.location.href= "${ctx}/reps/school/executeimport/studentlist.mvc";
	}
	
	var my = function(data){
		if (data.statusCode == 200 && data.status == 'OK') {
			messager.confirm("修改成功,是否立即导入修改后的数据", {
				okCall: function(){
					$.ajax({
						type: "GET",
						url: "${ctx}/reps/school/executeimport/savestu.mvc",
						data: {"orgTypes" : $("#orgTypes").val(), "ids" : $("#id").val() },
						success: function(data){
							if(data.success) {
								//存在导入失败的数据,查询导入失败的结果
 								if (data.result == false) {
 									messager.confirm("导入过程中存在错误数据,是否查询错误数据", {
 										okCall: function(){
 											window.parent.location.href = "${ctx}/reps/school/executeimport/studentlist.mvc?orgTypes=" + $("#orgTypes").val() + "&status=" + 2;
 										},
										cancelCall:function(){
											window.parent.location.href = "${ctx}/reps/school/executeimport/studentlist.mvc?orgTypes=" + $("#orgTypes").val();
										}
 									});
 								} else {
 									messager.info(data.msg, {
 										okCall:function(){
 											window.parent.location.href = "${ctx}/reps/school/executeimport/studentlist.mvc?orgTypes=" + $("#orgTypes").val();
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
