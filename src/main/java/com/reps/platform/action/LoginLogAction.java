package com.reps.platform.action;

import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.lang.StringUtils;
import org.reps.system.log.vo.AccountLog;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.data.domain.Sort.Direction;
import org.springframework.data.domain.Sort.Order;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.reps.core.commons.Pagination;
import com.reps.core.exception.RepsException;

/**
 * 登录日志查看
 * 
 * @author YangMing
 * @date 2016年9月22日 上午10:59:32
 *
 */
@Controller("com.reps.platform.action.LoginLogAction")
@RequestMapping(value = "/platform/sys/loginlog")
public class LoginLogAction {

	@Autowired
	MongoTemplate mongoTemplate;
	
	protected final Logger log = LoggerFactory.getLogger(getClass());

	/**
	 * 
	 * @Title list @Description 分页查询所有日志的列表 @param @param pager @param @param
	 *        log @param @return @param @throws RepsException @return
	 *        ModelAndView @throws
	 */
	@RequestMapping(value = "/list")
	public ModelAndView list(Pagination pager, AccountLog info, String logTable) throws RepsException {
		ModelAndView mav = new ModelAndView("/system/loginlog/list");
		if(StringUtils.isBlank(logTable)) {
			logTable = AccountLog.getTableName(new Date());
		}
		Set<String> logTables = mongoTemplate.getCollectionNames();
		Map<String, String> tablesMap = new LinkedHashMap<>();
		if (logTables != null && !logTables.isEmpty()) {
			String tableNamePre = AccountLog.getTableNamePre();
			for (String table : logTables) {
				if (!table.startsWith(tableNamePre)) {
					continue;
				}
				tablesMap.put(table, table);
			}
		}
		
		Query query = new Query();
		if (info != null) {
			if (StringUtils.isNotBlank(info.getLoginName())) {
				//query.addCriteria(new Criteria("loginName").regex(".*?" + info.getLoginName() + ".*"));
				query.addCriteria(new Criteria("loginName").is(info.getLoginName()));
			}
			if (info.getLoginWith() != null) {
				//query.addCriteria(new Criteria("loginName").regex(".*?" + info.getLoginName() + ".*"));
				query.addCriteria(new Criteria("loginWith").is(info.getLoginWith()));
			}
		}

		long count = mongoTemplate.count(query, logTable);

		query.with(new Sort(new Order(Direction.DESC, "logTime")));
		query.skip(pager.getStartRow()).limit(pager.getPageSize());

		List<AccountLog> listLog = mongoTemplate.find(query, AccountLog.class, logTable);

		pager.setTotalRecord(count);
		mav.addObject("tablesMap", tablesMap);
		mav.addObject("logTable", logTable);
		mav.addObject("list", listLog);
		mav.addObject("pager", pager);
		mav.addObject("info", info);
		return mav;
	}
	
	@RequestMapping(value = "/report")
	public ModelAndView report(String logTable) {
		ModelAndView mav = new ModelAndView("/system/loginlog/report");
		
//		Query query = new Query();
//		long count = mongoTemplate.count(query, logTable);
//		if(count == 0) {
//			return mav;
//		}
//		query = new Query();
//		query.with(new Sort(new Order(Direction.ASC, "logTime")));
//		query.skip(0).limit(1);
//		List<AccountLog> firstData = mongoTemplate.find(query, AccountLog.class, logTable);
//		
//		Date startDate = firstData.get(0).getLogTime();
//		
//		query = new Query();
//		query.with(new Sort(new Order(Direction.DESC, "logTime")));
//		query.skip(0).limit(1);
//		List<AccountLog> lastData = mongoTemplate.find(query, AccountLog.class, logTable);
//		
//		Date endDate = firstData.get(0).getLogTime();
		
		return mav;
	}
	
}
