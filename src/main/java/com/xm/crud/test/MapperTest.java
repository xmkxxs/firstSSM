package com.xm.crud.test;

import java.util.UUID;

import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.xm.crud.bean.Department;
import com.xm.crud.bean.Employee;
import com.xm.crud.dao.DepartmentMapper;
import com.xm.crud.dao.EmployeeMapper;




public class MapperTest {
	ApplicationContext ioc=new ClassPathXmlApplicationContext("applicationContext.xml");
	
	@Test
	public void testCRUD(){
		DepartmentMapper dm=ioc.getBean(DepartmentMapper.class);
		dm.insertSelective(new Department(null,"开发部"));
		dm.insertSelective(new Department(null,"测试部"));
		
		EmployeeMapper em=ioc.getBean(EmployeeMapper.class);
		em.insertSelective(new Employee(null,"looo","M","Jerry@163.com",6));
		}
		
		@Test
		public void testCRUD2(){
			//执行批量插入
			SqlSession ss=(SqlSession) ioc.getBean("sqlSession");
			EmployeeMapper empp=ss.getMapper(EmployeeMapper.class);
			for(int i=0;i<1000;i++){
				String uuid=UUID.randomUUID().toString().substring(0,5)+i;
				empp.insertSelective(new Employee(null,uuid,"M",uuid+"@163.com",6));
			}
	}


}
