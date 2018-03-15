<htmlTag>
<td <#if id??> id="${id!}"</#if> <#if style??> style="${style!}"style</#if> <#if cssClass??> class="${cssClass!}"</#if> <#if align??> align="${align!}"</#if> <#if nowrap> nowrap="nowrap"</#if> <#if textTitle??>title="${textTitle!}"</#if>>
<#if flagCheckbox??>
	<#if checkboxDisabled>
			<#if checkboxTitle??>
					<input <#if checked>checked="checked"</#if> type="${flagCheckbox!}" style="vertical-align:middle;" title="${checkboxTitle!}" disabled="disabled"  class="itemCheck" name="${checkboxName!}" value="${value!}" />
				<#else>
					<input <#if checked>checked="checked"</#if> type="${flagCheckbox!}" style="vertical-align:middle;" disabled="disabled"  class="itemCheck" name="${checkboxName!}" value="${value!}" />
			</#if>
		<#else>
			<#if checkboxTitle??>
					<input <#if checked>checked="checked"</#if> type="${flagCheckbox!}" style="vertical-align:middle;" title="${checkboxTitle!}" class="itemCheck" name="${checkboxName!}" value="${value!}" />
				<#else>
					<input <#if checked>checked="checked"</#if> type="${flagCheckbox!}" style="vertical-align:middle;" class="itemCheck" name="${checkboxName!}" value="${value!}" />
			</#if>
	</#if>
</#if>
</htmlTag>
<htmlTagEnd>
</td>
</htmlTagEnd>
