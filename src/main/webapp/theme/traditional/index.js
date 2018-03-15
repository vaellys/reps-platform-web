$(function(){
	
	$("ul.navigate li.more").on("click",function(){
		var left = $(this).offset().left;
		if($(".dropdown_menu").is(":hidden")){
			$(".dropdown_menu").css({left:(left-133)}).show();
		}else{	
			$(".dropdown_menu").hide();
		}
	});
	/*不同屏幕尺寸的不同展示  开始*/
	//宽度计算
	var menuWidth; //全局变量的定义
	function checkWidth(){
		menuWidth=0;//初始化
		$('ul.navigate').find('li:visible').each(function(){
			menuWidth += $(this).width();
		});
		//document.body.clientWidth	  window.screen.availWidth
		while(menuWidth + ($(".dropdown_menu").width() / 2) + $('.headerNavLeft').width() >= document.body.clientWidth ){
			if($('ul.navigate').find('li:visible').length == 1) return false; //为了满足 window.onresize
			var len=$('ul.navigate').find('li:visible').length -2 ;
			menuWidth = menuWidth - $('ul.navigate').find('li:visible').eq(len).width();
			$('ul.navigate').find('li:visible').eq(len).addClass('hide');
		}
	}	
	checkWidth();
	$(window).resize(function() {
		$('ul.navigate').find('li').removeClass('hide');
		checkWidth();		
	});	
	/*不同屏幕尺寸的不同展示    结束*/
	$(".dropdown_menu").mouseleave(function(){
		$(".dropdown_menu").hide();	
	});
	
	//more menu operation
	$("div.dropdown_menu ul.more li").on("click",function(){	
		var $this = $(this);
		//navigate
		var menuId = $this.attr("id");
		var classAttr = $this.attr("class");
		var menuCode = $this.attr("menucode");
		var menuName = $this.find("a").html();
		var existMenu = $("ul.navigate>li[id="+menuId+"]");	
		if(existMenu.size() > 0){	
			if(existMenu.hasClass('hide')){
				existMenu.clone(true).removeClass('hide').prependTo('ul.navigate');				
				$("ul.navigate>li[id="+menuId+"]").eq(1).remove();
				$("ul.navigate li:first-child").removeClass('current').click();				
			}else{
				existMenu.click();	
			}		
		}else{			
			var appendLi = "<li id=\""+menuId+"\" class=\""+classAttr+" current\" menuCode=\""+menuCode+"\"><span></span><a href=\"javascript:void(0);\">"+menuName+"</a></li>";			
			
			$("ul.navigate li.current").removeClass("current");			
			$("ul.navigate li:visible:eq(0)").before(appendLi);			
		}	
		checkWidth();	
	});
	var winHeight = $(window).height();
	var height = winHeight - 100 -1 - 2 -28;
	$("#userDesk").attr("style","height:"+height+"px;overflow:auto;");
	
	$("li[id^='cmsHeader']").hover(function(){
		var $this = $(this);
		var headerId = $this.attr("id");
		var id = headerId.substring(9);
		$("div[id^='cmsContent']").each(function(){
			var $this = $(this);
			$this.hide();
		});
		$("li[id^='cmsHeader']").each(function(){
			var $this = $(this);
			$this.css("background","#fff");
		});
		$this.css("background","#e9f0f2");
		$("#cmsContent"+id).css("display","inline-block");
	});
	
	$.setRegional("messager", {
		title:{error:"错误", info:"提示", warn:"警告", correct:"成功", confirm:"确认提示"},
		butMsg:{ok:"确定", yes:"是", no:"否", cancel:"取消"}
	});
	
	
	
});