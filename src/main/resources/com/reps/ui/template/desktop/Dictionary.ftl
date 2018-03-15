<htmlTag>
<#if id?? || name??>
	<#if type?if_exists != 'input'>
			<#if type?if_exists == 'checkbox'>
					<#list dictionaryList as dictionaryItem>
						<span style="display:inline-block;margin-right:2px;"><input type='checkbox' name="${name!}" <#if style??>style="${style!}"</#if> value="${dictionaryItem.code!}" <#if tabIndex gt -1>tabIndex="${tabIndex!}"</#if> <#if value?if_exists?seq_contains(dictionaryItem.code)>checked="checked"</#if> <#if onChange??>onchange="${onChange!}"</#if> />${dictionaryItem.name!}</span>
					</#list>
				<#elseif type?if_exists == 'radio'>
					<#list dictionaryList as dictionaryItem>
						<span style="display:inline-block;margin-right:2px;"><input type='radio' name="${name!}" value="${dictionaryItem.code!}" <#if style??>style="${style!}"</#if> <#if tabIndex gt -1>tabIndex="${tabIndex!}"</#if> <#if value?if_exists == dictionaryItem.code>checked="checked"</#if> <#if onChange??>onchange="${onChange!}"</#if> />${dictionaryItem.name!}</span>
					</#list>
				<#else>
					<select <#if required>class="required"</#if><#if disabled> disabled</#if> <#if id??>id="${id!}"</#if> <#if name??>name="${name!}"</#if> <#if onChange??>onChange="${onChange!}"</#if> <#if css??>class="${css!}"</#if> <#if style??>style="${style!}"<#else>style="width:180px;"</#if> <#if tabIndex gt -1>tabIndex="${tabIndex!}"</#if> >
						<#assign flagExistHeaderValue = false>
						<#if dictionaryList??>
							<#list dictionaryList as item>
								<#if headerValue?? && (headerValue == item.code)>
									<#assign flagExistHeaderValue = true>
								</#if>
							</#list>
						</#if>
						<#if headerText??>
							<#if !flagExistHeaderValue>
								<#if headerValue??>
										<option value="${headerValue!}">${headerText!}</option>
									<#else>
										<option>${headerText!}</option>
								</#if>
							</#if>
						</#if>
						<#if value?? && value?length gt 0>
							<#assign flagValueNotInOptions = true />
						</#if>
						<#list dictionaryList?if_exists as dictionaryItem>
							<#if value?? && dictionaryItem.code?if_exists == value>
									<#assign flagValueNotInOptions = false />
									<option selected="selected" value="${dictionaryItem.code!}">${dictionaryItem.name!}</option>
								<#else>
									<#if flagExistHeaderValue && (headerValue == dictionaryItem.code)>
											<option selected="selected" value="${dictionaryItem.code!}">${dictionaryItem.name!}</option>
										<#else>
											<option value="${dictionaryItem.code!}">${dictionaryItem.name!}</option>
									</#if>
							</#if>
						</#list>
						<#if value?? && value?length gt 0 && temp?? && temp?length gt 0 && flagValueNotInOptions>
							<option selected="selected" value="${value!}">${temp!}</option>
						</#if>
					</select>
			</#if>
		<#else>
			<input <#if id??>id="${id!}"</#if> <#if name??>name="${name!}"</#if> <#if required>class="required"</#if> <#if style??> style="background-color:#fff;${style!}"<#else> style="background-color:#fff;width:158px;"</#if> <#if tabIndex gt -1>tabIndex="${tabIndex!}"</#if> />
	</#if>
<#else>
${temp!}
</#if>
</htmlTag>
<onload>
<#if type?if_exists == 'input'>
$("input[name='${name!}']").repscombobox({data:'<#list dictionaryList as item>${item.code!}:${item.name!},</#list>'},'{<#if id??>"id":"${id!}",</#if><#if name??>"name":"${name!}",</#if><#if headerValue??>"headerValue":"${headerValue!}",</#if><#if headerText??>"headerText":"${headerText!}"</#if>}');
</#if>
</onload>