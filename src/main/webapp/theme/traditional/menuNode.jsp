<c:choose>
	<c:when test="${fn:indexOf(menu.action, ':') == -1 ? false : (fn:substring(menu.action, 0, fn:indexOf(menu.action, ':')) eq 'http' or fn:substring(menu.action, 0, fn:indexOf(menu.action, ':')) eq 'https')}">
		<li><a href="${menu.action}" target="${menu.newpage ? '_blank' : 'navTab'}" rel="${parentCatalog.code}" leafCode="${menu.code}" external="true" title="${menu.name}">${menu.name}</a></li>
	</c:when>
	<c:otherwise>
		<c:choose>
			<c:when test="${menu.category eq menuNodeCategorySystem}">
				<c:set value="${fn:indexOf(menu.action, ';') == -1 ? menu.action : fn:substring(menu.action, 0, fn:indexOf(menu.action, ';'))}" var="action" />
				<li><a href="${empty menu.baseUrl ? path : menu.baseUrl}${action}" target="${menu.newpage ? '_blank' : 'navTab'}" rel="${parentCatalog.code}" leafCode="${menu.code}" external="true" title="${menu.name}">${menu.name}</a></li>
			</c:when>
			<c:otherwise>
				<li><a href="${rootCatalog.action}${fn:endsWith(fn:substring(rootCatalog.action, fn:length(rootCatalog.action) - 1, fn:length(rootCatalog.action)), '/') and fn:startsWith(menu.action, '/') ? fn:substringAfter(menu.action, '/') : menu.action}" target="${menu.newpage ? '_blank' : 'navTab'}" rel="${parentCatalog.code}" leafCode="${menu.code}" external="true" title="${menu.name}">${menu.name}</a></li>
			</c:otherwise>
		</c:choose>
	</c:otherwise>
</c:choose>
