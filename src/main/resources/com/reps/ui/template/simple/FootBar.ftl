<htmlTag>
<div class="panel-footbar" <#if tagLista??><#if style??>style="${style!}"</#if><#else>style="display:none;"</#if>>
	<ul>
	<#if tagLista??>
		<#list tagLista as taga>
			<#if taga == '<a/>'>
				<li class="line">line</li>
				<#else>
				<li>${taga!}</li>
			</#if>
		</#list>
	</#if>
	</ul>
</div>
</htmlTag>