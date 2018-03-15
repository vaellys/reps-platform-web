<htmlTag>
<#if icon??>
	<#if type?if_exists == "link">
			<a <#if id??>id="${id?if_exists}"</#if> href="<#if act??>${act?if_exists}<#else>javascript:void(0);</#if>" <#if target??>target="${target}"</#if> class="btn<#if color??> ${color!}</#if>" <#if onClick??>onClick="${onClick}"</#if>><span class="icon ${icon!}"></span><#if val??>${val!}</#if></a>
		<#elseif type?if_exists == "submit">
			<button type="submit" class="btn <#if color??> ${color!}</#if>" ><span class="icon ${icon!}"></span>${val!}</button>
		<#else>
			<button class="btn <#if color??> ${color!}</#if>" <#if onClick??>onClick="${onClick}"</#if>><span class="icon ${icon!}"></span>${val!}</button>
	</#if>
<#else>
	<#if type?if_exists == "submit" || type?if_exists =="button">
			<div class="${cssClass?if_exists}" <#if style??>style="${style?if_exists}"</#if>><input type="${type?if_exists}" value="${val?if_exists}" <#if id??>id="${id?if_exists}"</#if> <#if name??>name="${name?if_exists}"</#if> <#if disabled>disabled="disabled"</#if> <#if onClick??>onClick="${onClick?if_exists}"</#if> /></div>
		<#else>
			<a href="<#if act??>${act?if_exists}<#else>javascript:void(0);</#if>" class="${cssClass?if_exists}" <#if style??>style="${style?if_exists}"</#if>  <#if id??>id="${id?if_exists}"</#if> <#if onClick??>onClick="${onClick}"</#if> ><span>${val?if_exists}</span></a>
	</#if>
</#if>
</htmlTag>