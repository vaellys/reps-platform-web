<#macro getChildren tn>
	<li>${tn.html}
			<#if tn.nodes??>
					<ul>
						<#list tn.nodes as tn1>
							<@getChildren tn1 />
						</#list>
					</ul>	
			</#if>
	 </li>
</#macro>
<htmlTag>
<ul id="${id!}" class="tree <#if checkbox>treeCheck</#if> <#if expand>expand<#else>collapse</#if> <#if cssClass??>${cssClass}</#if>">
<#list rootNodes as tn >
	<@getChildren tn />
</#list>
</ul>
</htmlTag>
<onload>
<#if id??>
$("#${id}").jTree({cascade:${checkCascade?string('true','false')}});
<#else>
$("ul.tree").jTree({cascade:${checkCascade?string('true','false')}});
</#if>
</onload>
