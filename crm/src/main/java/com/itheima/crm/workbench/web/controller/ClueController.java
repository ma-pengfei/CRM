package com.itheima.crm.workbench.web.controller;

import com.itheima.crm.settings.domain.User;
import com.itheima.crm.settings.service.UserService;
import com.itheima.crm.settings.service.impl.UserServiceImpl;
import com.itheima.crm.utils.DateTimeUtil;
import com.itheima.crm.utils.PrintJson;
import com.itheima.crm.utils.ServiceFactory;
import com.itheima.crm.utils.UUIDUtil;
import com.itheima.crm.workbench.domain.*;
import com.itheima.crm.workbench.service.ActivityService;
import com.itheima.crm.workbench.service.ClueService;
import com.itheima.crm.workbench.service.impl.ActivityServiceImpl;
import com.itheima.crm.workbench.service.impl.ClueServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author Administrator
 */
public class ClueController extends HttpServlet {

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        System.out.println("进入到线索控制器");

        String path = request.getServletPath();

        if ("/workbench/clue/getUserList.do".equals(path)){
            getUserList(request,response);
        } else if ("/workbench/clue/save.do".equals(path)){
            save(request,response);
        } else if ("/workbench/clue/pageList.do".equals(path)){
            pageList(request,response);
        } else if ("/workbench/clue/getClueById.do".equals(path)){
            getClueById(request,response);
        } else if ("/workbench/clue/updateClue.do".equals(path)){
            updateClue(request,response);
        } else if ("/workbench/clue/deleteClue.do".equals(path)){
            deleteClue(request,response);
        } else if ("/workbench/clue/detail.do".equals(path)){
            detail(request,response);
        } else if ("/workbench/clue/getRemarkListByClueId.do".equals(path)){
            getRemarkListByClueId(request,response);
        } else if ("/workbench/clue/updateRemarkById.do".equals(path)){
            updateRemarkById(request,response);
        } else if ("/workbench/clue/deleteRemarkById.do".equals(path)){
            deleteRemarkById(request,response);
        } else if ("/workbench/clue/saveRemarkById.do".equals(path)){
            saveRemarkById(request,response);
        } else if ("/workbench/clue/getActivityListByClueId.do".equals(path)){
            getActivityListByClueId(request,response);
        } else if ("/workbench/clue/queryActivityListNotRelationByName.do".equals(path)){
            queryActivityListNotRelationByName(request,response);
        } else if ("/workbench/clue/unbund.do".equals(path)){
            unbund(request,response);
        } else if ("/workbench/clue/bund.do".equals(path)){
            bund(request,response);
        } else if ("/workbench/clue/getActivityListByName.do".equals(path)){
            getActivityListByName(request,response);
        } else if ("/workbench/clue/convert.do".equals(path)){
            convert(request,response);
        }

    }

    private void convert(HttpServletRequest request, HttpServletResponse response) throws IOException {
        System.out.println("进入线索转换");
        //接收clueId
        String clueId = request.getParameter("clueId");

        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        Tran tran = null;
        //接收是否创建交易标志
        if ("1".equals(request.getParameter("flag"))){
            tran = new Tran();
            //接收参数
            String money = request.getParameter("money");
            String name = request.getParameter("name");
            String expectedDate = request.getParameter("expectedDate");
            String stage = request.getParameter("stage");
            String activityId = request.getParameter("activityId");
            String id = UUIDUtil.getUUID();
            String createTime = DateTimeUtil.getSysTime();
            tran.setId(id);
            tran.setMoney(money);
            tran.setName(name);
            tran.setExpectedDate(expectedDate);
            tran.setStage(stage);
            tran.setActivityId(activityId);
            tran.setCreateBy(createBy);
            tran.setCreateTime(createTime);
        }
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean success = clueService.convert(clueId,tran,createBy);

        if (success){
            response.sendRedirect(request.getContextPath()+"/workbench/clue/index.jsp");
        }
    }

    private void getActivityListByName(HttpServletRequest request, HttpServletResponse response) {
        //获取查询条件
        String name = request.getParameter("name");
        //调用service
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        List<Activity> list = activityService.getActivityListByName(name);
        //返回结果
        PrintJson.printJsonObj(response,list);
    }

    private void bund(HttpServletRequest request, HttpServletResponse response) {

        //接收参数
        String clueId = request.getParameter("clueId");
        String[] activityIds = request.getParameterValues("activityId");

        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean falg = clueService.bund(clueId, activityIds);

        PrintJson.printJsonFlag(response, falg);
    }

    private void unbund(HttpServletRequest request, HttpServletResponse response) {
        //获取参数
        String id = request.getParameter("id");
        //调用service
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean success = clueService.unbund(id);
        //响应数据
        PrintJson.printJsonFlag(response, success);
    }

    private void queryActivityListNotRelationByName(HttpServletRequest request, HttpServletResponse response) {
        //获取参数
        String name = request.getParameter("name");
        String clueId = request.getParameter("clueId");
        Map<String,String> map = new HashMap<>();
        map.put("name",name);
        map.put("clueId",clueId);
        //调用service
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        List<Activity> activityList = activityService.queryActivityListNotRelationByName(map);
        //响应数据
        PrintJson.printJsonObj(response, activityList);
    }

    private void getActivityListByClueId(HttpServletRequest request, HttpServletResponse response) {
        //获取参数
        String clueId = request.getParameter("clueId");
        //调用service
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        List<Activity> activityList = activityService.getActivityListByClueId(clueId);
        //响应数据
        PrintJson.printJsonObj(response, activityList);
    }

    private void saveRemarkById(HttpServletRequest request, HttpServletResponse response) {
        //获取参数
        String clueId = request.getParameter("clueId");
        String noteContent = request.getParameter("noteContent");
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        String createTime = DateTimeUtil.getSysTime();
        String id = UUIDUtil.getUUID();
        //封装对象
        ClueRemark clueRemark = new ClueRemark();
        clueRemark.setId(id);
        clueRemark.setNoteContent(noteContent);
        clueRemark.setCreateBy(createBy);
        clueRemark.setCreateTime(createTime);
        clueRemark.setClueId(clueId);
        //调用service
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean success = clueService.saveRemarkById(clueRemark);
        Map<String,Object> map = new HashMap<>();
        map.put("success",success);
        map.put("clueRemark",clueRemark);
        //响应数据
        PrintJson.printJsonObj(response, map);
    }

    private void deleteRemarkById(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入删除线索备注");
        //获取参数
        String id = request.getParameter("id");
        //调用service
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean flag = clueService.deleteRemarkById(id);
        //响应数据
        PrintJson.printJsonFlag(response, flag);
    }

    private void updateRemarkById(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入修改线索备注");
        //获取参数
        String id = request.getParameter("id");
        String noteContent = request.getParameter("noteContent");
        String editBy = ((User)request.getSession().getAttribute("user")).getName();
        String editTime = DateTimeUtil.getSysTime();
        String editFlag = "1";
        //封装对象
        ClueRemark clueRemark = new ClueRemark();
        clueRemark.setId(id);
        clueRemark.setNoteContent(noteContent);
        clueRemark.setEditBy(editBy);
        clueRemark.setEditTime(editTime);
        clueRemark.setEditFlag(editFlag);
        //调用service
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean success =  clueService.updateRemarkById(clueRemark);
        Map<String,Object> map = new HashMap<>();
        map.put("success",success);
        map.put("clueRemark",clueRemark);
        //响应数据
        PrintJson.printJsonObj(response,map);
    }

    private void getRemarkListByClueId(HttpServletRequest request, HttpServletResponse response) {
        //获取参数
        String clueId = request.getParameter("clueId");
        //调用service
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        List<ClueRemark> clueRemarkList = clueService.getRemarkListByClueId(clueId);
        //响应数据
        PrintJson.printJsonObj(response, clueRemarkList);
    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("跳转到详细线索信息页");
        //获取参数
        String id = request.getParameter("id");
        //调用service
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        Clue clue = clueService.detail(id);
        //响应数据
        request.setAttribute("clue",clue);
        request.getRequestDispatcher("/workbench/clue/detail.jsp").forward(request,response);
    }


    private void deleteClue(HttpServletRequest request, HttpServletResponse response) {
        //获取参数
        String[] checkedIds = request.getParameterValues("id");
        //调用service
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean flag = clueService.deleteClue(checkedIds);
        //响应数据
        PrintJson.printJsonFlag(response, flag);
    }

    private void updateClue(HttpServletRequest request, HttpServletResponse response) {
        //获取参数
        String id = request.getParameter("id");
        String owner = request.getParameter("owner");
        String fullname = request.getParameter("fullname");
        String company = request.getParameter("company");
        String appellation = request.getParameter("appellation");
        String job = request.getParameter("job");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String website = request.getParameter("website");
        String mphone = request.getParameter("mphone");
        String state = request.getParameter("state");
        String source = request.getParameter("source");
        String description = request.getParameter("description");
        String contactSummary = request.getParameter("contactSummary");
        String nextContactTime = request.getParameter("nextContactTime");
        String address = request.getParameter("address");
        String editBy = ((User)request.getSession().getAttribute("user")).getName();
        String editTime = DateTimeUtil.getSysTime();
        //封装对象
        Clue clue = new Clue();
        clue.setId(id);
        clue.setOwner(owner);
        clue.setFullname(fullname);
        clue.setCompany(company);
        clue.setAppellation(appellation);
        clue.setJob(job);
        clue.setEmail(email);
        clue.setPhone(phone);
        clue.setWebsite(website);
        clue.setMphone(mphone);
        clue.setState(state);
        clue.setSource(source);
        clue.setDescription(description);
        clue.setContactSummary(contactSummary);
        clue.setNextContactTime(nextContactTime);
        clue.setAddress(address);
        clue.setEditBy(editBy);
        clue.setEditTime(editTime);
        //调用service
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean flag = clueService.updateClue(clue);
        //返回结果
        PrintJson.printJsonFlag(response,flag);

    }

    private void getClueById(HttpServletRequest request, HttpServletResponse response) {
        //获取参数
        String id = request.getParameter("id");
        //调用service
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        Map<String,Object> map = clueService.getClueById(id);
        //响应数据
        PrintJson.printJsonObj(response,map);
    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到pageList");
        //接收参数
        String name = request.getParameter("name");
        String company = request.getParameter("company");
        String phone = request.getParameter("phone");
        String source = request.getParameter("source");
        String owner = request.getParameter("owner");
        String mphone = request.getParameter("mphone");
        String state = request.getParameter("state");
        String pageNumber = request.getParameter("pageNumber");
        String size = request.getParameter("pageSize");
        //计算每页展示的条目数和起始条目数
        int pageSize = Integer.parseInt(size);
        int startIndex = (Integer.parseInt(pageNumber) - 1) * pageSize;
        //封装数据
        Map<String,Object> map = new HashMap<>();
        map.put("pageSize",pageSize);
        map.put("startIndex",startIndex);
        map.put("state",state);
        map.put("mphone",mphone);
        map.put("owner",owner);
        map.put("source",source);
        map.put("phone",phone);
        map.put("company",company);
        map.put("name",name);
        //调用service
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        VO<Clue> clueVO = clueService.pageList(map);
        //响应数据
        PrintJson.printJsonObj(response,clueVO);


    }

    private void save(HttpServletRequest request, HttpServletResponse response) {
        //接收参数
        String owner = request.getParameter("owner");
        String fullname = request.getParameter("fullname");
        String appellation = request.getParameter("appellation");
        String company = request.getParameter("company");
        String job = request.getParameter("job");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String website = request.getParameter("website");
        String mphone = request.getParameter("mphone");
        String state = request.getParameter("state");
        String source = request.getParameter("source");
        String description = request.getParameter("description");
        String contactSummary = request.getParameter("contactSummary");
        String nextContactTime = request.getParameter("nextContactTime");
        String address = request.getParameter("address");
        //获取系统时间作为createTime
        String createTime = DateTimeUtil.getSysTime();
        //获取创建者
        String createBy = ((User) request.getSession().getAttribute("user")).getName();
        //获取ID
        String id = UUIDUtil.getUUID();

        //封装数据
        Clue clue = new Clue();
        clue.setId(id);
        clue.setOwner(owner);
        clue.setFullname(fullname);
        clue.setAppellation(appellation);
        clue.setCompany(company);
        clue.setJob(job);
        clue.setEmail(email);
        clue.setPhone(phone);
        clue.setWebsite(website);
        clue.setMphone(mphone);
        clue.setState(state);
        clue.setSource(source);
        clue.setDescription(description);
        clue.setContactSummary(contactSummary);
        clue.setNextContactTime(nextContactTime);
        clue.setAddress(address);
        clue.setCreateTime(createTime);
        clue.setCreateBy(createBy);
        //调用service，执行sql
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean success = clueService.save(clue);

        PrintJson.printJsonFlag(response, success);
    }

    private void getUserList(HttpServletRequest request, HttpServletResponse response) {
        //获取service对象
        UserService userService = (UserService) ServiceFactory.getService(new UserServiceImpl());

        List<User> userList = userService.getUserList();

        PrintJson.printJsonObj(response, userList);
    }

}




