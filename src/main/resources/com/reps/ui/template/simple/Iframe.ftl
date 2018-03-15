<htmlTag>
<iframe <#if id??>id="${id!}"</#if> <#if name??>name="${name!}"</#if> <#if src??>src="${src!}"</#if> <#if fit>class="reps-fit"</#if> <#if style??>style="${style!}"</#if> frameborder="no" border="0" marginwidth="0" marginheight="0" ></iframe>
</htmlTag>
<onload>
<#if fit>
$(".reps-fit").each(function(){var $this = $(this);$this.height($this.parent().parent().height()); $this.width($this.parent().width());});
</#if>
</onload>