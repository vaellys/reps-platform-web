package com.reps.platform.action;

import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.reps.core.RepsConstant;
import com.reps.core.RepsContext;
import com.reps.core.dictionary.DictionaryItem;
import com.reps.core.exception.RepsException;

/**
 * 只是用于行政区字典的树型选择
 * 
 * @author seastar
 *
 */
@Controller
@RequestMapping(value = RepsConstant.ACTION_BASE_PATH + "/sys/district")
public class DistrictAction {

	@RequestMapping(value = "/tree")
	public ModelAndView tree(String code, String filter, String callback) throws RepsException {
		ModelAndView mav = new ModelAndView("/system/district_tree");

		// 使用新的表
		// List<DictionaryItem> items =
		// RepsContext.getDictionaryItems("province");
		// List<DictionaryItem> cityItems =
		// RepsContext.getDictionaryItems("city");
		// List<DictionaryItem> blockItems =
		// RepsContext.getDictionaryItems("cityblock");
		// items.addAll(cityItems);
		// items.addAll(blockItems);

		// 使用原来的行政区表
		List<DictionaryItem> items = null;
		if (StringUtils.isNotBlank(filter)) {
			items = RepsContext.getDictionaryItemsByFilter("district", filter);
		} else {
			items = RepsContext.getDictionaryItems("district");
		}

		mav.addObject("treeList", items);

		mav.addObject("curcode", code);
		mav.addObject("callback", callback);
		return mav;
	}
}
