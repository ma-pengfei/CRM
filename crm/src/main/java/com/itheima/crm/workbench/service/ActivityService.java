package com.itheima.crm.workbench.service;

import com.itheima.crm.workbench.domain.VO;
import com.itheima.crm.workbench.domain.Activity;
import com.itheima.crm.workbench.domain.ActivityRemark;
import com.itheima.crm.workbench.exception.AddException;

import java.util.List;
import java.util.Map;

/**
 * @author Administrator
 */
public interface ActivityService {

  boolean addActivityInfo(Activity activity) throws AddException;

    VO<Activity> queryActivityInfo(Map<String, Object> map);

    boolean deleteByIds(String[] checkedIds);

    Map<String,Object> getActivityInfo(String id);

    boolean updateActivityInfo(Activity activity);

    Activity detail(String id);

    List<ActivityRemark> getRemarkListByActivityId(String activityId);

    boolean deleteRemarkById(String id);

    boolean saveRemark(ActivityRemark activityRemark);

    boolean updateRemark(ActivityRemark activityRemark);

    List<Activity> getActivityListByClueId(String clueId);

    List<Activity> queryActivityListNotRelationByName(Map<String, String> map);

    List<Activity> getActivityListByName(String name);
}
