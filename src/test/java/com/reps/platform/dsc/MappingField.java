package com.reps.platform.dsc;

import com.thoughtworks.xstream.annotations.XStreamAlias;
import com.thoughtworks.xstream.annotations.XStreamAsAttribute;

@XStreamAlias("field")
public class MappingField {
	
	@XStreamAsAttribute
	private String property;
	
	@XStreamAsAttribute
	private String name;
	
	@XStreamAsAttribute
	private String type;
	
	@XStreamAsAttribute
	private Integer length;
	
	@XStreamAsAttribute
	private String isMust;
	
	private MappingRef ref;

	public String getProperty() {
		return property;
	}

	public void setProperty(String property) {
		this.property = property;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public Integer getLength() {
		return length;
	}

	public void setLength(Integer length) {
		this.length = length;
	}

	public MappingRef getRef() {
		return ref;
	}

	public void setRef(MappingRef ref) {
		this.ref = ref;
	}

	public String getIsMust() {
		return isMust;
	}

	public void setIsMust(String isMust) {
		this.isMust = isMust;
	}

}
