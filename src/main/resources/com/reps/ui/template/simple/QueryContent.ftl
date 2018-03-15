<htmlTag>
<table <#if style??>style="${style!}"<#else>style="width:100%"</#if>>
	<tbody>
		<tr>
			${queryContent!}
		</tr>
	</tbody>
</table>
</htmlTag>