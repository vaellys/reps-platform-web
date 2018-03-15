<htmlTag>
<span style="display:inline-block;">
<input class="txtInput date <#if required>required</#if>" <#if id??>id="${id?if_exists}"</#if> <#if name??>name="${name?if_exists}"</#if> <#if format??>dateFmt="${format?if_exists}"</#if> <#if min??>minDate="${min?if_exists}"</#if> <#if max??>maxDate="${max?if_exists}"</#if> <#if style??>style="${style?if_exists}"<#else>style="width:159px;"</#if> <#if disabled>disabled="disabled"</#if> <#if readonly>readonly="readonly"</#if> <#if value??>value="${value?if_exists}"</#if> <#if varStr??>value="${varStr?if_exists}"</#if> <#if tabIndex gt -1>tabIndex="${tabIndex!}"</#if> />
<a class="inputDateButton" href="javascript:;">选择</a>
</span>
</htmlTag>
<onload>
$("input.date").datepicker();
</onload>