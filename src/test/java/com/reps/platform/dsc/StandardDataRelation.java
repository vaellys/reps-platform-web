package com.reps.platform.dsc;

import com.reps.dsc.core.data.DataField;

/**
 * 
* @author zds
* @date 2016-4-20 下午12:50:08
*
 */
public class StandardDataRelation {
	private String standardName; //标准名称
	private DataField dataField; //数据实体
	private MappingField mappingField; //标准实体
	
	public String getStandardName() {
		return standardName;
	}
	public void setStandardName(String standardName) {
		this.standardName = standardName;
	}
	public DataField getDataField() {
		return dataField;
	}
	public void setDataField(DataField dataField) {
		this.dataField = dataField;
	}
	public MappingField getMappingField() {
		return mappingField;
	}
	public void setMappingField(MappingField mappingField) {
		this.mappingField = mappingField;
	}
}
