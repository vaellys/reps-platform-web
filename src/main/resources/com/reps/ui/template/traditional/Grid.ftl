<htmlTag>
<div id="${id!}">
<#if flagSeq>
		<#if showSeq>
			<table class="reps-grid" data-options='{<#if pagination??>"pageSize":${pagination.pageSize?c},"curPageNumber":${pagination.curPageNumber?c},</#if>"flagSeq":true,<#if !flagOverText>"flagOverText":false,<#else>"flagOverText":true,</#if>"showSeq":true,"flagAlign":"${flagAlign!}"}' width="<#if width == 0>100%<#else>${width?c}</#if>">
		<#else>
			<table class="reps-grid" data-options='{<#if pagination??>"pageSize":${pagination.pageSize?c},"curPageNumber":${pagination.curPageNumber?c},</#if>"flagSeq":true,<#if !flagOverText>"flagOverText":false,<#else>"flagOverText":true,</#if>"showSeq":false,"flagAlign":"${flagAlign!}"}' width="<#if width == 0>100%<#else>${width?c}</#if>">
		</#if>
	<#else>
		<table class="reps-grid" data-options='{<#if !flagOverText>"flagOverText":false<#else>"flagOverText":true</#if>}' width="<#if width == 0>100%<#else>${width?c}</#if>">
</#if>
<thead><tr>
<#list fields?if_exists as field>
	<#if field.width gt 0>
			<#if field.flagCheckbox??>
					<#if 'checkbox' == field.flagCheckbox?if_exists>
							<#if field.checkboxTitle??>
									<#if field.checkboxDisabled>
											<th width="${field.width!}" flagCheckbox="${field.flagCheckbox!}"><input type="${field.flagCheckbox!}" title="${field.checkboxTitle!}" disabled="disabled" name="seqCheck" />${field.title!}</th>
										<#else>
											<th width="${field.width!}" flagCheckbox="${field.flagCheckbox!}"><input type="${field.flagCheckbox!}" title="${field.checkboxTitle!}" name="seqCheck" />${field.title!}</th>
									</#if>
								<#else>
									<#if field.checkboxDisabled>
											<th width="${field.width!}" flagCheckbox="${field.flagCheckbox!}"><input type="${field.flagCheckbox!}" disabled="disabled" name="seqCheck" />${field.title!}</th>
										<#else>
											<th width="${field.width!}" flagCheckbox="${field.flagCheckbox!}"><input type="${field.flagCheckbox!}" name="seqCheck" />${field.title!}</th>
									</#if>
							</#if>
						<#else>
							<th width="${field.width!}" flagCheckbox="${field.flagCheckbox!}">${field.title}</th>
					</#if>
				<#else>
					<th width="${field.width!}">${field.title}</th>
			</#if>
		<#else>
			<#if field.flagCheckbox??>
					<#if field.checkboxTitle??>
								<#if field.checkboxDisabled>
										<th flagCheckbox="${field.flagCheckbox!}"><input type="${field.flagCheckbox!}" title="${field.checkboxTitle!}" disabled="disabled" name="seqCheck" />${field.title!}</th>
									<#else>
										<th flagCheckbox="${field.flagCheckbox!}"><input type="${field.flagCheckbox!}" title="${field.checkboxTitle!}" name="seqCheck" />${field.title!}</th>
								</#if>
							<#else>
								<#if field.checkboxDisabled>
										<th flagCheckbox="${field.flagCheckbox!}"><input type="${field.flagCheckbox!}" disabled="disabled" name="seqCheck" />${field.title!}</th>
									<#else>
										<th flagCheckbox="${field.flagCheckbox!}"><input type="${field.flagCheckbox!}" name="seqCheck" />${field.title!}</th>
								</#if>
					</#if>
				<#else>
					<th onclick="gridSortSubmit('name','${form!}')">${field.title!}</th>
			</#if>
	</#if>
</#list>
</tr></thead>
	<tbody>
		<#if onlyHeader>
				<tr><td colspan="${fields?size!}" style="color:red;text-align:center">无记录</td></tr>
			<#else>
				${bodyContent?if_exists}
		</#if>
	</tbody>
   </table>
</div>
<#if pagination??>
	<div class="pagination">	
		<#if !flagShowPages>
				<div class="pagination-pages" style="display:none;">
			<#else>
				<div class="pagination-pages">
		</#if>
		<span>显示</span>
		<select class="combox" name="pageSizeSelect" onchange="paginationNavBreak('${form!}',{numPerPage:this.value,flagPerNum:true})">
			<option <#if pagination.pageSize == 20>selected="selected"<#else></#if> value="20">20</option>
			<option <#if pagination.pageSize == 30>selected="selected"<#else></#if> value="30">30</option>
			<option <#if pagination.pageSize == 50>selected="selected"<#else></#if> value="50">50</option>
			<option <#if pagination.pageSize == 100>selected="selected"<#else></#if> value="100">100</option>
		</select>
		<span>条，共${pagination.totalRecord?c}条</span>
	</div>
	<div class="pagination-nav" form="${form!}" totalCount="${pagination.totalRecord?c}" currentPage="${pagination.curPageNumber?c}" numPerPage="${pagination.pageSize!}" pageNumShown="${pageNumShow!}">
   </div>
  </div>
</#if>
</htmlTag>
<onload>
$("table.reps-grid", $p).jTable();
$("div.gridScroller").gridH(false,<#if flagNoHeight>true<#else>false</#if>);
$(".pagination-nav", $p).each(function(){var $this = $(this);$this.pagination({targetType:$this.attr("targetType"),rel:$this.attr("rel"),totalCount:$this.attr("totalCount"),form:$this.attr("form"),numPerPage:$this.attr("numPerPage"),pageNumShown:$this.attr("pageNumShown"),currentPage:$this.attr("currentPage")});});
</onload>