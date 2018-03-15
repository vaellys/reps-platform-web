<htmlTag>
<div class="pagination">
	    <div class="pagination-pages">
	      <span>显示</span>
	      <select class="combox" name="numPerPage" onchange="navTabPageBreak({numPerPage:this.value})">
	          <option value="20">20</option>
	          <option value="30">30</option>
	          <option value="50">50</option>
	          <option value="100">100</option>
	      </select>
	      <span>条，共${totalRecord!}条</span>
	    </div>
	    <div class="pagination-nav" targetType="navTab" totalCount="${totalRecord!}" numPerPage="${pageSize!}" pageNumShown="${pageNumShown!}" currentPage="${currentPage!}">
	   </div>
</div>
<#if form??>
<form id="form_${id!}"></form>
</#if>
</htmlTag>
<onload>
$(".pagination-nav", $p).each(function(){var $this = $(this);$this.pagination({targetType:$this.attr("targetType"),rel:$this.attr("rel"),totalCount:$this.attr("totalCount"),form:$this.attr("form"),numPerPage:$this.attr("numPerPage"),pageNumShown:$this.attr("pageNumShown"),currentPage:$this.attr("currentPage")});});
</onload>