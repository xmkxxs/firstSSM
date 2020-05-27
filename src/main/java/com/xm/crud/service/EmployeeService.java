package com.xm.crud.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.xm.crud.bean.Employee;
import com.xm.crud.bean.EmployeeExample;
import com.xm.crud.bean.EmployeeExample.Criteria;
import com.xm.crud.dao.EmployeeMapper;

@Service
public class EmployeeService {
	
	@Autowired
	EmployeeMapper employeeMapper;
	
	//查询所有员工
	public List<Employee> getAll() {
		//null为查询条件为null 
		return employeeMapper.selectByExampleWithDept(null);
	}

	//员工保存方法
	public void saveEmp(Employee employee) {
		// TODO Auto-generated method stub
		employeeMapper.insertSelective(employee);
	}

	//检查邮箱是否在数据库已经存在
	public boolean checkEmail(String email) {
		EmployeeExample example=new EmployeeExample();
		Criteria c=example.createCriteria();
		c.andEmailEqualTo(email);
		long count=employeeMapper.countByExample(example);
		//如果查询结果是大于1的就是说明邮箱存在，为0是不存在
		boolean b=count>=1?true:false;
		return b;
	}

	/**
	 * 按id查员工信息
	 * */
	public Employee getEmp(Integer id) {
		Employee employee= employeeMapper.selectByPrimaryKey(id);
		return employee;
	}

	/**
	 * 员工更新
	 * **/
	public void updateEmp(Employee employee) {
		
		employeeMapper.updateByPrimaryKeySelective(employee);
	}

	/**
	 * 员工单个删除
	 * **/
	public void deleteEmp(Integer id) {
		employeeMapper.deleteByPrimaryKey(id);
	}

	/**
	 * 员工批量删除
	 * **/
	public void deleteEmps(List<Integer> ids) {
		//实例化一个条件类,会将list中的id的sql语句写成select from where id on 这个list中的id
		EmployeeExample example=new EmployeeExample();
		Criteria c=example.createCriteria();
		c.andEmpIdIn(ids);
		employeeMapper.deleteByExample(example);
	}
	
}
