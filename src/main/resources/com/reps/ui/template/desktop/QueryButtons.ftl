<htmlTag>
<div class="panel-query-buttons" <#if style??>style="${style!}"<#else>style=""</#if>>
	<#list tagLista?if_exists as taga>
		<span>${taga!}</span>
	</#list>
</div>
</htmlTag>