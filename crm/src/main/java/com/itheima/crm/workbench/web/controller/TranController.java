package com.itheima.crm.workbench.web.controller;

import com.itheima.crm.settings.domain.User;
import com.itheima.crm.settings.service.UserService;
import com.itheima.crm.settings.service.impl.UserServiceImpl;
import com.itheima.crm.utils.DateTimeUtil;
import com.itheima.crm.utils.PrintJson;
import com.itheima.crm.utils.ServiceFactory;
import com.itheima.crm.utils.UUIDUtil;
import com.itheima.crm.workbench.domain.*;
import com.itheima.crm.workbench.service.*;
import com.itheima.crm.workbench.service.impl.*;

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
public class TranController extends HttpServlet {

  @Override
  protected void service(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    System.out.println("进入到交易控制器");

    String path = request.getServletPath();

    if ("/workbench/transaction/pageList.do".equals(path)) {
      pageList(request, response);
    } else if ("/workbench/transaction/add.do".equals(path)) {
      add(request, response);
    } else if ("/workbench/transaction/getActivityListByName.do".equals(path)) {
        getActivityListByName(request, response);
    } else if ("/workbench/transaction/getContactsListByName.do".equals(path)) {
        getContactsListByName(request, response);
    } else if ("/workbench/transaction/save.do".equals(path)) {
        save(request, response);
    } else if ("/workbench/transaction/getCustomerName.do".equals(path)) {
        getCustomerName(request, response);
    } else if ("/workbench/transaction/detail.do".equals(path)) {
        detail(request, response);
    } else if ("/workbench/transaction/showHistoryList.do".equals(path)) {
        showHistoryList(request, response);
    } else if ("/workbench/transaction/getRemarkList.do".equals(path)) {
        getRemarkList(request, response);
    }

  }

    private void getRemarkList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("根据交易的id查询交易备注");
        String id = request.getParameter("tranId");
        TranService tranService = (TranService) ServiceFactory.getService(new TranServiceImpl());
        List<TranRemark> remarkList = tranService.getRemarkList(id);
        PrintJson.printJsonObj(response,remarkList);

    }

    private void showHistoryList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("根据交易的id查询交易历史");
        String id = request.getParameter("tranId");
        TranService tranService = (TranService) ServiceFactory.getService(new TranServiceImpl());
        List<TranHistory> tranHistoryList = tranService.showHistoryList(id);

        Map<String,String> pMap = (Map<String, String>) request.getServletContext().getAttribute("pMap");
        for (TranHistory tranHistory : tranHistoryList) {
            tranHistory.setPossibility(pMap.get(tranHistory.getStage()));
        }
        PrintJson.printJsonObj(response,tranHistoryList);

    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("跳转到详细信息页");
        String id = request.getParameter("id");
        TranService tranService = (TranService) ServiceFactory.getService(new TranServiceImpl());
        Tran tran = tranService.detail(id);
        //根据交易阶段取出可能性
        Map<String,String> pMap = (Map<String, String>) request.getServletContext().getAttribute("pMap");
        String possibility = pMap.get(tran.getStage());
        request.setAttribute("p",possibility);
        request.setAttribute("tran",tran);
        request.getRequestDispatcher("/workbench/transaction/detail.jsp").forward(request,response);
    }

    private void getCustomerName(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("取得客户名称列表(根据取得的客户名称模糊查询)");

        String name = request.getParameter("name");

        CustomerService customerService = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());

        List<String> nameList = customerService.getCustomerName(name);
        PrintJson.printJsonObj(response,nameList);
    }

    private void save(HttpServletRequest request, HttpServletResponse response) throws IOException {
        System.out.println("进入到创建交易的操作");
        //接收参数
        String owner = request.getParameter("owner");
        String money = request.getParameter("money");
        String name = request.getParameter("name");
        String expectedDate = request.getParameter("expectedDate");
        String customer = request.getParameter("customer");
        String stage = request.getParameter("stage");
        String type = request.getParameter("type");
        String source = request.getParameter("source");
        String activityId = request.getParameter("activity");
        String contactsId = request.getParameter("contacts");
        String description = request.getParameter("description");
        String contactSummary = request.getParameter("contactSummary");
        String nextContactTime = request.getParameter("nextContactTime");
        //封装参数
        Tran tran = new Tran();
        tran.setId(UUIDUtil.getUUID());
        tran.setOwner(owner);
        tran.setMoney(money);
        tran.setName(name);
        tran.setExpectedDate(expectedDate);
        tran.setCustomerId(customer);
        tran.setStage(stage);
        tran.setType(type);
        tran.setSource(source);
        tran.setActivityId(activityId);
        tran.setContactsId(contactsId);
        tran.setCreateBy(((User) request.getSession().getAttribute("user")).getName());
        tran.setCreateTime(DateTimeUtil.getSysTime());
        tran.setDescription(description);
        tran.setContactSummary(contactSummary);
        tran.setNextContactTime(nextContactTime);
        //调用service
        TranService tranService = (TranService) ServiceFactory.getService(new TranServiceImpl());
        boolean flag = tranService.addTran(tran);

        if (flag) {
            //添加成功，重定向到列表页
            response.sendRedirect(request.getContextPath() + "/workbench/transaction/index.jsp");
        }
    }

    private void getContactsListByName(HttpServletRequest request, HttpServletResponse response) {
        //获取查询条件
        String name = request.getParameter("name");
        //调用service
        ContactsService contactsService = (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        List<Contacts> contactsList = contactsService.getContactsListByName(name);
        //返回结果
        PrintJson.printJsonObj(response,contactsList);
    }

    private void getActivityListByName(HttpServletRequest request, HttpServletResponse response) {
        //获取查询条件
        String name = request.getParameter("name");
        //调用service
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        List<Activity> activityList = activityService.getActivityListByName(name);
        //返回结果
        PrintJson.printJsonObj(response,activityList);
    }

    private void add(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("跳转到添加交易的页面的操作");
        UserService userService = (UserService) ServiceFactory.getService(new UserServiceImpl());
        List<User> userList = userService.getUserList();
        request.setAttribute("userList",userList);
        request.getRequestDispatcher("/workbench/transaction/save.jsp").forward(request,response);
    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
    // 接收参数
    String pageNumber = request.getParameter("pageNumber");
    String size = request.getParameter("pageSize");
    String owner = request.getParameter("owner");
    String name = request.getParameter("name");
    String customer = request.getParameter("customer");
    String stage = request.getParameter("stage");
    String type = request.getParameter("type");
    String source = request.getParameter("source");
    String contacts = request.getParameter("contacts");
    // 计算起始页和页面大小
    int pageSize = Integer.parseInt(size);
    int startIndex = (Integer.parseInt(pageNumber) - 1) * pageSize;
    // 封装参数
    Map<String, Object> map = new HashMap<>();
    map.put("startIndex", startIndex);
    map.put("pageSize", pageSize);
    map.put("owner", owner);
    map.put("name", name);
    map.put("customer", customer);
    map.put("stage", stage);
    map.put("type", type);
    map.put("source", source);
    map.put("contacts", contacts);
    // 调用service
    TranService tranService = (TranService) ServiceFactory.getService(new TranServiceImpl());
    VO<Tran> vo = tranService.pageList(map);
    // 返回数据
    PrintJson.printJsonObj(response, vo);
  }
}
