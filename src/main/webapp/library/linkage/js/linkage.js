/*
*	pluginName:联动选择插件
*	author: zhongwh
*	date: 20160612
*
*
*
*
*/

;(function($){
	var LinkSelect = function(ele,option){
		this.$this=ele;
		this.defaults={
			struct : "2-2-2",  //几级联动，以及联动时解析数据ID的规则  如 101010 为 [2,2 				
			jsonData: "" ,                //数据
			css :  "",					//样式
			style: "" 
		};
		this.setting=$.extend({},this.defaults,option);
	}
	
	LinkSelect.prototype={		
		init: function(){			
			this.opt();//解析配置文件，获取层级,获取数据ID解析规则
			this.initHtml(); //页面基本DOM元素的初始化
			//console.log(this.struct);
			this.infoData=this.data(); //数据的获取			
			//this.infoData=this.setting.data;
			//一切从一开始
			var optData=this._analayz_data(this.infoData,1,this.firstData()); //对数据进行解析分组
			this.add(optData,1);
			
		},
		firstData:function(){
			var l=this.struct[this.level];
			var demoString="";
			for(var i=0; i <l ; i++){
				demoString +="0";
			}			
			return demoString;
		},
		opt:function(){		
			//将字符串重新解析成数组
			this.setting.idStruct=this.setting.struct.toString().split("-");			
			//层级的计算
			this.level=this.setting.idStruct.length;
			//字符串的位置计算
			this.struct=[];
			this.struct[0]=0;  //索引值从0开始
			for(var i=1; i< this.level+1; i++){
				if(i == 1){
					this.struct[i]= this.setting.idStruct[i-1];
				}else{
					var number=0;
					for(j=i;j>0;j--){
						number += Number( this.setting.idStruct[j-1] );
					}	
					this.struct[i]=	number;											
				}				
			}				
		},
		data:function(){				
			if(this.setting.jsonData){
				return this.setting.jsonData;
				//return eval("("+ this.setting.jsonData +")");
				
			}
			//测试数据
			//return [
			//	{id:'300000',name:'云南省'},{id:'301000',name:'云南省昆明市'},{id:'301001',name:'花'},
			//	{id:'400000',name:'省'},{id:'400100',name:'省昆明市'},{id:'401001',name:'省花'}
			//
			//];
		},
		initHtml:function(){
			var str="";
			for(var i= 0,j= this.level; i<j ; i++){
				str += "<select id=\"linkSelect-"+i+"\">" +
						"<option value=\"\">请选择</option>" +
						"</select>";
			}
			$("#" + $(this.$this).attr("id")).append(str);
			//样式的处理
			if(this.setting.style){				
				$("select[id^='linkSelect']").attr("style",this.setting.style);
			}
			if(this.setting.css){
				$("select[id^='linkSelect']").attr("css",this.setting.css);
			}
			
		},
		add:function(data,num){
			if (num >= this.level + 1){
				return ;
			}
			var str="";
			for(var i=0,j=data.length ; i<j ; i++){
				str += "<option value=\""+data[i].id+"\">"+data[i].name+"</option>";
			}			
			$("#linkSelect-"+(num-1)).append(str);
///			//事件的绑定
			var _self=this;
			$("#linkSelect-"+(num-1)).change(function(){
				if (num >= this.level ){
					return ;
				}
				var value=$(this).val();
				//空选择
				//if(value == ""){					
				//	_self.emptyHtml(num);  //清空选择
				//	return;
				//};			
/*********/		
				//数据清空
				_self.emptyHtml(num);
				var optData=_self._analayz_data(_self.infoData,num+1,value); //对数据进行解析分组
				_self.add(optData,num+1);
///
			});	
		},	
		emptySelect:function(num){
			if (num >= this.level ){
				return ;
			}
			$("#linkSelect-" + num ).val("");  
			this.emptySelect(num + 1);
		},
		emptyHtml:function(num){
			if (num >= this.level ){
				return ;
			}
			$("#linkSelect-" + num ).empty().html("<option value=\"\">请选择</option>");
			this.emptyHtml(num + 1);
		},
		_analayz_data:function(data,x,demodata){
			//x参数从1开始,data为筛选前数据,demodata为样品数据
			//数据解析			
			var m=this.struct.length; //计数器
			var result=[],midv=this.struct[x],maxv=this.struct[m-1],minv=this.struct[x-1];  //用以存放解析结果			
			//暂时存储数据ID解析信息
			var predata=demodata.substring(0,minv);
			var middata=demodata.substring(minv,midv);
			var aftdata=demodata.substring(midv,maxv);
			//特殊情况处理					
			for(var i=0,n=data.length; i<n; i++){				
				if(data[i].id.substring(0,minv) == predata && data[i].id.substring(midv,maxv) == aftdata && data[i].id.substring(minv,midv) != middata){
					result.push(data[i]);
				}
			}
			//console.log("="+predata+"-"+middata+"-"+aftdata+"=");
			//console.log(result);
			return result;
		}
	};
	
	$.fn.linkage=function(option){
		var linkSelect=new LinkSelect(this,option);
		linkSelect.init();
	};
})(jQuery);


