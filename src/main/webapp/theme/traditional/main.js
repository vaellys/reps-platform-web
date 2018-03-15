var main = {
	indexContainer:null,
	leftMenu:null,
	init:function(){
		
		//整体layout
		main.relayout();
		
		//窗口改变大小
		main.resize();
		
		//左边导航第一个展开
		main.navigateFirstClick();
		
		//左边导航中的树初始化化
		main.treeInit();
		
		//tab切换
		main.navTab();
		
		//主页布局排序
		main.makeIndexSort();
		
		//初始化主页
		main.initMainPage();
		
		//绑定事件
		main.bindEvent();
	},
	bindEvent:function(){
		//向左隐藏菜单效果
		$('#toggle-west').click(function () {
			$('.west').animate({width: 'toggle'}, {duration: 500, complete: main.relayout, step: main.relayout});
		});
		
		//向上隐藏导航效果
		$('#toggle-north').click(function () {
			var indexHeader=$(".header");
			if(indexHeader.is(":visible")){
				indexHeader.hide();
				$('.north').animate({height: '30'}, {duration: 0, complete: main.relayout, step: main.relayout});
		
			}else{
				indexHeader.show();
				$('.north').animate({height: '100'}, {duration: 0, complete: main.relayout, step: main.relayout});
			}
		
		});
		
		//初始化tab切换
		$("div.tabs").each(function() {
			var $this = $(this);
			var options = {};
			options.currentIndex = $this.attr("currentIndex") || 0;
			options.eventType = $this.attr("eventType") || "click";
			$this.tabs(options);
		});
		
		//tab切换
		$("a[target=navTab]").each(function () {
			$(this).click(function (event) {
				var $this = $(this);
				var title = $this.attr("title") || $this.text();
				var tabid = $this.attr("rel") || "_blank";
				var fresh = eval($this.attr("fresh") || "true");
				var external = eval($this.attr("external") || "false");
				var url = unescape($this.attr("href")).replaceTmById($(event.target).parents(".unitBox:first"));
				if (!url.isFinishedTm()) {
					//alertMsg.error($this.attr("warn") || DWZ.msg("alertSelectMsg"));
					return false;
				}
				navTab.openTab(tabid, url, {
					title : title,
					fresh : fresh,
					external : external 
				});
				event.preventDefault();
			});
		});
		
		//弹出框
		$("a[target=dialog]").each(function () {
			$(this).click(function (event) {
				var $this = $(this);
				var title = $this.attr("title") || $this.text();
				var rel = $this.attr("rel") || "_blank";
				var options = {};
				var w = $this.attr("width");
				var h = $this.attr("height");
				if (w)
					options.width = w;
				if (h)
					options.height = h;
				options.max = eval($this.attr("max") || "false");
				options.mask = eval($this.attr("mask") || "true");
				options.maxable = eval($this.attr("maxable") || "false");
				options.minable = eval($this.attr("minable") || "false");
				options.fresh = eval($this.attr("fresh") || "true");
				options.resizable = eval($this.attr("resizable") || "false");
				options.drawable = eval($this.attr("drawable") || "true");
				options.close = eval($this.attr("close") || "");
				options.param = $this.attr("param") || "";
				var url = unescape($this.attr("href")).replaceTmById($(event.target).parents(".unitBox:first"));
				if (!url.isFinishedTm()) {
					//alertMsg.error($this.attr("warn") || DWZ.msg("alertSelectMsg"));
					return false;
				}
				$.pdialog.open(url, rel, title, options);
				return false;
			});
		});
	},
	relayout:function(){
		main.indexContainer = $('.layout');
		main.leftMenu = $("#accContent");
		main.indexContainer.layout({resize: false});
		main.leftMenu.height(main.leftMenu.parent().height()-30);
		$(".accordion").each(function(){
			if($(this).is(":visible")){
				$(this).accordion({fillSpace:true,alwaysOpen:true,active:0});
			}
		});
	},
	makeIndexSort:function(){
		makeSort('${layout}');
	},
	resize:function(){
		$(window).resize(main.relayout);
	},
	navigateFirstClick:function(){
		$(".navigate li:first").click();
	},
	treeInit:function(){
		$("ul.tree", main.leftMenu).jTree();
	},
	navTab:function(){
		navTab.init();
	},
	initMainPage:function(){
		var listModule = [];
		$("div[id^='module_']").each(function(key,value){
			var objModule = {}
			var id = $(value).attr("id");
			if(id.length > 8){
				return true;
			}
			var index = key;
			var subNum = $(value).find("div[id^='groupItem']").size();
			objModule["id"] = id ;
			objModule["index"] = index ;
			objModule["subNum"] = subNum ;
			listModule.push(objModule);
		});
		
		listModule.sort(function(a,b){
			return a.subNum - b.subNum;
		});
		
		var minModule = listModule[0];
		var maxModule = listModule[2];
		
		if(maxModule.subNum > minModule.subNum){
			var dif1 = maxModule.subNum - minModule.subNum;
			var dif2 = maxModule.subNum - listModule[1].subNum;
			
			var moduleId1 = minModule.id;
			if(dif2 > 0 && listModule[1].subNum > 0){
				var moduleId2 = listModule[1].id;
				var $extendGroupItem2 = $("#"+moduleId2).find("div[id^='groupItem']").eq(listModule[1].subNum - 1);
				var height = (180+(8+207)*dif2);
				$extendGroupItem2.children(".itemContent").children("div").eq(1).css("height",height + "px").css("overflow","auto");
				var $childrenGroupItem2 = $extendGroupItem2.children(".itemContent").children("div").eq(1).children();
				if($childrenGroupItem2.hasClass("controllMainStyle")){
					$childrenGroupItem2.removeClass("controllMainStyle").addClass("extendControllMainStyle");
				}else if($childrenGroupItem2.hasClass("shortcutItem")){
					$childrenGroupItem2.removeClass("shortcutItem").addClass("extendShortcutItem");
				}else if($childrenGroupItem2.hasClass("extendNews")){
					$childrenGroupItem2.css("height",height + "px");
					$childrenGroupItem2.children().css("height",height + "px");
				}
			}
			
			if(minModule.subNum > 0){
				var $extendGroupItem1 = $("#"+moduleId1).find("div[id^='groupItem']").eq(minModule.subNum - 1);
				var height = (180+(8+207)*dif1);
				$extendGroupItem1.children(".itemContent").children("div").eq(1).css("height",height + "px").css("overflow","auto");
				var $childrenGroupItem1 = $extendGroupItem1.children(".itemContent").children("div").eq(1).children();
				if($childrenGroupItem1.hasClass("controllMainStyle")){
					$childrenGroupItem1.removeClass("controllMainStyle").addClass("extendControllMainStyle");
				}else if($childrenGroupItem1.hasClass("shortcutItem")){
					$childrenGroupItem1.removeClass("shortcutItem").addClass("extendShortcutItem");
				}else if($childrenGroupItem1.hasClass("extendNews")){
					$childrenGroupItem1.css("height",height + "px");
					$childrenGroupItem1.children().css("height",height + "px");
				}
			}
		}
	},
	getMessage:function(){
		//读取消息
		$.ajax({
		  url: "message.mvc",
		  type: "POST",
		  dataType: "json",
		  success: function(data){
			 if(data.success)
			 {
			 	for(var i=0;i<data.messages.length;i++)
			 	{
			 		DCS.util.showTip("", "系统消息", data.messages[i].content, false);
			 	}
			 }
		  }
		});
	},
	showMenu:function(obj, code, name ,hideMenu){
		$(".accordion").hide();
		$("#menu" + code).show();
		$(".-header-menu-name").html(name);
		$(".navigate li:not('.more')").each(function(){
				$(this).removeClass("current");
		});
		if(hideMenu){
			//if the menu is show , select it not append to first position
			var menuId = $(obj).attr("id");
			var existMenu = $(".navigate li[id="+menuId+"]");
			if(existMenu.size() > 0){
				existMenu.click();
			}else{
				var appendLi = "<li id=\""+menuId+"\" class=\""+$(obj).attr("class")+"\" onclick=\"main.showMenu(this, '"+code+"', '"+name+"')\"><span></span><a href=\"javascript:void(0);\">"+name+"</a></li>";
				$(".navigate li").eq(6).remove();
				$(".navigate").prepend(appendLi);
				$("#"+menuId+"").addClass("current");
			}
		}else{
			$(obj).addClass("current");
		}
		
		$("#menu" + code).accordion({fillSpace:true,alwaysOpen:true,active:0});
	}
	
}

$(function(){
	main.init();
	
	/* 先注释，以后可能用的着-------------------------------------------------------------*/
	//getMessage();	
	//setInterval("getMessage();", 5 * 60 * 1000);
});