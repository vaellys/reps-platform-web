<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/commons/tags.jsp"%>
<!DOCTYPE HTML>
<html>
<head>
	<title>导入教师信息展示页</title>
	<reps:theme />
</head>
<body>
<reps:container layout="true">
	<reps:panel id="mytop" dock="top" action="${ctx}/reps/school/executeimport/teacherlist.mvc" method="post" formId="queryForm">
		<input type="hidden" name="ids">
		<input type="hidden" id="orgTypes" name="orgTypes" value="${orgTypes}">
		<input type="hidden" id="isManager" name="isManager" value="${isManager}">
		<reps:formcontent parentLayout="true" style="width:80%;">
			<reps:formfield label="姓名" labelStyle="width:20%;" textStyle="width:27%;">
				<reps:input name="name">${query.name}</reps:input>
			</reps:formfield>
			<reps:formfield label="执行结果" labelStyle="width:20%;" textStyle="width:27%;">
				<reps:select name="status" jsonData="{'':'', '0':'未执行', '1':'成功', '2': '失败'}">${query.status}</reps:select>
			</reps:formfield>
			<reps:formfield label="学校名称" labelStyle="width:20%;" textStyle="width:27%;">
				<reps:input name="organize.name">${query.organize.name}</reps:input>
			</reps:formfield>
		</reps:formcontent>
		<reps:querybuttons>
			<reps:ajaxgrid messageCode="manage.button.query" formId="queryForm" gridId="mygrid" cssClass="search-form-a"></reps:ajaxgrid>
		</reps:querybuttons>
		<reps:footbar>
			<reps:ajax id="saveStudent" cssClass="submit-a"  value="全部执行" beforeCall="checkChecked" formId="queryForm" callBack="saveTeacher"></reps:ajax>
			<c:if test="${isManager == '1'}">
				<reps:upload id="file1" callBack="importTeacher" value="数据上传" cssClass="uploading-a" url="${ctx}/reps/school/dataupload/edumanager.mvc" fileType="xls,xlsx,xlsm"></reps:upload>
				<reps:button cssClass="downloading-a" target="_blank" value="下载模版" action="${ctx}/reps/school/dataupload/template/teacher-manager.mvc"></reps:button>
			</c:if>
			<c:if test="${isManager == '0'}">
				<reps:upload id="file1" callBack="importTeacher" value="数据上传" cssClass="uploading-a" url="${ctx}/reps/school/dataupload/teacher.mvc" fileType="xls,xlsx,xlsm"></reps:upload>
				<reps:button cssClass="downloading-a" target="_blank" value="下载模版" action="${ctx}/reps/school/dataupload/template/teacher.mvc"></reps:button>
			</c:if>
			<reps:ajax id="deleteStudent" cssClass="delete-a" beforeCall="deleteChecked" formId="queryForm"  value="批量删除" confirm="你确定要删除吗？" redirect="${ctx}/reps/school/executeimport/teacherlist.mvc?orgTypes=${orgTypes}&isManager=${isManager}"></reps:ajax>
		</reps:footbar>
	</reps:panel>
	<reps:panel id="mybody" dock="center">
		<reps:grid id="mygrid" items="${list}" var="tt" form="queryForm" flagSeq="false" pagination="${pager}">
			<reps:gridrow>
				<reps:gridcheckboxfield checkboxName="id" align="center" title="" width="5">${tt.id}</reps:gridcheckboxfield>
				<reps:gridfield title="姓名" width="8" align="center">${tt.name}</reps:gridfield>
				<reps:gridfield title="身份证号" width="18" align="center">${tt.icNumber}</reps:gridfield>
				<reps:gridfield title="学校" width="18" align="center">${tt.organize.name}</reps:gridfield>
				<reps:gridfield title="登陆名" width="10" align="center">${tt.loginName}</reps:gridfield>
				<reps:gridfield title="操作人" width="10" align="center">${tt.operateName}</reps:gridfield>
				<reps:gridfield title="操作结果" width="8" align="center">
					<c:if test="${tt.status=='0'}">未执行</c:if>
					<c:if test="${tt.status=='1'}">成功</c:if>
					<c:if test="${tt.status=='2'}">失败</c:if>
				</reps:gridfield>
				<reps:gridfield title="导入时间" width="11" align="center">
					<fmt:parseDate value="${fn:trim(tt.saveTime)}" var="saveTime" pattern="yyyy-MM-dd HH:mm:ss"/>
					<fmt:formatDate value="${saveTime}" pattern="yyyy-MM-dd HH:mm" />
				</reps:gridfield>
				<reps:gridfield title="操作" width="18">
					<c:if test="${tt.status=='2'}">
						<reps:dialog cssClass="modify-table" id="editStu" iframe="true" width="850" height="400"
							url="${ctx}/reps/school/executeimport/toeditteacher.mvc?id=${tt.id}&orgTypes=${orgTypes}" value="修改"></reps:dialog>
						<reps:dialog id="dialog${tt.id}" cssClass="search-a" title="点击查看详情" value="失败原因" width="300" >
							<div>${tt.reason}</div>
					    </reps:dialog>
					</c:if>
					<reps:ajax id="delete" url="${ctx}/reps/school/executeimport/deleteteacher.mvc?id=${tt.id}" messageCode="manage.action.delete"
							cssClass="delete-table" confirm="你确定要删除吗？" redirect="${ctx}/reps/school/executeimport/teacherlist.mvc?orgTypes=${orgTypes}&isManager=${isManager}"></reps:ajax>
				</reps:gridfield>
			</reps:gridrow>
		</reps:grid>
	</reps:panel>
</reps:container>
<script type="text/javascript">
 	
 	function saveTeacher(data) {
 		if(data.success) {
 			//存在导入失败的数据,查询导入失败的结果
 			if (data.result == false) {
 				messager.confirm("导入过程中存在错误数据,是否查询错误数据", {
 					okCall: function(){
 						window.location.href = "${ctx}/reps/school/executeimport/teacherlist.mvc?orgTypes=" + $("#orgTypes").val() + "&status=" + 2;
 					},
					cancelCall:function(){
						refresh();
					}
 				});
 			} else {
 				messager.info(data.msg, {
 					okCall:function(){
 						refresh();
 					}
 				});
 			}
		} else {
			messager.error(data.msg);
		}
 	}
 	
 	function checkChecked() {
		var ids = $("input[type=hidden][name=ids]");
		ids.val("");
		$.each($("input[type=checkbox][name=id]:checked"), function(i, obj) {
			if (ids.val() == "") {
				ids.val($(obj).val());
			} else {
				ids.val(ids.val() + "," + $(obj).val());
			}
		});
		$("#queryForm").attr("action", "${ctx}/reps/school/executeimport/saveteacher.mvc");
		return true;
	}
	
	function importTeacher(d){
		if(d.success) {
			messager.confirm("数据上传成功, 是否现在执行导入", {
				okCall: function(){
					$.ajax({
						type: "GET",
						url: "${ctx}/reps/school/executeimport/saveteacher.mvc",
						data: {"orgTypes" : $("#orgTypes").val(), "run" : Math.random()},
						success: function(data){
							saveTeacher(data);
						}
					});
				},
				cancelCall:function(){
					refresh();
				}
			
			});
		} else {
			messager.error(d.msg);
		}
	}
	
	function refresh() {
 		window.location.href = "${ctx}/reps/school/executeimport/teacherlist.mvc?orgTypes=" + $("#orgTypes").val();
 	}
	
 	function setDisabled() {
 		var flag = true;
 		$(".grid table tr input").each(function(i, obj){
 			if (i == 0) {return true };
 			if ($(obj).attr("disabled")) {
 				$(".grid table tr input").eq(0).attr("disabled", "disabled");
 				flag = false;
 				return false;
 			}
 		});
 		if (flag) {
 			$(".grid table tr input").eq(0).removeAttr("disabled");
 		}
 	}
 	
 	 	function deleteChecked() {
		var ids = $("input[type=hidden][name=ids]");
		ids.val("");
		$.each($("input[type=checkbox][name=id]:checked"), function(i, obj) {
			if (ids.val() == "") {
				ids.val($(obj).val());
			} else {
				ids.val(ids.val() + "," + $(obj).val());
			}
		});
		$("#queryForm").attr("action", "${ctx}/reps/school/executeimport/deleteteacher.mvc");
		return true;
	}
 	
</script>
</body>
</html>