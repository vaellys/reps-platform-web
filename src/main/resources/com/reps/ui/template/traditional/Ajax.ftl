<htmlTag>
<#if type?? && (type == "submit" || type =="button")>
	<div <#if cssClass??>class="${cssClass!}"</#if> <#if style??>style="${style!}"</#if>><input type="${type!}"
	<#else>
	<a href="javascript:;" <#if style??>style="${style!}"</#if> <#if cssClass??>class="${cssClass!}"</#if>
</#if>
<#if name??> name="${name!}"</#if> <#if id??> id="${id!}"</#if> 
<#if formId??>
	<#if beforeCall??>
		onclick="<#if beforeCall??>var flag = ${beforeCall!};if(flag){ajaxFormSubmit('${formId!}'</#if>
	<#else>
		onclick="ajaxFormSubmit('${formId!}'
	</#if>
<#else>
	<#if beforeCall??>
		onclick="<#if beforeCall??>var flag = ${beforeCall!};if(flag){ajaxUrlCallback('${url!}'</#if>
	<#else>
		onclick="ajaxUrlCallback('${url!}'
	</#if>
</#if>
<#if confirm??>,'${confirm!}'<#else>,null</#if>
<#if callback??>,${callback!}<#else>,null</#if>
<#if redirect??>,'${redirect!}'<#else>,null</#if>
<#if okCall??>,${okCall!}</#if>
<#if beforeCall??>)}"<#else>)"</#if>

<#if type?? && (type! == "submit" || type! =="button")>
 value="${value!}"/></div>
<#else>
 ><span>${value!}</span></a>
</#if>
</htmlTag>