package com.xm.crud.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.validation.Valid;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.xm.crud.bean.Employee;
import com.xm.crud.bean.Msg;
import com.xm.crud.service.EmployeeService;

@Controller
public class EmployeeController {
	
	@Autowired
	EmployeeService employeeService;
	
	//分页查询员工数据
	/**
	 * 此方法不用了，用下面的getEmpsWithJson的返回json数据的方法
	 * 此方法用到的页面时index2.jsp，访问index2.jsp后会向此服务器发送请求，此方法
	 * 会将员工信息都查出来，然后跳转到list2.jsp页面将信息显示出来
	 * 但list2.jsp中怎么搭建出来的效果值得研究
	 * */
	//@RequestMapping("/emps")
	public String getEmps(@RequestParam(value="pn",defaultValue="1")Integer pn,Model model){
		//在查询之前，需要调用分页方法,传入页码以及每页展示几个数据
		PageHelper.startPage(pn, 5);
		//查询员工所有数据,紧跟着分页方法的查出来的数据就会分页。
		List<Employee> emps=employeeService.getAll();
		//封装了分页信息,4代表底部的页码，每次展示4个
		//再想获取emps用page.getList()
		PageInfo page=new PageInfo(emps,4);
		model.addAttribute("pageInfo",page);
		//跳转到list页面
		return "list2";
	}
	
	
	//分页查询员工数据，返回json格式数据，用ajax向服务器发起请求
	/**
	 * @ResponseBody会将方法的返回值自动转换成json
	 * 导入jackson包
	 * Msg是自己设计的通用返回类，在bean包下
	 * **/
	@ResponseBody
	@RequestMapping("/emps")
	public Msg getEmpsWithJson(@RequestParam(value="pn",defaultValue="1")Integer pn){
		//在查询之前，需要调用分页方法,传入页码以及每页展示几个数据
				PageHelper.startPage(pn, 5);
				//查询员工所有数据,紧跟着分页方法的查出来的数据就会分页。
				List<Employee> emps=employeeService.getAll();
				//封装了分页信息,4代表底部的页码，每次展示4个
				//再想获取emps用page.getList()
				PageInfo page=new PageInfo(emps,4);
				return Msg.success().add("pageInfo",page);
	}
	
	
	/**
	 * 员工保存方法
	 * REST风格
	 * */
	@RequestMapping(value="/emp",method=RequestMethod.POST)
	@ResponseBody
	//提交过来的数据自动封装成Employee的POJO，但要求是表单中的各个name要和bean中的属性名一致
	public Msg saveEmp(@Valid Employee employee,BindingResult result){
		if(result.hasErrors()){
			//用户数据后台校验失败
			Map<String,Object>map=new HashMap();
			//获取所有失败信息
			List<FieldError> errors=result.getFieldErrors();
			for(FieldError fieldError:errors){
				map.put(fieldError.getField(), fieldError.getDefaultMessage());
			}
			return Msg.fail().add("errorFields", map);
		}else{
			//用户数据后台校验成功
			//调用保存员工的方法
			employeeService.saveEmp(employee);
			return Msg.success();
		}
		
	}
	
	/**
	 * 检测邮箱是否已经存在
	 * */
	@RequestMapping(value="/checkEmail")
	@ResponseBody
	public boolean checkEmail(@RequestParam("email")String email){
		boolean bool=employeeService.checkEmail(email);
		return bool;
	}
	
	
	/**
	 * 查询指定员工信息，用于编辑按钮
	 * **/
	@RequestMapping(value="/emp/{id}",method=RequestMethod.GET)
	@ResponseBody
	public Msg getEmp(@PathVariable("id")Integer id){
		Employee employee= employeeService.getEmp(id);
		return Msg.success().add("emp", employee);
		
	}
	
	/**
	 * 保存员工修改的信息
	 * **/
	@ResponseBody
	@RequestMapping(value="/updateEmp/{empId}",method=RequestMethod.PUT)
	public Msg saveEmp(Employee employee){
		employeeService.updateEmp(employee);
		return Msg.success();
	}
	
	/**
	 * 单个删除员工
	 * **/
	@ResponseBody
	@RequestMapping(value="/deleteEmp/{id}",method=RequestMethod.DELETE)
	public Msg deleteEmpId(@PathVariable("id")Integer id){
		employeeService.deleteEmp(id);
		return Msg.success();
	}
	
	/**
	 * 批量删除员工
	 * **/
	@ResponseBody
	@RequestMapping(value="/deleteEmps/{ids}",method=RequestMethod.DELETE)
	public Msg deleteEmps(@PathVariable("ids")String ids){
		//分割传过来的id中的-符号
		String[] str=ids.split("-");
		List<Integer> delIds=new ArrayList();
		for(String id:str){
			delIds.add(Integer.parseInt(id));
		}
		employeeService.deleteEmps(delIds);
		return Msg.success();
	}
	
}
