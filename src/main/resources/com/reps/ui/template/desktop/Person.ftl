<htmlTag>
<#if !multiple>
<input class="txtInput <#if required> required</#if>" name="${name!}" id="${id!}" type="input" value="${nameValue!}" <#if style??>style="float:left;${style!}"<#else> style="float:left;width:176px;"</#if> <#if readonly> readonly='readonly'</#if> <#if tabIndex gt -1>tabIndex="${tabIndex!}"</#if> />
</#if>
<input name="${hideName!}" id="${hideId!}" type="hidden" value="${hideNameValue!}" />
<#assign href = "" />
<#if !multiple>
		<a class="btnLook" style="margin-left:-27px;" target="dialog" 
		<#if url??>
			<#assign href = href + "${url!}personType=${personType!}&showName=${name!}&hideName=${hideName!}&dialogId=${hideId!}dialog&callBack=${callBack!}&orgId=" />
		<#else>
			<#assign href = href + "${contextPath!}${actionBasePath!}/sys/chooseperson/single.mvc?personType=${personType!}&showName=${name!}&hideName=${hideName!}&dialogId=${hideId!}dialog&callBack=${callBack!}&orgId=" />
		</#if>
	<#else>
		<a <#if cssClass??>class="${cssClass!}"</#if> target="dialog" 
		<#if url??>
			<#assign href = href + "${url!}personType=${personType!}&hideName=${hideName!}&multiple=${multiple?string}&dialogId=${hideId!}dialog&orgId=" />
		<#else>
			<#assign href = href + "${contextPath!}${actionBasePath!}/sys/chooseperson/multiple.mvc?personType=${personType!}&hideName=${hideName!}&multiple=${multiple?string}&dialogId=${hideId!}dialog&orgId=" />
		</#if>
</#if>
<#if orgId?starts_with("#")>  
<#assign href = href + orgId />
</#if>
 href="#" onClick="${hideId!}personClick();" rel="${hideId!}-person-rel" <#if title??>title="${title!}"<#else>title="人员选择"</#if> data-options='{"id":"${hideId!}dialog","drawable":${drawable?string("true","false")},"inIframe":true<#if !multiple>}'></a><#else>,"okCall":"function(){var hideNameValue = $(&apos;input[name=hideNameValue]&apos;,window.${hideId!}dialog.document).val();<#if !allowBlank>if(hideNameValue.length == 0){alert(&apos;请选择人员！&apos;);return false;}</#if>  var hideName = $(&apos;input[name=hideName]&apos;,window.${hideId!}dialog.document).val();$(&apos;input[name=&apos;+hideName+&apos;]&apos;).val(hideNameValue);<#if callBack??>var ${hideId!}MulCallback = ${callBack!};${hideId!}MulCallback();</#if>}","cancelCall":"function(){}"}'><span><#if value??>${value!}<#else>人员选择</#if></span></a></#if>
<#assign href = href + "&hideNameValue='+hideNameValues" /> 
<script>
    var ${hideId!}personClick = function(){
    var hideNameValues = $('input[name="${hideName!}"]').val();
    <#if orgId?starts_with("#")>
    	var orgIdPerson = $('${orgId!}').val();
    	<#assign href = href + "'+orgIdPerson">
    </#if>
    $('a[rel="${hideId!}-person-rel"]').attr('href','${href!});}
</script>
</htmlTag>
<onload>
$('a[target=dialog]', $p).each(function(){$(this).off("click").click(function(event){var $this = $(this);
var title = $this.attr('title') || $this.text();var rel = $this.attr('rel') || '_blank';
var url = unescape($this.attr('href'));var options = $this.data('options');
if(typeof options == "string"){
	options = eval("("+options+")");
}
$.pdialog.open(url, rel, title, options);return false;});});
</onload>