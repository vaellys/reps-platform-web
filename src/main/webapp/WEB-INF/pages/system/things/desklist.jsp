<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@include file="/WEB-INF/commons/tags.jsp"%>
<meta http-equiv="pragma" content="no-cache"> 
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<div id="div_content" class="extendNews" style="height:180px;overflow:none;">
	<ol id="div_content_ol" style="width:91%;float:left;padding-top:5px;">
		<c:forEach items="${list}" var="things" begin="0" end="6">
			<li style="line-height:150%;list-style:none;padding-left:15px;background:url(theme/chengdu/images/li_bg.bmp) no-repeat 6px 7px;">
				<span style="width:80%;display:inline-block;overflow:hidden;text-overflow:ellipsis;font-size:14px;color:#000"><nobr>${things.title}</nobr></span> 
				<span style="float:right;font-size:14px;">
				<a href="${things.url}" external="true" target="navTab-new" title="${things.title}" style="width:120%;font-size:14px;">
					${things.number}项
				</a>
				</span>
				<%--
				<span style="float:right;font-size:14px;">
					<fmt:parseDate value="${things.addTime}" var="addTime" pattern="yyyy-MM-dd HH:ss"/>
					<fmt:formatDate value="${addTime}" pattern="yyyy-MM-dd"/>
				</span>
		    	--%>
		    </li>
		</c:forEach>
	</ol>
</div>
<script type="text/javascript">
<%--
window.onload = function(){  
	//console.log("\\WEB-INF\\pages\\system\\things\\desklist.jsp 页面中的定时器启动中...");
	//window.setTimeout("data()",1000*10);
};
var timer;
function data(){
	if('${not empty list}' && '${list.size()>0}'){
		timer = window.setInterval("saveMe()", 1000*10);//这里设定时间 默认为10秒执行一次
	}
}
function saveMe(){
	desk();
	clearInterval(timer);
	data();
	return;
}
function desk(){
 	var my = document.getElementById("div_content");
     if (my != null){
         my.parentNode.removeChild(my);
     }
	$.ajax({
		type:"get",
		url:"${ctx}/reps/sys/things/desk/list.mvc",
		async:false,
		success : function(data){
			$("#contentsys011100").append(data);
			reSetNavTab();
		}
	});
 }
--%>
</script>