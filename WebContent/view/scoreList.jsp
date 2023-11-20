<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta charset="UTF-8">
	<title>成绩列表</title>
	<link rel="stylesheet" type="text/css" href="easyui/themes/default/easyui.css">
	<link rel="stylesheet" type="text/css" href="easyui/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="easyui/css/demo.css">
	<script type="text/javascript" src="easyui/jquery.min.js"></script>
	<script type="text/javascript" src="easyui/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="easyui/js/validateExtends.js"></script>
	<script type="text/javascript">
	$(function() {	
		//datagrid初始化 
	    $('#dataList').datagrid({ 
	        title:'成绩信息列表', 
	        iconCls:'icon-more',//图标 
	        border: true, 
	        collapsible: false,//是否可折叠的 
	        fit: true,//自动大小 
	        method: "post",
	        url:"ScoreServlet?method=ScoreList&t="+new Date().getTime(),
	        idField:'id', 
	        singleSelect: true,//是否单选 
	        pagination: true,//分页控件 
	        rownumbers: true,//行号 
	        sortName:'id',
	        sortOrder:'DESC', 
	        remoteSort: false,
	        columns: [[  
				{field:'chk',checkbox: true,width:50},
 		        {field:'id',title:'ID',width:50},    
 		        {field:'studentId',title:'学生',width:200,
 		        	formatter: function(value,row,index){
 						if (row.studentId){
 							var studentList = $("#studentList").combobox("getData");
 							for(var i=0;i<studentList.length;i++ ){
 								//console.log(clazzList[i]);
 								if(row.studentId == studentList[i].id)return studentList[i].name;
 							}
 							return row.studentId;
 						} else {
 							return 'not found';
 						}
 					}	
 		        },
 		       	{field:'courseId',title:'课程',width:200,
 		        	formatter: function(value,row,index){
 						if (row.courseId){
 							var courseList = $("#courseList").combobox("getData");
 							for(var i=0;i<courseList.length;i++ ){
 								//console.log(clazzList[i]);
 								if(row.courseId == courseList[i].id)return courseList[i].name;
 							}
 							return row.courseId;
 						} else {
 							return 'not found';
 						}
 					}		
 		       	},
 		       {field:'score',title:'成绩',width:200},
 		       {field:'remark',title:'备注',width:200}
	 		]], 
	        toolbar: "#toolbar",
	        onBeforeLoad : function(){
	        	try{
	        		$("#studentList").combobox("getData")
	        	}catch(err){
	        		preLoadClazz();
	        	}
	        }
	    }); 
		//提前加载学生和课程信息
	    function preLoadClazz(){
	  		$("#studentList").combobox({
		  		width: "150",
		  		height: "25",
		  		valueField: "id",
		  		textField: "name",
		  		multiple: false, //可多选
		  		editable: false, //不可编辑
		  		method: "post",
		  		url: "StudentServlet?method=StudentList&t="+new Date().getTime()+"&from=combox",
		  		
		  	});
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
	  	}
		
	  //设置分页控件 
	    var p = $('#dataList').datagrid('getPager'); 
	    $(p).pagination({ 
	        pageSize: 10,//每页显示的记录条数，默认为10 
	        pageList: [10,20,30,50,100],//可以设置每页记录条数的列表 
	        beforePageText: '第',//页数文本框前显示的汉字 
	        afterPageText: '页    共 {pages} 页', 
	        displayMsg: '当前显示 {from} - {to} 条记录   共 {total} 条记录', 
	    });
	   	
	    //设置工具类按钮
	    $("#add").click(function(){
	    	$("#addDialog").dialog("open");
	    });
	    
	    //设置导入工具类按钮
	    $("#import").click(function(){
	    	$("#importDialog").dialog("open");
	    });
	    
	  //设置编辑按钮
	    $("#edit").click(function(){
	    	table = $("#editTable");
	    	var selectRows = $("#dataList").datagrid("getSelections");
        	if(selectRows.length != 1){
            	$.messager.alert("消息提醒", "请选择一条数据进行操作!", "warning");
            } else{
            	$("#edit_id").val(selectRows[0].id);
		    	$("#editDialog").dialog("open");
            }
	    });
	    
	    
	    //删除
	    $("#delete").click(function(){
	    	var selectRow = $("#dataList").datagrid("getSelected");
        	if(selectRow == null){
            	$.messager.alert("消息提醒", "请选择数据进行删除!", "warning");
            } else{
            	var id = selectRow.id;
            	$.messager.confirm("消息提醒", "确定删除成绩么，确认继续？", function(r){
            		if(r){
            			$.ajax({
							type: "post",
							url: "ScoreServlet?method=DeleteScore",
							data: {id: id},
							success: function(msg){
								if(msg == "success"){
									$.messager.alert("消息提醒","删除成功!","info");
									//刷新表格
									$("#dataList").datagrid("reload");
								}else if(msg == "not found"){
									$.messager.alert("消息提醒","不存在该选课记录!","info");
								}else{
									$.messager.alert("消息提醒","删除失败!","warning");
									return;
								}
							}
						});
            		}
            	});
            }
	    });
	  	
	  	//设置添加窗口
	    $("#addDialog").dialog({
	    	title: "添加成绩信息",
	    	width: 450,
	    	height: 450,
	    	iconCls: "icon-add",
	    	modal: true,
	    	collapsible: false,
	    	minimizable: false,
	    	maximizable: false,
	    	draggable: true,
	    	closed: true,
	    	buttons: [
	    		{
					text:'添加',
					plain: true,
					iconCls:'icon-book-add',
					handler:function(){
						var validate = $("#addForm").form("validate");
						if(!validate){
							$.messager.alert("消息提醒","请检查你输入的数据!","warning");
							return;
						} else{
							$.ajax({
								type: "post",
								url: "ScoreServlet?method=AddScore",
								data: $("#addForm").serialize(),
								success: function(msg){
									if(msg == "success"){
										$.messager.alert("消息提醒","选课信息添加成功!","info");
										//关闭窗口
										$("#addDialog").dialog("close");
										//清空原表格数据
										$("#add_remark").textbox('setValue', "");
										//刷新
										$('#dataList').datagrid("reload");
									} else if(msg == "added"){
										$.messager.alert("消息提醒","该课程成绩已经录入，不可再录入!","warning");
										return;
									} else{
										$.messager.alert("消息提醒","系统内部出错，请联系管理员!","warning");
										return;
									}
								}
							});
						}
					}
				},
				{
					text:'重置',
					plain: true,
					iconCls:'icon-book-reset',
					handler:function(){
						$("#add_remark").textbox('setValue', "");
					}
				},
			]
	    });
	  	
	  //设置修改窗口
	    $("#editDialog").dialog({
	    	title: "修改成绩信息",
	    	width: 450,
	    	height: 450,
	    	iconCls: "icon-edit",
	    	modal: true,
	    	collapsible: false,
	    	minimizable: false,
	    	maximizable: false,
	    	draggable: true,
	    	closed: true,
	    	buttons: [
	    		{
					text:'修改',
					plain: true,
					iconCls:'icon-book-edit',
					handler:function(){
						var validate = $("#editForm").form("validate");
						if(!validate){
							$.messager.alert("消息提醒","请检查你输入的数据!","warning");
							return;
						} else{
							$.ajax({
								type: "post",
								url: "ScoreServlet?method=EditScore",
								data: $("#editForm").serialize(),
								success: function(msg){
									if(msg == "success"){
										$.messager.alert("消息提醒","选课信息添加成功!","info");
										//关闭窗口
										$("#editDialog").dialog("close");
										//清空原表格数据
										$("#edit_remark").textbox('setValue', "");
										//刷新
										$('#dataList').datagrid("reload");
									} else if(msg == "added"){
										$.messager.alert("消息提醒","该课程成绩已经录入，不可再录入!","warning");
										return;
									} else{
										$.messager.alert("消息提醒","系统内部出错，请联系管理员!","warning");
										return;
									}
								}
							});
						}
					}
				},
				{
					text:'重置',
					plain: true,
					iconCls:'icon-book-reset',
					handler:function(){
						$("#edit_remark").textbox('setValue', "");
					}
				},
			],
			onBeforeOpen: function(){
				var selectRow = $("#dataList").datagrid("getSelected");
				//设置值
				$("#edit_studentList").combobox('setValue', selectRow.studentId);
				$("#edit_score").numberbox('setValue', selectRow.score);
				$("#edit_remark").textbox('setValue', selectRow.remark);
				setTimeout(function(){
					$("#edit_courseList").combobox('setValue', selectRow.courseId);
				}, 100);
				
			}
	    });
	  	
	  //设置导入窗口
	    $("#importDialog").dialog({
	    	title: "导入成绩信息",
	    	width: 450,
	    	height: 150,
	    	iconCls: "icon-add",
	    	modal: true,
	    	collapsible: false,
	    	minimizable: false,
	    	maximizable: false,
	    	draggable: true,
	    	closed: true,
	    	buttons: [
	    		{
					text:'确认导入',
					plain: true,
					iconCls:'icon-book-add',
					handler:function(){
						var validate = $("#importForm").form("validate");
						if(!validate){
							$.messager.alert("消息提醒","请选择文件!","warning");
							return;
						} else{
							importScore();
							$("#importDialog").dialog("close");
						}
					}
				}
			]
	    });
	  
	  //下拉框通用属性
	  	$("#add_studentList, #add_courseList,#studentList,#courseList,#edit_studentList, #edit_courseList").combobox({
	  		width: "200",
	  		height: "30",
	  		valueField: "id",
	  		textField: "name",
	  		multiple: false, //不可多选
	  		editable: false, //不可编辑
	  		method: "post",
	  	});
	  	//添加信息学生选择框
	    $("#add_studentList").combobox({
	  		url: "StudentServlet?method=StudentList&t="+new Date().getTime()+"&from=combox",
	  		onLoadSuccess: function(){
				//默认选择第一条数据
				var data = $(this).combobox("getData");
				$(this).combobox("setValue", data[0].id);
				getStudentSelectedCourseList(data[0].id);
	  		},
	  		onChange:function(id,o){
	  			getStudentSelectedCourseList(id);
	  		}
	  	});
	  	
	  //添加信息课程选择框
	    
	    function getStudentSelectedCourseList(studentId){
		  	//添加信息课程选择框
			    $("#add_courseList").combobox({
			  		url: "AttendanceServlet?method=getStudentSelectedCourseList&t="+new Date().getTime()+"&student_id="+studentId,
			  		onLoadSuccess: function(){
						//默认选择第一条数据
						var data = $(this).combobox("getData");
						$(this).combobox("setValue", data[0].id);
			  		}
			  	});
		  	}	
	  
	  //修改信息学生选择框
	    $("#edit_studentList").combobox({
	  		url: "StudentServlet?method=StudentList&t="+new Date().getTime()+"&from=combox",
	  		onLoadSuccess: function(){
				//默认选择第一条数据
				var data = $(this).combobox("getData");
				$(this).combobox("setValue", data[0].id);
				getEditStudentSelectedCourseList(data[0].id);
	  		},
	  		onChange:function(id,o){
	  			getEditStudentSelectedCourseList(id);
	  		}
	  	});
	    function getEditStudentSelectedCourseList(studentId){
		  	//修改信息课程选择框
			    $("#edit_courseList").combobox({
			  		url: "AttendanceServlet?method=getStudentSelectedCourseList&t="+new Date().getTime()+"&student_id="+studentId,
			  		onLoadSuccess: function(){
						//默认选择第一条数据
						var data = $(this).combobox("getData");
						$(this).combobox("setValue", data[0].id);
			  		}
			  	});
		  	}
	  
	    //搜索按钮监听事件
	  	$("#search-btn").click(function(){
	  		$('#dataList').datagrid('load',{
	  			studentid: $("#studentList").combobox('getValue') == '' ? 0 : $("#studentList").combobox('getValue'),
	  			courseid: $("#courseList").combobox('getValue') == '' ? 0 : $("#courseList").combobox('getValue')
	  		});
	  	});
	    
	  //导出按钮监听事件
	  	$("#export").click(function(){
	  		studentid = $("#studentList").combobox('getValue') == '' ? 0 : $("#studentList").combobox('getValue');
	  		courseid = $("#courseList").combobox('getValue') == '' ? 0 : $("#courseList").combobox('getValue');
	  		url = 'ScoreServlet?method=ExportScoreList&studentid='+studentid+"&courseid="+courseid;
	  		window.location.href = url;
	  	});
	    
	    //清空搜索条件
	  	$("#clear-btn").click(function(){
	    	$('#dataList').datagrid("reload",{});
	    	$("#studentList").combobox('clear');
	    	$("#courseList").combobox('clear');
	    });
	    
	  	function importScore(){
			$("#importForm").submit();
			$.messager.progress({text:'正在上传导入中...'});
			var interval = setInterval(function(){
				var message =  $(window.frames["import_target"].document).find("#message").text();
				if(message != null && message != ''){
					$.messager.progress('close');
					$.messager.alert("消息提醒",message,"info");
					$('#dataList').datagrid("reload");
					clearInterval(interval);
				}
			}, 1000)
		}
	});
	</script>
</head>
<body>
	<!-- 数据列表 -->
	<table id="dataList" cellspacing="0" cellpadding="0"> 
	    
	</table> 
	<!-- 工具栏 -->
	<div id="toolbar">
		<c:if test="${userType != 2}">
		<div style="float: left;"><a id="add" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true">添加</a></div>
		<div style="float: left;" class="datagrid-btn-separator"></div>
		<div style="float: left;"><a id="import" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true">导入</a></div>
		<div style="float: left;" class="datagrid-btn-separator"></div>
		<div style="float: left;"><a id="export" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true">导出</a></div>
		<div style="float: left;" class="datagrid-btn-separator"></div>
		<div style="float: left;"><a id="edit" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true">修改</a></div>
		<div style="float: left;" class="datagrid-btn-separator"></div>
		<div style="float: left; margin-right: 10px;"><a id="delete" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-some-delete',plain:true">删除</a></div>
		<div style="float: left;" class="datagrid-btn-separator"></div>
		</c:if>
		<div style="margin-top: 3px;">
			学生：<input id="studentList" class="easyui-textbox" name="studentList" />
			课程：<input id="courseList" class="easyui-textbox" name="courseList" />
			<a id="search-btn" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true">搜索</a>
			<a id="clear-btn" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true">清空搜索</a>
		</div>
	</div>
	
	<!-- 添加数据窗口 -->
	<div id="addDialog" style="padding: 10px">  
    	<form id="addForm" method="post">
	    	<table cellpadding="8" >
	    		<tr>
	    			<td style="width:40px">学生:</td>
	    			<td colspan="3">
	    				<input id="add_studentList" style="width: 200px; height: 30px;" class="easyui-textbox" name="studentid" />
	    			</td>
	    			<td style="width:80px"></td>
	    		</tr>
	    		<tr>
	    			<td style="width:40px">课程:</td>
	    			<td colspan="3">
	    				<input id="add_courseList" style="width: 200px; height: 30px;" class="easyui-textbox" name="courseid" data-options="required:true, missingMessage:'请选择课程'" />
	    			</td>
	    			<td style="width:80px"></td>
	    		</tr>
	    		
	    		<tr>
	    			<td style="width:40px">成绩:</td>
	    			<td colspan="3">
	    				<input id="add_score" style="width: 200px; height: 30px;" class="easyui-numberbox" data-options="required:true,min:0,precision:2, missingMessage:'请填写正确的成绩'" name="score" />
	    			</td>
	    			<td style="width:80px"></td>
	    		</tr>
	    		
	    		<tr>
	    			<td>备注:</td>
	    			<td>
	    				<textarea id="add_remark" name="remark" style="width: 300px; height: 160px;" class="easyui-textbox" data-options="multiline:true" ></textarea>
	    			</td>
	    		</tr>
	    	</table>
	    </form>
	</div>
	
	<!-- 修改数据窗口 -->
	<div id="editDialog" style="padding: 10px">  
    	<form id="editForm" method="post">
	    	
	    	<input type="hidden" id="edit_id" name="id">
	    	<table cellpadding="8" >
	    		<tr>
	    			<td style="width:40px">学生:</td>
	    			<td colspan="3">
	    				<input id="edit_studentList" style="width: 200px; height: 30px;" class="easyui-textbox" name="studentid" />
	    			</td>
	    			<td style="width:80px"></td>
	    		</tr>
	    		<tr>
	    			<td style="width:40px">课程:</td>
	    			<td colspan="3">
	    				<input id="edit_courseList" style="width: 200px; height: 30px;" class="easyui-textbox" name="courseid" data-options="required:true, missingMessage:'请选择课程'" />
	    			</td>
	    			<td style="width:80px"></td>
	    		</tr>
	    		
	    		<tr>
	    			<td style="width:40px">成绩:</td>
	    			<td colspan="3">
	    				<input id="edit_score" style="width: 200px; height: 30px;" class="easyui-numberbox" data-options="required:true,min:0,precision:2, missingMessage:'请填写正确的成绩'" name="score" />
	    			</td>
	    			<td style="width:80px"></td>
	    		</tr>
	    		
	    		<tr>
	    			<td>备注:</td>
	    			<td>
	    				<textarea id="edit_remark" name="remark" style="width: 300px; height: 160px;" class="easyui-textbox" data-options="multiline:true" ></textarea>
	    			</td>
	    		</tr>
	    	</table>
	    </form>
	</div>
	
	<!-- 导入数据窗口 -->
	<div id="importDialog" style="padding: 10px">  
    	<form id="importForm" method="post" enctype="multipart/form-data" action="ScoreServlet?method=ImportScore" target="import_target">
	    	<table cellpadding="8" >
	    		<tr>
	    			<td>请选择文件:</td>
	    			<td>
	    				<input class="easyui-filebox" name="importScore" data-options="required:true,min:0,precision:2, missingMessage:'请选择文件',prompt:'选择文件'" style="width:200px;">
	    			</td>
	    		</tr>
	    		
	    	</table>
	    </form>
	</div>
<!-- 提交表单处理iframe框架 -->
	<iframe id="import_target" name="import_target"></iframe>	
</body>
</html>