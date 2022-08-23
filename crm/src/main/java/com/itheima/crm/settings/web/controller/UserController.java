package com.itheima.crm.settings.web.controller;

import com.itheima.crm.settings.domain.User;
import com.itheima.crm.settings.service.UserService;
import com.itheima.crm.settings.service.impl.UserServiceImpl;
import com.itheima.crm.utils.MD5Util;
import com.itheima.crm.utils.PrintJson;
import com.itheima.crm.utils.ServiceFactory;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class UserController extends HttpServlet {

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        System.out.println("进入到用户控制器");

        String path = request.getServletPath();

        if ("/settings/user/login.do".equals(path)){
            login(request,response);
        }

    }

    private void login(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到验证登录操作");
        //获取请求参数：用户名和密码
        String loginAct = request.getParameter("loginAct");
        String loginPwd = request.getParameter("loginPwd");
        //将密码的明文转化为MD5的密文形式
        loginPwd = MD5Util.getMD5(loginPwd);
        //接收浏览器端的ip地址
        String ip = request.getRemoteAddr();
        System.out.println("ip = " + ip);

        //使用代理类形态的接口获取service对象
        UserService service = (UserService) ServiceFactory.getService(new UserServiceImpl());

        try{
            User user = service.login(loginAct, loginPwd, ip);
            request.getSession().setAttribute("user",user);
            //登录验证成功
            PrintJson.printJsonFlag(response,true);
        } catch (Exception e){
            e.printStackTrace();
            //登录验证失败
            String message = e.getMessage();
            Map<String,Object> map = new HashMap<>();
            map.put("success",false);
            map.put("msg",message);
            PrintJson.printJsonObj(response,map);
        }


    }
}
