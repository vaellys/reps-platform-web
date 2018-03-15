<htmlTag>
<#if !multiple>
<input class="txtInput <#if required> required</#if>" name="${name!}" id="${id!}" type="input" value="${nameValue!}" <#if style??>style="float:left;${style!}"<#else> style="float:left;width:176px;"</#if> <#if readonly> readonly='readonly'</#if> <#if tabIndex gt -1>tabIndex="${tabIndex!}"</#if> />
</#if>
<input name="${hideName!}" id="${hideId!}" type="hidden" value="${hideNameValue!}" />
<#assign href = "" />
<#if !multiple>
		<a class="btnLook" target="dialog" href="#" style="margin-left:-27px;" onClick="${hideId!}organizeClick();" rel="${hideId!}-organize-rel" title="组织机构" data-options='{"id":"${hideId!}dialog","drawable":${drawable?string("true","false")},"inIframe":true<#if !multiple>}'></a><#else>,"okCall":"function(){var hideNameValue = $(&apos;input[name=hideNameValue]&apos;,window.${hideId!}dialog.document).val();if(hideNameValue.length == 0){alert(&apos;请选择组织机构！&apos;);return false;} var hideName = $(&apos;input[name=hideName]&apos;,window.${hideId!}dialog.document).val();$(&apos;input[name=&apos;+hideName+&apos;]&apos;).val(hideNameValue);$(&apos;input[name=&apos;+hideName+&apos;]&apos;).val(hideNameValue);<#if callBack??>var ${hideId!}MulCallback = ${callBack!};${hideId!}MulCallback();}","cancelCall":"function(){}"}'><#if value??>${value!}<#else>组织机构选择</#if></a></#if></#if>
		<#if url??>
			<#assign href = href + "${url!}showName=${name!}&hideName=${hideName!}&dialogId=${hideId!}dialog&showRoot=${showRoot?string}&organize.type=${dataType!}&callBack=${callBack!}" />
		<#else>
			<#assign href = href + "${contextPath!}${actionBasePath!}/sys/chooseorganize/single.mvc?showName=${name!}&hideName=${hideName!}&dialogId=${hideId!}dialog&showRoot=${showRoot?string}&organize.type=${dataType!}&callBack=${callBack!}" />
			</#if>
	<#else>
		<a target="dialog" style="<#if style??>${style}</#if>" href="#" onClick="${hideId!}organizeClick();" rel="${hideId!}-organize-rel" title="组织机构" data-options='{"id":"${hideId!}dialog","drawable":${drawable?string("true","false")},"inIframe":true<#if !multiple>}'></a><#else>,"okCall":"function(){var hideNameValue = $(&apos;input[name=hideNameValue]&apos;,window.${hideId!}dialog.document).val();<#if !allowBlank>if(hideNameValue.length == 0){alert(&apos;请选择组织机构！&apos;);return false;}</#if> var hideName = $(&apos;input[name=hideName]&apos;,window.${hideId!}dialog.document).val();$(&apos;input[name=&apos;+hideName+&apos;]&apos;).val(hideNameValue);$(&apos;input[name=&apos;+hideName+&apos;]&apos;).val(hideNameValue);<#if callBack??>var ${hideId!}MulCallback = ${callBack!};${hideId!}MulCallback();</#if>}","cancelCall":"function(){}"}'><#if value??>${value!}<#else>组织机构选择</#if></a></#if>
		<#if url??>
			<#assign href = href + "${url!}hideName=${hideName!}&multiple=${multiple?string}&dialogId=${hideId!}dialog&showRoot=${showRoot?string}&organize.type=${dataType!}" />
		<#else>
			<#assign href = href + "${contextPath!}${actionBasePath!}/sys/chooseorganize/multiple.mvc?hideName=${hideName!}&multiple=${multiple?string}&dialogId=${hideId!}dialog&showRoot=${showRoot?string}&organize.type=${dataType!}" />
		</#if>
 </#if>
<#assign href = href + "&hideNameValue='+hideNameValues+''" />
<script>
    var ${hideId!}organizeClick = function(){
    var hideNameValues = $('input[name="${hideName!}"]').val();
    $('a[rel="${hideId!}-organize-rel"]').attr('href','${href!});}
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