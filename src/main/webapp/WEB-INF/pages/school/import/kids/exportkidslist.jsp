<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/commons/tags.jsp"%>
<!DOCTYPE HTML>
<html>
<head>
	<title>导入孩子信息展示页</title>
	<reps:theme />
</head>
<body>
<reps:container layout="true">
	<reps:panel id="mytop" dock="top" action="${ctx}/reps/school/executeimport/kidslist.mvc" method="post" formId="queryForm">
		<input type="hidden" name="ids">
		<input type="hidden" id="orgTypes" name="orgTypes" value="${orgTypes}">
		<reps:formcontent parentLayout="true" style="width:80%;">
			<reps:formfield label="孩子姓名" labelStyle="width:20%;" textStyle="width:27%;">
				<reps:input name="cName">${query.cName}</reps:input>
			</reps:formfield>
			<reps:formfield label="执行结果" labelStyle="width:20%;" textStyle="width:27%;">
				<reps:select name="status" jsonData="{'':'', '0':'未执行', '1':'成功', '2': '失败'}">${query.status}</reps:select>
			</reps:formfield>
		</reps:formcontent>
		<reps:querybuttons>
			<reps:ajaxgrid messageCode="manage.button.query" formId="queryForm" gridId="mygrid"  cssClass="search-form-a"></reps:ajaxgrid>
		</reps:querybuttons>
		<reps:footbar>
			<reps:ajax id="saveStudent" cssClass="submit-a"  value="全部执行" formId="queryForm" beforeCall="checkChecked" callBack="savekids"></reps:ajax>
			<reps:upload id="file2" callBack="importkids" value="数据上传" cssClass="uploading-a" url="${ctx}/reps/school/dataupload/kids.mvc" fileType="xls,xlsx,xlsm"></reps:upload>
			<reps:button cssClass="downloading-a" target="_blank" value="下载模版" action="${ctx}/reps/school/dataupload/template/kids.mvc"></reps:button>
			<reps:ajax id="deleteStudent" cssClass="delete-a" beforeCall="deleteChecked" formId="queryForm"  value="批量删除" confirm="你确定要删除吗？" redirect="${ctx}/reps/school/executeimport/kidslist.mvc?orgTypes=${orgTypes}"></reps:ajax>
		</reps:footbar>
	</reps:panel>
	<reps:panel id="mybody" dock="center">
		<reps:grid id="mygrid" items="${list}" var="kids" form="queryForm" flagSeq="false" pagination="${pager}">
			<reps:gridrow>
				<reps:gridcheckboxfield checkboxName="id" align="center" title="" width="5">${kids.id}</reps:gridcheckboxfield>
				<reps:gridfield title="孩子姓名" width="7" align="center">${kids.cName}</reps:gridfield>
				<reps:gridfield title="孩子身份证号" width="15" align="center">${kids.cIcNumber}</reps:gridfield>
				<reps:gridfield title="班级" width="8" align="center">${kids.classes.name}</reps:gridfield>
				<reps:gridfield title="监护人姓名" width="7" align="center">${kids.pName}</reps:gridfield>
				<reps:gridfield title="监护人手机号" width="10" align="center">${kids.phone}</reps:gridfield>
				<reps:gridfield title="关系" width="6" align="center"><sys:dictionary src="family_relationship">${kids.relationship}</sys:dictionary></reps:gridfield>
				<reps:gridfield title="操作人" width="7" align="center">${kids.operateName}</reps:gridfield>
				<reps:gridfield title="操作结果" width="8" align="center">
					<c:if test="${kids.status=='0'}">未执行</c:if>
					<c:if test="${kids.status=='1'}">成功</c:if>
					<c:if test="${kids.status=='2'}">失败</c:if>
				</reps:gridfield>
				<reps:gridfield title="导入时间" width="11" align="center">
					<fmt:parseDate value="${fn:trim(kids.saveTime)}" var="saveTime" pattern="yyyy-MM-dd HH:mm:ss"/>
					<fmt:formatDate value="${saveTime}" pattern="yyyy-MM-dd HH:mm" />
				</reps:gridfield>
				<reps:gridfield title="操作" width="19">
					<c:if test="${kids.status=='2'}">
						<reps:dialog cssClass="modify-table" id="editStu" iframe="true" width="850" height="400"
							url="${ctx}/reps/school/executeimport/toeditkids.mvc?id=${kids.id}&orgTypes=${orgTypes}" value="修改" ></reps:dialog>
							
						<reps:dialog id="dialog${kids.id}" cssClass="search-a" title="点击查看详情" value="失败原因" width="300" >
							<div>${kids.reason}</div> </reps:dialog>
					</c:if>
					<reps:ajax  id="delete" url="${ctx}/reps/school/executeimport/deletekids.mvc?id=${kids.id}" messageCode="manage.action.delete"
							cssClass="delete-table" confirm="你确定要删除吗？" redirect="${ctx}/reps/school/executeimport/kidslist.mvc?orgTypes=${orgTypes}"></reps:ajax>
				</reps:gridfield>
			</reps:gridrow>
		</reps:grid>
	</reps:panel>
</reps:container>
<script type="text/javascript">
	
	var importkids = function(d){
		if(d.success) {
			messager.confirm("是否现在执行导入", {
				okCall: function(){
					$.ajax({
						type: "GET",
						url: "${ctx}/reps/school/executeimport/savekids.mvc",
						data: {"orgTypes" : $("#orgTypes").val(), "run" : Math.random()},
						success: function(data){
							savekids(data);
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
		$("#queryForm").attr("action", "${ctx}/reps/school/executeimport/savekids.mvc");
		return true;
	}
 	
 	function savekids(data) {
 		if(data.success) {
 			//存在导入失败的数据,查询导入失败的结果
 			if (data.result == false) {
 				messager.confirm("导入过程中存在错误数据,是否查询错误数据", {
 					okCall: function(){
 						window.location.href = "${ctx}/reps/school/executeimport/kidslist.mvc?orgTypes=" + $("#orgTypes").val() + "&status=" + 2;
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
 	
 	function refresh() {
 		window.location.href = "${ctx}/reps/school/executeimport/kidslist.mvc?orgTypes=" + $("#orgTypes").val();
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
		$("#queryForm").attr("action", "${ctx}/reps/school/executeimport/deletekids.mvc");
		return true;
	}
</script>
</body>
</html>