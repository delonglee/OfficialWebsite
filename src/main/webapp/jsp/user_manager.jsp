<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@include file="../common/head.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>
	<script type="text/javascript">
	
		/*查询*/
		function doSearch(){
			/* 执行load方法  {}里是参数，key是field对应的userName,传的参数是value */
			$("#datagrid").datagrid("load",{
				'name':$("#name").val()
				})
		}
		
		/* 删除 */
		function doDelete(){
			//getSelections none 返回所有被选中的行，当没有记录被选中的时候将返回一个空数组。得到的是object对象 
			var selectedIds = $("#datagrid").datagrid("getSelections");
	/* 		//输出selectedIds
			console.log(selectedIds); */
			var ids = [];//[1,2,3]
			//遍历
			for(var i in selectedIds){
				ids.push(selectedIds[i].id);
			}
			ids = ids.join(",");// 1,2,3
			if (ids.length == 0) {
				$.messager.alert("系统提示", "请选择要删除的数据");
				return;
			}
			$.messager.confirm("系统提示", "您确认要删除么", function(r){
				if (r){
					$.post(
						"${ctx}/user/delete.action",
						{ids:ids}, 
						function(result) {
							$.messager.alert("系统提示", result.msg);
							if(result.status == 0) {
								$("#datagrid").datagrid("reload");
							}
						},
						"json"
					);
				}
			})
		}
		
		var url;
		/* 打开添加的dialog */
		function openAddDialog(){
			$("#dialog").dialog("open").dialog("setTitle","添加信息");
			url =  "${ctx}/user/add.action";
			$("#form").form("clear");
		}
		
		/* 打开修改dialog */
		function openUpdateDialog(){
			var selections = $("#datagrid").datagrid("getSelections");
			if (selections.length == 0) {
				$.messager.alert('系统提示',"请选择要修改的数据");
				return;				
			}
			var row = selections[0];
			$("#dialog").dialog("open").dialog("setTitle","修改信息");
			url = "${ctx}/user/update.action";
			$("#form").form("load",row);
		}
		
		/* 关闭dialog */
		function closeDialog(){
			$("#dialog").dialog("close");
		}
		
		/* 添加和修改的保存 */
		function doSave(){
			$("#form").form('submit',{
				url:url,
				/* 在提交之前触发，返回false可以终止提交。 */
				onSubmit:function(){
					//do some check  做一些判断
					if($("#roleName").combobox("getValue") == "") {
						$.messager.alert("系统提示","请选择用户角色");
						//终止提交
						return false;
					}
					//做表单字段验证，当所有字段都有效的时候返回true。该方法使用validatebox(验证框)插件。
					return $(this).form("validate");
				},
				success:function (data){
					//json字符串转化成json格式
					var data = eval('('+data+')');
					if (data.status == Util.SUCCESS) {
						$.messager.alert("系统提示",data.msg);
						$("#dialog").dialog("close");
						//reload 重载行。等同于'load'方法，但是它将保持在当前页。
						$("#datagrid").datagrid("reload");
						
					}
				}
			});
		}
	</script>
</head>
<body>
	<table id="datagrid" class="easyui-datagrid" pagination="true" fitColumns="true" pagination="true"
		data-options="rownumbers:true,fit:true,singleSelect:false,url:'${ctx}/user/userManager.action',method:'get',toolbar:'#toolbar'">
		<thead>
			<tr>
				<th data-options="field:'cb',checkbox:true,align:'center'"></th>
				<th data-options="field:'id',width:80,align:'center'">编号</th>
				<th data-options="field:'name',width:100,align:'center'">用户名</th>
				<th data-options="field:'password',width:80,align:'center'">密码</th>
				<th data-options="field:'trueName',width:80,align:'center'">真实姓名</th>
				<th data-options="field:'email',width:180,align:'center'">邮件</th>
				<th data-options="field:'phone',width:120,align:'center'">联系电话</th>
				<th data-options="field:'roleName',width:60,align:'center'">角色</th>
			</tr>
		</thead>
	</table>
	
	<!-- toolbar开始 -->
	<div id="toolbar">
	<div></div>
		<a class="easyui-linkbutton" iconCls="icon-add" href="javascript:openAddDialog()">添加</a>
		<a class="easyui-linkbutton" iconCls="icon-edit" href="javascript:openUpdateDialog()">修改</a>
		<a class="easyui-linkbutton" href="javascript:doDelete()" iconCls="icon-remove">删除</a>
		<input id="name" class="easyui-textbox" data-options="prompt:'用户名'" style="width:200px"></input>
		<a href="javascript:doSearch();" class="easyui-linkbutton" iconCls="icon-search">搜索</a>
	</div>
	<!-- toolbar结束 -->
	
	<!-- 添加和修改的dialog 开始 -->
	<div id="dialog" class="easyui-dialog" style="width: 650;height: 280,padding: 10px 20px" buttons="#dialog-button" closed="true">
		<form action="" id="form" method="post">
			<input type="hidden" id="id" name="id"/>
			<table cellspacing="8px">
				<tr>
					<td>用户名：</td>
					<td><input type="text" id="name" name="name" class="easyui-validatebox" required="true"/><font color="red">*</font></td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td>密码：</td>
					<td><input type="text" id="password" name="password" class="easyui-validatebox" required="true"/><font color="red">*</font></td>
				</tr>
				<tr>
					<td>真实姓名：</td>
					<td><input type="text" id="trueName" name="trueName" class="easyui-validatebox" required="true"/><font color="red">*</font></td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td>邮箱：</td>
					<td><input type="text" id="email" name="email" class="easyui-validatebox" required="true" validType="email"/><font color="red">*</font></td>
				</tr>
				<tr>
					<td>联系电话：</td>
					<td><input type="text" id="phone" name="phone" class="easyui-validatebox" required="true"/><font color="red">*</font></td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td>用户角色：</td>
					<td>
						<select class="easyui-combobox" id="roleName" name="roleName" style="width:160">
							<option></option>
							<option value="系统管理员">系统管理员</option>
							<option value="销售主管">销售主管</option>
							<option value="客户经理">客户经理</option>
							<option value="高管">高管</option>
						</select>
						<font color="red">*</font>
					</td>
				</tr>
			</table>
		</form>	
	</div>
	<!-- 添加和修改的dialog 结束 -->
	
	<!-- dialog-button 开始 -->
	<div id="dialog-button">
		<a href="javascript:doSave()" class="easyui-linkbutton" iconCls="icon-ok">保存</a>
		<a href="javascript:closeDialog()" class="easyui-linkbutton" iconCls="icon-cancel">取消</a>
	</div>
	<!-- dialog-button 结束 -->
	
</body>
</html>