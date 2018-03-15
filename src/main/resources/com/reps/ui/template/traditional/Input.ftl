<htmlTag>
<#if multiLine>
<textarea class="txtInput <#if dataType??>${dataType}</#if> <#if required>required</#if>" <#if type??>type="${type}"</#if> <#if id??>id="${id?if_exists}"</#if> <#if name??>name="${name?if_exists}"</#if> <#if placeholder??>placeholder="${placeholder!}"</#if> <#if disabled>disabled="disabled"</#if> <#if readonly>readonly="readonly"</#if> <#if alt??>alt="${alt}"</#if> <#if equalTo??>equalTo="${equalTo?if_exists}"</#if> <#if minLength?if_exists gt 0>minLength="${minLength?c}"</#if> <#if maxLength?if_exists gt 0>maxLength="${maxLength?c}"</#if> <#if onClick??>onClick="${onClick?if_exists}"</#if> <#if style?if_exists == "154px">style="width:74.9%;"<#else>style="${style?if_exists}"</#if> <#if tabIndex gt -1>tabIndex="${tabIndex!}"</#if> ><#if value??>${value?if_exists}</#if></textarea>
<#else>
<input class="txtInput <#if dataType??>${dataType}</#if> <#if required>required</#if>" <#if type??>type="${type}"</#if> <#if id??>id="${id?if_exists}"</#if> <#if name??>name="${name?if_exists}"</#if> <#if disabled>disabled="disabled"</#if> <#if placeholder??>placeholder="${placeholder!}"</#if> <#if readonly>readonly="readonly"</#if> <#if alt??>alt="${alt}"</#if> <#if equalTo??>equalTo="${equalTo?if_exists}"</#if> <#if minLength?if_exists gt 0>minLength="${minLength?c}"</#if> <#if maxLength?if_exists gt 0>maxLength="${maxLength?c}"</#if> <#if onClick??>onClick="${onClick?if_exists}"</#if> <#if style??>style="${style?if_exists}"</#if> <#if value??>value="${value?if_exists}"</#if> <#if tabIndex gt -1>tabIndex="${tabIndex!}"</#if> />
</#if>
</htmlTag>
<onload>
<#if ajaxUrl??>
$("#<#if formId??>${formId!}</#if>").validate({onfocusout:function(element) {$(element).valid()},rules:{${name?if_exists}:{remote:{type:"post",url:"${ajaxUrl?if_exists}",data:{${name?if_exists}:function(){return $("input[name=${name?if_exists}]").val();}},dataType:"html",dataFilter:function(data){var jsonData = $.parseJSON(data); var a = jsonData.statusCode; var b =REPS.statusCode.ok; if(a === b){return true;}else{return false;}}}}},messages:{${name?if_exists}:{remote:"${message?if_exists}"}}});
</#if>
</onload>
<dependency>
${contextPath!}/library/base/jquery.placeholder.js
</dependency>
