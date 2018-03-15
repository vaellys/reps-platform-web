package com.reps.platform;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;

import com.reps.core.log.LogInfo;
import com.reps.system.SystemDataImpl;
import com.reps.system.entity.LogBusiness;

public class PlatformDataImpl extends SystemDataImpl {

	@Autowired
	MongoTemplate mongoTemplate;
	
	@Override
	public void saveLog(List<LogInfo> logs) {
		try {
			for (LogInfo b : logs) {
				LogBusiness lb = new LogBusiness();
				lb.setLogContent(b.getLogContent());
				lb.setLogLevel(b.getLogLevel());
				lb.setLogTitle(b.getLogTitle());
				lb.setOperation(b.getOperation());
				lb.setRepsOrgId(b.getOrgId());
				lb.setRepsOrgName(b.getOrgName());
				lb.setRepsUserId(b.getUserId());
				lb.setRepsUserName(b.getUserName());
				mongoTemplate.save(lb, lb.getClass().getSimpleName());
			}
		} catch (Exception e) {
			log.error("保存日志出错!", e);
		}
	}
	
}
