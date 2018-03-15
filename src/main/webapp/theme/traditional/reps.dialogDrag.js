/**
 * @author Roger Wu
 */
(function($){
	$.fn.dialogDrag = function(options){
        if (typeof options == 'string') {
                if (options == 'destroy') 
					return this.each(function() {
							var dialog = this;		
							$("div.dialogHeader", dialog).unbind("mousedown");
	                });
        }
		return this.each(function(){
			var dialog = $(this);
			$("div.dialogHeader", dialog).mousedown(function(e){
				$.pdialog.switchDialog(dialog);
				dialog.data("task",true);
				setTimeout(function(){
					if(dialog.data("task"))$.dialogDrag.start(dialog,e);
				},100);
				return false;
			}).mouseup(function(e){
				dialog.data("task",false);
				return false;
			});
		});
	};
	$.dialogDrag = {
		currId:null,
		_init:function(dialog) {
			this.currId = new Date().getTime();
			var dialogProxyTemplate='<div id="dialogProxy" class="dialog dialogProxy">';
			    dialogProxyTemplate+='  <div class="dialogHeader">';
			    dialogProxyTemplate+='      <div class="dialogHeader_r">';
			    dialogProxyTemplate+='          <div class="dialogHeader_c">';
			    dialogProxyTemplate+='              <a class="close" href="#close">close</a>';
			    dialogProxyTemplate+='              <a class="maximize" href="#maximize">maximize</a>';
			    dialogProxyTemplate+='              <a class="minimize" href="#minimize">minimize</a>';
			    dialogProxyTemplate+='              <h1></h1>';
			    dialogProxyTemplate+='          </div>';
			    dialogProxyTemplate+='      </div>';
			    dialogProxyTemplate+='  </div>';
			    dialogProxyTemplate+='  <div class="dialogContent"></div>';
			    dialogProxyTemplate+='  <div class="dialogFooter">';
			    dialogProxyTemplate+='     <div class="dialogFooter_r">';
			    dialogProxyTemplate+='          <div class="dialogFooter_c"></div>';
			    dialogProxyTemplate+='     </div>';
			    dialogProxyTemplate+='  </div>';
			    dialogProxyTemplate+='</div>';
			    
			var shadow = $("#dialogProxy");
			if (!shadow.size()) {
				shadow = $(dialogProxyTemplate);
				$("body").append(shadow);
			}
			$("h1", shadow).html($(".dialogHeader h1", dialog).text());
		},
		start:function(dialog,event){
				this._init(dialog);
				var sh = $("#dialogProxy");
				sh.css({
					left: dialog.css("left"),
					top: dialog.css("top"),
					height: dialog.css("height"),
					width: dialog.css("width"),
					zIndex:parseInt(dialog.css("zIndex")) + 1
				}).show();
				$("div.dialogContent",sh).css("height",$("div.dialogContent",dialog).css("height"));
				sh.data("dialog",dialog);
				dialog.css({left:"-10000px",top:"-10000px"});
				$(".shadow").hide();				
				$(sh).jDrag({
					selector:".dialogHeader",
					stop: this.stop,
					event:event
				});
				return false;
		},
		stop:function(){
			var sh = $(arguments[0]);
			var dialog = sh.data("dialog");
			$(dialog).css({left:$(sh).css("left"),top:$(sh).css("top")});
			$.pdialog.attachShadow(dialog);
			$(sh).hide();
		}
	}
})(jQuery);