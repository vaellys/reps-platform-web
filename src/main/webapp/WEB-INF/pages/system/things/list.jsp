<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@include file="/WEB-INF/commons/tags.jsp" %>
<!DOCTYPE HTML>
<html>
<head>
<title>待办事项列表管理</title>
<reps:theme/>
</head>
<body>
<reps:container layout="true">
   <reps:panel id="mytop" dock="top" action="list.mvc" method="post" formId="xform">
        <reps:formcontent parentLayout="true" style="width:80%;">
			<reps:formfield label="标题" labelStyle="width:23%;" textStyle="width:27%;">
				<reps:input name="title">${info.title}</reps:input>
			</reps:formfield>
			<reps:formfield label="处理状态" labelStyle="width:23%;" textStyle="width:27%;">
				<reps:select name="status" jsonData="{'0':'未审批','1':'已审批'}" headerText="" headerValue="">${info.status}</reps:select>
			</reps:formfield>
        </reps:formcontent>
        <reps:querybuttons>
			<reps:ajaxgrid messageCode="manage.button.query" formId="xform" gridId="mygrid" cssClass="search-form-a"></reps:ajaxgrid>
		</reps:querybuttons>
        <%--<reps:footbar>
				<reps:button messageCode="manage.action.add" action="toadd.mvc" cssClass="add-a"></reps:button>
		</reps:footbar>	
	 --%></reps:panel>
   <reps:panel id="mybody" dock="center" border="false" style="float:left;">
      <reps:grid id="mygrid" items="${list}" var="my" form="xform" pagination="${pager}">
		   <reps:gridrow>
				<reps:gridfield title="标题" width="20" align="center">${my.title}</reps:gridfield>
				<reps:gridfield title="处理状态" width="20" align="center">${my.status eq 1?'已审批':'未审批'}</reps:gridfield>
				<reps:gridfield title="添加时间" width="20" align="center">
					<fmt:parseDate value="${my.addTime}" var="addTime" pattern="yyyy-MM-dd HH:ss"/>
					<fmt:formatDate value="${addTime}" pattern="yyyy-MM-dd"/>
				</reps:gridfield>
				<reps:gridfield title="审批时间" width="20" align="center">
					<fmt:parseDate value="${my.finishTime}" var="finishTime" pattern="yyyy-MM-dd HH:ss"/>
					<fmt:formatDate value="${finishTime}" pattern="yyyy-MM-dd"/>
				</reps:gridfield>
				<reps:gridfield title="操作" width="20" align="center">
				<%--
					<reps:button cssClass="detail-table" action="detail.mvc?id=${my.id}" messageCode="manage.action.detail"></reps:button>
					<reps:button cssClass="modify-table" action="toedit.mvc?id=${my.id}" messageCode="manage.action.update"></reps:button>
					<reps:ajax messageCode="manage.action.delete" id="delete" url="delete.mvc?id=${my.id}" 
					cssClass="delete-table" confirm="您确定要删除所选行吗?" 
					redirect="list.mvc?id=${my.id}" ></reps:ajax>
				--%>
				<c:if test="${my.status eq 1}">
				<a href="#" class="repsbutton modify-table" style="color: #aaaaaa" title="已审批的待办事项"><span>审批</span></a>
				</c:if>
				<c:if test="${my.status eq 0}">
					<reps:button cssClass="modify-table" action="../../../${my.contentUrl}" value="审批"/>
				</c:if>
				</reps:gridfield>
		   </reps:gridrow>
		</reps:grid>
  	</reps:panel>
</reps:container>
  </body>
</html>