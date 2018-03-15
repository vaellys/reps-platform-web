<htmlTag>
<div class="panel-body-content" <#if style??>style="${style!}"</#if>>
	<table class="formContent" >
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
													<td class="fLabel" <#if field.title??>title="${field.title!}"</#if> style="${field.labelStyle!}">${field.label!}:</td><td colspan="3" class="fInput" style="${field.textStyle!}">${field.innerHtml!}</td>
												<#else>
													<td class="fLabel" <#if field.title??>title="${field.title!}"</#if> style="${field.labelStyle!}">${field.label!}:</td><td colspan="3" class="fInput">${field.innerHtml!}</td>
											</#if>
										<#else>
											<#if field.textStyle??>
													<td class="fLabel" <#if field.title??>title="${field.title!}"</#if>>${field.label!}:</td><td colspan="3" class="fInput" style="${field.textStyle!}">${field.innerHtml!}</td>
												<#else>
													<td class="fLabel" <#if field.title??>title="${field.title!}"</#if>>${field.label!}:</td><td colspan="3" class="fInput">${field.innerHtml!}</td>
											</#if>
									</#if>
								<#else>
									<td colspan="4" class="fInput">${field.innerHtml!}</td>
							</#if>
					<#else>
						<#assign nextContinue = true>
						<#list 0..columnLen as column>
							<#assign columnFieldIndex = i +column />
							<#if columnFieldIndex lte len>
							<#assign columnField = fields[columnFieldIndex] />
							<#if columnField.label??>
								<#if columnField.labelStyle??>
										<#if columnField.textStyle??>
												<td class="fLabel" <#if columnField.title??>title="${columnField.title!}"</#if> style="${columnField.labelStyle!}">${columnField.label!}:</td><td class="fInput" style="${columnField.textStyle!}">${columnField.innerHtml!}</td>
											<#else>
												<td class="fLabel" <#if columnField.title??>title="${columnField.title!}"</#if> style="${columnField.labelStyle!}">${columnField.label!}:</td><td class="fInput">${columnField.innerHtml!}</td>
										</#if>
									<#else>
										<#if columnField.textStyle??>
												<td class="fLabel" <#if columnField.title??>title="${columnField.title!}"</#if>>${columnField.label!}:</td><td class="fInput" style="${columnField.textStyle!}">${columnField.innerHtml!}</td>
											<#else>
												<td class="fLabel" <#if columnField.title??>title="${columnField.title!}"</#if>>${columnField.label!}:</td><td class="fInput">${columnField.innerHtml!}</td>
										</#if>
								</#if>
							<#else>
								<td colspan="2" class="fInput">${columnField.innerHtml!}</td>
							</#if>
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
</div>
</htmlTag>