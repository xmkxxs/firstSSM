package com.xm.crud.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.xm.crud.bean.Department;
import com.xm.crud.bean.Msg;
import com.xm.crud.service.DepartmentService;

@Controller
public class DepartmentController {
	
	@Autowired
	private DepartmentService departmentService;
	
	//查询所有人的部门信息
	@ResponseBody
	@RequestMapping("/depts")
	public Msg getDepts(){
		List<Department> list=departmentService.getDepts();
		return Msg.success().add("depts", list);
	}
	
}
