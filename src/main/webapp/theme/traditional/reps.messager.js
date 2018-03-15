/**
 * @date 2014/4/22
 */
$.setRegional("messager", {
	title:{error:"Error", info:"Information", warn:"Warning", correct:"Successful", confirm:"Confirmation"},
	butMsg:{ok:"OK", yes:"Yes", no:"No", cancel:"Cancel"}
});
var messager = {
	_boxId: "#alertMsgBox",
	_bgId: "#alertBackground",
	_closeTimer: null,

	_types: {error:"error", info:"info", warn:"warn", correct:"correct", confirm:"confirm"},

	_getTitle: function(key){
		return $.regional.messager.title[key];
	},

	_keydownOk: function(event){
		if (event.keyCode == REPS.keyCode.ENTER) event.data.target.trigger("click");
		return false;
	},
	_keydownEsc: function(event){
		if (event.keyCode == REPS.keyCode.ESC) event.data.target.trigger("click");
	},
	/**
	 * 
	 * @param {Object} type
	 * @param {Object} msg
	 * @param {Object} buttons [button1, button2]
	 */
	_open: function(type, msg, buttons){
		var alertButTemplate='<li><a class="button" rel="#callback#" onclick="messager.close()" href="javascript:"><span>#butMsg#</span></a></li>';
		var alertBoxTemplate='<div id="alertMsgBox" class="alert"><div class="alertContent"><div class="#type#"><div class="alertInner"><h1>#title#</h1><div class="msg">#message#</div></div><div class="toolBar"><ul>#butFragment#</ul></div></div></div><div class="alertFooter"><div class="alertFooter_r"><div class="alertFooter_c"></div></div></div></div>';
		$(this._boxId).remove();
		var butsHtml = "";
		if (buttons) {
			for (var i = 0; i < buttons.length; i++) {
				var sRel = buttons[i].call ? "callback" : "";
				butsHtml += alertButTemplate.replace("#butMsg#", buttons[i].name).replace("#callback#", sRel);
			}
		}
		var boxHtml = alertBoxTemplate.replace("#type#", type).replace("#title#", this._getTitle(type)).replace("#message#", msg).replace("#butFragment#", butsHtml);
		$(boxHtml).appendTo("body").css({top:-$(this._boxId).height()+"px"}).animate({top:$(document).scrollTop()+"px"}, 500);
		
		if (this._closeTimer) {
			clearTimeout(this._closeTimer);
			this._closeTimer = null;
		}
		if (this._types.info == type || this._types.correct == type){
			this._closeTimer = setTimeout(function(){messager.close()}, 5500);
		} else {
			$(this._bgId).show();
		}
	
		var jButs = $(this._boxId).find("a.button");
		var jCallButs = jButs.filter("[rel=callback]");
		var jDoc = $(document);
		
		for (var i = 0; i < buttons.length; i++) {
			if (buttons[i].call) jCallButs.eq(i).click(buttons[i].call);
			if (buttons[i].keyCode == REPS.keyCode.ENTER) {
				jDoc.bind("keydown",{target:jButs.eq(i)}, this._keydownOk);
			}
			if (buttons[i].keyCode == REPS.keyCode.ESC) {
				jDoc.bind("keydown",{target:jButs.eq(i)}, this._keydownEsc);
			}
		}
		
	},
	close: function(){
		$(document).unbind("keydown", this._keydownOk).unbind("keydown", this._keydownEsc);
		$(this._boxId).animate({top:-$(this._boxId).height()}, 500, function(){
			$(this).remove();
		});
		$(this._bgId).hide();
	},
	error: function(msg, options) {
		this._alert(this._types.error, msg, options);
	},
	info: function(msg, options) {
		this._alert(this._types.info, msg, options);
	},
	warn: function(msg, options) {
		this._alert(this._types.warn, msg, options);
	},
	correct: function(msg, options) {
		this._alert(this._types.correct, msg, options);
	},
	_alert: function(type, msg, options) {
		var op = {okName:$.regional.messager.butMsg.ok, okCall:null};
		$.extend(op, options);
		var buttons = [
			{name:op.okName, call: op.okCall, keyCode:REPS.keyCode.ENTER}
		];
		this._open(type, msg, buttons);
	},
	/**
	 * 
	 * @param {Object} msg
	 * @param {Object} options {okName, okCal, cancelName, cancelCall}
	 */
	confirm: function(msg, options) {
		var op = {okName:$.regional.messager.butMsg.ok, okCall:null, cancelName:$.regional.messager.butMsg.cancel, cancelCall:null};
		$.extend(op, options);
		var buttons = [
			{name:op.okName, call: op.okCall, keyCode:REPS.keyCode.ENTER},
			{name:op.cancelName, call: op.cancelCall, keyCode:REPS.keyCode.ESC}
		];
		this._open(this._types.confirm, msg, buttons);
	},
	message: function(data,callback){
		if(data.statusCode == REPS.statusCode.ok){
			 this.correct(data.message,{ okCall:callback});
		}else if (data.statusCode == REPS.statusCode.error){
			 this.error(data.message);
		}else{
			 this.info(data.message);
		}
	}
	
};

