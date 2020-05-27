<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>员工列表list2</title>
<script src="<%=request.getContextPath() %>/static/bootstrap-3.3.7-dist/js/jquery-3.3.1.min.js"></script>
<link href="<%=request.getContextPath() %>/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
<script src="<%=request.getContextPath() %>/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
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
  				<button class="btn btn-default btn btn-info" type="submit">添加员工</button>
  				<button class="btn btn-default btn btn-danger" type="submit">删除员工</button>
  			</div>
		</div>
		
	<!-- 第三行 ，表格-->	
		<div class="row" style="padding-top:20px">
			<div class="col-md-12">
				<table class="table table-bordered">
					<tr>
						<th>#</th>
						<th>姓名</th>
						<th>邮箱</th>
						<th>性别</th>
						<th>部门</th>
						<th>操作</th>
					</tr>	
					<!-- 使用c:foreach遍历出服务器查询出来的数据 -->
					<c:forEach items="${pageInfo.getList() }" var="emp">
						<tr>
							<td>${emp.empId }</td>
							<td>${emp.empName }</td>
							<td>${emp.email }</td>
							<td>${emp.gender=="M"?"男":"女" }</td>
							<td>${emp.department.deptName }</td>
							<td>
								<button class="btn btn-info">
									<span class="glyphicon glyphicon-pencil " aria-hidden="true"></span>
									&nbsp;编辑
								</button>
								<button class="btn btn-warning">
									<span class="glyphicon glyphicon-trash " style="color:red" aria-hidden="true"></span>
									&nbsp;删除
							    </button>
							</td>
						</tr>		
					</c:forEach>	
				</table>
			</div>
		</div>
		
	<!-- 第四行 ，分页-->	
		<div class="row">
		<!-- 分页信息 -->
			<div class="col-md-4 ">
			当前为${pageInfo.getPageNum() }页，
			共${pageInfo.getPages() }页，
			共${pageInfo.getTotal() }条记录。						
			</div>
		<!-- 分页条 -->	
			<div class="col-md-8 ">
				<nav aria-label="Page navigation">
				<ul class="pagination">
				<li><a href="<%=request.getContextPath() %>/emps?pn=1">首页</a></li>
				
				<!-- 如果有上一页，就显示<<这个图标按钮 -->
				<c:if test="${pageInfo.hasPreviousPage }">
					<li>
				    <a href="<%=request.getContextPath() %>/emps?pn=${pageInfo.getPageNum()-1 }" aria-label="Previous">
				      <span aria-hidden="true">&laquo;</span>
				    </a>
				  </li>
				</c:if>
				
				  <!-- 遍历显示页码 -->
				  <c:forEach items="${pageInfo.getNavigatepageNums() }" var="page_Num">
				  <!-- 如果是当前页面，当前页码设置高亮 -->
				  	 <c:if test="${page_Num == pageInfo.getPageNum() }">
				  	 	<li class="active"><a href="#">${page_Num }</a></li>
				  	 </c:if>
				  	 <!-- 如果不是当前页面，正常显示 -->
				  	 <c:if test="${page_Num != pageInfo.getPageNum() }">
				  	 	<li><a href="<%=request.getContextPath() %>/emps?pn=${page_Num }">${page_Num }</a></li>
				  	 </c:if>
				  </c:forEach>
				  
				  <!-- 是否有上一页，有就显示下一页>>图标按钮 -->
				   <c:if test="${pageInfo.hasNextPage }">
				  	<li>
					    <a href="<%=request.getContextPath() %>/emps?pn=${pageInfo.getPageNum()+1 }" aria-label="Next">
					      <span aria-hidden="true">&raquo;</span>
					    </a>
				  	</li>
				  </c:if>
				  
				  <!-- 点击末页直接来到总页 -->
				  <li><a href="<%=request.getContextPath() %>/emps?pn=${pageInfo.getPages() }">末页</a></li>
				</ul>
			</nav>
			</div>
		</div>

	</div>
	
</body>
</html>