package com.reps.platform.dsc;

import java.io.File;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.thoughtworks.xstream.XStream;

/**
 * 标准数据与实体数据的映射,应该考虑是否通过接口来实现
 * @author seastar
 */
public class StandardDataMapping {
	private static final Log log = LogFactory.getLog(StandardDataMapping.class);
	private static XStream xstream;
	
	/**
     * 实体的属性与标准对象的字段的映射
     */
    private static Map<String,Map<String,MappingField>> dataFieldMap=new HashMap<String,Map<String,MappingField>>();
    private static Map<String,String> nameClassMap=new HashMap<String,String>();
    
	
	private StandardDataMapping(){
		xstream = new XStream();
        xstream.processAnnotations(MappingEntity.class);
        xstream.processAnnotations(MappingField.class);
        xstream.processAnnotations(MappingRef.class);
	}
    
    /**
     * 添加映射
     * @param c
     * @param name
     * @param fields
     */
    private static void add(String name,Map<String,MappingField> fields){
    	dataFieldMap.put(name, fields);
    }
    
    /**
     * 添加映射
     * @param c
     * @param name
     * @param className
     */
    private static void add(String name,String className){
    	nameClassMap.put(name, className);
    }

    //读取配置文件到对象
    public static void initConfig(){
    	if(xstream==null){
	    	xstream = new XStream();
	        xstream.processAnnotations(MappingEntity.class);
	        xstream.processAnnotations(MappingField.class);
	        xstream.processAnnotations(MappingRef.class);
    	}
		//读取配置文件
        URL url=Thread.currentThread().getContextClassLoader().getResource("/dscmap");
        if(url==null){
        	log.info("未找到任何数据交换配置文件");
        }
		String path=url.getPath();
		File mapPath=new File(path);
		if(mapPath.exists()){
			File[] xmlFiles=mapPath.listFiles();
			for(File xml : xmlFiles){
				try{
					@SuppressWarnings("unchecked")
					List<MappingEntity> entities=(List<MappingEntity>)xstream.fromXML(xml);
					for(MappingEntity me : entities){
						Map<String,MappingField> fields=new HashMap<String,MappingField>();
						for(MappingField mf : me.getFields()){
							fields.put(mf.getProperty(), mf);
						}
						StandardDataMapping.add(me.getName(), me.getOperateClass());
						StandardDataMapping.add(me.getName(), fields);
					}
				}catch(Exception exp){
					exp.printStackTrace();
				}
			}
		}
    }
    
    /**
     * 根据名称获取数据对象字段列表
     * @param name
     * @return
     */
    public static List<MappingField> getFields(String name){
    	
    	if(dataFieldMap.size()==0){
    		initConfig();
    	}
    	if(dataFieldMap.containsKey(name)){
    		List<MappingField> result=new ArrayList<MappingField>();
    		Map<String,MappingField> mappingField= dataFieldMap.get(name);
    		Set<String> set = mappingField.keySet();
    		for(Iterator<String> iter = set.iterator(); iter.hasNext();){
    			String key = iter.next();
    			MappingField value = mappingField.get(key);
    			result.add(value);
    		}
    		return result;
    	}else{
    		return null;
    	}
    }
    	
    	
	/**
     * 根据名称获取处理类名称
     * @param name
     * @return
     */
    public static String getClassName(String name){
    	if(nameClassMap.size()==0){
    		initConfig();
    	}
    	if(nameClassMap.containsKey(name)){
    		String className= nameClassMap.get(name);
    		return className;
    	}else{
    		return null;
    	}
    }
}
