<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/commons/tags.jsp"%>
<!DOCTYPE HTML>
<html>
<head>
<title>日志查询</title>
<reps:theme />  
</head>
<script type="text/javascript">
	function exportTo() {
		var total = $("input[name='totalRecord']").val();
		if (total > 10000) {
			alert("数据太多, 导出失败. 请重新筛选数据, 再使用导出功能.");
			return false;
		}
		$("#queryForm").attr("action", "toxml.mvc");
		$("#queryForm").submit();
		$("#queryForm").attr("action", "list.mvc");
	}
</script>
<body>
	<reps:container layout="true">
		<reps:panel id="mytop" dock="top" action="list.mvc" method="post" formId="queryForm" style="height:130px">
			<reps:formcontent parentLayout="true" style="width:80%;">
				<reps:formfield label="开始时间" labelStyle="width:23%;" textStyle="width:27%;">
					<reps:datepicker name="beginTime"></reps:datepicker>
				</reps:formfield>
				<reps:formfield label="结束时间" labelStyle="width:23%;" textStyle="width:27%;">
					<reps:datepicker name="endTime"></reps:datepicker>
				</reps:formfield>
				<reps:formfield label="操作人">
					<reps:input name="repsUserName"></reps:input>
				</reps:formfield>
				<reps:formfield label="所在单位">
					<reps:input name="repsOrgName"></reps:input>
				</reps:formfield>
				<reps:formfield label="日志标题">
					<reps:input name="logTitle"></reps:input>
				</reps:formfield>
			</reps:formcontent>
			<reps:querybuttons>
				<reps:ajaxgrid messageCode="manage.button.query" formId="xform" gridId="mygrid" cssClass="search-form-a"></reps:ajaxgrid>
			</reps:querybuttons>
			<reps:footbar>
 				<reps:button cssClass="export-a" id="exportExcel" value="导出" onClick="exportTo();"></reps:button>
			</reps:footbar>
		</reps:panel> 
		<reps:panel id="mybody" dock="center">
			<reps:grid id="mygrid" items="${list}" var="log" form="xform" pagination="${pager}" flagSeq="true" >
				<reps:gridrow>
					<reps:gridfield title="操作人" width="10">${log.repsUserName}</reps:gridfield>
					<reps:gridfield title="所在单位" width="15">${log.repsOrgName}</reps:gridfield>
					<reps:gridfield title="操作类型" width="8" align="center">${log.operation}</reps:gridfield>
					<reps:gridfield title="日志标题" width="10">${log.logTitle}</reps:gridfield>
					<reps:gridfield title="日志内容" width="35" ><reps:dialog id="dialog${log.id}" title="点击查看详情" value="${log.logContent}" width="500" ><div>${log.logContent}</div></reps:dialog></reps:gridfield>
					<reps:gridfield title="日志级别" width="7" align="center">${log.logLevel}</reps:gridfield>
					<reps:gridfield title="操作日期" width="15" align="center"><fmt:formatDate value="${log.lastUpdateTime}" pattern="yyyy-MM-dd HH:mm"/></reps:gridfield>
				</reps:gridrow>
			</reps:grid>
		</reps:panel>
	</reps:container>
</body>
</html>

