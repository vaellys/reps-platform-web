<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<div id="groupItem${empty item.depend ? item.code : item.depend}" class="groupItem">
    <div class="itemContent">
      <div style="-moz-user-select: none;" class="itemHeader ${item.icon}">&nbsp;&nbsp;${item.name}
      	<c:if test="${not empty item.more}">
      	<a href="${item.more}" target="navTab-new" rel="${item.depend}" external="true" title="${item.name}" class="closeEl">更多</a>
      	</c:if>
      </div>
      <c:choose>
		<c:when test="${fn:startsWith(item.value, '/') eq false}">
			<c:set value="${item.value}" var="contentUrl"></c:set>
		</c:when>
		<c:otherwise>
			<c:set value="${path}${fn:indexOf(item.value, ';') == -1 ? item.value : fn:substring(item.value, 0, fn:indexOf(item.value, ';'))}" var="contentUrl"></c:set>
		</c:otherwise>
	  </c:choose>
      <c:choose>
      	<c:when test="${item.iframe}">
      		<div style="width: 100%;height:180px"><iframe id="iframe${empty item.depend ? item.code : item.depend}" src="${contentUrl}" style="width:100%;height:180px;border:0px;" ></iframe></div>
      	</c:when>
      	<c:otherwise>
      		<div id="content${empty item.depend ? item.code : item.depend}" class="repsMainContent"></div>
      		<script type="text/javascript">
      		$.ajax({
  				type:"get",
  				url:"${contentUrl}",
  				async:false,
  				success : function(data){
  					$("#content${empty item.depend ? item.code : item.depend}").append(data);
  					reSetNavTab();
  				}
  			});
      		</script>
      	</c:otherwise>
      </c:choose>
    </div>
  </div>