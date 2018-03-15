<htmlTag><#if anchor??><a name="${anchor!}"></a></#if><div id="${id!}" class="panel" <#if style??>style="${style?if_exists}"</#if> data-options='{"dock":"${dock?if_exists}" ,"border":"<#if border>true<#else>false</#if>"<#if id??>,"id":"${id?if_exists}"</#if>}'>
<#if formId??><form id="${formId?if_exists}" method="${method?if_exists}" <#if action??>action="${action?if_exists}"</#if> <#if enctype??>enctype="${enctype?if_exists}"</#if> <#if onSubmit??>onSubmit="${onSubmit?if_exists}"</#if> <#if target??>target="${target?if_exists}"</#if>><input style="display:none;"/></#if>
<#if title??><div class="panel-header"><div class="panel-title">${title?if_exists}</div><#if TitleButtons??>${TitleButtons!}</#if></div></#if>
</htmlTag>
<htmlTagEnd>
<#if ToolButtons??>${ToolButtons!}</#if>
<#if FormContent?? || QueryButtons?? || FormButtons??>
	<div class="panel-body">
			<#if FormContent??>
				${FormContent!}
			</#if>
			<#if QueryButtons??>
				${QueryButtons!}
			</#if>
			<#if FormButtons??>
				${FormButtons!}
			</#if>
	</div>
</#if>
${innerHtml!}
<#if FootBarTag??>${FootBarTag!}</#if>
<#if formId??></form></#if></div>
</htmlTagEnd>
<onload>
<#if validForm?if_exists>$("#${formId?if_exists}").validate();</#if>
<#if formId??>
$(".formContent select").on("change",function(){
	$(".formContent input:visible").each(function(){
		var $searchA = $(".search-form-a");
		var $searchASmall = $(".small-search-form-a");
		if($searchA.size() == 0 && $searchASmall.size() == 0){
			return false;
		}
		var $this = $(this);
		$this[0].focus();
		return false;
	})
});
<#if flagEnter>
$(".formContent input").keydown(function(event){  
    if(event.keyCode==13){ 
       $(".search-form-a",document).click();  
       $(".small-search-form-a",document).click();
    }  
 });
 </#if>
</#if>
</onload>