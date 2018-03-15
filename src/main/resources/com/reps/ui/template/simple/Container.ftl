<htmlTag><div id="container" <#if layout>class="reps-layout"</#if> ></htmlTag>
<htmlTagEnd>
</div>
<div id="splitBar"></div>
<div id="splitBarProxy"></div>
<div class="resizable"></div>
<div class="shadow" style="width:508px; top:148px; left:296px;">  
	<div class="shadow_h">     
		<div class="shadow_h_r"></div>     
		<div class="shadow_h_c"></div>  
	</div>  
	<div class="shadow_c">    
		<div class="shadow_c_l" style="height:296px;"></div>    
		<div class="shadow_c_r" style="height:296px;"></div>    
		<div class="shadow_c_c" style="height:296px;"></div>  
	</div>  
	<div class="shadow_f">    
		<div class="shadow_f_l"></div>    
		<div class="shadow_f_r"></div>    
		<div class="shadow_f_c"></div>  
	</div>
</div>
<div id="alertBackground" class="alertBackground"></div>
<div id="dialogBackground" class="dialogBackground"></div>
<div id="background" class="background"></div>
<div id="progressBar" class="progressBar">数据加载中，请稍等...</div>
</htmlTagEnd>
<onload>
var ajaxbg = $("#background,#progressBar");ajaxbg.hide();
<#if ajaxProcess??>
	<#if ajaxProcess>
	$(document).ajaxStart(function(){ajaxbg.show();}).ajaxStop(function(){ajaxbg.hide();});
	</#if>
</#if>
var $p = $(document);
<#if layout>$(".reps-layout").layout();<#else>$("#container").width($(window).width()-2)</#if>
if($(".panel-query-buttons").length > 0 ){
	var panelBodyContentHeight = $(".panel-body-content").height();
	$(".panel-query-buttons").css({"height":panelBodyContentHeight+"px","line-height":panelBodyContentHeight+15+"px"});
}else{
	$(".panel-body-content").css("float","none");
}

</onload>