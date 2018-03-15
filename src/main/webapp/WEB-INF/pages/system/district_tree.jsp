<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/commons/tags.jsp"%>
<!DOCTYPE HTML>
<html>
<head>
	<title>选择行政区</title>
	<reps:theme/>
</head>
<body>
<reps:container>
    <reps:panel id="myform" dock="none">
        <reps:content>
	     <div style="width:100%;height:300px;overflow:auto;background-color: #ffffff ">
	     	  <reps:ztree id="mytree" items="${treeList}" var="aa" checkbox="true">
	     	  	<reps:ztreenode parentKey="${aa.filter}" key="${aa.code}" >
	     	  		${aa.name}
	     	  	</reps:ztreenode>
	     	  </reps:ztree>
		 </div>
       </reps:content>
       <reps:formbar style="padding-top:10px">
           <reps:button type="button" onClick="okcall();" cssClass="small_btn_save" value="确定"/>
       </reps:formbar>
    </reps:panel>
</reps:container>
<script type="text/javascript">
function okcall(){
	var treeObj = $.fn.zTree.getZTreeObj("mytree");
	var nodes = treeObj.getCheckedNodes(true);
	var value,name;
	value = nodes[0].id;
	name = nodes[0].name;
	
	if(value.length == 0 || name.length == 0){
		alert("必须选中一项");
		return;
	}
	
	var cb='${callback}';
	if(cb == ""){
		alert("未设置callback回调函数");
		return;
	}
	cb = "window.parent."+cb+"('"+value+"','"+name+"')";
	eval(cb);
}
</script>
</body>
</html>