<htmlTag>
<div class="tabs" currentIndex="0" eventType="click" style="${style!}">
<div class="tabsHeader">
	<div class="tabsHeaderContent">
		<ul>
			<#assign index = 0 />
			<#list tabItems?if_exists as tabItem>
				<#if tabItem.url??>
						<#if tabItem.iframeId??>
								<li><a href="${tabItem.url!}" iframeId="${tabItem.iframeId!}" class="j-iframe-ajax"><span>${tabItem.value!}</span></a></li>
							<#else>
								<li><a href="${tabItem.url!}" class="j-iframe-ajax"><span>${tabItem.value!}</span></a></li>
						</#if>
					<#else>
						<li><a href="javascript:;"><span>${tabItem.value!}</span></a></li>
				</#if>
				<#assign index = index + 1 />
			</#list>
		</ul>
	</div>
</div>
<div class="tabsContent">
	<#assign tabItemsSize = tabItems?if_exists?size-1 />
	<#list 0..tabItemsSize as i>
		<#assign flagContain = false />
		<#list containBodys as containBody>
			<#if containBody == i>
				<#assign flagContain = true />
			</#if>
		</#list>
		<#if flagContain>
				<div>${tabItems[i].innerHtml!}</div>
			<#else>
				<div></div>
		</#if>
	</#list>
</div>
<div class="tabsFooter">
	<div class="tabsFooterContent">
	</div>
</div>
</div>
</htmlTag>
<onload>
$("div.tabs", $p).each(function(){var $this = $(this);var options = {};
options.currentIndex = $this.attr("currentIndex") || 0;
options.style = $this.attr("style");
options.eventType = $this.attr("eventType") || "click";$this.tabs(options);});
</onload>