<htmlTag>
<script id="${id!}" type="text/plain" name="${name!}" style="${style!}" >${textValue!}</script>
<#if contentFuncName??>
	<script>var ${contentFuncName!} = function(){return UE.getEditor('${id!}').getContent();}</script>
</#if>
</htmlTag>
<onload>
var editor${id!};
<#if toolbars??>
editor${id!} = UE.getEditor('${id!}',{<#if wordCount>wordCount:true,maximumWords:${maximumWords!},<#else>wordCount:false,</#if>autoHeightEnabled:false,toolbars:${toolbars!}});
<#elseif group?if_exists == 'text'>
editor${id!} = UE.getEditor('${id!}',{<#if wordCount>wordCount:true,maximumWords:${maximumWords!},<#else>wordCount:false,</#if>autoHeightEnabled:false,toolbars:[['undo','redo','bold','italic', 'underline', 'fontborder','spechars','snapscreen','wordimage','strikethrough', 'superscript', 'subscript', 'fullscreen','parenthese','fontfamily', 'fontsize','|','inserttable', 'deletetable', 'insertparagraphbeforetable', 'insertrow', 'deleterow', 'insertcol', 'deletecol', 'mergecells', 'mergeright', 'mergedown', 'splittocells', 'splittorows', 'splittocols','justifyleft', 'justifycenter', 'justifyright', 'justifyjustify', '|', 'touppercase', 'tolowercase','cleardoc','removeformat','map']]});
<#elseif group?if_exists == 'simple'>
editor${id!} = UE.getEditor('${id!}',{<#if wordCount>wordCount:true,maximumWords:${maximumWords!},<#else>wordCount:false,</#if>autoHeightEnabled:false,toolbars:[['undo','redo','bold','italic', 'underline', 'fontborder','spechars','snapscreen','simpleupload','wordimage','strikethrough', 'superscript', 'subscript', 'fullscreen','parenthese','fontfamily', 'fontsize','|','inserttable', 'deletetable', 'insertparagraphbeforetable', 'insertrow', 'deleterow', 'insertcol', 'deletecol', 'mergecells', 'mergeright', 'mergedown', 'splittocells', 'splittorows', 'splittocols','justifyleft', 'justifycenter', 'justifyright', 'justifyjustify', '|', 'touppercase', 'tolowercase','attachment', 'map','cleardoc','removeformat', 'gmap']]});
<#elseif group?if_exists == 'full'>
editor${id!} = UE.getEditor('${id!}',{<#if wordCount>wordCount:true,maximumWords:${maximumWords!},<#else>wordCount:false,</#if>autoHeightEnabled:false,toolbars:[['anchor','undo','redo', 'bold','indent','snapscreen','italic','underline','strikethrough','subscript','fontborder','superscript','formatmatch','source','blockquote','pasteplain','selectall','print','preview','horizontal','removeformat','time','date','unlink','insertrow','insertcol','mergeright','mergedown','deleterow','deletecol','splittorows','splittocols','splittocells','deletecaption','inserttitle','mergecells','deletetable','cleardoc','insertparagraphbeforetable','fontfamily','fontsize','paragraph','simpleupload','insertimage','edittable','edittd','link','emotion','spechars','searchreplace','map','gmap','insertvideo','help','justifyleft','justifyright','justifycenter','justifyjustify','forecolor','backcolor','insertorderedlist','insertunorderedlist','fullscreen','directionalityltr','directionalityrtl','rowspacingtop','rowspacingbottom','pagebreak','insertframe','imagenone','imageleft','imageright','attachment','imagecenter','wordimage','lineheight','edittip ','customstyle','autotypeset','webapp','touppercase','tolowercase','background','template','scrawl','music','inserttable','drafts','charts']]});
<#elseif group?if_exists == 'table'>
editor${id!} = UE.getEditor('${id!}',{<#if wordCount>wordCount:true,maximumWords:${maximumWords!},<#else>wordCount:false,</#if>autoHeightEnabled:false,toolbars:[['undo','redo','bold','indent','italic','underline','strikethrough','subscript','fontborder','superscript','horizontal','insertrow','insertcol','mergeright','mergedown','deleterow','deletecol','splittorows','splittocols','splittocells','deletecaption','inserttitle','mergecells','deletetable','cleardoc','removeformat','insertparagraphbeforetable']]});
<#else>
editor${id!} = UE.getEditor('${id!}',{<#if wordCount>wordCount:true,maximumWords:${maximumWords!},<#else>wordCount:false,</#if>autoHeightEnabled:false});
</#if>
</onload>
<dependency>
${contextPath!}/library/ueditor/ueditor.config.js,${contextPath!}/library/ueditor/ueditor.all.min.js,${contextPath!}/library/ueditor/lang/zh-cn/zh-cn.js
</dependency>