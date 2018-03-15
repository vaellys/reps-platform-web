<htmlTag>
<div class="panel-toolbar" <#if style??>style="${style!}"</#if>>
	<ul>
		<#list tagLista?if_exists as taga>
			<#if taga == "<a/>">
					<li class="line">line</li>
				<#else>
					<li>${taga!}</li>
			</#if>
		</#list>
	</ul>
</div>
</htmlTag>