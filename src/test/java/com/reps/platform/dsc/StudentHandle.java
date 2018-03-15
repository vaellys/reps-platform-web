package com.reps.platform.dsc;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.StringUtils;

import com.reps.core.SpringContext;
import com.reps.core.orm.IJdbcDao;
import com.reps.dsc.core.data.DataField;

public class StudentHandle implements BaseOperateInterface {
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
		
		//用于保存学生信息语句
		StringBuffer insert_student_fieldsStr = new StringBuffer();
		StringBuffer insert_student_valuesStr = new StringBuffer();
		List<Object> insert_student_values = new ArrayList<Object>();
		
		//用于生成更新学生信息语句
		StringBuffer update_student_fieldsStr = new StringBuffer("update reps_sch_student set ");
		List<Object> update_student_values = new ArrayList<Object>();
		
		//用于保存学籍信息语句
		StringBuffer insert_student_school_fieldsStr = new StringBuffer();
		StringBuffer insert_student_school_valuesStr = new StringBuffer();
		List<Object> insert_student_school_values = new ArrayList<Object>();
		
		
		//学生id
		String studentId=null;
		
		boolean hasStudent=false;//学生信息表中是否存在该学生信息   存在---》更新   不存在----》插入
		
		//对部分信息进行存在验证
		for(StandardDataRelation relation:relationList){
			DataField df=relation.getDataField();
			String standardName=relation.getStandardName();
			if("ID".equalsIgnoreCase(standardName)){
				if(df!=null&&df.getValue()!=null){
					String idValue=df.getValue().toString();
					String findStuSchool=" select count(*) from reps_sch_student_school where id='"+idValue+"' ";
					int perCount=jdbcDao.queryForInt(findStuSchool);
					if(perCount>0){
						throw new Exception("添加--》数据对象【学生基本信息】的数据项【"+standardName+"="+idValue+"】对应学籍信息已存在");
					}
				}
			}
			if("所在学校ID".equalsIgnoreCase(standardName)){
				if(df!=null&&df.getValue()!=null){
					//判断所在学校ID对应学校信息是否存在
					String schoolIdValue=df.getValue().toString();
					String findSchool=" select count(*) from reps_sch_school where id='"+schoolIdValue+"' ";
					int perCount=jdbcDao.queryForInt(findSchool);
					if(perCount<1){
						throw new Exception("添加--》数据对象【学生基本信息】的数据项【"+standardName+"="+schoolIdValue+"】对应学校信息不存在");
					}
				}
			}
			if("所在班级IDS".equalsIgnoreCase(standardName)){
				//判断班级IDS对应班级是否存在
				if(df!=null&&df.getValue()!=null){
					String classIdsValue=df.getValue().toString();
					if(StringUtils.isNotBlank(classIdsValue)){
						String[] classIds=classIdsValue.split(",");
						for(String classId:classIds){
							String findClass=" select count(*) from reps_sch_classes where id='"+classId+"' ";
							int perCount=jdbcDao.queryForInt(findClass);
							if(perCount<1){
								throw new Exception("添加--》数据对象【学生基本信息】的数据项【"+standardName+"】的值"+classId+"对应班级信息不存在");
							}
						}
					}
				}
			}
			if("人员基本信息".equalsIgnoreCase(standardName)){
				if(df!=null&&df.getValue()!=null){
					String value=df.getValue().toString();
					//判断对应人员信息是否存在
					String findPerson=" select count(*) from reps_sys_person where id='"+value+"' ";
					int personCount=jdbcDao.queryForInt(findPerson);
					if(personCount<1){
						throw new Exception("添加--》数据对象【学生基本信息】中数据项【"+standardName+"="+value+"】对应人员信息不存在");
					}
					//判断对应学生信息是否存在
					String findParent="select count(*) from reps_sch_student where id='"+value+"'";
					int studentCount=jdbcDao.queryForInt(findParent);
					if(studentCount==1){
						hasStudent=true;
					}
					studentId=value;
				}
			}
		}
		
		//拼接sql串
		int index_student_insert=0;
		int index_student_update=0;
		int index_student_school_insert=0;
		
		for(int i=0;i<relationList.size();i++){
			StandardDataRelation relation=relationList.get(i);
			DataField df=relation.getDataField();
			MappingField mf=relation.getMappingField();
			String standardName=relation.getStandardName();
			if(df!=null){
				if(hasStudent){
					//更新到学生信息表reps_sch_student中
					if("学籍号,特长,家庭联系人,家庭电话".indexOf(standardName)!=-1){
						if(index_student_update==0){
							update_student_fieldsStr.append(" " + mf.getProperty()+"=? ");
							index_student_update++;
						}else{
							update_student_fieldsStr.append("," + mf.getProperty()+"=? ");
						}
						update_student_values.add(df.getValue());
					}
				}else{//添加到学生信息表reps_sch_student中
					if("人员基本信息".equalsIgnoreCase(standardName)){
						if(index_student_insert==0){
							insert_student_fieldsStr.append(" id");
							insert_student_valuesStr.append(" ?");
							index_student_insert++;
						}else{
							insert_student_fieldsStr.append(",id");
							insert_student_valuesStr.append(",?");
						}
						insert_student_values.add(df.getValue());
					}
					//保存到学生信息表reps_sch_student中
					if("学籍号,特长,家庭联系人,家庭电话".indexOf(standardName)!=-1){
						if(index_student_insert==0){
							insert_student_fieldsStr.append(" "+mf.getProperty());
							insert_student_valuesStr.append(" ?");
							index_student_insert++;
						}else{
							insert_student_fieldsStr.append(","+mf.getProperty());
							insert_student_valuesStr.append(",?");
						}
						insert_student_values.add(df.getValue());
					}
				}
				
				//添加学生ID到学籍信息表reps_sch_student_school中
				if("人员基本信息".equalsIgnoreCase(standardName)){
					if(index_student_school_insert==0){
						insert_student_school_fieldsStr.append(" student_id");
						insert_student_school_valuesStr.append(" ?");
						index_student_school_insert++;
					}else{
						insert_student_school_fieldsStr.append(",student_id");
						insert_student_school_valuesStr.append(",?");
					}
					insert_student_school_values.add(df.getValue());
				}
				
				//添加ID、学籍信息到学籍信息表reps_sch_student_school中
				if("ID,所在学校ID,所在班级IDS,学号,入学本校时间,就读性质,就读方式,在校状态,学籍状态".indexOf(standardName)!=-1){
					if(index_student_school_insert==0){
						insert_student_school_fieldsStr.append(" "+mf.getProperty());
						insert_student_school_valuesStr.append(" ?");
						index_student_school_insert++;
					}else{
						insert_student_school_fieldsStr.append(","+mf.getProperty());
						insert_student_school_valuesStr.append(",?");
					}
					insert_student_school_values.add(df.getValue());
				}
			}
		}
		if(hasStudent){//更新学生信息到学生信息表reps_sch_student中
			if(update_student_values.size()>0){
				update_student_fieldsStr.append(" where id=? ");
				update_student_values.add(studentId);
				jdbcDao.update(update_student_fieldsStr.toString(), update_student_values.toArray());
			}
		}else{//添加学生信息到学生信息表reps_sch_student中
			if(insert_student_fieldsStr.length()>0&&insert_student_valuesStr.length()>0){
				insert_student_fieldsStr.append(",valid_record");
				insert_student_valuesStr.append(",?");
				insert_student_values.add(1);
				String insert = "Insert into reps_sch_student (" + insert_student_fieldsStr.toString() + ")values(" + insert_student_valuesStr.toString() + ")";
				jdbcDao.update(insert, insert_student_values.toArray());
			}else{
				throw new Exception("添加--》数据对象【学生基本信息】的数据项不能为空");
			}
		}
		//添加学籍信息到学籍信息表reps_sch_student_school中
		if(insert_student_school_fieldsStr.length()>0&&insert_student_school_valuesStr.length()>0){
			insert_student_school_fieldsStr.append(",valid_record");
			insert_student_school_valuesStr.append(",?");
			insert_student_school_values.add(1);
			String insert = "Insert into reps_sch_student_school (" + insert_student_school_fieldsStr.toString() + ")values(" + insert_student_school_valuesStr.toString() + ")";
			jdbcDao.update(insert, insert_student_school_values.toArray());
		}else{
			throw new Exception("添加--》数据对象【学生基本信息】的数据项为空");
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
		
		//用于生成保存学生信息语句
		StringBuffer insert_student_fieldsStr = new StringBuffer();
		StringBuffer insert_student_valuesStr = new StringBuffer();
		List<Object> insert_student_values = new ArrayList<Object>();
		
		//用于生成更新学生信息语句
		StringBuffer update_student_fieldsStr = new StringBuffer("update reps_sch_student set ");
		List<Object> update_student_values = new ArrayList<Object>();
		
		//用于生成更新学籍信息语句
		StringBuffer update_student_school_fieldsStr = new StringBuffer("update reps_sch_student_school set ");
		List<Object> update_student_school_values = new ArrayList<Object>();
		
		//学生id
		String studentId=null;
		//学籍id
		String idValue=null;
		
		boolean hasStudent=false;//学生信息表中是否存在该学生信息   存在---》更新   不存在----》插入
		
		//对部分信息进行存在验证
		for(StandardDataRelation relation:relationList){
			DataField df=relation.getDataField();
			String standardName=relation.getStandardName();
			if("ID".equalsIgnoreCase(standardName)){
				if(df!=null&&df.getValue()!=null){
					idValue=df.getValue().toString();
					String findStuSchool=" select count(*) from reps_sch_student_school where id='"+idValue+"' ";
					int perCount=jdbcDao.queryForInt(findStuSchool);
					if(perCount<1){
						throw new Exception("更新--》数据对象【学生基本信息】的数据项【"+standardName+"="+idValue+"】对应学籍信息不存在");
					}
				}
			}
			if("所在学校ID".equalsIgnoreCase(standardName)){
				//判断所在学校ID对应学校信息是否存在
				if(df!=null&&df.getValue()!=null){
					String schoolIdValue=df.getValue().toString();
					String findSchool=" select count(*) from reps_sch_school where id='"+schoolIdValue+"' ";
					int perCount=jdbcDao.queryForInt(findSchool);
					if(perCount<1){
						throw new Exception("更新--》数据对象【学生基本信息】的数据项【"+standardName+"="+schoolIdValue+"】对应学校信息不存在");
					}
				}
			}
			if("所在班级IDS".equalsIgnoreCase(standardName)){
				//判断班级IDS对应班级是否存在
				if(df!=null&&df.getValue()!=null){
					String classIdsValue=df.getValue().toString();
					if(StringUtils.isNotBlank(classIdsValue)){
						String[] classIds=classIdsValue.split(",");
						for(String classId:classIds){
							String findClass=" select count(*) from reps_sch_classes where id='"+classId+"' ";
							int perCount=jdbcDao.queryForInt(findClass);
							if(perCount<1){
								throw new Exception("更新--》数据对象【学生基本信息】的数据项【"+standardName+"】的值"+classId+"对应班级信息不存在");
							}
						}
					}
				}
			}
			if("人员基本信息".equalsIgnoreCase(standardName)){
				if(df!=null&&df.getValue()!=null){
					String value=df.getValue().toString();
					//判断对应人员信息是否存在
					String findPerson=" select count(*) from reps_sys_person where id='"+value+"' ";
					int personCount=jdbcDao.queryForInt(findPerson);
					if(personCount<1){
						throw new Exception("更新--》数据对象【学生基本信息】中数据项【"+standardName+"="+value+"】对应人员信息不存在");
					}
					//判断对应学生信息是否存在
					String findParent="select count(*) from reps_sch_student where id='"+value+"'";
					int studentCount=jdbcDao.queryForInt(findParent);
					if(studentCount==1){
						hasStudent=true;
					}
					studentId=value;
				}else{
					hasStudent=true;
				}
				
			}
		}
		
		//拼接sql串
		int index_student_insert=0;
		int index_student_update=0;
		int index_student_school_update=0;
		
		for(int i=0;i<relationList.size();i++){
			StandardDataRelation relation=relationList.get(i);
			DataField df=relation.getDataField();
			MappingField mf=relation.getMappingField();
			String standardName=relation.getStandardName();
			if(df!=null){
				if(hasStudent){
					//更新到学生信息表reps_sch_student中
					if("学籍号,特长,家庭联系人,家庭电话".indexOf(standardName)!=-1){
						if(index_student_update==0){
							update_student_fieldsStr.append(" " + mf.getProperty()+"=? ");
							index_student_update++;
						}else{
							update_student_fieldsStr.append("," + mf.getProperty()+"=? ");
						}
						update_student_values.add(df.getValue());
					}
				}else{//添加到学生信息表reps_sch_student中
					if("人员基本信息".equalsIgnoreCase(standardName)){
						if(index_student_insert==0){
							insert_student_fieldsStr.append(" id");
							insert_student_valuesStr.append(" ?");
							index_student_insert++;
						}else{
							insert_student_fieldsStr.append(",id");
							insert_student_valuesStr.append(",?");
						}
						insert_student_values.add(df.getValue());
					}
					//保存到学生信息表reps_sch_student中
					if("学籍号,特长,家庭联系人,家庭电话".indexOf(standardName)!=-1){
						if(index_student_insert==0){
							insert_student_fieldsStr.append(" "+mf.getProperty());
							insert_student_valuesStr.append(" ?");
							index_student_insert++;
						}else{
							insert_student_fieldsStr.append(","+mf.getProperty());
							insert_student_valuesStr.append(",?");
						}
						insert_student_values.add(df.getValue());
					}
				}
				//更新学生ID到学籍信息表reps_sch_student_school中
				if("人员基本信息".equalsIgnoreCase(standardName)){
					if(index_student_school_update==0){
						update_student_school_fieldsStr.append(" student_id=? ");
						index_student_school_update++;
					}else{
						update_student_school_fieldsStr.append(",student_id=? ");
					}
					update_student_school_values.add(df.getValue());
				}
				
				//更新学生ID、学籍信息到学籍信息表reps_sch_student_school中
				if(!"ID".equalsIgnoreCase(standardName)&&"所在学校ID,所在班级IDS,学号,入学本校时间,就读性质,就读方式,在校状态,学籍状态".indexOf(standardName)!=-1){
					if(index_student_school_update==0){
						update_student_school_fieldsStr.append(" " + mf.getProperty()+"=? ");
						index_student_school_update++;
					}else{
						update_student_school_fieldsStr.append("," + mf.getProperty()+"=? ");
					}
					update_student_school_values.add(df.getValue());
				}
			}
		}
		if(hasStudent){//更新学生信息到学生信息表reps_sch_student中
			if(update_student_values.size()>0){
				if(StringUtils.isBlank(studentId)){
					String findStu=" select student_id from reps_sch_student_school where id='"+idValue+"' ";
					studentId=(String)jdbcDao.queryForObject(findStu, String.class);
				}
				update_student_fieldsStr.append(" where id=? ");
				update_student_values.add(studentId);
				jdbcDao.update(update_student_fieldsStr.toString(), update_student_values.toArray());
			}
		}else{//添加学生信息到学生信息表reps_sch_student中
			if(insert_student_fieldsStr.length()>0&&insert_student_valuesStr.length()>0){
				insert_student_fieldsStr.append(",valid_record");
				insert_student_valuesStr.append(",?");
				insert_student_values.add(1);
				String insert = "Insert into reps_sch_student (" + insert_student_fieldsStr.toString() + ")values(" + insert_student_valuesStr.toString() + ")";
				jdbcDao.update(insert, insert_student_values.toArray());
			}else{
				throw new Exception("更新--》数据对象【学生基本信息】的数据项不能为空");
			}
		}
		//更新学籍信息到学籍信息表reps_sch_student_school中
		if(update_student_school_values.size()>0){
			update_student_school_fieldsStr.append(" where id=? ");
			update_student_school_values.add(idValue);
			jdbcDao.update(update_student_school_fieldsStr.toString(), update_student_school_values.toArray());
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
		    throw new Exception("删除记录错误:未设置数据对象【学生基本信息】的ID");
		}
		//检查id对应的记录是否存在
		int count=jdbcDao.queryForInt(" select count(*) from reps_sch_student_school where id='"+id+"' ");
		if(count==1){
			jdbcDao.execute("update reps_sch_student_school set valid_record=0 where id='"+id+"' ");
			flag=true;
		}else{
			throw new Exception("删除--》数据对象【学生基本信息】中【ID="+id+"】对应的学籍信息不存在");
		}
		return flag;
	}
	
}
