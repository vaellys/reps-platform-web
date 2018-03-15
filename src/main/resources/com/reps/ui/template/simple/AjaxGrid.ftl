<htmlTag>
<#if type?if_exists == "submit" || type?if_exists =="button">
<div <#if cssClass??>class="${cssClass}"</#if>><input type="${type?if_exists}" <#if name??>name="${name?if_exists}"</#if> <#if id??>id="${id?if_exists}"</#if> onclick="<#if beforeCall??>var beforeCallback = ${beforeCall!};if(!beforeCallback()){return false;};</#if>ajaxGrid('${gridId?if_exists}',<#if formId??>'${formId}'<#else>null</#if>,<#if url??>'${url}'<#else>null</#if>,<#if confirm??>'${confirm}'<#else>null</#if>,<#if callback??>'${callback}'<#else>null</#if>,${loadDialogJs?string("true","false")})" value="${value?if_exists}" /></div>
<#else>
<a href="javascript:;" <#if cssClass??>class="${cssClass}"</#if> <#if name??>name="${name?if_exists}"</#if> <#if id??>id="${id?if_exists}"</#if> onclick="<#if beforeCall??>var beforeCallback = ${beforeCall!};if(!beforeCallback()){return false;};</#if>ajaxGrid('${gridId?if_exists}',<#if formId??>'${formId}'<#else>null</#if>,<#if url??>'${url}'<#else>null</#if>,<#if confirm??>'${confirm}'<#else>null</#if>,<#if callback??>'${callback}'<#else>null</#if>,${loadDialogJs?string("true","false")})"><span>${value?if_exists}</span></a>
</#if>
</htmlTag>