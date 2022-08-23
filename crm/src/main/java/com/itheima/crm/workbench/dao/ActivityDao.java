package com.itheima.crm.workbench.dao;

import com.itheima.crm.workbench.domain.Activity;
import com.itheima.crm.workbench.domain.ActivityRemark;

import java.util.List;
import java.util.Map;

public interface ActivityDao {

    List<Activity> getActivityListByClueId(String clueId);

    int addActivity(Activity activity);

    List<Activity> queryActivity(Map<String, Object> map);

    int queryTotal(Map<String, Object> map);

    int deleteByIds(String[] checkedIds);

    Activity getActivityInfo(String id);

    int updateActivityInfo(Activity activity);

    Activity detail(String id);

    List<Activity> queryActivityListNotRelationByName(Map<String, String> map);

    List<Activity> getActivityListByName(String name);
}
