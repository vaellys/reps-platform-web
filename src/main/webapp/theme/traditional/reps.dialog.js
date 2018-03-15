/**
 * @author Roger Wu
 * reference:*.drag.js, *.dialogDrag.js, *.resize.js, *.taskBar.js
 */
(function($){
	$.pdialog = {
		_op:{height:380, width:700, minH:40, minW:50, total:20, max:false, mask:false, resizable:false, drawable:true, maxable:false,minable:false,fresh:true,inIframe:false,okCall:"",cancelCall:"",beforeLoad:"",afterLoad:"",blockId:"",close:true,beforeCall:"function(){return true;}"},
		_current:null,
		_zIndex:42,
		getCurrent:function(){
			return this._current;
		},
		reload:function(url, options){
			var op = $.extend({data:{}, dialogId:"", callback:null}, options);
			var dialog = (op.dialogId && $("body").data(op.dialogId)) || this._current;
			if (dialog){
				var jDContent = dialog.find(".dialogContent");
				jDContent.ajaxUrl({
					type:"POST", url:url, data:op.data, callback:function(response){
						jDContent.find("[layoutH]").layoutH(jDContent);
						$(".pageContent", dialog).width($(dialog).width()-14);
						$(":button.close", dialog).click(function(){
							$.pdialog.close(dialog);
							return false;
						});
						if ($.isFunction(op.callback)) op.callback(response);
					}
				});
			}
		},
		//打开一个层
		open:function(url, dlgid, title, options) {
			var op = $.extend({},$.pdialog._op, options);
			var repsBeforeCall = "var repsBeforeCallBack =" + op.beforeCall;
			eval(repsBeforeCall);
			var flagBefore = repsBeforeCallBack();
			if(!flagBefore){
				return;
			}
			var dialog = $("body").data(dlgid);
			var dialogTemplate='<div id="dialog'+op.id+'" class="dialog" style="top:150px; left:300px;">';
			    dialogTemplate+='  <div class="dialogHeader" onselectstart="return false;" oncopy="return false;" onpaste="return false;" oncut="return false;">';
			    dialogTemplate+='     <div class="dialogHeader_r">';
			    dialogTemplate+='        <div class="dialogHeader_c">';
			    dialogTemplate+='            <a class="close" href="#close">close</a>';
			    dialogTemplate+='            <a class="maximize" href="#maximize">maximize</a>';
			    dialogTemplate+='            <a class="restore" href="#restore">restore</a>';
			    dialogTemplate+='            <h1>弹出窗口</h1>';
			    dialogTemplate+='        </div>';
			    dialogTemplate+='     </div>';
			    dialogTemplate+='  </div>';
			    dialogTemplate+='  <div class="dialogContent layoutBox unitBox"></div>';
			    dialogTemplate+='  <div class="dialogButtons"></div>';
			    dialogTemplate+='  <div class="dialogFooter"><div class="dialogFooter_r"><div class="dialogFooter_c"></div></div></div>';
			    dialogTemplate+='  <div class="resizable_h_l" tar="nw"></div>';
			    dialogTemplate+='  <div class="resizable_h_r" tar="ne"></div>';
			    dialogTemplate+='  <div class="resizable_h_c" tar="n"></div>';
			    dialogTemplate+='  <div class="resizable_c_l" tar="w" style="height:300px;"></div>';
			    dialogTemplate+='  <div class="resizable_c_r" tar="e" style="height:300px;"></div>';
			    dialogTemplate+='  <div class="resizable_f_l" tar="sw"></div>';
			    dialogTemplate+='  <div class="resizable_f_r" tar="se"></div>';
			    dialogTemplate+='  <div class="resizable_f_c" tar="s"></div>';
			    dialogTemplate+='</div>';
			//重复打开一个层
			if(dialog) {
				if(dialog.is(":hidden")) {
					dialog.show();
				}
			} else { 
				$("body").append(dialogTemplate);
				dialog = $(">.dialog:last-child", "body");
				dialog.data("id",dlgid);
				dialog.data("url",url);
				if(op.close) dialog.data("close",op.close);
				if(op.param) dialog.data("param",op.param);
				//不再支持ie6，所以这个针对于ie6的操作就不再做了
				//($.fn.bgiframe && dialog.bgiframe());
				
				dialog.find(".dialogHeader").find("h1").html(title);
				$(dialog).css("zIndex", ($.pdialog._zIndex+=2));
				$("div.shadow").css("zIndex", $.pdialog._zIndex - 3).show();
				
				//buttons controls
				//load data,2014-4-25修改，采用iframe方式加载
				var jDContent = $(".dialogContent",dialog);
				var jBContent = $(".dialogButtons",dialog);
				var jFRContent = $(".resizable_f_r",dialog);
				var appendIframeAndButtons = "<ul>";
				var buttonFlag = false;
				if(700 != op.width){
					jBContent.attr("style","width:"+(op.width-2)+"px;");
				}
				if("" != op.okCall){
					buttonFlag = true;
					appendIframeAndButtons += '<div class="small_btn_save"><input type="button" onClick="var okCallback='+op.okCall+';var reOkCallback = okCallback(); if(reOkCallback != false){ var dialog =$(&quot;#dialog'+op.id+'&quot;); $.pdialog.close(dialog);}" value="保存"></div>';
				}
				if("" != op.cancelCall){
					buttonFlag = true;
					appendIframeAndButtons += '<div class="small_btn_cancel"><input type="button" onClick="var cancelCallback='+op.cancelCall+';var reCancelCallback = cancelCallback();if(reCancelCallback != false){ var dialog =$(&quot;#dialog'+op.id+'&quot;); $.pdialog.close(dialog);}" value="取消" ></div>';
				}
				
				$.pdialog._init(dialog, op, buttonFlag);
				$(dialog).click(function(){
					$.pdialog.switchDialog(dialog);
				});
				
				if(op.resizable)
					dialog.jresize();
				if(op.drawable)
				 	dialog.dialogDrag();
				$("a.close", dialog).click(function(event){ 
					$.pdialog.close(dialog);
					return false;
				});
				if (op.maxable) {
					$("a.maximize", dialog).show().click(function(event){
						$.pdialog.switchDialog(dialog);
						$.pdialog.maxsize(dialog);
						dialog.jresize("destroy").dialogDrag("destroy");
						return false;
					});
				} else {
					$("a.maximize", dialog).hide();
				}
				$("a.restore", dialog).click(function(event){
					$.pdialog.restore(dialog);
					dialog.jresize().dialogDrag();
					return false;
				});
				if (op.minable) {
					$("a.minimize", dialog).show().click(function(event){
						$.pdialog.minimize(dialog);
						return false;
					});
				} else {
					$("a.minimize", dialog).hide();
				}
				$("div.dialogHeader a", dialog).mousedown(function(){
					return false;
				});
				$("div.dialogHeader", dialog).dblclick(function(){
					if($("a.restore",dialog).is(":hidden"))
						$("a.maximize",dialog).trigger("click");
					else
						$("a.restore",dialog).trigger("click");
				});
				if(op.max) {
//					$.pdialog.switchDialog(dialog);
					$.pdialog.maxsize(dialog);
					dialog.jresize("destroy").dialogDrag("destroy");
				}
				$("body").data(dlgid, dialog);
				$.pdialog._current = dialog;
				$.pdialog.attachShadow(dialog);
				
				//appendIframeAndButtons += '</ul></div>';
				var dialogContentHeight = op.height - (buttonFlag ? 40 : 0) - 28;
				var heightPercent = (new Number(dialogContentHeight/jDContent.height())).toFixed(3) * 100 +"%";
				//for blockId
				if("" != op.blockId){
					var divContent = "<div class='dialogPageContent' style='height:"+dialogContentHeight+"px;overflow:auto;'>";
					var content = op.blockContent.replaceAll("&qreps;","\"");
					divContent += content +"</div>";
					if(buttonFlag){
						jBContent.html(appendIframeAndButtons);
					}else{
						jBContent.attr("style","display:none;");
					}
					jFRContent.attr("style","bottom:-11px;");
					if("" != op.beforeLoad){
						$.pdialog.beforeLoad(op.beforeLoad);
					}
					jDContent.html(divContent);
					$("button.close").click(function(){
						$.pdialog.close(dialog);
						return false;
					 });
					if (op.mask) {
						$(dialog).css("zIndex", 1000);
						$("a.minimize",dialog).hide();
						$(dialog).data("mask", true);
						$("#dialogBackground").show();
					}
					
					if("" != op.afterLoad){
						$.pdialog.afterLoad(op.afterLoad);
					}
					return false;
				}
				
				if(op.inIframe){
					if("" != op.beforeLoad){
						$.pdialog.beforeLoad(op.beforeLoad);
					}
					//for iframe
					var iframe = "";
					/*if(buttonFlag){
						iframe += '<iframe id="'+op.id+'" name="'+op.id+'" src="'+url+'" style="width:100%;height:'+heightPercent+';" frameborder="no" border="0" scrolling="'+(op.scrolling?"auto":"no")+'" marginwidth="0" marginheight="0"></iframe>';
						iframe += appendIframeAndButtons;
					}*/
					iframe += '<iframe id="'+op.id+'" name="'+op.id+'" src="'+url+'" style="width:100%;height:'+dialogContentHeight+'px;" frameborder="no" border="0" scrolling="'+(op.scrolling?"auto":"no")+'" marginwidth="0" marginheight="0"></iframe>';
					
					jDContent.html(iframe);
					
					if(buttonFlag){
						jBContent.html(appendIframeAndButtons);
					}else{
						jBContent.attr("style","display:none;");
					}
					jFRContent.attr("style","bottom:-11px;");
					$("button.close").click(function(){
						$.pdialog.close(dialog);
						return false;
					 });
					
					if("" != op.afterLoad){
						$.pdialog.afterLoad(op.afterLoad);
					}
				}else{
					if("" != op.beforeLoad){
						$.pdialog.beforeLoad(op.beforeLoad);
					}
					//for url
					$.ajax({
						type:'GET',
						url:url,
						dataType:"html",
						cache: false,
						success:function(myresult){
							 if(buttonFlag){
								 myresult += appendIframeAndButtons;
							 }
							 jDContent.html(myresult);
							 $("button.close").click(function(){
									$.pdialog.close(dialog);
									return false;
								 });
							 if("" != op.afterLoad){
								 $.pdialog.afterLoad(op.afterLoad);
								}
						}
					});
			     }
				if (op.mask) {
					$(dialog).css("zIndex", 1000);
					$("a.minimize",dialog).hide();
					$(dialog).data("mask", true);
					$("#dialogBackground").show();
				}
				
		  }
		},
		/**
		 * 加载内容前和后的操作
		 * @param {Object} dialog
		 */
		beforeLoad : function(beforeLoad){
			var reCallBeforeLoadjs = " var reCallBeforeLoad = " + beforeLoad;
			eval(reCallBeforeLoadjs);
			setTimeout(function(){
				reCallBeforeLoad();
			},10);
		},
		afterLoad : function(afterLoad){
			var reCallAfterLoadjs = " var reCallAfterLoad = " + afterLoad;
			eval(reCallAfterLoadjs);
			setTimeout(function(){
				reCallAfterLoad();
			},10);
		},
		/**
		 * 切换当前层
		 * @param {Object} dialog
		 */
		switchDialog:function(dialog) {
			var index = $(dialog).css("zIndex");
			$.pdialog.attachShadow(dialog);
			if($.pdialog._current) {
				var cindex = $($.pdialog._current).css("zIndex");
				$($.pdialog._current).css("zIndex", index);
				$(dialog).css("zIndex", cindex);
				$("div.shadow").css("zIndex", cindex - 1);
				$.pdialog._current = dialog;
			}
			//$.taskBar.switchTask(dialog.data("id"));
		},
		/**
		 * 给当前层附上阴隐层
		 * @param {Object} dialog
		 */
		attachShadow:function(dialog) {
			var shadow = $("div.shadow");
			if(shadow.is(":hidden")) shadow.show();
			shadow.css({
				top: parseInt($(dialog)[0].style.top) - 2,
				left: parseInt($(dialog)[0].style.left) - 4,
				height: parseInt($(dialog).height()) + 8,
				width: parseInt($(dialog).width()) + 8,
				zIndex:parseInt($(dialog).css("zIndex")) - 1
			});
			$(".shadow_c", shadow).children().andSelf().each(function(){
				$(this).css("height", $(dialog).outerHeight() - 4);
			});
		},
		_init:function(dialog, options, buttonFlag) {
			var op = $.extend({}, this._op, options);
			var height = op.height>op.minH?op.height:op.minH;
			var width = op.width>op.minW?op.width:op.minW;
			if(isNaN(dialog.height()) || dialog.height() < height){
				$(dialog).height(height+"px");
				if(buttonFlag){
					$(".dialogContent",dialog).height(height - $(".dialogHeader", dialog).outerHeight() - $(".dialogButtons", dialog).outerHeight()); // the 6 is the class dialogContent padding to
				}else{
					$(".dialogContent",dialog).height(height - $(".dialogHeader", dialog).outerHeight()); 
				}
				
			}
			if(isNaN(dialog.css("width")) || dialog.width() < width) {
				$(dialog).width(width+"px");
			}
			
			var iTop = $(document).scrollTop()+($(window).height()-dialog.height())/2;
			dialog.css({
				left: ($(window).width()-dialog.width())/2,
				top: iTop > 0 ? iTop : 0
			});
		},
		/**
		 * 初始化半透明层
		 * @param {Object} resizable
		 * @param {Object} dialog
		 * @param {Object} target
		 */
		initResize:function(resizable, dialog,target) {
			$("body").css("cursor", target + "-resize");
			resizable.css({
				top: $(dialog).css("top"),
				left: $(dialog).css("left"),
				height:$(dialog).css("height"),
				width:$(dialog).css("width")
			});
			resizable.show();
		},
		/**
		 * 改变阴隐层
		 * @param {Object} target
		 * @param {Object} options
		 */
		repaint:function(target,options){
			var shadow = $("div.shadow");
			if(target != "w" && target != "e") {
				shadow.css("height", shadow.outerHeight() + options.tmove);
				$(".shadow_c", shadow).children().andSelf().each(function(){
					$(this).css("height", $(this).outerHeight() + options.tmove);
				});
			}
			if(target == "n" || target =="nw" || target == "ne") {
				shadow.css("top", options.otop - 2);
			}
			if(options.owidth && (target != "n" || target != "s")) {
				shadow.css("width", options.owidth + 8);
			}
			if(target.indexOf("w") >= 0) {
				shadow.css("left", options.oleft - 4);
			}
		},
		/**
		 * 改变左右拖动层的高度
		 * @param {Object} target
		 * @param {Object} tmove
		 * @param {Object} dialog
		 */
		resizeTool:function(target, tmove, dialog) {
			$("div[class^='resizable']", dialog).filter(function(){
				return $(this).attr("tar") == 'w' || $(this).attr("tar") == 'e';
			}).each(function(){
				$(this).css("height", $(this).outerHeight() + tmove);
			});
		},
		/**
		 * 改变原始层的大小
		 * @param {Object} obj
		 * @param {Object} dialog
		 * @param {Object} target
		 */
		resizeDialog:function(obj, dialog, target) {
			var oleft = parseInt(obj.style.left);
			var otop = parseInt(obj.style.top);
			var height = parseInt(obj.style.height);
			var width = parseInt(obj.style.width);
			if(target == "n" || target == "nw") {
				tmove = parseInt($(dialog).css("top")) - otop;
			} else {
				tmove = height - parseInt($(dialog).css("height"));
			}
			$(dialog).css({left:oleft,width:width,top:otop,height:height});
			$(".dialogContent", dialog).css("width", (width-12) + "px");
			$(".dialogContent", dialog).find(".dialogButtons").css("width", (width-12) + "px");
			$(".pageContent", dialog).css("width", (width-14) + "px");
			if (target != "w" && target != "e") {
				var content = $(".dialogContent", dialog);
				content.css({height:height - $(".dialogHeader", dialog).outerHeight() - $(".dialogFooter", dialog).outerHeight() - 6});
				content.find("[layoutH]").layoutH(content);
				$.pdialog.resizeTool(target, tmove, dialog);
			}
			$.pdialog.repaint(target, {oleft:oleft,otop: otop,tmove: tmove,owidth:width});
			
			$(window).trigger(REPS.eventType.resizeGrid);
		},
		close:function(dialog) {
			if(typeof dialog == 'string') dialog = $("body").data(dialog);
			var close = dialog.data("close");
			var go = true;
			if(close && $.isFunction(close)) {
				var param = dialog.data("param");
				if(param && param != ""){
					param = REPS.jsonEval(param);
					go = close(param);
				} else {
					go = close();
				}
				if(!go) return;
			}
			
			$(dialog).hide();
			$("div.shadow").hide();
			if($(dialog).data("mask")){
				$("#dialogBackground").hide();
			} else{
				//if ($(dialog).data("id")) $.taskBar.closeDialog($(dialog).data("id"));
			}
			$("body").removeData($(dialog).data("id"));
			$(dialog).trigger(REPS.eventType.pageClear).remove();
		},
		closeCurrent:function(){
			this.close($.pdialog._current);
		},
		checkTimeout:function(){
			var $conetnt = $(".dialogContent", $.pdialog._current);
			var json = REPS.jsonEval($conetnt.html());
			if (json && json.statusCode == REPS.statusCode.timeout) this.closeCurrent();
		},
		maxsize:function(dialog) {
			$(dialog).data("original",{
				top:$(dialog).css("top"),
				left:$(dialog).css("left"),
				width:$(dialog).css("width"),
				height:$(dialog).css("height")
			});
			$("a.maximize",dialog).hide();
			$("a.restore",dialog).show();
			var iContentW = $(window).width();
			var iContentH = $(window).height() - 34;
			$(dialog).css({top:"0px",left:"0px",width:iContentW+"px",height:iContentH+"px"});
			$.pdialog._resizeContent(dialog,iContentW,iContentH);
			$("iframe",dialog).attr("src",$("iframe",dialog).attr("src"));
		},
		restore:function(dialog) {
			var original = $(dialog).data("original");
			var dwidth = parseInt(original.width);
			var dheight = parseInt(original.height);
			$(dialog).css({
				top:original.top,
				left:original.left,
				width:dwidth,
				height:dheight
			});
			$.pdialog._resizeContent(dialog,dwidth,dheight);
			$("a.maximize",dialog).show();
			$("a.restore",dialog).hide();
			$.pdialog.attachShadow(dialog);
		},
		minimize:function(dialog){
			$(dialog).hide();
			$("div.shadow").hide();
		},
		_resizeContent:function(dialog,width,height) {
			var content = $(".dialogContent", dialog);
			content.css({width:(width-12) + "px",height:height - $(".dialogHeader", dialog).outerHeight() - $(".dialogFooter", dialog).outerHeight() - 6});
			content.find("[layoutH]").layoutH(content);
			$(".pageContent", dialog).css("width", (width-14) + "px");
			
			$(window).trigger(REPS.eventType.resizeGrid);
		},
		closeDialog:function(){
			$(".dialogHeader .close").click();
		}
	};
})(jQuery);
