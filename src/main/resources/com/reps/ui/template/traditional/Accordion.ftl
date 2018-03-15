<htmlTag>
<div <#if id??>id="${id}"</#if> class="accordion" <#if style??>style="${style}"</#if>>
<#if items??>
	<#list items as item>
		${item}
	</#list>
</#if>
</div>
</htmlTag>
<onload>
$("#${id!}").accordion({fillSpace:true,alwaysOpen:true,active:0});
</onload>