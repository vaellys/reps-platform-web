<htmlTag>
<div class="panel-header-buttons" <#if style??>style="${style!}"</#if> >
	<ul>
		<#list tagLista?if_exists as taga>
			${taga!}
		</#list>
	</ul>
</div>
</htmlTag>