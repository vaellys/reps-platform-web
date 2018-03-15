<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/commons/tags.jsp"%>
<!DOCTYPE html>
<html style="height: 100%">
   <head>
       <meta charset="utf-8">
   </head>
   <body style="height: 100%; margin: 0">
       <div id="container" style="height: 100%"></div>
       <script type="text/javascript" src="http://echarts.baidu.com/gallery/vendors/echarts/echarts-all-3.js"></script>
       <script type="text/javascript" src="http://echarts.baidu.com/gallery/vendors/echarts/extension/dataTool.min.js"></script>
       <script type="text/javascript" src="http://echarts.baidu.com/gallery/vendors/echarts/map/js/china.js"></script>
       <script type="text/javascript" src="http://echarts.baidu.com/gallery/vendors/echarts/map/js/world.js"></script>
       <script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=ZUONbpqGBsYGXNIYHicvbAbM"></script>
       <script type="text/javascript" src="http://echarts.baidu.com/gallery/vendors/echarts/extension/bmap.min.js"></script>
       <script type="text/javascript">
var dom = document.getElementById("container");
var myChart = echarts.init(dom);
var app = {};
option = null;
<c:choose>
	<c:when test="${logTable eq 'AccountLog_201609'}">
		option = {
		    title: {
		        text: '登录统计'
		    },
		    tooltip: {},
		    legend: {
		        data:['登录次数']
		    },
		    xAxis: {
		        data: ["09-26","09-27","09-28","09-29","09-30"]
		    },
		    yAxis: {},
		    series: [{
		        name: '访问次数',
		        type: 'bar',
		        data: [345, 456, 563, 672, 389]
		    }]
		};
	</c:when>
	<c:otherwise>
		option = {
		    title: {
		        text: '登录统计'
		    },
		    tooltip: {},
		    legend: {
		        data:['登录次数']
		    },
		    xAxis: {
		        data: ["10-01","10-02","10-03","10-04","10-05","10-06","10-07","10-08","10-09","10-10","10-11","10-12","10-13","10-14","10-15","10-16","10-17","10-18"]
		    },
		    yAxis: {},
		    series: [{
		        name: '访问次数',
		        type: 'bar',
		        data: [132, 231, 101, 231, 389, 345, 235, 514, 665, 712, 1034, 1089, 1233, 1353, 231, 318, 1297, 1357]
		    }]
		};
	</c:otherwise>
</c:choose>


if (option && typeof option === "object") {
    myChart.setOption(option, true);
}
       </script>
   </body>
</html>