<htmlTag>
<#if !flagInput>
			<#if type?if_exists == 'checkbox'>
					<#if dictionaryItem??>
						<#list dictionaryItem as item>
								<span style="display:inline-block;margin-right:2px;"><input type='checkbox' <#if id??>id="${id!}"</#if> <#if style??>style="${style!}"</#if> <#if name??>name="${name!}"</#if> value="${item.code!}" <#if disabled>disabled="disabled"</#if>  <#if tabIndex gt -1>tabIndex="${tabIndex!}"</#if> <#if value?if_exists?seq_contains(item.code)>checked="checked"</#if> />${item.name!}</span>
						</#list>
					</#if>
					<#list dataMap?keys as key>
							<span style="display:inline-block;margin-right:2px;"><input type='checkbox' <#if id??>id="${id!}"</#if> <#if style??>style="${style!}"</#if> <#if name??>name="${name!}"</#if> value="${key!}" <#if disabled>disabled="disabled"</#if>  <#if tabIndex gt -1>tabIndex="${tabIndex!}"</#if> <#if value?if_exists?seq_contains(key)>checked="checked"</#if> />${dataMap[key]}</span>
					</#list>
				<#elseif type?if_exists == 'radio'>
					<#if dictionaryItem??>
						<#list dictionaryItem as item>
							<input type='radio' <#if id??>id="${id!}"</#if> <#if name??>name="${name!}"</#if> value="${item.code!}" <#if disabled>disabled="disabled"</#if>  <#if tabIndex gt -1>tabIndex="${tabIndex!}"</#if> <#if value?if_exists?seq_contains(item.code)>checked="checked"</#if> >${item.name!}</input>
						</#list>
					</#if>
					<#list dataMap?keys as key>
							<input type='radio' <#if id??>id="${id!}"</#if> <#if name??>name="${name!}"</#if> value="${key!}" <#if disabled>disabled="disabled"</#if>  <#if tabIndex gt -1>tabIndex="${tabIndex!}"</#if> <#if value?if_exists?seq_contains(key)>checked="checked"</#if> >${dataMap[key]}</input>
					</#list>
				<#else>
					<select <#if required>class="required"</#if> <#if id??>id="${id!}"</#if> <#if name??>name="${name!}"</#if> <#if disabled>disabled="disabled"</#if> <#if onChange??>onChange="${onChange!}"</#if> <#if css??>class="${css!}"</#if> <#if style??>style="${style!}"<#else>style="width:180px;"</#if> <#if tabIndex gt -1>tabIndex="${tabIndex!}"</#if> >
						<#assign flagExistHeaderValue = false>
						<#list dataMap?keys as key>
							<#if headerValue?? && (headerValue == key)>
								<#assign flagExistHeaderValue = true>
							</#if>
						</#list>
						<#if dictionaryItem??>
							<#list dictionaryItem as item>
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
						<#if value??>
								<#list dataMap?keys as key>
									<#if value?? && (key == value)>
											<option selected="selected" value="${key!}">${dataMap[key]}</option>
										<#else>
											<option value="${key!}">${dataMap[key]}</option>
									</#if>
								</#list>
								<#if dictionaryItem??>
									<#list dictionaryItem as item>
											<#if value?? && (item.code == value)>
													<option selected="selected" value="${item.code!}">${item.name!}</option>
												<#else>
													<option value="${item.code!}">${item.name!}</option>
											</#if>
									</#list>
								</#if>
							<#else>
								<#list dataMap?keys as key>
											<#if flagExistHeaderValue && (headerValue == key)>
													<option value="${key!}" selected="selected">${dataMap[key]}</option>
												<#else>
													<option value="${key!}">${dataMap[key]}</option>
											</#if>
								</#list>
								<#if dictionaryItem??>
									<#list dictionaryItem as item>
											<#if flagExistHeaderValue && (headerValue == item.code)>
													<option selected="selected" value="${item.code!}">${item.name!}</option>
												<#else>
													<option value="${item.code!}">${item.name!}</option>
											</#if>
									</#list>
								</#if>
						</#if>
					</select>
			</#if>
		
	<#else>
		<input <#if id??>id="${id!}"</#if> <#if name??>name="${name!}"</#if> <#if required>class="required"</#if> <#if style??> style="background-color:#fff;${style!}"<#else> style="background-color:#fff;width:154px;"</#if> <#if tabIndex gt -1>tabIndex="${tabIndex!}"</#if> />
</#if>
</htmlTag>
<onload>
<#if flagInput>
$("input[name='${name!}']").repscombobox("${selectOptions!}");
</#if>
</onload>