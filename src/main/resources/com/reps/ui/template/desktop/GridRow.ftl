<htmlTag>
<#if height??>
		<tr style='height:${height!}' <#if title??>title="${title!}"</#if>>
	<#else>
		<tr <#if title??>title="${title!}"</#if>>
</#if>
</htmlTag>  
<htmlTagEnd>
</tr>
</htmlTagEnd>