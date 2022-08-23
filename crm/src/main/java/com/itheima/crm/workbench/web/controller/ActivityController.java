package com.itheima.crm.workbench.web.controller;

import com.itheima.crm.settings.domain.User;
import com.itheima.crm.workbench.domain.VO;
import com.itheima.crm.settings.service.UserService;
import com.itheima.crm.settings.service.impl.UserServiceImpl;
import com.itheima.crm.utils.*;
import com.itheima.crm.workbench.domain.Activity;
import com.itheima.crm.workbench.domain.ActivityRemark;
import com.itheima.crm.workbench.service.ActivityService;
import com.itheima.crm.workbench.service.impl.ActivityServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.*;

/**
 * @author Administrator
 */
public class ActivityController extends HttpServlet {

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        System.out.println("进入到市场活动控制器");

        String path = request.getServletPath();

        if ("/workbench/activity/getUserList.do".equals(path)){
            getUserList(request,response);
        } else if ("/workbench/activity/save.do".equals(path)) {
            save(request,response);
        } else if ("/workbench/activity/pageList.do".equals(path)) {
            pageList(request, response);
        } else if ("/workbench/activity/delete.do".equals(path)) {
            delete(request, response);
        } else if ("/workbench/activity/getActivityInfo.do".equals(path)) {
            getActivityInfo(request, response);
        } else if ("/workbench/activity/updateActivityInfo.do".equals(path)) {
            updateActivityInfo(request, response);
        } else if ("/workbench/activity/detail.do".equals(path)) {
            detail(request, response);
        } else if ("/workbench/activity/getRemarkListByActivityId.do".equals(path)) {
            getRemarkListByActivityId(request, response);
        } else if ("/workbench/activity/deleteRemarkById.do".equals(path)) {
            deleteRemarkById(request, response);
        } else if ("/workbench/activity/saveRemark.do".equals(path)) {
            saveRemark(request, response);
        } else if ("/workbench/activity/updateRemark.do".equals(path)) {
            updateRemark(request, response);
        }
    }

    private void updateRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入修改市场活动的备注");
        //接收参数
        String id = request.getParameter("id");
        String noteContent = request.getParameter("noteContent");
        //封装数据
        ActivityRemark activityRemark = new ActivityRemark();
        activityRemark.setId(id);
        activityRemark.setNoteContent(noteContent);
        activityRemark.setEditBy(((User)request.getSession().getAttribute("user")).getName());
        activityRemark.setEditTime(DateTimeUtil.getSysTime());
        activityRemark.setEditFlag("1");
        //调用service
        ActivityService service = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        boolean success = service.updateRemark(activityRemark);
        Map<String, Object> map = new HashMap<>();
        map.put("success", success);
        map.put("activityRemark",activityRemark);
        PrintJson.printJsonObj(response, map);
    }

    private void saveRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入添加市场活动的备注");
        //接收参数
        String activityId = request.getParameter("activityId");
        String noteContent = request.getParameter("noteContent");
        //封装数据
        ActivityRemark activityRemark = new ActivityRemark();
        activityRemark.setId(UUIDUtil.getUUID());
        activityRemark.setNoteContent(noteContent);
        activityRemark.setCreateTime(DateTimeUtil.getSysTime());
        activityRemark.setCreateBy(((User) request.getSession().getAttribute("user")).getName());
        activityRemark.setActivityId(activityId);
        activityRemark.setEditFlag("0");
        //调用service
        ActivityService service = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        boolean success = service.saveRemark(activityRemark);
        Map<String, Object> map = new HashMap<>();
        map.put("success", success);
        map.put("activityRemark",activityRemark);
        PrintJson.printJsonObj(response, map);
    }

    private void deleteRemarkById(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("根据备注的id删除备注");
        //接收参数
        String id = request.getParameter("id");
        ActivityService service = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        boolean flag = service.deleteRemarkById(id);
        PrintJson.printJsonFlag(response,flag);
    }

    private void getRemarkListByActivityId(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("根据市场活动的id取得市场活动的备注");
        //接收参数
        String activityId = request.getParameter("activityId");

        ActivityService service = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        List<ActivityRemark> activityRemarkList = service.getRemarkListByActivityId(activityId);

        PrintJson.printJsonObj(response,activityRemarkList);

    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("跳转到市场活动详细信息页面");
        //接收数据
        String id = request.getParameter("id");
        ActivityService service = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        Activity activityInfo = service.detail(id);
        request.setAttribute("activityInfo", activityInfo);
        request.getRequestDispatcher("/workbench/activity/detail.jsp").forward(request,response);

    }

    private void updateActivityInfo(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("更新市场活动信息");
        //接收数据
        String id = request.getParameter("id");
        String owner = request.getParameter("owner");
        String name = request.getParameter("name");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String cost = request.getParameter("cost");
        String description = request.getParameter("description");
        //获取系统当前时间作为修改时间
        String currentTime = DateTimeUtil.getSysTime();
        //获取修改者
        User user = (User) request.getSession().getAttribute("user");
        //封装数据
        Activity activity = new Activity();
        activity.setId(id);
        activity.setOwner(owner);
        activity.setName(name);
        activity.setStartDate(startDate);
        activity.setEndDate(endDate);
        activity.setCost(cost);
        activity.setDescription(description);
        activity.setEditTime(currentTime);
        activity.setEditBy(user.getName());


        ActivityService service = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        //更新市场活动信息
        boolean flag = service.updateActivityInfo(activity);
        PrintJson.printJsonFlag(response, flag);
    }


    private void getActivityInfo(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("查询市场活动信息");

        String id = request.getParameter("id");

        ActivityService service = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        //查询市场活动信息
        Map<String,Object> map = service.getActivityInfo(id);
        //查询用户列表
        //封装数据
        PrintJson.printJsonObj(response, map);
    }

    private void delete(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("执行市场活动的删除操作");

        //获取参数
        String[] checkedIds = request.getParameterValues("id");

        System.out.println(Arrays.toString(checkedIds));

        ActivityService service = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());

        boolean flag = service.deleteByIds(checkedIds);

        PrintJson.printJsonFlag(response,flag);
    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("查询市场活动信息以及分页查询");
        //接收参数
        String name = request.getParameter("name");
        String owner = request.getParameter("owner");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        //每页展现的条目数
        String pageSizeStr = request.getParameter("pageSize");
        int pageSize = Integer.parseInt(pageSizeStr);
        //计算起始条目数
        String pageNumber = request.getParameter("pageNumber");
        int indexNumber = ( Integer.parseInt(pageNumber) - 1 ) * pageSize;

        //封装数据
        Map<String, Object> map = new HashMap<>();
        map.put("name",name);
        map.put("owner",owner);
        map.put("startDate",startDate);
        map.put("endDate",endDate);
        map.put("pageSize",pageSize);
        map.put("indexNumber",indexNumber);

        //获取动态代理
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());

        VO<Activity> vo = activityService.queryActivityInfo(map);

        PrintJson.printJsonObj(response, vo);
    }

    private void save(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("添加市场活动信息");
        //获取数据
        String owner = request.getParameter("owner");
        String name = request.getParameter("name");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String cost = request.getParameter("cost");
        String description = request.getParameter("description");
        //封装数据
        Activity activity = new Activity();
        activity.setOwner(owner);
        activity.setName(name);
        activity.setStartDate(startDate);
        activity.setEndDate(endDate);
        activity.setCost(cost);
        activity.setDescription(description);
        //获取UUID
        String uuid = UUIDUtil.getUUID();
        activity.setId(uuid);
        //获取系统当前时间作为创建时间
        String currentTime = DateTimeUtil.getSysTime();
        activity.setCreateTime(currentTime);
        //获取创建者
        User user = (User) request.getSession().getAttribute("user");
        activity.setCreateBy(user.getName());

        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());


        //响应 添加是否成功
        try{
            activityService.addActivityInfo(activity);
            PrintJson.printJsonFlag(response,true);
        } catch (Exception e){
            e.printStackTrace();
            //添加失败
            String message = e.getMessage();
            Map<String,Object> map = new HashMap<>();
            map.put("success",false);
            map.put("msg",message);
            PrintJson.printJsonObj(response,map);
        }

    }

    private void getUserList(HttpServletRequest request, HttpServletResponse response) {

        System.out.println("查询用户信息列表");

        UserService userService = (UserService) ServiceFactory.getService(new UserServiceImpl());

        List<User> userList = userService.getUserList();

        PrintJson.printJsonObj(response, userList);
    }

}


