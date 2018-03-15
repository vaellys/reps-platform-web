package com.reps.platform.dsc;

import java.util.List;

import com.thoughtworks.xstream.annotations.XStreamAlias;
import com.thoughtworks.xstream.annotations.XStreamAsAttribute;

@XStreamAlias("entity")
public class MappingEntity {
	
	@XStreamAsAttribute
	private String operateClass;
	
	@XStreamAsAttribute
	private String name;
	
	private List<MappingField> fields;

	

	public String getOperateClass() {
		return operateClass;
	}

	public void setOperateClass(String operateClass) {
		this.operateClass = operateClass;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public List<MappingField> getFields() {
		return fields;
	}

	public void setFields(List<MappingField> fields) {
		this.fields = fields;
	}
	
	

}
