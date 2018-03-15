//保存配置
var saveConfig = function (){
	createModuleSort();
	$.ajax({
	 	url: path + '/usersetting/desk/savechange.mvc?run=' + Math.random(), 
	    type: 'post',
	    async:false,
	    data : {
			"layout" : $("#deskLayout").val(),
			"moduleSort" : $("#moduleSort").val()
		},
	    success: function(data) {
	    	$("#userDesk").html("");
	    	if(data.indexOf("<body>") != -1 && data.indexOf("</body>") != -1)
    		{
	    		data = data.substring(data.indexOf("<body>") + 6, data.indexOf("</body>"));
    		}
			$("#userDesk").append(data);
			makeSort($("#deskLayout").val());
			//$(".reps-fit").each(function(){var $this = $(this);$this.height($this.parent().height()); $this.width($this.parent().width());});
			
			//message alert
			var messageData = {"statusCode":200,"message":"保存成功"};
			messager.message(messageData, function(){ window.location.reload(); });
		}
	});
	
	initMain();
	
	
};
var reSetNavTab = function()
{
	$("a[target=navTab-new]").each(function () {
		$(this).click(function (event) {
			var $this = $(this);
			var title = $this.attr("title") || $this.text();
			var tabid = $this.attr("rel") || "_blank";
			var fresh = eval($this.attr("fresh") || "true");
			var external = eval($this.attr("external") || "false");
			var url = unescape($this.attr("href")).replaceTmById($(event.target).parents(".unitBox:first"));
			//DWZ.debug(url);
			if (!url.isFinishedTm()) {
			alertMsg.error($this.attr("warn") || DWZ.msg("alertSelectMsg"));
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
}
//版式布局切换
var makeSort = function(e){	
	var CssMode= new Array('1:3','3:1','1:2:1','1:1:2','2:1:1'); //布局模式
	var CssText= new Array(['w250-index','w750-index','wnone'],['w750-index','w250-index','wnone'],['w250-index','w500-index','w250-index'],['w250-index','w250-index','w500-index'],['w500-index','w250-index','w250-index']);	//w250,w750,w500,wnone 是css 名.class
	var Modules=new Array('module_l','module_m','module_r'); //栏目id
	var CssTextId=0;//默认css数组编号
	var ModuleItems="";
	$.each( CssMode, function(m, mn){
		if(e==mn) CssTextId=m;//css 赋值
	});	
	$.each( Modules, function(s, sn){		
		if(CssText[CssTextId][s]=='wnone') {//出现布局由3->2的变化	,最右边栏目的内容搬到最左边
			$("#"+sn).empty();//摧毁原有的元素，以免重复出现冲突
		}
		$("#"+sn).removeClass("w250-index w750-index w500-index wnone");//清空css，以免css重复冲突
		$("#"+sn).addClass(CssText[CssTextId][s]);//增加css
	});	
};
var setChange = function ()
{
	$("#isChange").val("true");
}
var ArrayIndexOf = function(a,array){
	for(var i = 0 ;i < array.length;i++){
		if(array[i] == a){
			return i;
		}
	}
	return -1;
}
//版式布局切换
var makeUserSettingSort = function(e,obj){
	setChange();
	var CssMode= new Array('1:3','3:1','1:2:1','1:1:2','2:1:1'); //布局模式
	if(obj == undefined){
		var index = ArrayIndexOf(e,CssMode);
		$("input[name=settingradio]").eq(index).prop("checked",true);
	}
	var CssText= new Array(['w250','w750','wnone'],['w750','w250','wnone'],['w250','w500','w250'],['w250','w250','w500'],['w500','w250','w250']);	//w250,w750,w500,wnone 是css 名.class
	var Modules=new Array('module_left','module_mid','module_right'); //栏目id
	var CssTextId=0;//默认css数组编号
	var ModuleItems="";
	$.each( CssMode, function(m, mn){
		if(e==mn) CssTextId=m;//css 赋值
	});	
	$("#deskLayout").val(e);
	$.each( Modules, function(s, sn){		
		if(CssText[CssTextId][s]=='wnone') {//出现布局由3->2的变化	,最右边栏目的内容搬到最左边
			ModuleItems=$('#'+sn).sortable('toArray');//获取最新的的元素
			$.each( ModuleItems, function(m, mn){
				$("#" + Modules[0]).append($("#"+mn));//注意在两栏三栏间切换的时候 返回已经丢失的模块,而且只能够逐个添加元素，不可以一次添加多个
			});
			$("#"+sn).empty();//摧毁原有的元素，以免重复出现冲突
		}		
		$("#"+sn).removeClass("w250 w750 w500 wnone");//清空css，以免css重复冲突
		$("#"+sn).addClass(CssText[CssTextId][s]);//增加css
	});	
	createModuleSort();
};

//刷新组建列表
var createModuleSort = function()
{
	var modeSort = "left=" + $("#module_left").sortable("toArray") + ";";
	modeSort += "mid=" + $("#module_mid").sortable("toArray") + ";";
	modeSort += "right=" + $("#module_right").sortable("toArray");
	$("#moduleSort").val(modeSort.replaceAll("usersettingItem", ""));
}

//增删模块
var displayDesk = function(obj){
	var moduleId = ($(obj).attr("id")).replace("config_", "");
	if($(obj).attr("checked"))
	{
		var moduleText = "<div id=\"usersettingItem" + moduleId + "\" class=\"ui-state-default\">" + $(obj).val().split(":")[0] + "</div>";
		if($("#module_" + $(obj).val().split(":")[1]).css("display") == "block")
			$("#module_" + $(obj).val().split(":")[1]).append(moduleText);
		else
			$("#module_left").append(moduleText);
		$("#usersetting .groupWrapper").sortable('enable');
	}
	else
	{
		$("#usersettingItem" + moduleId).remove();
	}
	setChange();
	createDeskSort();
};