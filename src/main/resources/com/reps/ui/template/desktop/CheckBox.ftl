<htmlTag>
<input type="checkbox" class="txtInput <#if required??>required"<#else>"</#if> <#if id??>id="${id!}"</#if> <#if name??>name="${name!}"</#if> <#if style??>style="${style!}"</#if> <#if alt??>alt="${alt!}"</#if> value="${value!}" /><label for="${id!}">${label!}</label>
</htmlTag>