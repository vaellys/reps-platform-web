package com.reps.platform.dsc;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.StringUtils;

import com.reps.core.SpringContext;
import com.reps.core.orm.IJdbcDao;
import com.reps.dsc.core.data.DataField;

public class TeacherHandle implements BaseOperateInterface {
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
		
		//用于生成保存教职工信息语句
		StringBuffer insert_teacher_fieldsStr = new StringBuffer();
		StringBuffer insert_teacher_valuesStr = new StringBuffer();
		List<Object> insert_teacher_values = new ArrayList<Object>();
		
		//用于生成更新教职工信息语句
		StringBuffer update_teacher_fieldsStr = new StringBuffer("update reps_sch_teacher set ");
		List<Object> update_teacher_values = new ArrayList<Object>();
		
		//用于生成保存教籍信息语句
		StringBuffer insert_teacher_school_fieldsStr = new StringBuffer();
		StringBuffer insert_teacher_school_valuesStr = new StringBuffer();
		List<Object> insert_teacher_school_values = new ArrayList<Object>();
		
		
		//教职工id
		String teacherId=null;
		
		boolean hasTeacher=false;//教职工信息表中是否存在该教职工信息   存在---》更新   不存在----》插入
		
		//对部分信息进行存在验证
		for(StandardDataRelation relation:relationList){
			DataField df=relation.getDataField();
			String standardName=relation.getStandardName();
			if("ID".equalsIgnoreCase(standardName)){
				if(df!=null&&df.getValue()!=null){
					String idValue=df.getValue().toString();
					String findTeaSchool=" select count(*) from reps_sch_teacher_school where id='"+idValue+"' ";
					int perCount=jdbcDao.queryForInt(findTeaSchool);
					if(perCount>0){
						throw new Exception("添加--》数据对象【教职工基本信息】的数据项【"+standardName+"="+idValue+"】对应教籍信息已存在");
					}
				}
			}
			if("所在机构ID".equalsIgnoreCase(standardName)){
				//判断所在机构ID对应机构信息是否存在
				if(df!=null&&df.getValue()!=null){
					String orgIdValue=df.getValue().toString();
					String findOrg=" select count(*) from reps_sys_organize where id='"+orgIdValue+"' ";
					int perCount=jdbcDao.queryForInt(findOrg);
					if(perCount<1){
						throw new Exception("添加--》数据对象【教职工基本信息】的数据项【"+standardName+"="+orgIdValue+"】对应机构信息不存在");
					}
				}
			}
			if("所教班级IDS".equalsIgnoreCase(standardName)){
				//判断班级IDS对应班级是否存在
				if(df!=null&&df.getValue()!=null){
					String classIdsValue=df.getValue().toString();
					if(StringUtils.isNotBlank(classIdsValue)){
						String[] classIds=classIdsValue.split(",");
						for(String classId:classIds){
							String findClass=" select count(*) from reps_sch_classes where id='"+classId+"' ";
							int perCount=jdbcDao.queryForInt(findClass);
							if(perCount<1){
								throw new Exception("添加--》数据对象【教职工基本信息】的数据项【"+standardName+"】的值"+classId+"对应班级信息不存在");
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
						throw new Exception("添加--》数据对象【教职工基本信息】中数据项【"+standardName+"="+value+"】对应人员信息不存在");
					}
					//判断对应教职工信息是否存在
					String findTeacher="select count(*) from reps_sch_teacher where id='"+value+"'";
					int teacherCount=jdbcDao.queryForInt(findTeacher);
					if(teacherCount==1){
						hasTeacher=true;
					}
					teacherId=value;
				}
			}
		}
		
		//拼接sql串
		int index_teacher_insert=0;
		int index_teacher_update=0;
		int index_teacher_school_insert=0;
		
		for(int i=0;i<relationList.size();i++){
			StandardDataRelation relation=relationList.get(i);
			DataField df=relation.getDataField();
			MappingField mf=relation.getMappingField();
			String standardName=relation.getStandardName();
			if(df!=null){
				if(hasTeacher){
					//更新到教职工信息表reps_sch_teacher中
					if("工号,参加工作时间,从教日期,编制状态,档案编号,专业技术职称,特长,工龄,教龄".indexOf(standardName)!=-1){
						if(index_teacher_update==0){
							update_teacher_fieldsStr.append(" " + mf.getProperty()+"=? ");
							index_teacher_update++;
						}else{
							update_teacher_fieldsStr.append("," + mf.getProperty()+"=? ");
						}
						update_teacher_values.add(df.getValue());
					}
				}else{//添加到教职工信息表reps_sch_teacher中
					if("人员基本信息".equalsIgnoreCase(standardName)){
						if(index_teacher_insert==0){
							insert_teacher_fieldsStr.append(" id");
							insert_teacher_valuesStr.append(" ?");
							index_teacher_insert++;
						}else{
							insert_teacher_fieldsStr.append(",id");
							insert_teacher_valuesStr.append(",?");
						}
						insert_teacher_values.add(df.getValue());
					}
					//保存到教职工信息表reps_sch_teacher中
					if("工号,参加工作时间,从教日期,编制状态,档案编号,专业技术职称,特长,工龄,教龄".indexOf(standardName)!=-1){
						if(index_teacher_insert==0){
							insert_teacher_fieldsStr.append(" "+mf.getProperty());
							insert_teacher_valuesStr.append(" ?");
							index_teacher_insert++;
						}else{
							insert_teacher_fieldsStr.append(","+mf.getProperty());
							insert_teacher_valuesStr.append(",?");
						}
						insert_teacher_values.add(df.getValue());
					}
				}
				
				//添加教职工ID到教籍信息表reps_sch_teacher_school中
				if("人员基本信息".equalsIgnoreCase(standardName)){
					if(index_teacher_school_insert==0){
						insert_teacher_school_fieldsStr.append(" teacher_id");
						insert_teacher_school_valuesStr.append(" ?");
						index_teacher_school_insert++;
					}else{
						insert_teacher_school_fieldsStr.append(",teacher_id");
						insert_teacher_school_valuesStr.append(",?");
					}
					insert_teacher_school_values.add(df.getValue());
				}
				
				//添加教籍信息到教籍信息表reps_sch_teacher_school中
				if("ID,所在机构ID,所教班级IDS,来校日期,编制类别,教职工来源,岗位职业,在岗状态,所属学段,任教学科".indexOf(standardName)!=-1){
					if(index_teacher_school_insert==0){
						insert_teacher_school_fieldsStr.append(" "+mf.getProperty());
						insert_teacher_school_valuesStr.append(" ?");
						index_teacher_school_insert++;
					}else{
						insert_teacher_school_fieldsStr.append(","+mf.getProperty());
						insert_teacher_school_valuesStr.append(",?");
					}
					insert_teacher_school_values.add(df.getValue());
				}
			}
		}
		if(hasTeacher){//更新教职工信息到教职工信息表reps_sch_teacher中
			if(update_teacher_values.size()>0&&StringUtils.isNotBlank(teacherId)){
				update_teacher_fieldsStr.append(" where id=? ");
				update_teacher_values.add(teacherId);
				jdbcDao.update(update_teacher_fieldsStr.toString(), update_teacher_values.toArray());
			}
		}else{//添加教职工信息到教职工信息表reps_sch_teacher中
			if(insert_teacher_fieldsStr.length()>0&&insert_teacher_valuesStr.length()>0){
				insert_teacher_fieldsStr.append(",valid_record");
				insert_teacher_valuesStr.append(",?");
				insert_teacher_values.add(1);
				String insert = "Insert into reps_sch_teacher (" + insert_teacher_fieldsStr.toString() + ")values(" + insert_teacher_valuesStr.toString() + ")";
				jdbcDao.update(insert, insert_teacher_values.toArray());
			}else{
				throw new Exception("添加--》数据对象【教职工基本信息】的数据项不能为空");
			}
		}
		//添加教籍信息到教籍信息表reps_sch_teacher_school中
		if(insert_teacher_school_fieldsStr.length()>0&&insert_teacher_school_valuesStr.length()>0){
			insert_teacher_school_fieldsStr.append(",valid_record");
			insert_teacher_school_valuesStr.append(",?");
			insert_teacher_school_values.add(1);
			String insert = "Insert into reps_sch_teacher_school (" + insert_teacher_school_fieldsStr.toString() + ")values(" + insert_teacher_school_valuesStr.toString() + ")";
			jdbcDao.update(insert, insert_teacher_school_values.toArray());
		}else{
			throw new Exception("添加--》数据对象【教职工基本信息】的数据项为空");
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
	
		//用于生成保存教职工信息语句
		StringBuffer insert_teacher_fieldsStr = new StringBuffer();
		StringBuffer insert_teacher_valuesStr = new StringBuffer();
		List<Object> insert_teacher_values = new ArrayList<Object>();
		
		//用于生成更新教职工信息语句
		StringBuffer update_teacher_fieldsStr = new StringBuffer("update reps_sch_teacher set ");
		List<Object> update_teacher_values = new ArrayList<Object>();
		
		//用于生成更新教籍信息语句
		StringBuffer update_teacher_school_fieldsStr = new StringBuffer("update reps_sch_teacher_school set ");
		List<Object> update_teacher_school_values = new ArrayList<Object>();
		
		//教职工id
		String teacherId=null;
		//教籍id
		String idValue=null;
		
		boolean hasTeacher=false;//教职工信息表中是否存在该教职工信息   存在---》更新   不存在----》插入
		
		//对部分信息进行存在验证
		for(StandardDataRelation relation:relationList){
			DataField df=relation.getDataField();
			String standardName=relation.getStandardName();
			if("ID".equalsIgnoreCase(standardName)){
				if(df==null||df.getValue()==null){
					throw new Exception("更新--》数据对象【教职工基本信息】的数据项【"+standardName+"】不能为空");
				}
				idValue=df.getValue().toString();
				String findTeaSchool=" select count(*) from reps_sch_teacher_school where id='"+idValue+"' ";
				int perCount=jdbcDao.queryForInt(findTeaSchool);
				if(perCount<1){
					throw new Exception("更新--》数据对象【教职工基本信息】的数据项【"+standardName+"="+idValue+"】对应教籍信息不存在");
				}
			}
			if("所在机构ID".equalsIgnoreCase(standardName)){
				if(df!=null&&df.getValue()!=null){
					//判断所在机构ID对应机构信息是否存在
					String orgIdValue=df.getValue().toString();
					String findOrg=" select count(*) from reps_sys_organize where id='"+orgIdValue+"' ";
					int perCount=jdbcDao.queryForInt(findOrg);
					if(perCount<1){
						throw new Exception("更新--》数据对象【教职工基本信息】的数据项【"+standardName+"="+orgIdValue+"】对应机构信息不存在");
					}
				}
			}
			if("所教班级IDS".equalsIgnoreCase(standardName)){
				//判断班级IDS对应班级是否存在
				if(df!=null&&df.getValue()!=null){
					String classIdsValue=df.getValue().toString();
					if(StringUtils.isNotBlank(classIdsValue)){
						String[] classIds=classIdsValue.split(",");
						for(String classId:classIds){
							String findClass=" select count(*) from reps_sch_classes where id='"+classId+"' ";
							int perCount=jdbcDao.queryForInt(findClass);
							if(perCount<1){
								throw new Exception("更新--》数据对象【教职工基本信息】的数据项【"+standardName+"】的值"+classId+"对应班级信息不存在");
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
						throw new Exception("更新--》数据对象【教职工基本信息】中数据项【"+standardName+"="+value+"】对应人员信息不存在");
					}
					//判断对应教职工信息是否存在
					String findTeacher="select count(*) from reps_sch_teacher where id='"+value+"'";
					int teacherCount=jdbcDao.queryForInt(findTeacher);
					if(teacherCount==1){
						hasTeacher=true;
					}
					teacherId=value;
				}else{
					hasTeacher=true;
				}
			}
		}
		
		//拼接sql串
		int index_teacher_insert=0;
		int index_teacher_update=0;
		int index_teacher_school_update=0;
		
		for(int i=0;i<relationList.size();i++){
			StandardDataRelation relation=relationList.get(i);
			DataField df=relation.getDataField();
			MappingField mf=relation.getMappingField();
			String standardName=relation.getStandardName();
			if(df!=null){
				if(hasTeacher){
					//更新到教职工信息表reps_sch_teacher中
					if("工号,参加工作时间,从教日期,编制状态,档案编号,专业技术职称,特长,工龄,教龄".indexOf(standardName)!=-1){
						if(index_teacher_update==0){
							update_teacher_fieldsStr.append(" " + mf.getProperty()+"=? ");
							index_teacher_update++;
						}else{
							update_teacher_fieldsStr.append("," + mf.getProperty()+"=? ");
						}
						update_teacher_values.add(df.getValue());
					}
				}else{//添加到教职工信息表reps_sch_teacher中
					if("人员基本信息".equalsIgnoreCase(standardName)){
						if(index_teacher_insert==0){
							insert_teacher_fieldsStr.append(" id");
							insert_teacher_valuesStr.append(" ?");
							index_teacher_insert++;
						}else{
							insert_teacher_fieldsStr.append(",id");
							insert_teacher_valuesStr.append(",?");
						}
						insert_teacher_values.add(df.getValue());
					}
					//保存到教职工信息表reps_sch_teacher中
					if("工号,参加工作时间,从教日期,编制状态,档案编号,专业技术职称,特长,工龄,教龄".indexOf(standardName)!=-1){
						if(index_teacher_insert==0){
							insert_teacher_fieldsStr.append(" "+mf.getProperty());
							insert_teacher_valuesStr.append(" ?");
							index_teacher_insert++;
						}else{
							insert_teacher_fieldsStr.append(","+mf.getProperty());
							insert_teacher_valuesStr.append(",?");
						}
						insert_teacher_values.add(df.getValue());
					}
				}
				
				//更新教职工ID到教籍信息表reps_sch_teacher_school中
				if("人员基本信息".equalsIgnoreCase(standardName)){
					if(index_teacher_school_update==0){
						update_teacher_school_fieldsStr.append(" teacher_id=? ");
						index_teacher_school_update++;
					}else{
						update_teacher_school_fieldsStr.append(",teacher_id=? ");
					}
					update_teacher_school_values.add(df.getValue());
				}
				
				//更新教籍信息到教籍信息表reps_sch_teacher_school中
				if(!"ID".equalsIgnoreCase(standardName)&&"所在机构ID,所教班级IDS,来校日期,编制类别,教职工来源,岗位职业,在岗状态,所属学段,任教学科".indexOf(standardName)!=-1){
					if(index_teacher_school_update==0){
						update_teacher_school_fieldsStr.append(" " + mf.getProperty()+"=? ");
						index_teacher_school_update++;
					}else{
						update_teacher_school_fieldsStr.append("," + mf.getProperty()+"=? ");
					}
					update_teacher_school_values.add(df.getValue());
				}
			}
		}
		if(hasTeacher){//更新教职工信息到教职工信息表reps_sch_teacher中
			if(update_teacher_values.size()>0){
				if(StringUtils.isBlank(teacherId)){
					String findTea=" select teacher_id from reps_sch_teacher_school where id='"+idValue+"' ";
					teacherId=(String)jdbcDao.queryForObject(findTea, String.class);
				}
				update_teacher_fieldsStr.append(" where id=? ");
				update_teacher_values.add(teacherId);
				jdbcDao.update(update_teacher_fieldsStr.toString(), update_teacher_values.toArray());
			}
		}else{//添加教职工信息到教职工信息表reps_sch_teacher中
			if(insert_teacher_fieldsStr.length()>0&&insert_teacher_valuesStr.length()>0){
				insert_teacher_fieldsStr.append(",valid_record");
				insert_teacher_valuesStr.append(",?");
				insert_teacher_values.add(1);
				String insert = "Insert into reps_sch_teacher (" + insert_teacher_fieldsStr.toString() + ")values(" + insert_teacher_valuesStr.toString() + ")";
				jdbcDao.update(insert, insert_teacher_values.toArray());
			}else{
				throw new Exception("添加--》数据对象【教职工基本信息】的数据项不能为空");
			}
		}
		//更新教籍信息到教籍信息表reps_sch_teacher_school中
		if(update_teacher_school_values.size()>0){
			update_teacher_school_fieldsStr.append(" where id=? ");
			update_teacher_school_values.add(idValue);
			jdbcDao.update(update_teacher_school_fieldsStr.toString(), update_teacher_school_values.toArray());
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
		    throw new Exception("删除记录错误:未设置数据对象【教职工基本信息】的ID");
		}
		//检查id对应的记录是否存在
		int count=jdbcDao.queryForInt(" select count(*) from reps_sch_teacher_school where id='"+id+"' ");
		if(count==1){
			jdbcDao.execute("update reps_sch_teacher_school set valid_record=0 where id='"+id+"' ");
			flag=true;
		}else{
			throw new Exception("删除--》数据对象【教职工基本信息】中【ID="+id+"】对应的教籍信息不存在");
		}
		return flag;
	}
	
}
