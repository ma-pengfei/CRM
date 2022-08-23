package com.itheima.crm.workbench.dao;

import com.itheima.crm.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActivityRemarkDao {

    int queryCountByActivityId(String[] checkedIds);

    int deleteByActivityId(String[] checkedIds);

    List<ActivityRemark> getRemarkListByActivityId(String activityId);

    int deleteRemarkById(String id);

    int saveRemark(ActivityRemark activityRemark);

    int updateRemark(ActivityRemark activityRemark);
}
