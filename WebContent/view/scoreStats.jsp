<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta charset="UTF-8">
	<title>成绩统计</title>
	<link rel="stylesheet" type="text/css" href="easyui/themes/default/easyui.css">
	<link rel="stylesheet" type="text/css" href="easyui/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="easyui/css/demo.css">
	<script type="text/javascript" src="easyui/jquery.min.js"></script>
	<script type="text/javascript" src="easyui/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="easyui/js/validateExtends.js"></script>
	<script type="text/javascript">
	$(function() {	
		
		//提前加载学生和课程信息
	    $("#courseList").combobox({
		  		width: "150",
		  		height: "25",
		  		valueField: "id",
		  		textField: "name",
		  		multiple: false, //可多选
		  		editable: false, //不可编辑
		  		method: "post",
		  		url: "CourseServlet?method=CourseList&t="+new Date().getTime()+"&from=combox",
		  		
		  	});
		
	  
	  //下拉框通用属性
	  	$("#courseList").combobox({
	  		width: "200",
	  		height: "30",
	  		valueField: "id",
	  		textField: "name",
	  		multiple: false, //不可多选
	  		editable: false, //不可编辑
	  		method: "post",
	  	});
	  	
	    //搜索按钮监听事件
	  	$(".search-score-btn").click(function(){
	  		var searchKey = $(this).attr('key');
	  		var courseId = $("#courseList").combobox('getValue');
	  		if(courseId == null || courseId == ''){
	  			$.messager.alert("消息提醒","请选择课程!","info");
	  			return;
	  		}
	  		$.ajax({
	  			url:'ScoreServlet?method=getStatsList&courseid='+courseId+"&searchType="+searchKey,
	  			dataType:'json',
	  			success:function(rst){
	  				if(rst.type == "suceess"){
	  					var option;
	  					if(searchKey == 'range'){
	  						option = {
		  			  	            title: {
		  			  	                text: '课程：'+rst.courseName
		  			  	            },
		  			  	            tooltip: {
		  			  	                trigger: 'axis',
		  			  	                axisPointer: {
		  			  	                    type: 'cross',
		  			  	                    crossStyle: {
		  			  	                        color: '#999'
		  			  	                    }
		  			  	                }
		  			  	            },
		  			  	        legend: {
		  			  	        		data:['成绩区间分布']
		  			  	    		},
		  			  	            xAxis: {
		  			  	                data: rst.rangeList
		  			  	            },
		  			  	            yAxis: {type: 'value'},
		  			  	            series: [{
		  			  	                name: '成绩区间分布',
		  			  	                type: 'bar',
		  			  	                data: rst.numberList
		  			  	            }]
		  			  	        };
	  					}else{
	  						option = {
		  			  	            title: {
		  			  	                text: '课程：'+rst.courseName
		  			  	            },
		  			  	            tooltip: {
		  			  	                trigger: 'axis',
		  			  	                axisPointer: {
		  			  	                    type: 'cross',
		  			  	                    crossStyle: {
		  			  	                        color: '#999'
		  			  	                    }
		  			  	                }
		  			  	            },
		  			  	        legend: {
		  			  	        		data:['成绩分布']
		  			  	    		},
		  			  	            xAxis: {
		  			  	                data: rst.avgList
		  			  	            },
		  			  	            yAxis: {type: 'value'},
		  			  	            series: [{
		  			  	                name: '成绩分布',
		  			  	                type: 'bar',
		  			  	                data: rst.scoreList
		  			  	            }]
		  			  	        };
	  					}
	  					showCharts(option);
	  				}else{
	  					$.messager.alert("消息提醒","获取数据出错!","info");
	  				}
	  			}
	  		})
	  		
	  	});
	    
	});
	</script>
</head>
<body style="padding:0px;">
	<div class="panel-header"><div class="panel-title panel-with-icon">成绩信息统计</div><div class="panel-icon icon-more"></div><div class="panel-tool"></div></div>
	<!-- 工具栏 -->
	<div id="toolbar" class="datagrid-toolbar">
		<div style="margin-top: 3px;">
			课程：<input id="courseList" class="easyui-textbox" name="courseList" />
			<a href="javascript:;" class="easyui-linkbutton search-score-btn" key="range" data-options="iconCls:'icon-sum',plain:true">区间统计图</a>
			<a href="javascript:;" class="easyui-linkbutton search-score-btn" key="avg" data-options="iconCls:'icon-sum',plain:true">平均统计图</a>
		</div>
	</div>
	<div id="charts-div" style="width:100%;height:500px;"></div>
</body>
<script type="text/javascript" src="easyui/js/echarts.common.min.js"></script>
<script type="text/javascript">
        // 基于准备好的dom，初始化echarts实例
        var myChart = echarts.init(document.getElementById('charts-div'));

        function showCharts(option){
        	// 使用刚指定的配置项和数据显示图表。
            myChart.setOption(option);
        }
    </script>
</html>