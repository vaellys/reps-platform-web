<htmlTag>
<div class="formBar" <#if style??>style="${style!}"<#else>style="text-align:center;"</#if>>
	<ul>
		<#list tagLista?if_exists as taga>
			<span>${taga!}</span>
		</#list>
	</ul>
</div>
</htmlTag>