<htmlTag>
<div class="panel-body-buttons" <#if style??>style="${style!}"<#else>style="text-align:center;"</#if>>
	<ul>
		<#list tagLista?if_exists as taga>
			${taga!}
		</#list>
	</ul>
</div>
</htmlTag>