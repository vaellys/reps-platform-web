package com.reps.platform.dsc;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.StringUtils;

import com.reps.core.SpringContext;
import com.reps.core.orm.IJdbcDao;
import com.reps.dsc.core.data.DataField;

public class ParentStudentHandle implements BaseOperateInterface {
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
		
		//用于生成保存家长信息语句
		StringBuffer insert_parent_fieldsStr = new StringBuffer();
		StringBuffer insert_parent_valuesStr = new StringBuffer();
		List<Object> insert_parent_values = new ArrayList<Object>();
		
		//用于生成更新家长信息语句
		StringBuffer update_parent_fieldsStr = new StringBuffer("update reps_sch_parent set ");
		List<Object> update_parent_values = new ArrayList<Object>();
		
		//用于保存家长与学生关系表
		StringBuffer insert_relation_fieldsStr = new StringBuffer();
		StringBuffer insert_relation_valuesStr = new StringBuffer();
		List<Object> insert_relation_values = new ArrayList<Object>();
		
		
		//家长id
		String parentId=null;
		
		boolean hasParent=false;//家长信息表中是否存在该家长信息   存在---》更新   不存在----》插入
		
		//对部分信息进行存在验证
		for(StandardDataRelation relation:relationList){
			DataField df=relation.getDataField();
			String standardName=relation.getStandardName();
			if("ID".equalsIgnoreCase(standardName)){
				if(df!=null&&df.getValue()!=null){
					String value=df.getValue().toString();
					String findStuSchool=" select count(*) from reps_sch_parent_student where id='"+value+"' ";
					int perCount=jdbcDao.queryForInt(findStuSchool);
					if(perCount>0){
						throw new Exception("添加--》数据对象【家长基本信息】的数据项【"+standardName+"="+value+"】对应家长与学生关系记录已存在");
					}
				}
			}
			if("学生ID".equalsIgnoreCase(standardName)){
				if(df!=null&&df.getValue()!=null){
					//判断学生ID对应学生是否存在
					String value=df.getValue().toString();
					String findStudent=" select count(*) from reps_sch_student where valid_record=1 and id='"+value+"' ";
					int perCount=jdbcDao.queryForInt(findStudent);
					if(perCount<1){
						throw new Exception("添加--》数据对象【家长基本信息】的数据项【"+standardName+"="+value+"】对应学生信息不存在");
					}
				}
			}
			if("人员基本信息".equalsIgnoreCase(standardName)){
				if(df!=null&&df.getValue()!=null){
					String value=df.getValue().toString();
					//判断对应人员信息是否存在
					String findPerson=" select count(*) from reps_sys_person where valid_record=1 and id='"+value+"' ";
					int personCount=jdbcDao.queryForInt(findPerson);
					if(personCount<1){
						throw new Exception("添加--》数据对象【家长基本信息】中数据项【"+standardName+"="+value+"】对应人员信息不存在");
					}
					//判断对应家长信息是否存在
					String findParent="select count(*) from reps_sch_parent where id='"+value+"'";
					int parentCount=jdbcDao.queryForInt(findParent);
					if(parentCount==1){
						hasParent=true;
					}
					parentId=value;
				}
			}
		}
		
		//拼接sql串
		int index_parent_insert=0;
		int index_parent_student_insert=0;
		int index_parent_update=0;
		for(int i=0;i<relationList.size();i++){
			StandardDataRelation relation=relationList.get(i);
			DataField df=relation.getDataField();
			MappingField mf=relation.getMappingField();
			String standardName=relation.getStandardName();
			if(df!=null){
				if(hasParent){
					//更新到家长信息表reps_sch_parent中
					if("工作单位,职业,专业技术职务,职务级别".indexOf(standardName)!=-1){
						if(index_parent_update==0){
							update_parent_fieldsStr.append(" " + mf.getProperty()+"=? ");
							index_parent_update++;
						}else{
							update_parent_fieldsStr.append("," + mf.getProperty()+"=? ");
						}
						update_parent_values.add(df.getValue());
					}
				}else{//添加到家长信息表reps_sch_parent中
					if("人员基本信息".equalsIgnoreCase(standardName)){
						if(index_parent_insert==0){
							insert_parent_fieldsStr.append(" id");
							insert_parent_valuesStr.append(" ?");
							index_parent_insert++;
						}else{
							insert_parent_fieldsStr.append(",id");
							insert_parent_valuesStr.append(",?");
						}
						insert_parent_values.add(df.getValue());
					}
					//保存到家长信息表reps_sch_parent中
					if("工作单位,职业,专业技术职务,职务级别".indexOf(standardName)!=-1){
						if(index_parent_insert==0){
							insert_parent_fieldsStr.append(" "+mf.getProperty());
							insert_parent_valuesStr.append(" ?");
							index_parent_insert++;
						}else{
							insert_parent_fieldsStr.append(","+mf.getProperty());
							insert_parent_valuesStr.append(",?");
						}
						insert_parent_values.add(df.getValue());
					}
				}
				
				//添加家长ID到家长与学生关系表reps_sch_parent_student中
				if("人员基本信息".equalsIgnoreCase(standardName)){
					if(index_parent_student_insert==0){
						insert_relation_fieldsStr.append(" parent_id");
						insert_relation_valuesStr.append(" ?");
						index_parent_student_insert++;
					}else{
						insert_relation_fieldsStr.append(",parent_id");
						insert_relation_valuesStr.append(",?");
					}
					insert_relation_values.add(df.getValue());
				}
				
				//添加ID、学生ID、与学生关系到家长与学生关系表reps_sch_parent_student中
				if("ID,学生ID,与学生关系".indexOf(standardName)!=-1){
					if(index_parent_student_insert==0){
						insert_relation_fieldsStr.append(" "+mf.getProperty());
						insert_relation_valuesStr.append(" ?");
						index_parent_student_insert++;
					}else{
						insert_relation_fieldsStr.append(","+mf.getProperty());
						insert_relation_valuesStr.append(",?");
					}
					insert_relation_values.add(df.getValue());
				}
			}
		}
		if(hasParent){//更新家长信息到家长信息表reps_sch_parent中
			if(update_parent_values.size()>0){
				update_parent_fieldsStr.append(" where id=? ");
				update_parent_values.add(parentId);
				jdbcDao.update(update_parent_fieldsStr.toString(), update_parent_values.toArray());
			}
		}else{//添加家长信息到家长信息表reps_sch_parent中
			if(insert_parent_fieldsStr.length()>0&&insert_parent_valuesStr.length()>0){
				String insert = "Insert into reps_sch_parent (" + insert_parent_fieldsStr.toString() + ")values(" + insert_parent_valuesStr.toString() + ")";
				jdbcDao.update(insert, insert_parent_values.toArray());
			}else{
				throw new Exception("添加--》数据对象【家长基本信息】的数据项不能为空");
			}
		}
		//添加家长与学生关系信息到家长与学生关系表reps_sch_parent_student中
		if(insert_relation_fieldsStr.length()>0&&insert_relation_valuesStr.length()>0){
			String insert = "Insert into reps_sch_parent_student (" + insert_relation_fieldsStr.toString() + ")values(" + insert_relation_valuesStr.toString() + ")";
			jdbcDao.update(insert, insert_relation_values.toArray());
		}else{
			throw new Exception("添加--》数据对象【家长基本信息】的数据项为空");
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
		
		//用于生成保存家长信息语句
		StringBuffer insert_parent_fieldsStr = new StringBuffer();
		StringBuffer insert_parent_valuesStr = new StringBuffer();
		List<Object> insert_parent_values = new ArrayList<Object>();
		
		//用于生成更新家长信息语句
		StringBuffer update_parent_fieldsStr = new StringBuffer("update reps_sch_parent set ");
		List<Object> update_parent_values = new ArrayList<Object>();
		
		//用于生成更新家长与学生关系信息语句
		StringBuffer update_relation_fieldsStr = new StringBuffer("update reps_sch_parent_student set ");
		List<Object> update_relation_values = new ArrayList<Object>();
		
		//家长id
		String parentId=null;
		
		//家长与学生关系id
		String idValue=null;
		
		boolean hasParent=false;//家长信息表中是否存在该家长信息   存在---》更新   不存在----》插入
		
		//对部分信息进行存在验证
		for(StandardDataRelation relation:relationList){
			DataField df=relation.getDataField();
			String standardName=relation.getStandardName();
			if("ID".equalsIgnoreCase(standardName)){
				if(df!=null&&df.getValue()!=null){
					idValue=df.getValue().toString();
					String findStuSchool=" select count(*) from reps_sch_parent_student where id='"+idValue+"' ";
					int perCount=jdbcDao.queryForInt(findStuSchool);
					if(perCount<1){
						throw new Exception("更新--》数据对象【家长基本信息】的数据项【"+standardName+"="+idValue+"】对应家长与学生关系记录不存在");
					}
				}
			}
			if("学生ID".equalsIgnoreCase(standardName)){
				if(df!=null&&df.getValue()!=null){
					//判断学生ID对应学生是否存在
					String value=df.getValue().toString();
					String findStudent=" select count(*) from reps_sch_student where valid_record=1 and id='"+value+"' ";
					int perCount=jdbcDao.queryForInt(findStudent);
					if(perCount<1){
						throw new Exception("更新--》数据对象【家长基本信息】的数据项【"+standardName+"="+value+"】对应学生信息不存在");
					}
				}
			}
			if("人员基本信息".equalsIgnoreCase(standardName)){
				if(df!=null&&df.getValue()!=null){
					String value=df.getValue().toString();
					//判断对应人员信息是否存在
					String findPerson=" select count(*) from reps_sys_person where valid_record=1 and id='"+value+"' ";
					int personCount=jdbcDao.queryForInt(findPerson);
					if(personCount<1){
						throw new Exception("更新--》数据对象【家长基本信息】中数据项【"+standardName+"="+value+"】对应人员信息不存在");
					}
					//判断对应家长信息是否存在
					String findParent="select count(*) from reps_sch_parent where id='"+value+"'";
					int parentCount=jdbcDao.queryForInt(findParent);
					if(parentCount==1){
						hasParent=true;
					}
					parentId=value;
				}else{
					hasParent=true;
				}
			}
		}
		
		//拼接sql串
		int insert_parent_index=0;
		int update_parent_index=0;
		int update_relation_index=0;
		for(int i=0;i<relationList.size();i++){
			StandardDataRelation relation=relationList.get(i);
			DataField df=relation.getDataField();
			MappingField mf=relation.getMappingField();
			String standardName=relation.getStandardName();
			if(df!=null){
				if(hasParent){
					//更新到家长信息表reps_sch_parent中
					if("工作单位,职业,专业技术职务,职务级别".indexOf(standardName)!=-1){
						if(update_parent_index==0){
							update_parent_fieldsStr.append(" " + mf.getProperty()+"=? ");
							update_parent_index++;
						}else{
							update_parent_fieldsStr.append("," + mf.getProperty()+"=? ");
						}
						update_parent_values.add(df.getValue());
					}
				}else{//添加到家长信息表reps_sch_parent中
					if("人员基本信息".equalsIgnoreCase(standardName)){
						if(insert_parent_index==0){
							insert_parent_fieldsStr.append(" id");
							insert_parent_valuesStr.append(" ?");
							insert_parent_index++;
						}else{
							insert_parent_fieldsStr.append(",id");
							insert_parent_valuesStr.append(",?");
						}
						insert_parent_values.add(df.getValue());
					}
					//保存到家长信息表reps_sch_parent中
					if("工作单位,职业,专业技术职务,职务级别".indexOf(standardName)!=-1){
						if(insert_parent_index==0){
							insert_parent_fieldsStr.append(" "+mf.getProperty());
							insert_parent_valuesStr.append(" ?");
							insert_parent_index++;
						}else{
							insert_parent_fieldsStr.append(","+mf.getProperty());
							insert_parent_valuesStr.append(",?");
						}
						insert_parent_values.add(df.getValue());
					}
				}
				
				//更新家长ID到家长与学生关系表reps_sch_parent_student中
				if("人员基本信息".equalsIgnoreCase(standardName)){
					if(update_relation_index==0){
						update_relation_fieldsStr.append(" parent_id=? ");
						update_relation_index++;
					}else{
						update_relation_fieldsStr.append(",parent_id=? ");
					}
					update_relation_values.add(df.getValue());
				}
				
				//更新学生ID、与学生关系到家长与学生关系表reps_sch_parent_student中
				if(!"ID".equalsIgnoreCase(standardName)&&"学生ID,与学生关系".indexOf(standardName)!=-1){
					if(update_relation_index==0){
						update_relation_fieldsStr.append(" " + mf.getProperty()+"=? ");
						update_relation_index++;
					}else{
						update_relation_fieldsStr.append("," + mf.getProperty()+"=? ");
					}
					update_relation_values.add(df.getValue());
				}
			}
		}
		if(hasParent){//更新家长信息到家长信息表reps_sch_parent中
			if(update_parent_values.size()>0){
				if(StringUtils.isBlank(parentId)){
					String findParent=" select teacher_id from reps_sch_parent_student where id='"+idValue+"' ";
					parentId=(String)jdbcDao.queryForObject(findParent, String.class);
				}
				update_parent_fieldsStr.append(" where id=? ");
				update_parent_values.add(parentId);
				jdbcDao.update(update_parent_fieldsStr.toString(), update_parent_values.toArray());
			}
		}else{//添加家长信息到家长信息表reps_sch_parent中
			if(insert_parent_fieldsStr.length()>0&&insert_parent_valuesStr.length()>0){
				String insert = "Insert into reps_sch_parent (" + insert_parent_fieldsStr.toString() + ")values(" + insert_parent_valuesStr.toString() + ")";
				jdbcDao.update(insert, insert_parent_values.toArray());
			}else{
				throw new Exception("更新--》数据对象【家长基本信息】的数据项不能为空");
			}
		}
		//添加家长与学生关系信息到家长与学生关系表reps_sch_parent_student中
		if(update_relation_values.size()>0){
			update_relation_fieldsStr.append(" where id=? ");
			update_relation_values.add(idValue);
			jdbcDao.update(update_relation_fieldsStr.toString(), update_relation_values.toArray());
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
		    throw new Exception("删除记录错误:未设置数据对象【家长基本信息】的ID");
		}
		//检查id对应的记录是否存在
		int count=jdbcDao.queryForInt(" select count(*) from reps_sch_parent_student where id='"+id+"' ");
		if(count==1){
			jdbcDao.execute("delete from reps_sch_parent_student where id='"+id+"' ");
			flag=true;
		}else{
			throw new Exception("删除--》数据对象【家长基本信息】中【ID="+id+"】对应的家长信息不存在");
		}
		return flag;
	}
	
}
