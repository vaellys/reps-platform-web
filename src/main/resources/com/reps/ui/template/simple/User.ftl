<htmlTag>
<#if !multiple>
<input class="txtInput <#if required> required</#if>" name="${name!}" id="${id!}" type="input" value="${nameValue!}" <#if style??>style="float:left;${style!}"<#else> style="float:left;width:154px;"</#if> <#if readonly> readonly='readonly'</#if> <#if tabIndex gt -1>tabIndex="${tabIndex!}"</#if> />
</#if>
<input name="${hideName!}" id="${hideId!}" type="hidden" value="${hideNameValue!}" />
<#assign href = "" />
<#if !multiple>
		<a class="btnLook" style="margin-left:-27px;" target="dialog"
		<#if url??>
			<#assign href = href + "${url!}showName=${name!}&hideName=${hideName!}&showDisable=${showDisable?string}&dialogId=${hideId!}dialog&callBack=${callBack!}&filterSelected=${filterSelected?string('true','false')}&organizeId=" />
		<#else>
			<#assign href = href + "${contextPath!}${actionBasePath!}/sys/chooseuser/single.mvc?showName=${name!}&hideName=${hideName!}&showDisable=${showDisable?string}&dialogId=${hideId!}dialog&callBack=${callBack!}&filterSelected=${filterSelected?string('true','false')}&organizeId=" />
		</#if>
	<#else>
		<a target="dialog" <#if cssClass??>class="${cssClass!}" </#if>
		<#if url??>
			<#assign href = href + "${url!}hideName=${hideName!}&multiple=${multiple?string}&showDisable=${showDisable?string}&dialogId=${hideId!}dialog&callBack=${callBack!}&filterSelected=${filterSelected?string('true','false')}&allowBlank=${allowBlank?string('true','false')}&organizeId=" />
		<#else>
			<#assign href = href + "${contextPath!}${actionBasePath!}/sys/chooseuser/multiple.mvc?hideName=${hideName!}&multiple=${multiple?string}&showDisable=${showDisable?string}&dialogId=${hideId!}dialog&callBack=${callBack!}&filterSelected=${filterSelected?string('true','false')}&allowBlank=${allowBlank?string('true','false')}&organizeId=" />
		</#if>
</#if>
 href="#" onClick="${hideId!}userClick();" rel="${hideId!}-user-rel" title="用户选择" data-options='{"id":"${hideId!}dialog","drawable":${drawable?string("true","false")},"inIframe":true}'><#if !multiple></a><#else><span>用户选择</span></a></#if>
<script>
    var ${hideId!}userClick = function(){
    var hideNameValues = $('input[name="${hideName!}"]').val();
    <#if orgId?starts_with("#")>
	    	var orgIdUser = $('${orgId!}').val();
	    	<#assign href = href + "'+orgIdUser+'">
    	<#else>
    		<#assign href = href + "${orgId!}">
    </#if>
    <#assign href = href + "&hideNameValue='+hideNameValues" />
    $('a[rel="${hideId!}-user-rel"]').attr('href','${href!});}
</script>
</htmlTag>
<onload>
$('a[target=dialog]', $p).each(function(){$(this).off("click").click(function(event){var $this = $(this);
var title = $this.attr('title') || $this.text();var rel = $this.attr('rel') || '_blank';
var url = unescape($this.attr('href'));var options = $this.data('options');
if(typeof options == "string"){
	options = eval("("+options+")");
}
<#if beforeCall??>
	eval("var flag = ${beforeCall}();");
	if(flag){
		$.pdialog.open(url, rel, title, options);
	}
<#else>
	$.pdialog.open(url, rel, title, options);
</#if>

return false;});});
</onload>