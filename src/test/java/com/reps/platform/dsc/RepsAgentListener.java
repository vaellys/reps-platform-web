//package com.reps.platform.dsc;
//
//import java.util.ArrayList;
//import java.util.HashMap;
//import java.util.List;
//import java.util.Map;
//
//import org.apache.commons.lang.StringUtils;
//
//import com.reps.core.SpringContext;
//import com.reps.core.standard.IDataReceiver;
//import com.reps.dsc.core.DataField;
//import com.reps.dsc.core.DataObject;
//import com.reps.dsc.core.Result;
//import com.reps.dsc.sdk.IAgentListener;
//
//public class RepsAgentListener implements IAgentListener {
//    
//    private static Map<String,IDataReceiver> receivers=new HashMap<String,IDataReceiver>();
//    
//    public IDataReceiver getByObjName(String name){
//        if(receivers.size()==0){
//            
//            Map<String,IDataReceiver> myreceivers= (Map<String,IDataReceiver>)SpringContext.getBeans(IDataReceiver.class);
//            for(IDataReceiver dr : myreceivers.values()){
//                receivers.put(dr.getObjName(), dr);
//            }
//        }
//        if(receivers.containsKey(name)){
//            return receivers.get(name);
//        }
//        return null;
//    }
//
//	public void doAdd(DataObject data){
//		System.out.println("接收到的[添加]的对象：" + data.getName());
//		
//		try {
//			//获取数据对象名称
//			String objName=data.getName();
//			//获取数据对象数据项列表
//			List<DataField> dfList=data.getFields();
//			if(StringUtils.isNotBlank(data.getId())){
//				//主键添加到数据项列表中
//				DataField df=new DataField("ID",data.getId());
//				dfList.add(df);
//				//保存数据到数据库中
//				DataObjectHandle dbo=new DataObjectHandle(objName);
//				dbo.save(dfList);//完成数据校验、数据项与字段转换并保存数据
//			}else{
//				throw new Exception("数据对象【"+objName+"】的id不能为空");
//			}
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
//	}
//	
//	public void doUpddate(DataObject data) {
//		
//		System.out.println("接收到的[更新]的对象：" + data.getName());
//		try {
//			//获取数据对象名称
//			String objName=data.getName();
//			//获取数据对象数据项列表
//			List<DataField> dfList=data.getFields();
//			
//			if(StringUtils.isNotBlank(data.getId())){
//				DataField df=new DataField("ID",data.getId());
//				dfList.add(df);
//				//更新数据到数据库中
//				DataObjectHandle dbo=new DataObjectHandle(objName);
//				dbo.update(dfList);//完成数据校验、数据项与字段转换并更新数据
//			}
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
//	}
//	
//	public void doDelete(DataObject data) {
//		System.out.println("接收到的[删除]的对象：" + data.getName());
//		try {
//			String id=data.getId();
//		    String objName=data.getName();
//			if(StringUtils.isBlank(id)){
//				throw new Exception("删除--数据对象【"+objName+"】的id不能为空");
//			}
//			//删除数据库中对应数据
//			DataObjectHandle dbo=new DataObjectHandle(objName);
//			dbo.delete(id);
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
//	}
//
//	public void doResult(List<DataObject> list) {
//		System.out.println("接收到的[集合]的对象的数量：" + list.size());
//		if(list!=null && list.size()>0){
//		    String name=list.get(0).getName();
//    		IDataReceiver dr=getByObjName(name);
//            if(dr!=null){
//                List<Map<String,Object>> result=new ArrayList<Map<String,Object>>();
//                for(DataObject obj : list){
//                    Map<String,Object> map=new HashMap<String,Object>();
//                    for(DataField df:obj.getFields()){
//                        map.put(df.getName(), df.getValue());
//                    }
//                    result.add(map);
//                }
//                dr.doResult(result);
//            }
//		}
//	}
//	
//	
//}
