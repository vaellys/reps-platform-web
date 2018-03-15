<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/commons/tags.jsp"%>
<!DOCTYPE HTML>
<html>
<head>
	<title>导入孩子信息修改</title>
	<reps:theme />
</head>
<body>
<reps:container>
	<reps:panel id="myform" dock="none" action="${ctx}/reps/school/executeimport/editkids.mvc" formId="xform" validForm="true">
		<div class="block_container">
			<div class="block_title">
				<h3>孩子信息</h3>
				<reps:formcontent style="width:950px;">
					<input type="hidden" name="id" value="${tk.id}">
					<input type="hidden" id="orgTypes" name="orgTypes" value="${orgTypes}">
					<reps:formfield label="姓名" labelStyle="width:18%" textStyle="width:30%">
						<reps:input name="cName" minLength="2" maxLength="36" required="true">${tk.cName}</reps:input>
					</reps:formfield>
					<reps:formfield label="孩子身份证号">
						<reps:input name="cIcNumber" dataType="alphanumeric" maxLength="20" required="true">${tk.cIcNumber}</reps:input>
					</reps:formfield>
					<reps:formfield label="监护人姓名">
						<reps:input name="pName" minLength="2" maxLength="36" required="true">${tk.pName}</reps:input>
					</reps:formfield>
					<reps:formfield label="监护人手机号">
						<reps:input maxLength="11" name="phone" required="true" >${tk.phone}</reps:input>
					</reps:formfield>
					<reps:formfield label="监护人身份证号">
						<reps:input name="pIcNumber" dataType="alphanumeric" maxLength="20" required="true">${tk.pIcNumber}</reps:input>
					</reps:formfield>
					<reps:formfield label="与监护人关系">
						<reps:select name="relationship" jsonData="{'51':'父亲','52':'母亲', '61':'祖父', '62':'祖母', '63':'外祖父', '64':'外祖母'}">${tk.relationship}</reps:select>
					</reps:formfield>
					<reps:formfield label="班级名称">
						${tk.classes.name}
					</reps:formfield>
					<reps:formfield label="学校名称">
						${tk.organize.name}
					</reps:formfield>
					<reps:formfield label="失败原因" fullRow="true">
						${tk.reason}
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
		window.location.href= "${ctx}/reps/school/executeimport/kidslist.mvc";
	}
	
	var my = function(data){
		if (data.statusCode == 200 && data.status == 'OK') {
			messager.confirm("修改成功,是否立即导入修改后的数据", {
				okCall: function(){
					$.ajax({
						type: "GET",
						url: "${ctx}/reps/school/executeimport/savekids.mvc",
						data: {"orgTypes" : $("#orgTypes").val(), "ids" : $("#id").val() },
						success: function(data){
							if(data.success) {
								//存在导入失败的数据,查询导入失败的结果
 								if (data.result == false) {
 									messager.confirm("导入过程中存在错误数据,是否查询错误数据", {
 										okCall: function(){
 											window.parent.location.href = "${ctx}/reps/school/executeimport/kidslist.mvc?orgTypes=" + $("#orgTypes").val() + "&status=" + 2;
 										},
										cancelCall:function(){
											window.parent.location.href = "${ctx}/reps/school/executeimport/kidslist.mvc?orgTypes=" + $("#orgTypes").val();
										}
 									});
 								} else {
 									messager.info(data.msg, {
 										okCall:function(){
 											window.parent.location.href = "${ctx}/reps/school/executeimport/kidslist.mvc?orgTypes=" + $("#orgTypes").val();
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
