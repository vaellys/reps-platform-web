<htmlTag>
<#if cssClass??>
	<a class="${cssClass!}" title="${title!}" target="dialog" <#if id??> id="${id!}"</#if> <#if style??> style="${style!}"</#if> <#if url??> href="${url?html}"</#if> <#if rel??> rel="${rel!}"</#if> data-options='{"id":"${id!}"<#if mask>,"mask":"true"</#if><#if width gt 0>,"width":"${width!}"</#if><#if height gt 0>,"height":"${height!}"</#if><#if iframe>,"inIframe":true</#if><#if blockId??>,"blockId":"${blockId!}"</#if><#if okCall??>,"okCall":"${okCall!}"</#if><#if cancelCall??>,"cancelCall":"${cancelCall!}"</#if><#if beforeCall??>,"beforeCall":"${beforeCall!}"</#if><#if beforeLoad??>,"beforeLoad":"${beforeLoad!}"</#if><#if afterLoad??>,"afterLoad":"${afterLoad!}"</#if><#if scrolling>,"scrolling":${scrolling?string}</#if><#if blockContent??>,"blockContent":"${blockContent!}"</#if>,"drawable":${drawable?string("true","false")}}' <#if value??>><span>${value!}</span></a><#else>></a></#if>
	<#else>
	<a title="${title!}" target="dialog" <#if id??> id="${id!}"</#if> <#if style??> style="${style!}"</#if> <#if url??> href="${url?html}"</#if> <#if rel??> rel="${rel!}"</#if> data-options='{"id":"${id!}"<#if mask>,"mask":"true"</#if><#if width gt 0>,"width":"${width!}"</#if><#if height gt 0>,"height":"${height!}"</#if><#if iframe>,"inIframe":true</#if><#if blockId??>,"blockId":"${blockId!}"</#if><#if okCall??>,"okCall":"${okCall!}"</#if><#if cancelCall??>,"cancelCall":"${cancelCall!}"</#if><#if beforeCall??>,"beforeCall":"${beforeCall!}"</#if><#if beforeLoad??>,"beforeLoad":"${beforeLoad!}"</#if><#if afterLoad??>,"afterLoad":"${afterLoad!}"</#if><#if scrolling>,"scrolling":${scrolling?string}</#if><#if blockContent??>,"blockContent":"${blockContent!}"</#if>,"drawable":${drawable?string("true","false")}}' <#if value??>><span>${value!}</span></a><#else>></a></#if>
</#if>
</htmlTag>
<onload>
<#if loadJs>
$('a[target=dialog]', $p).each(function(){$(this).off("click").click(function(event){var $this = $(this);
var title = $this.attr('title') || $this.text();var rel = $this.attr('rel') || '_blank';
var url = unescape($this.attr('href'));var options = $this.data('options');
if(typeof options == "string"){
	options = eval("("+options+")");
}
$.pdialog.open(url, rel, title, options);event.preventDefault();});});
</#if>
</onload>