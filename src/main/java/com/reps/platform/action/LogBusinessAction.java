package com.reps.platform.action;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
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

import com.reps.core.RepsConstant;
import com.reps.core.commons.Pagination;
import com.reps.core.exception.RepsException;
import com.reps.system.entity.LogBusiness;
import com.thoughtworks.xstream.XStream;

/**
 * @Title LogBusinessAction
 * @Description 日志管理动作类
 * @author Karlova
 * @date 2014-4-12
 * 
 */
@Controller("com.reps.platform.action.LogBusinessAction")
@RequestMapping(value = "/platform/sys/log")
public class LogBusinessAction {

	@Autowired
	MongoTemplate mongoTemplate;
	
	final static String tableName = LogBusiness.class.getSimpleName();

	protected final Logger log = LoggerFactory.getLogger(getClass());

	/**
	 * 
	 * @Title list @Description 分页查询所有日志的列表 @param @param pager @param @param
	 * log @param @return @param @throws RepsException @return
	 * ModelAndView @throws
	 */
	@RequestMapping(value = "/list")
	public ModelAndView list(Pagination pager, LogBusiness info) throws RepsException {
		Query query = new Query();
		if (info != null) {
			if (StringUtils.isNotBlank(info.getRepsUserName())) {
				query.addCriteria(new Criteria("repsUserName").regex(".*?" + info.getRepsUserName() + ".*"));
			}
			if (StringUtils.isNotBlank(info.getRepsOrgName())) {
				query.addCriteria(new Criteria("repsOrgName").regex(".*?" + info.getRepsOrgName() + ".*"));
			}
			if (StringUtils.isNotBlank(info.getLogTitle())) {
				query.addCriteria(new Criteria("logTitle").regex(".*?" + info.getLogTitle() + ".*"));
			}
			if (info.getBeginTime() != null) {
				query.addCriteria(new Criteria(RepsConstant.VERSION_FIELD_NAME).gte(info.getBeginTime()));
			}
		}

		long count = mongoTemplate.count(query, tableName);

		query.with(new Sort(new Order(Direction.DESC, RepsConstant.VERSION_FIELD_NAME)));
		query.skip(pager.getStartRow()).limit(pager.getPageSize());

		List<LogBusiness> list = mongoTemplate.find(query, LogBusiness.class, tableName);

		ModelAndView mav = new ModelAndView("/system/log/list");
		pager.setTotalRecord(count);
		mav.addObject("list", list);
		mav.addObject("pager", pager);
		return mav;
	}

	/**
	 * 
	 * @Title toXML @Description 将日志内容导出XML @param @param ids @param @param
	 * response @return void @throws
	 */
	@RequestMapping(value = "/toxml")
	public void toXML(LogBusiness info, HttpServletResponse response) {
		Query query = new Query();
		query.with(new Sort(new Order(Direction.ASC, RepsConstant.VERSION_FIELD_NAME)));
		if (info != null) {
			if (StringUtils.isNotBlank(info.getRepsUserName())) {
				query.addCriteria(new Criteria("repsUserName").regex(".*?\\" + info.getRepsUserName() + ".*"));
			}
			if (StringUtils.isNotBlank(info.getRepsOrgName())) {
				query.addCriteria(new Criteria("repsOrgName").regex(".*?\\" + info.getRepsOrgName() + ".*"));
			}
			if (StringUtils.isNotBlank(info.getLogTitle())) {
				query.addCriteria(new Criteria("logTitle").regex(".*?\\" + info.getLogTitle() + ".*"));
			}
			if (info.getBeginTime() != null) {
				query.addCriteria(new Criteria(RepsConstant.VERSION_FIELD_NAME).gte(info.getBeginTime()));
			}
		}
		List<LogBusiness> list = mongoTemplate.find(query, LogBusiness.class, tableName);
		XStream xstream = new XStream();
		String xml = xstream.toXML(list);
		OutputStream out = null;
		ByteArrayInputStream stream = null;
		try {
			response.reset();
//			response.setHeader("Location", "Log.xml");
//			response.setContentType("text/plain");
			response.setContentType("application/octet-stream");
			// 获得导出文件的名称
			String dispposition = "attachment;fileName=" + URLEncoder.encode("AA", "UTF-8") + System.currentTimeMillis() + ".xml";
			response.setHeader("Content-Disposition", dispposition);// 设置文件的名称
			int readedBytes = 0;
			byte[] buf = new byte[5120];
			stream = new ByteArrayInputStream(xml.getBytes());
			out = response.getOutputStream();
			while ((readedBytes = stream.read(buf)) > 0) {
				out.write(buf, 0, readedBytes);
			}
			out.flush();
		} catch (IOException e) {
			log.error("将日志内容导出XML出错", e);
		} finally {
			if (out != null) {
				try {
					out.close();
				} catch (IOException e) {
				}
			}
			if (stream != null) {
				try {
					stream.close();
				} catch (IOException e) {
				}
			}
		}
	}
}
