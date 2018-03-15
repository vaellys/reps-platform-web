<#macro getChildren tn>
	{click:"var treeObj = $.fn.zTree.getZTreeObj('mytree');",<#if tn.level != "2" && tn.id != "710000" && tn.id != "810000" && tn.id != "820000" && !radio>nocheck:true,</#if>id:"${tn.id!}",pId:"${tn.pid!}",name:"<#if tn??>${tn.value!}</#if>"<#if tn.target??>,target:"${tn.target!}"</#if><#if tn.url??>,url:"${tn.url!}"</#if><#if tn.click??>,click:"${tn.click!}"</#if> <#if tn.nodes??>,children:[<#list tn.nodes as tn1><@getChildren tn1 /></#list>]</#if>},
</#macro>
<htmlTag>
<ul id="${id!}" class="ztree"></ul>
</htmlTag>
<onload>
var setting = {callback:{onClick:zTreeOnClick},check:{enable:true,chkStyle:"radio",radioType:"all"},data:{simpleData:{enable:true,idKey:"id",pIdKey:"pId"}}};
var treeNodes = [<#list rootNodes as rootNode><@getChildren rootNode /></#list>];
var zTreeObj = $.fn.zTree.init($("#${id!}"), setting, treeNodes);
function zTreeOnClick(event, treeId, treeNode) {
    var treeObj = $.fn.zTree.getZTreeObj("mytree");
    treeObj.checkNode(treeNode,true,true);
};
<#if expand>
zTreeObj.expandAll(true);
</#if>
</onload>
<dependency>
${contextPath!}/library/ztree/jquery.ztree.core-3.5.min.js,${contextPath!}/library/ztree/jquery.ztree.excheck-3.5.min.js,${contextPath!}/library/ztree/jquery.ztree.exedit-3.5.min.js
</dependency>