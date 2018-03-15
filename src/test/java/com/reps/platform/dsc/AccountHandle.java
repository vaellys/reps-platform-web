package com.reps.platform.dsc;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.StringUtils;

import com.reps.core.SpringContext;
import com.reps.core.orm.IJdbcDao;
import com.reps.dsc.core.data.DataField;

public class AccountHandle implements BaseOperateInterface  {
	IJdbcDao jdbcDao=(IJdbcDao)SpringContext.getBean("jdbcDao");
	
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
					String findStr=" select count(*) from reps_sys_account where id='"+idValue+"' ";
					int count=jdbcDao.queryForInt(findStr);
					if(count>0){
						throw new Exception("添加--》数据对象【账户信息】的数据项【"+standardName+"="+idValue+"】对应账户信息已存在");
					}
				}
			}
			//判断人员ID是否存在
			if("人员ID".equalsIgnoreCase(standardName)){
				//判断数据库中是否存在该记录
				if(df!=null&&df.getValue()!=null){
					String personIdValue=df.getValue().toString();
					String findStr=" select count(*) from reps_sys_person where id='"+personIdValue+"' ";
					int count=jdbcDao.queryForInt(findStr);
					if(count<1){
						throw new Exception("添加--》数据对象【账户信息】的数据项【"+standardName+"="+personIdValue+"】对应人员信息不存在");
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
			//密码初始化为111111
			insertFields.append(",password");
			insertValues.append(",?");
			values.add("111111");
			
			insertFields.append(",valid_record");
			insertValues.append(",?");
			values.add(1);
			String insert = "Insert into reps_sys_account (" + insertFields.toString() + ")values(" + insertValues.toString() + ")";
			jdbcDao.update(insert, values.toArray());
		}else{
			throw new Exception("添加--》数据对象【账户信息】的数据项不能为空");
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
		
	
		StringBuffer update = new StringBuffer("update reps_sys_account set ");
		List<Object> values = new ArrayList<Object>();
		String idValue=null;
		
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
					idValue=df.getValue().toString();
					String findStr=" select count(*) from reps_sys_account where id='"+idValue+"' ";
					int count=jdbcDao.queryForInt(findStr);
					if(count<1){
						throw new Exception("更新--》数据对象【账户信息】的数据项【"+standardName+"="+idValue+"】对应账户信息不存在");
					}
				}
			}
			//判断人员ID是否存在
			if("人员ID".equalsIgnoreCase(standardName)){
				//判断数据库中是否存在该记录
				if(df!=null&&df.getValue()!=null){
					String personIdValue=df.getValue().toString();
					String selectStr=" select count(*) from reps_sys_person where id='"+personIdValue+"' ";
					int count=jdbcDao.queryForInt(selectStr);
					if(count<1){
						throw new Exception("更新--》数据对象【账户信息】的数据项【"+standardName+"="+personIdValue+"】对应人员信息不存在");
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
				throw new Exception("更新--》数据对象【账户信息】中没有填写要更新的数据项");
			}
		}else{
			throw new Exception("更新--》数据对象【账户信息】的数据项【ID】不能为空");
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
		    throw new Exception("删除记录错误:未设置数据对象【账户信息】的ID");
		}
		String selectStr=" select count(*) from reps_sys_account where id='"+id+"' ";
		//检查id对应的记录是否存在
		int count=jdbcDao.queryForInt(selectStr);
		if(count==1){
			jdbcDao.execute("update reps_sys_account set valid_record=0 where id='"+id+"' ");
			flag=true;
		}else{
			throw new Exception("删除--》数据对象【账户信息】中数据项【ID="+id+"】对应账户信息不存在");
		}
		return flag;
	}

}
