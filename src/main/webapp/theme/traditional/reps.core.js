var REPS = {
	keyCode: {
		ENTER: 13, ESC: 27, END: 35, HOME: 36,
		SHIFT: 16, TAB: 9,
		LEFT: 37, RIGHT: 39, UP: 38, DOWN: 40,
		DELETE: 46, BACKSPACE:8
	},
	eventType: {
		pageClear:"pageClear",	// 用于重新ajaxLoad、关闭nabTab, 关闭dialog时，去除xheditor等需要特殊处理的资源
		resizeGrid:"resizeGrid"	// 用于窗口或dialog大小调整时表格的变化
	},
	isOverAxis: function(x, reference, size) {
		//Determines when x coordinate is over "b" element axis
		return (x > reference) && (x < (reference + size));
	},
	isOver: function(y, x, top, left, height, width) {
		//Determines when x, y coordinates is over "b" element
		return this.isOverAxis(y, top, height) && this.isOverAxis(x, left, width);
	},
	
	pageInfo: {pageNum:"pageNum", numPerPage:"numPerPage", orderField:"orderField", orderDirection:"orderDirection"},
	
	statusCode: {ok:200, fail:205, error:500, timeout:504},
	ui:{sbar:true},
	frag:{}, //page fragment
	_msg:{}, //alert message
	_set:{
		loginUrl:"", //session timeout
		loginTitle:"", //if loginTitle open a login dialog
		debug:false
	},
	msg:function(key, args){
		var _format = function(str,args) {
			args = args || [];
			var result = str || "";
			for (var i = 0; i < args.length; i++){
				result = result.replace(new RegExp("\\{" + i + "\\}", "g"), args[i]);
			}
			return result;
		}
		return _format(this._msg[key], args);
	},
	debug:function(msg){
		if (this._set.debug) {
			if (typeof(console) != "undefined") console.log(msg);
			else alert(msg);
		}
	},
	
	/*
	 * json to string use
	 */
	obj2str:function(o) {
		var r = [];
		if(typeof o =="string") return "\""+o.replace(/([\'\"\\])/g,"\\$1").replace(/(\n)/g,"\\n").replace(/(\r)/g,"\\r").replace(/(\t)/g,"\\t")+"\"";
		if(typeof o == "object"){
			if(!o.sort){
				for(var i in o)
					r.push(i+":"+REPS.obj2str(o[i]));
				if(!!document.all && !/^\n?function\s*toString\(\)\s*\{\n?\s*\[native code\]\n?\s*\}\n?\s*$/.test(o.toString)){
					r.push("toString:"+o.toString.toString());
				}
				r="{"+r.join()+"}"
			}else{
				for(var i =0;i<o.length;i++) {
					r.push(REPS.obj2str(o[i]));
				}
				r="["+r.join()+"]"
			}
			return r;
		}
		return o.toString();
	},
	/*
	 * use
	 */
	jsonEval:function(data) {
		try{
			if ($.type(data) == 'string')
				return eval('(' + data + ')');
			else return data;
		} catch (e){
			return {};
		}
	},
	
	/*
	 * use
	 */
	ajaxError:function(xhr, ajaxOptions, thrownError){
		/*if (messager) {
			messager.error("<div>Http status: " + xhr.status + " " + xhr.statusText + "</div>" 
				+ "<div>ajaxOptions: "+ajaxOptions + "</div>"
				+ "<div>thrownError: "+thrownError + "</div>"
				+ "<div>"+xhr.responseText+"</div>");
		} else {
			alert("Http status: " + xhr.status + " " + xhr.statusText + "\najaxOptions: " + ajaxOptions + "\nthrownError:"+thrownError + "\n" +xhr.responseText);
		}*/
		
		if(messager){
			messager.error($.regional.messager.ajaxError);
		}else{
			alert($.regional.messager.ajaxError);
		}
	},
	/*use**/
	ajaxDone:function(json){
		if(json.statusCode == REPS.statusCode.error) {
			if(json.message && messager) messager.error(json.message);
		} else if (json.statusCode == REPS.statusCode.timeout) {
			if(messager) {
				messager.error(json.message);
			}
		} else {
			if(json.message && messager) messager.correct(json.message);
		};
	},
	getProjectName:function(){
		 var pathName=window.document.location.pathname;
		 return pathName.substring(0,pathName.substr(1).indexOf('/')+1);
	},
	getRootPath:function(){
		var href = window.document.location.href;
		var pathName = window.document.location.pathname;
		var pathNameIndex = href.indexOf(pathName); 
		var localhostPath = href.substring(0,pathNameIndex);
		return (localhostPath + this.getProjectName());  
	},
	reloadDialogJs:function(){
		$('a[target=dialog]').each(function(){
			$(this).click(function(event){
			var $this = $(this);
			var title = $this.attr('title') || $this.text();
			var rel = $this.attr('rel') || '_blank';
			var url = unescape($this.attr('href'));var options = $this.data('options');
			$.pdialog.open(url, rel, title, options);
			return false;
		  });
		});
	},
	max : function(array){
		return Math.max.apply(null, array);
	},
	min : function(array){
		return Math.min.apply(null, array);
	},
	fileSizeValidate:function(){ 
		var filestr = document.all.UploadFile.value;
		console.log(filestr);
	 	var fso,f;
	 	fso=new ActiveXObject("Scripting.FileSystemObject");
	 	f = fso.GetFile(filestr);
    	 if(f.size > 1*1024){
    		 alert("The size of .dbf is more than 5M");
    		 return false;
    	 }
	 	return true;
	},
	jqueryCompatible:function(){
		jQuery.browser={};
		(function(){
			jQuery.browser.msie=false; 
			jQuery.browser.version=0;
			if(navigator.userAgent.match(/MSIE ([0-9]+)./)){ 
				jQuery.browser.msie=true;
				jQuery.browser.version=RegExp.$1;
			}
		})();
	}
};

REPS.jqueryCompatible();

/*ajax操作 use**/
function ajaxUrlCallback(url, confirmMsg,callback,redirect) {
	//$this.trigger(REPS.eventType.pageClear);
	var _submitFn = function(){
		$.ajax({
			type:'GET',
			url:url,
			dataType:"json",
			cache: false,
			success: callback || function(json){
				if(json.statusCode==REPS.statusCode.error){
					if(json.message&&messager)messager.error(json.message);
				}else if(json.statusCode==REPS.statusCode.timeout){
					if(json.message&&messager){
					messager.info(json.message);}
				}else if (json.statusCode==REPS.statusCode.fail){
					if(json.message&&messager){
						messager.info(json.message);}
				}else{
					if(json.message&&messager) 
						 messager.correct(json.message,{
							 okCall:function(){ 
								 if(redirect){ location.href=redirect; }
							  }
						 });
					};
			},
			error: REPS.ajaxError
		});
	}
	
	if (confirmMsg) {
		messager.confirm(confirmMsg, {okCall: _submitFn});
	} else {
		_submitFn();
	}
	
	return false;
}

function ajaxFormSubmit(formId,confirmMsg,callback,redirect) {
	//$this.trigger(REPS.eventType.pageClear);
	var $form = $("#"+formId);
	if (!$form.valid()) {
		return false;
	}
	
	var _submitFn = function(){
		$.ajax({
			type:'POST',
			url:$form.attr("action"),
			data:$form.serializeArray(),
			dataType:"json",
			cache: false,
			success: callback || function(json){
				if(json.statusCode==REPS.statusCode.error){
					if(json.message&&messager)messager.error(json.message);
				}else if(json.statusCode==REPS.statusCode.timeout){
					if(json.message&&messager){
					messager.info(json.message);}
				}else if (json.statusCode==REPS.statusCode.fail){
					if(json.message&&messager){
						messager.info(json.message);}
				}else{
					if(json.message&&messager){ 
						 messager.correct(json.message,{
							 okCall:function(){ 
								 if(redirect){ location.href=redirect; }
							  }
						 });
					}
				};
			},
			error: REPS.ajaxError
		});
	}
	
	if (confirmMsg) {
		messager.confirm(confirmMsg, {okCall: _submitFn});
	} else {
		_submitFn();
	}
	
	return false;
}

function ajaxGrid(gridId,formId,url,confirmMsg,callback) {
	var $form = $("#"+formId);
	if (!$form.valid()) {
		return false;
	}
	
	var _submitFn = function(){
		// before search , make the current page to 1;
		$("input[name=curPageNumber]").val(1); 
		$.ajax({
			type:'POST',
			url:$form.attr("action"),
			data:$form.serializeArray(),
			dataType:"html",
			cache: false,
			success: function(data){
				var newdata=$(data).find("#"+gridId+" tbody").html();
				var $paginationNav = $(data).find(".pagination-nav");
				var totalCount = parseInt($paginationNav.attr("totalCount"));
				$(".pagination-pages > span:eq(1)").html($.regional.pagination.allRecords+totalCount+$.regional.pagination.record);
                var $newTbody=$("<table>"+newdata+"</table>");
                var $tbody=$(".gridTbody tbody");
                var $thead=$(".gridThead thead");
                var $firstTh = $(".gridThead thead tr th:first");
                var $secondTh = $firstTh.next();
                if($secondTh.attr("flagCheckbox") == "checkbox"){
              	  var $checkbox = $secondTh.find("input[name=seqCheck]");
              	  if($checkbox.prop("checked")){
              		  $checkbox.prop("checked",false);
	              }
                }
                var flagSeq = false;
                if($firstTh.attr("flagseq") == "true"){
              	  flagSeq = true;
                }
                var h=0;
                var flagNoValue = false;
                var $newTrs =  $newTbody.find("tbody tr");
                $newTrs.each(function(i){
            		  var $this = $(this);
            		  if($this.find("td:first").html() == $.regional.compare.novalue){
            			  flagNoValue = true;
            		  }
            	});
                if(flagSeq){
	              	  //have sequence
	              	  if(!flagNoValue){
	              		  	$newTrs.each(function(i){
	                  		   var $this = $(this);
			          		   $this.prepend("<td align='center'>"+(i+1)+"</td>");   
		                  	});
	              	  }
                }
                $thead.find("tr:first th").each(function(i){
                	if(!flagNoValue){
                		$newTbody.find("tr:first td:eq("+i+")").attr("style",$(this).attr("style"));
                	}
                });
                var tds = $newTbody.find("td");
                tds.each(function(){
                	$(this).html("<div><span>"+$(this).html()+"</span></div>");
                });
                $(".gridTbody tbody").html($newTbody.find("tbody").html());
                
                var $trs = $(".gridTbody tbody").find('>tr');
                $trs.hoverClass().each(function(i){
              	  var $tr = $(this);
              	  $tr.click(function(){
    					$trs.filter(".selected").removeClass("selected");
    					$tr.addClass("selected");
    				});
                });
                
                //after grid loaded
                $("input[name=totalRecord]").val(totalCount);
                $(".pagination-nav").attr("totalCount",totalCount);
                $(".pagination-nav").each(function(){
    				var $this = $(this);
    				$this.pagination({
    					targetType:$this.attr("targetType"),
    					rel:$this.attr("rel"),
    					totalCount:totalCount,
    					numPerPage:$this.attr("numPerPage"),
    					pageNumShown:$this.attr("pageNumShown"),
    					form:$this.attr("form")
    				});
    			});
                
                //reload dialog js
                REPS.reloadDialogJs();
			},
			error: REPS.ajaxError
		});
	}
	
	if (confirmMsg) {
		messager.confirm(confirmMsg, {okCall: _submitFn});
	} else {
		_submitFn();
	}
	
	if(null != callback && '' != callback && undefined != callback){
		eval("var callbackFun = " + callback);
		callbackFun();
	}
	
	return false;
}

(function($){
	//set regional
	$.setRegional = function(key, value){
		if (!$.regional) $.regional = {};
		$.regional[key] = value;
	};
	
	$.fn.extend({
		/**
		 * @param {Object} op: {type:GET/POST, url:ajax请求地址, data:ajax请求参数列表, callback:回调函数 }
		 */
		ajaxUrl: function(op){
			var $this = $(this);

			$this.trigger(REPS.eventType.pageClear);
			
			$.ajax({
				type: op.type || 'GET',
				url: op.url,
				data: op.data,
				cache: false,
				success: function(response){
					var json = REPS.jsonEval(response);
					
					if (json.statusCode==REPS.statusCode.error){
						if (json.message) messager.error(json.message);
					} else {
						//$this.html(response).initUI();
						if ($.isFunction(op.callback)) op.callback(response);
					}
					
					if (json.statusCode==REPS.statusCode.timeout){
						if ($.pdialog) $.pdialog.checkTimeout();
						if (navTab) navTab.checkTimeout();
	
						messager.error(json.message || REPS.msg("sessionTimout"), {okCall:function(){
							//REPS.loadLogin();
						}});
					} 
					
				},
				error: REPS.ajaxError,
				statusCode: {
					503: function(xhr, ajaxOptions, thrownError) {
						alert(REPS.msg("statusCode_503") || thrownError);
					}
				}
			});
		},
		loadUrl: function(url,data,callback){
			$(this).ajaxUrl({url:url, data:data, callback:callback});
		},
		/**
		 * adjust component inner reference box height
		 * @param {Object} refBox: reference box jQuery Obj
		 */
		layoutH: function($refBox){
			return this.each(function(){
				var $this = $(this);
				if (! $refBox) $refBox = $this.parents("div.layoutBox:first");
				var iRefH = $refBox.height();
				var iLayoutH = parseInt($this.attr("layoutH"));
				var iH = iRefH - iLayoutH > 50 ? iRefH - iLayoutH : 50;
				if ($this.isTag("table")) {
					$this.removeAttr("layoutH").wrap('<div layoutH="'+iLayoutH+'" style="overflow:auto;height:'+iH+'px"></div>');
				} else {
					$this.height(iH).css("overflow","auto");
				}
			});
		},
		
		gridH: function(gh,flagNoHeight){
			return this.each(function(){
				var $this = $(this);
				var $refBox = $this.parents("div.panel:first");
				var iRefH = $refBox.height();
				if(!gh){
					gh=iRefH;
				}
				var iH = gh-50;//80
				var $panelHeader = $(this).parent().parent().siblings(".panel-header");//substract title height
				if($panelHeader.size() > 0){
					iH -= 27;
				}
				if ($this.isTag("table")) {
					$this.removeAttr("layoutH").wrap('<div style="overflow:auto;height:'+iH+'px"></div>');
				} else {
					if(!flagNoHeight){
						$this.height(iH).css("overflow","auto");
					}
					
				}
			});
		},
		hoverClass: function(className, speed){
			var _className = className || "hover";
			return this.each(function(){
				var $this = $(this), mouseOutTimer;
				$this.hover(function(){
					if (mouseOutTimer) clearTimeout(mouseOutTimer);
					$this.addClass(_className);
				},function(){
					mouseOutTimer = setTimeout(function(){$this.removeClass(_className);}, speed||10);
				});
			});
		},
		focusClass: function(className){
			var _className = className || "textInputFocus";
			return this.each(function(){
				$(this).focus(function(){
					$(this).addClass(_className);
				}).blur(function(){
					$(this).removeClass(_className);
				});
			});
		},
		inputAlert: function(){
			return this.each(function(){
				
				var $this = $(this);
				
				function getAltBox(){
					return $this.parent().find("label.alt");
				}
				function altBoxCss(opacity){
					var position = $this.position();
					return {
						width:$this.width(),
						top:position.top+'px',
						left:position.left +'px',
						opacity:opacity || 1
					};
				}
				if (getAltBox().size() < 1) {
					if (!$this.attr("id")) $this.attr("id", $this.attr("name") + "_" +Math.round(Math.random()*10000));
					var $label = $('<label class="alt" for="'+$this.attr("id")+'">'+$this.attr("alt")+'</label>').appendTo($this.parent());
					
					$label.css(altBoxCss(1));
					if ($this.val()) $label.hide();
				}
				
				$this.focus(function(){
					getAltBox().css(altBoxCss(0.3));
				}).blur(function(){
					if (!$(this).val()) getAltBox().show().css("opacity",1);
				}).keydown(function(){
					getAltBox().hide();
				});
			});
		},
		isTag:function(tn) {
			if(!tn) return false;
			return $(this)[0].tagName.toLowerCase() == tn?true:false;
		},
		/**
		 * 判断当前元素是否已经绑定某个事件
		 * @param {Object} type
		 */
		isBind:function(type) {
			var _events = $(this).data("events");
			return _events && type && _events[type];
		},		
		/**
		 * 输出firebug日志
		 * @param {Object} msg
		 */
		log:function(msg){
			return this.each(function(){
				if (console) console.log("%s: %o", msg, this);
			});
		}
	});
	
	/**
	 * 扩展String方法
	 */
	$.extend(String.prototype, {
		isPositiveInteger:function(){
			return (new RegExp(/^[1-9]\d*$/).test(this));
		},
		isInteger:function(){
			return (new RegExp(/^\d+$/).test(this));
		},
		isNumber: function(value, element) {
			return (new RegExp(/^-?(?:\d+|\d{1,3}(?:,\d{3})+)(?:\.\d+)?$/).test(this));
		},
		trim:function(){
			return this.replace(/(^\s*)|(\s*$)|\r|\n/g, "");
		},
		startsWith:function (pattern){
			return this.indexOf(pattern) === 0;
		},
		endsWith:function(pattern) {
			var d = this.length - pattern.length;
			return d >= 0 && this.lastIndexOf(pattern) === d;
		},
		replaceSuffix:function(index){
			return this.replace(/\[[0-9]+\]/,'['+index+']').replace('#index#',index);
		},
		trans:function(){
			return this.replace(/&lt;/g, '<').replace(/&gt;/g,'>').replace(/&quot;/g, '"');
		},
		encodeTXT: function(){
			return (this).replaceAll('&', '&amp;').replaceAll("<","&lt;").replaceAll(">", "&gt;").replaceAll(" ", "&nbsp;");
		},
		replaceAll:function(os, ns){
			return this.replace(new RegExp(os,"gm"),ns);
		},
		replaceTm:function($data){
			if (!$data) return this;
			return this.replace(RegExp("({[A-Za-z_]+[A-Za-z0-9_]*})","g"), function($1){
				return $data[$1.replace(/[{}]+/g, "")];
			});
		},
		replaceTmById:function(_box){
			var $parent = _box || $(document);
			return this.replace(RegExp("({[A-Za-z_]+[A-Za-z0-9_]*})","g"), function($1){
				var $input = $parent.find("#"+$1.replace(/[{}]+/g, ""));
				return $input.val() ? $input.val() : $1;
			});
		},
		isFinishedTm:function(){
			return !(new RegExp("{[A-Za-z_]+[A-Za-z0-9_]*}").test(this)); 
		},
		skipChar:function(ch) {
			if (!this || this.length===0) {return '';}
			if (this.charAt(0)===ch) {return this.substring(1).skipChar(ch);}
			return this;
		},
		isValidPwd:function() {
			return (new RegExp(/^([_]|[a-zA-Z0-9]){6,32}$/).test(this)); 
		},
		isValidMail:function(){
			return(new RegExp(/^\w+((-\w+)|(\.\w+))*\@[A-Za-z0-9]+((\.|-)[A-Za-z0-9]+)*\.[A-Za-z0-9]+$/).test(this.trim()));
		},
		isSpaces:function() {
			for(var i=0; i<this.length; i+=1) {
				var ch = this.charAt(i);
				if (ch!=' '&& ch!="\n" && ch!="\t" && ch!="\r") {return false;}
			}
			return true;
		},
		isPhone:function() {
			return (new RegExp(/(^([0-9]{3,4}[-])?\d{3,8}(-\d{1,6})?$)|(^\([0-9]{3,4}\)\d{3,8}(\(\d{1,6}\))?$)|(^\d{3,8}$)/).test(this));
		},
		isUrl:function(){
			return (new RegExp(/^[a-zA-z]+:\/\/([a-zA-Z0-9\-\.]+)([-\w .\/?%&=:]*)$/).test(this));
		},
		isExternalUrl:function(){
			return this.isUrl() && this.indexOf("://"+document.domain) == -1;
		}
	});
})(jQuery);

/** 
 * You can use this map like this:
 * var myMap = new Map();
 * myMap.put("key","value");
 * var key = myMap.get("key");
 * myMap.remove("key");
 */
function Map(){

	this.elements = new Array();
	
	this.size = function(){
		return this.elements.length;
	}
	
	this.isEmpty = function(){
		return (this.elements.length < 1);
	}
	
	this.clear = function(){
		this.elements = new Array();
	}
	
	this.put = function(_key, _value){
		this.remove(_key);
		this.elements.push({key: _key, value: _value});
	}
	
	this.remove = function(_key){
		try {
			for (i = 0; i < this.elements.length; i++) {
				if (this.elements[i].key == _key) {
					this.elements.splice(i, 1);
					return true;
				}
			}
		} catch (e) {
			return false;
		}
		return false;
	}
	
	this.get = function(_key){
		try {
			for (i = 0; i < this.elements.length; i++) {
				if (this.elements[i].key == _key) { return this.elements[i].value; }
			}
		} catch (e) {
			return null;
		}
	}
	
	this.element = function(_index){
		if (_index < 0 || _index >= this.elements.length) { return null; }
		return this.elements[_index];
	}
	
	this.containsKey = function(_key){
		try {
			for (i = 0; i < this.elements.length; i++) {
				if (this.elements[i].key == _key) {
					return true;
				}
			}
		} catch (e) {
			return false;
		}
		return false;
	}
	
	this.values = function(){
		var arr = new Array();
		for (i = 0; i < this.elements.length; i++) {
			arr.push(this.elements[i].value);
		}
		return arr;
	}
	
	this.keys = function(){
		var arr = new Array();
		for (i = 0; i < this.elements.length; i++) {
			arr.push(this.elements[i].key);
		}
		return arr;
	}
}

(function ($) {
	var menu,
	shadow,
	hash;
	$.fn.extend({
		contextMenu : function (id, options) {
			var op = $.extend({
					shadow : true,
					bindings : {},
					ctrSub : null
				}, options);
			if (!menu) {
				menu = $('<div id="contextmenu"></div>').appendTo('body').hide();
			}
			if (!shadow) {
				shadow = $('<div id="contextmenuShadow"></div>').appendTo('body').hide();
			}
			hash = hash || [];
			hash.push({
				id : id,
				shadow : op.shadow,
				bindings : op.bindings || {},
				ctrSub : op.ctrSub
			});
			var index = hash.length - 1;
			$(this).bind('contextmenu', function (e) {
				display(index, this, e, op);
				return false;
			});
			return this;
		}
	});
	function display(index, trigger, e, options) {
		var cur = hash[index];
		var content = '<ul id="navTabCM"><li rel="reload">刷新标签页</li><li rel="closeCurrent">关闭标签页</li><li rel="closeOther">关闭其它标签页</li><li rel="closeAll">关闭全部标签页</li></ul>';
		$(content).find('li').hoverClass();
		menu.html(content);
		$.each(cur.bindings, function (id, func) {
			$("[rel='" + id + "']", menu).bind('click', function (e) {
				hide();
				func($(trigger), $("#" + cur.id));
			});
		});
		var posX = e.pageX;
		var posY = e.pageY;
		if ($(window).width() < posX + menu.width())
			posX -= menu.width();
		if ($(window).height() < posY + menu.height())
			posY -= menu.height();
		menu.css({
			'left' : posX,
			'top' : posY
		}).show();
		if (cur.shadow)
			shadow.css({
				width : menu.width(),
				height : menu.height(),
				left : posX + 3,
				top : posY + 3
			}).show();
		$(document).one('click', hide);
		if ($.isFunction(cur.ctrSub)) {
			cur.ctrSub($(trigger), $("#" + cur.id));
		}
	}
	function hide() {
		menu.hide();
		shadow.hide();
	}
})(jQuery);