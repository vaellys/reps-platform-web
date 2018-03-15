<htmlTag>
<#if !multiple>
<input class="txtInput <#if required> required</#if>" name="${name!}" id="${id!}" type="input" value="${nameValue!}" <#if style??>style="float:left;${style!}"<#else> style="float:left;width:176px;"</#if> <#if readonly> readonly='readonly'</#if> <#if tabIndex gt -1>tabIndex="${tabIndex!}"</#if> />
</#if>
<input name="${hideName!}" id="${hideId!}" type="hidden" value="${hideNameValue!}" />
<#assign href = "" />
<#if !multiple>
		<a class="btnLook" style="margin-left:-27px;" target="dialog" 
		<#if url??>
			<#assign href = href + "${url!}showName=${name!}&hideName=${hideName!}&dialogId=${hideId!}dialog&callBack=${callBack!}&filterSelected=${filterSelected?string('true','false')}&orgId=" />
		<#else>
			<#assign href = href + "${contextPath!}${actionBasePath!}/sys/chooseaccount/single.mvc?showName=${name!}&hideName=${hideName!}&dialogId=${hideId!}dialog&callBack=${callBack!}&filterSelected=${filterSelected?string('true','false')}&orgId=" />
		</#if>
	<#else>
		<a <#if cssClass??>class="${cssClass!}"</#if> target="dialog" 
		<#if url??>
			<#assign href = href + "${url!}hideName=${hideName!}&multiple=${multiple?string}&dialogId=${hideId!}dialog&filterSelected=${filterSelected?string('true','false')}&callBack=${callBack!}&orgId=" />
		<#else>
			<#assign href = href + "${contextPath!}${actionBasePath!}/sys/chooseaccount/multiple.mvc?hideName=${hideName!}&multiple=${multiple?string}&dialogId=${hideId!}dialog&filterSelected=${filterSelected?string('true','false')}&callBack=${callBack!}&orgId=" />
		</#if>
</#if>
<#if orgId?starts_with("#")>  
<#assign href = href + orgId />
</#if>
 href="#" onClick="${hideId!}accountClick();" rel="${hideId!}-account-rel" <#if title??>title="${title!}"<#else>title="人员选择"</#if> data-options='{"id":"${hideId!}dialog","drawable":${drawable?string("true","false")},"inIframe":true}'> <#if !multiple></a><#else><span><#if value??>${value!}<#else>人员选择</#if></span></a></#if>
<#assign href = href + "&hideNameValue='+hideNameValues" /> 
<script>
    var ${hideId!}accountClick = function(){
    var hideNameValues = $('input[name="${hideName!}"]').val();
    <#if orgId?starts_with("#")>
    	var orgIdPerson = $('${orgId!}').val();
    	<#assign href = href + "'+orgIdPerson">
    </#if>
    $('a[rel="${hideId!}-account-rel"]').attr('href','${href!});}
</script>
</htmlTag>
<onload>
$('a[target=dialog]', $p).each(function(){$(this).click(function(event){var $this = $(this);
var title = $this.attr('title') || $this.text();var rel = $this.attr('rel') || '_blank';
var url = unescape($this.attr('href'));var options = $this.data('options');
if(typeof options == "string"){
	options = eval("("+options+")");
}
$.pdialog.open(url, rel, title, options);return false;});});
</onload>