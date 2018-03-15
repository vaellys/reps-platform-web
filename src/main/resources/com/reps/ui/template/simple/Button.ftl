<htmlTag>
<#if type?if_exists == "submit" || type?if_exists =="button">
<div class="repsbtn ${cssClass?if_exists}" <#if style??>style="${style?if_exists}"</#if>><input type="${type?if_exists}" value="${val?if_exists}" <#if id??>id="${id?if_exists}"</#if> <#if name??>name="${name?if_exists}"</#if> <#if disabled>disabled="disabled"</#if> <#if onClick??>onClick="${onClick?if_exists}"</#if> /></div>
<#else>
<a href="<#if act??>${act?if_exists}<#else>javascript:void(0);</#if>" <#if target??>target="${target}"</#if> class="repsbutton ${cssClass?if_exists}" <#if style??>style="${style?if_exists}"</#if>  <#if id??>id="${id?if_exists}"</#if> <#if onClick??>onClick="${onClick}"</#if> ><span>${val?if_exists}</span></a>
</#if>
</htmlTag>