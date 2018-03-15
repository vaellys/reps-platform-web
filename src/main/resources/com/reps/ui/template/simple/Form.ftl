<htmlTag>
<table class="formContent" <#if style??>style="${style!}"</#if>>
<#if fields??>
	<#assign len = fields?size-1 />
	<#assign nextContinue = false />
<#list 0..len as i>
	<#if !nextContinue>
		<#assign field = fields[i] />
		<#assign isFullRow = false />
		<#if (i+1) == fields?size>
			<#assign isFullRow = true />
		</#if>
		<tr>
			<#if isFullRow || field.fullRow>
					<#if field.label??>
							<#if field.labelStyle??>
									<#if field.textStyle??>
											<td class="fLabel" style="${field.labelStyle!}">${field.label!}:</td><td colspan="3" class="fInput" style="${field.textStyle!}">${field.innerHtml!}</td>
										<#else>
											<td class="fLabel" style="${field.labelStyle!}">${field.label!}:</td><td colspan="3" class="fInput">${field.innerHtml!}</td>
									</#if>
								<#else>
									<#if field.textStyle??>
											<td class="fLabel">${field.label!}:</td><td colspan="3" class="fInput" style="${field.textStyle!}">${field.innerHtml!}</td>
										<#else>
											<td class="fLabel">${field.label!}:</td><td colspan="3" class="fInput">${field.innerHtml!}</td>
									</#if>
							</#if>
						<#else>
							<td colspan="4" class="fInput">${field.innerHtml!}</td>
					</#if>
			<#else>
				<#assign field2 = fields[i+1] />
				<#assign nextContinue = true>
				<#if field.label??>
						<#if field.labelStyle??>
								<#if field.textStyle??>
										<td class="fLabel" style="${field.labelStyle!}">${field.label!}:</td><td class="fInput" style="${field.textStyle!}">${field.innerHtml!}</td>
									<#else>
										<td class="fLabel" style="${field.labelStyle!}">${field.label!}:</td><td class="fInput">${field.innerHtml!}</td>
								</#if>
							<#else>
								<#if field.textStyle??>
										<td class="fLabel">${field.label!}:</td><td class="fInput" style="${field.textStyle!}">${field.innerHtml!}</td>
									<#else>
										<td class="fLabel">${field.label!}:</td><td class="fInput">${field.innerHtml!}</td>
								</#if>
						</#if>
					<#else>
						<td colspan="2" class="fInput">${field.innerHtml!}</td>
				</#if>
				<#if field2.label??>
						<#if field2.labelStyle??>
								<#if field2.textStyle??>
										<td class="fLabel" style="${field2.labelStyle!}">${field2.label!}:</td><td class="fInput" style="${field2.textStyle!}">${field2.innerHtml!}</td>
									<#else>
										<td class="fLabel" style="${field2.labelStyle!}">${field2.label!}:</td><td class="fInput">${field2.innerHtml!}</td>
								</#if>
							<#else>
								<#if field2.textStyle??>
										<td class="fLabel">${field2.label!}:</td><td colspan="3" class="fInput" style="${field2.textStyle!}">${field2.innerHtml!}</td>
									<#else>
										<td class="fLabel">${field2.label!}:</td><td colspan="3" class="fInput">${field2.innerHtml!}</td>
								</#if>
						</#if>
					<#else>
						<td colspan="2" class="fInput">${field2.innerHtml!}</td>
				</#if>
			</#if>
		</tr>
	<#else>
		<#assign nextContinue = false />
	</#if>
</#list>
</#if>
</table>
</htmlTag>