package com.reps.platform.dsc;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.StringUtils;

import com.reps.dsc.core.data.DataField;

public class DataObjectHandle  {
	
	//数据对象名称
	private String objName=null;
	private BaseOperateInterface baseOperate=null;
	
	public DataObjectHandle(String objName){
		try {
			this.objName=objName;
			String className=StandardDataMapping.getClassName(objName);
			@SuppressWarnings("unchecked")
			Class<BaseOperateInterface> c=(Class<BaseOperateInterface>) Class.forName(className);
			baseOperate=c.newInstance();
		}catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}catch (InstantiationException e){
            e.printStackTrace();
        }catch (IllegalAccessException e){
            e.printStackTrace();
        }
	}
	
	
	/**
	 * 
	* @author zds
	* @date  2016-4-20 上午10:47:11
	* @param dfList
	* @throws Exception
	* @return void
	 */
	public void save(List<DataField> dfList) throws Exception{
		
		//获取校验标准
		List<MappingField> mfList=StandardDataMapping.getFields(objName);
		//数据实体与数据标准绑定
		List<StandardDataRelation> relationList=getRelation(mfList, dfList);
		//数据校验
		checkValue(relationList,0);
		
		baseOperate.save(relationList);
	}
	
	/**
	 * 
	* @author zds
	* @date  2016-4-18 下午2:25:25
	* @param dfList 要修改的字段列表
	* @return
	* @throws Exception
	* @return boolean
	 */
	public boolean update(List<DataField> dfList) throws Exception {
		boolean flag=false;
		
		//获取校验标准
		List<MappingField> mfList=StandardDataMapping.getFields(objName);
		//数据实体与数据标准绑定
		List<StandardDataRelation> relationList=getRelation(mfList, dfList);
		//数据校验
		checkValue(relationList,1);
		flag=baseOperate.update(relationList);
		return flag;
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
	public boolean delete(String id) throws Exception{
		boolean flag=false;
		flag=baseOperate.delete(id);
		return flag;
	}

	//字段校验
	public void checkValue(List<StandardDataRelation> relationList,int flag) throws Exception{
		
		//数据标准是否为空
		if(relationList==null){
	        throw new Exception("无任何校验标准");
	    }
		
		for(StandardDataRelation relation:relationList){
			DataField df=relation.getDataField();
			MappingField mf=relation.getMappingField();
			String standardName=relation.getStandardName();
			
			//非空校验
			if("yes".equalsIgnoreCase(mf.getIsMust())){
				//flag=0 插入  flag=1更新
				if(flag==0&&(df==null||df.getValue()==null)){
					throw new Exception("添加--》数据对象【"+objName+"】中的数据项【"+standardName+"】不能为空");
				}
				if(flag==1&&df!=null&&(df.getValue()==null||StringUtils.isBlank(df.getValue().toString()))){
					throw new Exception("更新--》数据对象【"+objName+"】中的数据项【"+standardName+"】不能为空");
				}
			}
			//数据校验 只对数值型数据校验
			if(df!=null&&df.getValue()!=null){
				if("N".equalsIgnoreCase(mf.getType())){
					String value=df.getValue().toString().trim();
					if(!value.matches("^[-+]?(([0-9]+)([.]([0-9]+))?|([.]([0-9]+))?)$")){
						throw new Exception("数据对象【"+objName+"】中的数据项【"+standardName+"】应为数值型");
					}
				}
			}
			//长度校验 只对字符型数据校验
			if(df!=null&&df.getValue()!=null){
				if("C".equalsIgnoreCase(mf.getType())){
					String value=df.getValue().toString().trim();
					if(value.length()>mf.getLength()){
						throw new Exception("数据对象【"+objName+"】中的数据项【"+df.getName()+"】长度超过最大值");
					}
				}
			}
		}
	}
	
	//获取关联关系列表
	public List<StandardDataRelation> getRelation(List<MappingField> mfList,List<DataField> dfList){
		List<StandardDataRelation> relationList=new ArrayList<StandardDataRelation>();
		for(int i=0;i<mfList.size();i++){
			MappingField mf=mfList.get(i);
			int j=0;
			for(j=0;j<dfList.size();j++){
				DataField df=dfList.get(j);
				if(mf.getName().equalsIgnoreCase(df.getName())){
					StandardDataRelation sd=new StandardDataRelation();
					sd.setStandardName(mf.getName());
					sd.setDataField(df);
					sd.setMappingField(mf);
					relationList.add(sd);
					break;
				}
			}
			if(j==dfList.size()){
				StandardDataRelation sd=new StandardDataRelation();
				sd.setStandardName(mf.getName());
				sd.setDataField(null);
				sd.setMappingField(mf);
				relationList.add(sd);
			}
		}
		return relationList;
	}
}
