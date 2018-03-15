<htmlTag>
<table <#if id??>id="${id!}"</#if> class="tableContent" <#if style??>style="${style!}"</#if>>
<#if fields??>
			<#assign len = fields?size-1 />
			<#assign controlColumns = columns - 1 />
			<#assign columnLen = columns -1 />
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
													<td class="fLabel" style="${field.labelStyle!}">${field.label!}:&nbsp;</td><td colspan="${fields?if_exists?size}" class="fInput" style="${field.textStyle!}">${field.innerHtml!}</td>
												<#else>
													<td class="fLabel" style="${field.labelStyle!}">${field.label!}:&nbsp;</td><td colspan="${fields?if_exists?size}" class="fInput">${field.innerHtml!}</td>
											</#if>
										<#else>
											<#if field.textStyle??>
													<td class="fLabel">${field.label!}:&nbsp;</td><td colspan="${fields?if_exists?size}" class="fInput" style="${field.textStyle!}">${field.innerHtml!}</td>
												<#else>
													<td class="fLabel">${field.label!}:&nbsp;</td><td colspan="${fields?if_exists?size}" class="fInput">${field.innerHtml!}</td>
											</#if>
									</#if>
								<#else>
									<td colspan="4" class="fInput">${field.innerHtml!}</td>
							</#if>
					<#else>
						<#assign nextContinue = true>
						<#list 0..columnLen as column>
							<#assign columnField = fields[i+column] />
							<#if columnField.label??>
								<#if columnField.labelStyle??>
										<#if columnField.textStyle??>
												<td class="fLabel" style="${columnField.labelStyle!}">${columnField.label!}:&nbsp;</td><td class="fInput" style="${columnField.textStyle!}">${columnField.innerHtml!}</td>
											<#else>
												<td class="fLabel" style="${columnField.labelStyle!}">${columnField.label!}:&nbsp;</td><td class="fInput">${columnField.innerHtml!}</td>
										</#if>
									<#else>
										<#if columnField.textStyle??>
												<td class="fLabel">${columnField.label!}:&nbsp;</td><td class="fInput" style="${columnField.textStyle!}">${columnField.innerHtml!}</td>
											<#else>
												<td class="fLabel">${columnField.label!}:&nbsp;</td><td class="fInput">${columnField.innerHtml!}</td>
										</#if>
								</#if>
							<#else>
								<td colspan="2" class="fInput">${columnField.innerHtml!}</td>
							</#if>
						</#list>
					</#if>
				</tr>
			<#else>
				<#assign controlColumns = controlColumns -1 />
				<#if controlColumns lt 1>
					<#assign nextContinue = false />
					<#assign controlColumns = columns -1 />
				</#if>
				
			</#if>
		</#list>
		</#if>
</table>
</htmlTag>
<onload>
<#if !borderFlag && id??>
	$("#${id!}").css("border-width","0px");
	$("#${id!} td").css("border-width","0px");
</#if>

<#if !textBackgroundFlag && id??>
	$("#${id!} td.fInput").css("background","#E5EDEF");
</#if>
</onload>