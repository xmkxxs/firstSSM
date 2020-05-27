package com.xm.crud.test;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.mybatis.generator.api.MyBatisGenerator;
import org.mybatis.generator.config.Configuration;
import org.mybatis.generator.config.xml.ConfigurationParser;
import org.mybatis.generator.exception.InvalidConfigurationException;
import org.mybatis.generator.exception.XMLParserException;
import org.mybatis.generator.internal.DefaultShellCallback;

public class MBGTest {
	/**
	 * 对逆向工程mbg.xml进行运行
	 * 此代码是从mybatis文档中扣的，包括mgb.xml也是扣的，改改就行了
	 * 
	 * @throws InvalidConfigurationException 
	 * @throws XMLParserException 
	 * @throws IOException 
	 * @throws InterruptedException 
	 * @throws SQLException 
	 * **/
	public static void main(String[] args) throws InvalidConfigurationException, IOException, XMLParserException, SQLException, InterruptedException {
		// TODO Auto-generated method stub
		List<String> warnings = new ArrayList<String>();
		   boolean overwrite = true;
		   //指定配置文件位置
		   File configFile = new File("mbg.xml");
		   ConfigurationParser cp = new ConfigurationParser(warnings);
		   Configuration config = cp.parseConfiguration(configFile);
		   DefaultShellCallback callback = new DefaultShellCallback(overwrite);
		   MyBatisGenerator myBatisGenerator = new MyBatisGenerator(config, callback, warnings);
		   myBatisGenerator.generate(null);
	}

}
