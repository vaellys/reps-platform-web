<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/commons/tags.jsp"%>
<!DOCTYPE HTML>
<html>
  <head>
    <title>登入登出日志查看</title>
   <reps:theme/>
  </head>
  <script type="text/javascript">
	function exportTo() {
		$("#queryForm").attr("action", "export.mvc");
		$("#queryForm").submit();
		$("#queryForm").attr("action", "list.mvc");
	}
</script>
  <body>
    <reps:container layout="true">
	  <reps:panel id="top" dock="top" method="post" action="list.mvc" formId="queryForm">
         <reps:formcontent parentLayout="true" columns="3" style="width:80%;">
           <reps:formfield label="日志表">
               <reps:select dataSource="${tablesMap}" name="logTable" id="logTable" style="width:120px">${logTable}</reps:select>
           </reps:formfield>
           <reps:formfield label="操作入口">
               <reps:select jsonData="{'API':'API','WEB':'WEB'}" headerText="" headerValue="" name="loginWith" id="loginWith" style="width:120px">${info.loginWith}</reps:select>
           </reps:formfield>
           <reps:formfield label="登录名">
               <reps:input name="loginName" style="width:120px">${info.loginName}</reps:input>
           </reps:formfield>
         </reps:formcontent>
         <reps:querybuttons>
            <reps:ajaxgrid messageCode="manage.button.query" formId="queryForm" gridId="mygrid" cssClass="search-form-a"></reps:ajaxgrid>
         </reps:querybuttons>
         <reps:footbar>
         	<reps:dialog id="iframeDialogId" cssClass="dialog-a" title="查看当前月报表" iframe="true" mask="false"  url="report.mvc?logTable=${logTable}" width="400" height="300" value="查看当前月报表"></reps:dialog>
         	<reps:button cssClass="export-a" id="exportExcel" value="导出" onClick="exportTo();"></reps:button>
         </reps:footbar>
      </reps:panel>
      <reps:panel id="mybody" dock="center" border="true" style="margin-left:-1px;">
         <reps:grid id="mygrid" items="${list}" form="queryForm" var="loginLog" pagination="${pager}" flagSeq="true">
             <reps:gridrow>
                 <reps:gridfield title="登录名" width="35"><reps:dialog id="dialog${loginLog.id}" title="${loginLog.loginName}登录详情" value="${loginLog.loginName}" width="500" ><div>${loginLog.description}</div></reps:dialog></reps:gridfield>
                 <reps:gridfield title="操作时间" width="35"><fmt:formatDate value="${loginLog.logTime}" pattern="yyyy-MM-dd HH:mm"/></reps:gridfield>
                 <reps:gridfield title="操作入口" width="35">${loginLog.loginWith}</reps:gridfield>
                 <reps:gridfield title="操作类型" width="30">${loginLog.logType eq 'LOGIN' ? '登入' : '登出'}</reps:gridfield>
             </reps:gridrow>
         </reps:grid>
      </reps:panel>
    </reps:container>
  </body>
</html>
