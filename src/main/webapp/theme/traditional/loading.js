var loading = (function(window,document,undefined){
	return {
		init:function(){
			var pageHeight = document.documentElement.clientHeight,
			pageWidth = document.documentElement.clientWidth;
			var loadingTop = pageHeight > 61 ? (pageHeight - 61) / 2 : 0,
			loadingLeft = pageWidth > 215 ? (pageWidth - 215) / 2 : 0;
			var loadingHtml = '<div id="loadingDiv" style="position:absolute;left:0;width:100%;height:' + pageHeight + 'px;top:0;background:#f3f8ff;opacity:1;filter:alpha(opacity=80);z-index:10000;"><div style="position: absolute; cursor1: wait; left: ' + loadingLeft + 'px; top:' + loadingTop + 'px; width: auto; height: 57px; line-height: 57px; padding-left: 50px; padding-right: 5px; background: #fff url(theme/traditional/images/loading-big.gif) no-repeat scroll 5px 10px; border: 2px solid #95B8E7; color: #696969; font-family:\'Microsoft YaHei\';">页面加载中，请等待...</div></div>';
			document.write(loadingHtml);
			document.onreadystatechange = completeLoading;
			function completeLoading() {
			  if (document.readyState == "complete"){
			      var loadingMask = document.getElementById('loadingDiv');
			      loadingMask.parentNode.removeChild(loadingMask);
			  }
			}
			
		}
		
	}
	
})(window,document);

loading.init();