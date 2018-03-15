package com.reps.platform.dsc;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.StringUtils;

import com.reps.core.SpringContext;
import com.reps.core.orm.IJdbcDao;
import com.reps.dsc.core.data.DataField;

public class PersonHandle implements BaseOperateInterface {
	private IJdbcDao jdbcDao=(IJdbcDao)SpringContext.getBean("jdbcDao");
	
	/**
	 * 
	* @author zds
	* @date  2016-4-20 上午10:47:11
	* @param relationList
	* @throws Exception
	* @return void
	 */
	@Override
	public void save(List<StandardDataRelation> relationList) throws Exception{
		
		StringBuffer insertFields = new StringBuffer();
		StringBuffer insertValues = new StringBuffer();
		List<Object> values = new ArrayList<Object>();
		
		DataField icType=null;
		//获取证件类型
		for(StandardDataRelation relation:relationList){
			DataField df=relation.getDataField();
			String standardName=relation.getStandardName();
			if("证件类型".equalsIgnoreCase(standardName)){
				if(df!=null&&df.getValue()!=null){
					icType=df;
				}
			}
		}
		
		//拼接sql字符串
		int index=0;
		for(int i=0;i<relationList.size();i++){
			StandardDataRelation relation=relationList.get(i);
			DataField df=relation.getDataField();
			MappingField mf=relation.getMappingField();
			String standardName=relation.getStandardName();
			
			//判断id是否存在该值
			if("ID".equalsIgnoreCase(standardName)){
				//判断数据库中是否存在该记录
				if(df!=null&&df.getValue()!=null){
					String idValue=df.getValue().toString();
					String findStr=" select count(*) from reps_sys_person where id='"+idValue+"' ";
					int count=jdbcDao.queryForInt(findStr);
					if(count>0){
						throw new Exception("添加--》数据对象【人员基本信息】的数据项【"+standardName+"="+idValue+"】对应人员基本信息已存在");
					}
				}
			}
			//判断身份证号是否重复
			if("证件号码".equalsIgnoreCase(standardName)&&icType!=null&&"1".equalsIgnoreCase(icType.getValue().toString())){
				//判断数据库中身份证号是否重复
				if(df!=null&&df.getValue()!=null){
					String icValue=df.getValue().toString();
					String findStr=" select count(*) from reps_sys_person where ic_number='"+icValue+"' ";
					int count=jdbcDao.queryForInt(findStr);
					if(count>0){
						throw new Exception("添加--》数据对象【人员基本信息】的数据项【"+standardName+"="+icValue+"】对应人员信息已存在");
					}
				}
			}
			if(df!=null){
				if(index==0){
					insertFields.append(" " + mf.getProperty());
					insertValues.append(" ?");
					index++;
				}else{
					insertFields.append("," + mf.getProperty());
					insertValues.append(",?");
				}
				values.add(df.getValue());
			}
		}
		
		if(insertFields.length()>0&&insertValues.length()>0){
			//记录初始化为有效
			insertFields.append(",valid_record");
			insertValues.append(",?");
			values.add(1);
			String insert = "Insert into reps_sys_person (" + insertFields.toString() + ")values(" + insertValues.toString() + ")";
			jdbcDao.update(insert, values.toArray());
		}else{
			throw new Exception("添加--》数据对象【人员基本信息】的数据项不能为空");
		}
	}
	
	/**
	 * 
	* @author zds
	* @date  2016-4-18 下午2:25:25
	* @param relationList 要修改的字段列表
	* @return
	* @throws Exception
	* @return boolean
	 */
	@Override
	public boolean update(List<StandardDataRelation> relationList) throws Exception {
		
		StringBuffer update = new StringBuffer("update reps_sys_person set ");
		List<Object> values = new ArrayList<Object>();
		String idValue=null;
		DataField icType=null;
		//获取证件类型及ID值
		for(StandardDataRelation relation:relationList){
			DataField df=relation.getDataField();
			String standardName=relation.getStandardName();
			if("证件类型".equalsIgnoreCase(standardName)){
				if(df!=null&&df.getValue()!=null){
					icType=df;
				}
			}
			if("ID".equalsIgnoreCase(standardName)){
				//判断数据库中是否存在该记录
				if(df!=null&&df.getValue()!=null){
					idValue=df.getValue().toString();
				}
			}
		}
		
		//拼接sql字符串
		int index=0;
		for(int i=0;i<relationList.size();i++){
			StandardDataRelation relation=relationList.get(i);
			DataField df=relation.getDataField();
			MappingField mf=relation.getMappingField();
			String standardName=relation.getStandardName();
			
			//判断id是否存在该值
			if("ID".equalsIgnoreCase(standardName)){
				//判断数据库中是否存在该记录
				if(df!=null&&df.getValue()!=null){
					String findStr=" select count(*) from reps_sys_person where id='"+idValue+"' ";
					int count=jdbcDao.queryForInt(findStr);
					if(count<1){
						throw new Exception("更新--》数据对象【人员基本信息】的数据项【"+standardName+"="+idValue+"】对应人员信息不存在");
					}
				}
			}
			//判断身份证号是否重复
			if("证件号码".equalsIgnoreCase(standardName)&&icType!=null&&"1".equalsIgnoreCase(icType.getValue().toString())){
				//判断数据库中身份证号是否重复
				if(df!=null&&df.getValue()!=null){
					String icValue=df.getValue().toString();
					String findStr=" select count(*) from reps_sys_person where id!='"+idValue+"' and ic_number='"+icValue+"' ";
					int count=jdbcDao.queryForInt(findStr);
					if(count>0){
						throw new Exception("更新--》数据对象【人员基本信息】的数据项【"+standardName+"="+icValue+"】对应人员信息已存在");
					}
				}
			}
			if(df!=null){
				if(index==0){
					update.append(" " + mf.getProperty()+"=? ");
					index++;
				}else{
					update.append("," + mf.getProperty()+"=? ");
				}
				values.add(df.getValue());
			}
		}
		if(StringUtils.isNotBlank(idValue)){
			if(values.size()>=1){
				update.append(" where id=? ");
				values.add(idValue);
				jdbcDao.update(update.toString(), values.toArray());
			}else{
				throw new Exception("更新--》数据对象【人员基本信息】中没有填写要更新的数据项");
			}
		}else{
			throw new Exception("更新--》数据对象【人员基本信息】数据项【ID】不能为空");
		}
		return true;
	}
	
	/**
	 * 
	* @author zds
	* @date  2016-4-18 下午2:23:07
	* @param id 要删除的记录id
	* @return
	* @throws Exception
	* @return boolean
	 */
	@Override
	public boolean delete(String id) throws Exception{
		boolean flag=false;
		if (StringUtils.isBlank(id)) {
		    throw new Exception("删除记录错误:未设置数据对象【人员基本信息】的ID");
		}
		String findStr=" select count(*) from reps_sys_person where id='"+id+"' ";
		//检查id对应的记录是否存在
		int count=jdbcDao.queryForInt(findStr);
		if(count==1){
			jdbcDao.execute("update reps_sys_person set valid_record=0 where id='"+id+"' ");
			flag=true;
		}else{
			throw new Exception("删除--》数据对象【人员基本信息】中数据项【ID="+id+"】对应人员信息不存在");
		}
		return flag;
	}
}
