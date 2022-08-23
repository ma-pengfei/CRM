package com.itheima.crm.workbench.service.impl;

import com.itheima.crm.settings.dao.UserDao;
import com.itheima.crm.settings.domain.User;
import com.itheima.crm.workbench.dao.ClueActivityRelationDao;
import com.itheima.crm.workbench.domain.VO;
import com.itheima.crm.utils.SqlSessionUtil;
import com.itheima.crm.workbench.dao.ActivityDao;
import com.itheima.crm.workbench.dao.ActivityRemarkDao;
import com.itheima.crm.workbench.domain.Activity;
import com.itheima.crm.workbench.domain.ActivityRemark;
import com.itheima.crm.workbench.exception.AddException;
import com.itheima.crm.workbench.service.ActivityService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author Administrator
 */
public class ActivityServiceImpl implements ActivityService {

    private final ActivityDao activityDao = SqlSessionUtil.getSqlSession().getMapper(ActivityDao.class);
    private final ActivityRemarkDao activityRemarkDao = SqlSessionUtil.getSqlSession().getMapper(ActivityRemarkDao.class);
    private final UserDao userDao = SqlSessionUtil.getSqlSession().getMapper(UserDao.class);


    @Override
    public boolean addActivityInfo(Activity activity) throws AddException {

        int count = activityDao.addActivity(activity);
        if (count != 1) {
            throw new AddException("添加失败");
        }

        return true;
    }

    @Override
    public VO<Activity> queryActivityInfo(Map<String, Object> map) {

        //取得total
        int total = activityDao.queryTotal(map);
        //取得dataList
        List<Activity> activityList = activityDao.queryActivity(map);
        //封装数据到vo中
        VO<Activity> vo = new VO<>();
        vo.setDataList(activityList);
        vo.setTotal(total);

        return vo;

    }

    @Override
    public boolean deleteByIds(String[] checkedIds) {
        boolean flag = false;
        //查询出需要删除的备注的数量
        int count = activityRemarkDao.queryCountByActivityId(checkedIds);
        //删除备注，返回受到影响的条目数
        int deleteCount = activityRemarkDao.deleteByActivityId(checkedIds);
        //删除市场活动
        if (count == deleteCount) {
            int deleteNumber = activityDao.deleteByIds(checkedIds);
            if (deleteNumber == checkedIds.length) {
                flag = true;
            }
        }
        return flag;
    }

    @Override
    public Map<String,Object> getActivityInfo(String id) {

        List<User> userList = userDao.query();
        Activity activityInfo = activityDao.getActivityInfo(id);

        Map<String,Object> map = new HashMap<>();
        map.put("userList",userList);
        map.put("activityInfo",activityInfo);

        return map;

    }

    @Override
    public boolean updateActivityInfo(Activity activity) {
        boolean flag = false;

        int count = activityDao.updateActivityInfo(activity);

        if (count == 1) {
            flag = true;
        }
        return flag;
    }

    @Override
    public Activity detail(String id) {

        return activityDao.detail(id);
    }

    @Override
    public List<ActivityRemark> getRemarkListByActivityId(String activityId) {

        return activityRemarkDao.getRemarkListByActivityId(activityId);
    }

    @Override
    public boolean deleteRemarkById(String id) {

        int count = activityRemarkDao.deleteRemarkById(id);
        return count == 1;
    }

    @Override
    public boolean saveRemark(ActivityRemark activityRemark) {

        int count =  activityRemarkDao.saveRemark(activityRemark);

        return count == 1;
    }

    @Override
    public boolean updateRemark(ActivityRemark activityRemark) {

       int count = activityRemarkDao.updateRemark(activityRemark);
       return count == 1;
    }

    @Override
    public List<Activity> getActivityListByClueId(String clueId) {

        return activityDao.getActivityListByClueId(clueId);
    }

    @Override
    public List<Activity> queryActivityListNotRelationByName(Map<String, String> map) {

        return activityDao.queryActivityListNotRelationByName(map);
    }

    @Override
    public List<Activity> getActivityListByName(String name) {
        return activityDao.getActivityListByName(name);
    }
}
