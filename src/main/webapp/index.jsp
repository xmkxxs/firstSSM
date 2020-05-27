<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>员工列表</title>
	<script src="<%=request.getContextPath() %>/static/bootstrap-3.3.7-dist/js/jquery-3.3.1.min.js"></script>
	<link href="<%=request.getContextPath() %>/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="<%=request.getContextPath() %>/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>

<!-- 来到首页后，发送ajax请求到服务器，服务器查询到用户数据后返回json数据，首页用js解析员工数据进行展示 -->
	<script type="text/javascript">
		$(function(){
			/* 页面一进来，调用一个会发送ajax请求的方法，来到第一页 */
			to_page(1);
		});
		
		/* 用于点击页码返回数据展示 ****************************************************/
		function to_page(pn){
			$.ajax({
				type:"get",
				data:"pn="+pn,
				url:"<%=request.getContextPath() %>/emps",
				success:function(response){
					//console.log(response);
					//成功后，服务器会返回json员工数据
					//调用解析数据的方法
					build_emps_table(response);	
					//调用解析分页信息方法
					build_page_info(response);
					//调用解析分页条方法
					build_page_nav(response);
				}
			});
		}
		
		/* 解析用于构建表格数据的方法*****************************************************/
		function build_emps_table(response){
			/* 每次清空一次上次显示的信息，因为是不刷新技术，不清楚当我点击查看第二页时候第一页的数据还显示 */
			$("#emps_table tbody").empty();
			
			/* 获取服务器发来的员工数据 */
			var emps=response.extend.pageInfo.list;
			/* 遍历员工数据 */
			$.each(emps,function(index,item){
				var checkBoxTd=$("<td><input type='checkbox' class='check_item' /></td>")
				var empIdTd=$("<td></td>").append(item.empId);
				var empNameTd=$("<td></td>").append(item.empName);
				var genderTd=$("<td></td>").append(item.gender=='M'?'男':'女');
				var emailTd=$("<td></td>").append(item.email);
				var deptNameTd=$("<td></td>").append(item.department.deptName);
				
				/* 创建两个按钮 */
				var addBtn=$("<button></button>").addClass("btn btn-info edit_btn")
												 .append($("<span></span>").addClass("glyphicon glyphicon-pencil"))
												 .append("&nbsp;编辑");
				var delBtn=$("<button></button>").addClass("btn btn-warning delete_btn")
												 .append($("<span></span>").addClass("glyphicon glyphicon-trash").css("color","red"))
												 .append("&nbsp;删除");
				
				var btnTd=$("<td></td>").append(addBtn).append(" ").append(delBtn);
				
				$("<tr></tr>").append(checkBoxTd)
							  .append(empIdTd).append(empNameTd)
							  .append(genderTd).append(emailTd)
							  .append(deptNameTd)
							  .append(btnTd)
							  .appendTo("#emps_table tbody");
			});
		}
		
		/* 构建分页信息 *****************************************************/
		var currentPage;
		function build_page_info(response){
			currentPage=response.extend.pageInfo.pageNum;
			
			/* 每次清空一次上次显示的信息，因为是不刷新技术，不清楚当我点击查看第二页时候第一页的数据还显示 */
			$("#page_info_area").empty();
			
			$("#page_info_area").append("当前为第&nbsp;"+response.extend.pageInfo.pageNum+
					"&nbsp;页，共&nbsp;"+response.extend.pageInfo.pages+"&nbsp;页，共&nbsp;"+
					response.extend.pageInfo.total+"&nbsp;条记录。");
		}
		
		/* 构建用于展示分页条信息的方法 *****************************************************/
		function build_page_nav(response){
			/* 每次清空一次上次显示的信息，因为是不刷新技术，不清楚当我点击查看第二页时候第一页的数据还显示 */
			$("#page_nav_area").empty();
			
			var ul=$("<ul></ul>").addClass("pagination");
			
			var firstPageLi=$("<li></li>").append($("<a></a>").append("首页").attr("href","#"));
			var prePageLi=$("<li></li>").append($("<a></a>").append($("<span></span>").append("&laquo;")));
			
			
			
			var nextPageLi=$("<li></li>").append($("<a></a>").append($("<span></span>").append("&raquo;")));
			var lastPageLi=$("<li></li>").append($("<a></a>").append("末页").attr("href","#"));
			
			
			
			ul.append(firstPageLi).append(prePageLi);
			
			/* 遍历取出页码号,然后加到ul中 */
			$.each(response.extend.pageInfo.navigatepageNums,function(index,item){
				var numLi=$("<li></li>").append($("<a></a>").append(item));
				
				/* 如果是正在显示的页码，设置成高亮显示 */
				if(response.extend.pageInfo.pageNum==item){
					numLi.addClass("active");
				}
				
				/*  */
				numLi.click(function(){
					to_page(item);
				});
				
				ul.append(numLi);
			});
			
			ul.append(nextPageLi).append(lastPageLi);
			
			var navEle=$("<nav></nav>").append(ul);
			
			$("#page_nav_area").append(navEle);
			
			/* 如果没有前一页了，首页按钮和<<按钮将被禁用 */
			if(response.extend.pageInfo.hasPreviousPage==false){
				firstPageLi.addClass("disabled");
				prePageLi.addClass("disabled");
			}else{
				firstPageLi.click(function(){
					to_page(1);
				});
				
				prePageLi.click(function(){
					to_page(response.extend.pageInfo.pageNum-1);
				});
			}
			
			/* 如果没有下一页了，末页按钮和>>按钮将被禁用 */
			if(response.extend.pageInfo.hasNextPage==false){
				nextPageLi.addClass("disabled");
				lastPageLi.addClass("disabled");
			}else{
				lastPageLi.click(function(){
					to_page(response.extend.pageInfo.pages);
				});
				
				nextPageLi.click(function(){
					to_page(response.extend.pageInfo.pageNum+1);
				});
			}
		}
		
		
/* ======================================================================================= */
		$(function(){
			/* 点击添加员工按钮会打开填写员工信息的模态框 */
			$("#emp_add_modal_btn").click(function(){
				/* 修改保存按钮的id，防止和编辑按钮中的保存混淆，他们共用一个模态框 */
				//$(".save_btn").attr("id","emp_save_btn");
				/* 清空表单，防止上一次提交完成后数据不清空点击按钮后继续显示能继续提交 */
				$("#empAddModal form")[0].reset();
				/* 清空上一次样式 */
				$("#empName_add_input").parent().removeClass("has-error has-success");
				$("#email_add_input").parent().removeClass("has-error has-success");
				$("#empName_add_input").next("span").text("");
				$("#email_add_input").next("span").text("");
				
				/* 弹出之前，要发送ajax请求，查出部门id显示在模态框中的下拉列表中 */
				getDept("#dept_add_select");
				
				/* 模态框被调用,bootstrap中的代码 */
				/* backdrop设置点击空白处窗口不关闭 */
				$("#empAddModal").modal({
					backdrop: 'static'
				});
			});
			
			/* 查出所有部门信息 */
			function getDept(ele){
				/* 每次请求前清空值，防止累加显示 */
				$(ele).empty();
				$.ajax({
					type:"get",
					url:"<%=request.getContextPath() %>/depts",
					success:function(response){
		/* extend: {depts: [{deptId: 5, deptName: "开发部"}, {deptId: 6, deptName: "测试部"}]} */	
						//console.log(response);
						
						/* 遍历部门信息到下拉框中,下拉框再加入到select标签中 */
						$.each(response.extend.depts,function(){
							var optionEle=$("<option></option>").append(this.deptName).attr("value",this.deptId);
							$(ele).append(optionEle);
						});					
					}
				});
			}
			
			
			/* 前端数据校验********************************************************** */
			var ident_empName;/* 此变量用于提交按钮是否能执行，0F，1T */
			
			/* keyup事件能做到边输入边判断用户输入的用户名是否符合规范 */
			$("#empName_add_input").keyup(function(){
				verifyName();
			});
			
			function verifyName(){
				var empName=$("#empName_add_input").val();
				var regName=/(^[a-zA-Z0-9_-]{3,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
					
				if(!regName.test(empName)){
					//格式错误将文本框边框变成红色
					$("#empName_add_input").parent().addClass("has-error");
					$("#empName_add_input").next("span").text("用户名是3-16位英文或2-5位中文的组合");
					ident_empName=0;
					return false;
				}else{
					$("#empName_add_input").parent().removeClass("has-error");
					$("#empName_add_input").parent().addClass("has-success");
					$("#empName_add_input").next("span").text("");
					ident_empName=1;
				}
			}
			
			
			var ident_email;/* 此变量用于提交按钮是否能执行，0F，1T */
			/* 电子邮箱数据校验，且不能重复 */
			$("#email_add_input").keyup(function(){
				verifyEmail();
			});
			
			function verifyEmail(){
				var email=$("#email_add_input").val();
				var regEmail=/^([a-zA-Z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
				
				
				if(!regEmail.test(email)){
					//格式错误将文本框边框变成红色
					$("#email_add_input").parent().addClass("has-error");
					$("#email_add_input").next("span").text("邮箱格式不正确！");
					ident_email=0;
					return false;
				}else{
					/* 向服务器发异步请求，查看邮箱是否已经存在 */
					$.ajax({
						type:"get",
						url:"<%=request.getContextPath() %>/checkEmail",
						data:"email="+email,
						success:function(response){
							//var bo=String.valueOf(response);
							console.log(response);
							if(response){
								$("#email_add_input").parent().addClass("has-error");
								$("#email_add_input").next("span").text("请勿输入他人邮箱！");
								ident_email=0;
								return false;
							}else{
								$("#email_add_input").parent().removeClass("has-error");
								$("#email_add_input").parent().addClass("has-success");
								$("#email_add_input").next("span").text("");
								ident_email=1;
							}
						}
					});
				}
			}
			
			
			/* 点击保存按钮提交数据 */
			$("#emp_save_btn").click(function(){
				verifySubmit();
			});
			
			function verifySubmit(){
				/* 首先检测姓名和邮箱是否为空 */
				var empName=$("#empName_add_input").val();
				var email=$("#email_add_input").val();
				if(empName=="" && email==""){
					alert("请输入姓名以及邮箱 ！");
					return false;
				}
				if(empName=="" && email!=""){
					alert("请输入姓名 ！");
					return false;
				}
				if(email=="" && empName!==""){
					alert("请输入邮箱 ！");
					return false;
				}
				if(empName!="" && email!=""){
					/* 字段不为空了且全部输入格式正确及不重复邮箱才能提交,用ident_empName和ident_email变量 */
					if(ident_empName==0 || ident_email==0){
						alert("请按规范录入资料后再保存 ！")
						return false;
					}else{
						/* 填写的数据提交给服务器进行保存 */
						/* 我们先将表单中的用户填写的数据提取出来 */
						/* jq提供serialize方法，将表单中的name和用户填写的数据会被提取 */
						/* 提取的格式是如：empName=张三&email=xxx@163.com */
						var result=$("#empAddModal form").serialize();
						/* 然后数据发送到后端进行保存，保存前后端还会进行一次数据格式校验 */
						$.ajax({
							type:"post",
							url:"<%=request.getContextPath() %>/emp",
							data:result,
							success:function(response){
								if(response.code==100){
									//跳出保存成功提示
									alert(response.msg);
									//员工保存成功，模态框关闭，页面跳转到最后一页能看到刚添加的数据
									$('#empAddModal').modal('hide')
									/* 分页插件会自动帮我们跳转到最后一页，即使你传入的数据大于总页数 */
									to_page(9999);
								}else{
									//显示失败信息,没有错误信息的会提示undefined
									if(undefined!=response.extend.errorFields.email){
										alert("邮箱不合规范或使用了他人的邮箱 ！")
									}
									if(undefined!=response.extend.errorFields.empName){
										alert("姓名输入不合规范！")
									}
								}
							}
						});
					}
				}
			}
			
/* ======================================================================================= */
			/* 开始编辑按钮 */
			/* 编辑按钮由于是js代码生成的，所以绑定有点困难 */
			/* 用jq的on方法，第一个参数是点击事件，第二个参数是获取按钮的class，document是所有文档中 */	
			$(document).on("click",".edit_btn",function(){
				/* 点击编辑按钮后显示模态框 */
				/* 先每次清空模态框中内容和样式 */
				$("#empAddModal form")[0].reset();
				/* 清空上一次样式 */
				$("#empName_add_input").parent().removeClass("has-error has-success");
				$("#email_add_input").parent().removeClass("has-error has-success");
				$("#empName_add_input").next("span").text("");
				$("#email_add_input").next("span").text("");
				
				/* 我们的模态框用的是添加员工的模态框，所以里面有些提示属性需要改 */
				$("#myModalLabel").html("员工修改");
				$("#emp_save_btn").html("更新");
				/* 撤销保存按钮之前绑定的事件 */
				$(".save_btn").unbind();
				/* 弹出模态框之前，也要查询出此员工和部门的信息展示在模态框中 */
				getDept("#dept_add_select");
				/* 获取此员工的id */
				var id=$(this).parent().parent().children().html();
				getEmp(id);
				
				/* 显示模态框 */
				$("#empAddModal").modal({
					backdrop: 'static'
				});
				
				/* 点击保存按钮事件 */
				$("#emp_save_btn").click(function(){
					
					//verifySubmit();
					$.ajax({
						url:"<%=request.getContextPath() %>/updateEmp/"+id,
						type:"post",
						data:$("#empAddModal form").serialize()+"&_method=PUT",
						success:function(response){
							alert(response.msg);
							/* 员工修改成功与否，都会自动关闭对话框，还是回到本页面 */
							$("#empAddModal").modal("hide");
							to_page(currentPage);
						}
					});
				});
			});
			
			var empName;
			var email;
			var gender;
			var dId;
			/* 获取员工信息显示在编辑按钮的模态框中 */
			function getEmp(id){
				$.ajax({
					url:"<%=request.getContextPath() %>/emp/"+id,
					type:"GET",
					success:function(response){
						empName=response.extend.emp.empName;
						$("#empName_add_input").attr("placeholder","原姓名："+empName);
						email=response.extend.emp.email;
						$("#email_add_input").attr("placeholder","原邮件：："+email);
						gender=response.extend.emp.gender;
						$("#empAddModal input[name=gender]").val([gender]);
						dId=response.extend.emp.dId;
						$("#empAddModal select").val([dId]);
					}
				});
			}
			
/* ======================================================================================= */			
			/* 开始删除按钮 */
			$(document).on("click",".delete_btn",function(){
				/* 弹出确认删除对话框 ,find是找里面第二个td元素*/
				var empName=$(this).parent().parent().find("td:eq(2)").html();
				/* 获取此员工的id */
				var id=$(this).parent().parent().find("td:eq(1)").html();
				var flag=confirm("确定删除"+empName+"员工吗？");
				if(flag){
					$.ajax({
						url:"<%=request.getContextPath() %>/deleteEmp/"+id,
						type:"delete",
						success:function(response){
							alert(response.msg);
							/* 回到本页，如果删除最后一页的唯一一个数据，我们开了分页插件合理化，删除后最后一页没了，回到上一页 */
							to_page(currentPage);
							/* 清除全选被选中 ，应对各种情况*/
							$("#check_all").prop("checked",false);
						}
					});
				}
			});
/* ======================================================================================= */	
			/* 完成全选/全部选 */			
			$("#check_all").click(function(){
				/* 查看全选是否是选中的状态 */
				/* attr是获取我们已经在标签中写的属性值，而prop可以获取我们写在标签中的属性值 */
				var bool=$(this).prop("checked");
				/* 多选框是否被选中取决于 全选是否开启*/
				$(".check_item").prop("checked",bool);
				
				
			});
			
			/* 我们如果点满了多选框，那么全选按钮也得选中 */
			$(document).on("click",".check_item",function(){
				/* 判断多选框是否选满了 */
				/* :checked作用是匹配所有被选中的选择器 */
				var len=$(".check_item:checked").length
				/* 动态获取页面有几个多选按钮 */
				var allLen=$(".check_item").length;
				/* 如果选中的个数达到了总个数，全选按钮自动选择 */
				var bool=len==allLen;
				$("#check_all").prop("checked",bool);
			});
			
/* ======================================================================================= */
			/* 批量删除按钮 */
			$("#emp_delete_all_btn").click(function(){
				/* 遍历取出比选中按钮的员工姓名和id，姓名进行页面删除时的提示，id用于传到服务器按id进行删除 */
				var empName="";
				var empId="";
				/* :checked作用是匹配所有被选中的选择器 */
				$.each($(".check_item:checked"),function(){
					empName += $(this).parent().parent().find("td:eq(2)").html()+"，";
					empId += $(this).parent().parent().find("td:eq(1)").html()+"-";
				});
				
				//如果没有选择员工直接点击删除按钮
				if(empName==""){
					alert("请勾选要删除的员工！");
					return false;
				}
				
				/* 将遍历出来的姓名最后一个逗号去掉 */
				empName=empName.substring(0,empName.length-1);
				/* 将遍历出来的姓名最后一个-去掉，传到服务器后，服务器会将-都去掉，然后封装成List */
				empId=empId.substring(0,empName.length-1);
				
				var flag=confirm("确定删除【"+empName+"】吗？");
				
				if(flag){
					$.ajax({
						url:"<%=request.getContextPath() %>/deleteEmps/"+empId,
						type:"delete",
						success:function(response){
							alert(response.msg);
							//回到当前页面
							to_page(currentPage);
							/* 清除全选被选中 */
							$("#check_all").prop("checked",false);
						}
					});
				}
			});
		
		
	});
	</script>
</head>
<body>

	<!-- 搭建员工显示页面 -->
	<div class="container">
	<!-- 第一行 ，标题-->
		<div class="row">
			<div class="col-md-12">
				<h1>员工后台</h1>
			</div>
		</div>
		
	<!-- 第二行 ，按钮-->	
		<div class="row">
  			<div class="col-md-3 col-md-offset-10">
  				<button class="btn btn-default btn btn-info" type="submit" id="emp_add_modal_btn">添加员工</button>
  				<button class="btn btn-default btn btn-danger" type="submit" id="emp_delete_all_btn">批量删除</button>
  			</div>
		</div>
		
	<!-- 第三行 ，表格-->	
		<div class="row" style="padding-top:20px">
			<div class="col-md-12">
				<table class="table table-bordered" id="emps_table">
					<thead>
						<tr>
							<th>
								<span>全选&nbsp;</span> 
								<span style="float:right; padding-top:1px"><input type="checkbox" id="check_all" /></span>
							</th>
							<th>#</th>
							<th>姓名</th>
							<th>邮箱</th>
							<th>性别</th>
							<th>部门</th>
							<th>操作</th>
						</tr>	
					</thead>
					<tbody></tbody>	
				</table>
			</div>
		</div>
		
	<!-- 第四行 ，分页-->	
		<div class="row">
		<!-- 分页信息 -->
			<div class="col-md-4 " id="page_info_area"></div>
		</div>
		<div  class="row">
		<!-- 分页条 -->	
			<div class="col-md-5 col-md-offset-4 "  id="page_nav_area"></div>
		</div>

	</div>
<!-- ============================================================================================= -->	
	<!-- 模态框，点击添加员工按钮会弹出此窗口 -->
<div class="modal fade" id="empAddModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">员工录入</h4>
      </div>
      <div class="modal-body">
        <!-- 表单 -->
		 <form class="form-horizontal">
			  <div class="form-group">
			    <label for="inputEmail3" class="col-sm-2 control-label">姓名</label>
			    <div class="col-sm-10">
			      <input type="text" name="empName" class="form-control" id="empName_add_input" placeholder="请输入员工姓名">
			      <span class="help-block"></span>
			    </div>
			  </div>
		
			  <div class="form-group">
			    <label for="inputPassword3" class="col-sm-2 control-label">电子邮件</label>
			    <div class="col-sm-10">
			      <input type="text" name="email" class="form-control" id="email_add_input" placeholder="zhangsan@163.com">
			      <span class="help-block"></span>
			    </div>
			  </div>
			  
			  <div class="form-group">
			    <label for="inputPassword3" class="col-sm-2 control-label">性别</label>
			    <div class="col-sm-10">
			      <label class="radio-inline">
					  <input type="radio" name="gender" id="gender1_add_input" value="M" checked="checked"> 男
				  </label>
				  <label class="radio-inline">
					  <input type="radio" name="gender" id="gender2_add_input" value="F"> 女
				  </label>
			    </div>
			  </div>
			  
			  <div class="form-group">
			    <label for="inputPassword3" class="col-sm-2 control-label">部门</label>
			    <div class="col-xs-3">
			    <!-- 提交部门id到数据库即可 -->
			    	<select class="form-control" name="dId" id="dept_add_select"></select>
			    </div>
			  </div>
		</form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
        <button type="button" class="btn btn-primary save_btn" id="emp_save_btn" >保存</button>
      </div>
    </div>
  </div>
</div>
	
</body>
</html>