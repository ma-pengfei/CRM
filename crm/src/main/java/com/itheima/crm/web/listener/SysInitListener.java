package com.itheima.crm.web.listener;

import com.itheima.crm.settings.domain.DicValue;
import com.itheima.crm.settings.service.DicService;
import com.itheima.crm.settings.service.impl.DicServiceImpl;
import com.itheima.crm.utils.ServiceFactory;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.*;

/**
 * @author Administrator
 */
public class SysInitListener implements ServletContextListener {

    /**
     * 该方法用来监听上下文域对象。当服务器启动，上下文域对象创建，对象创建完毕后，执行该方法
     *
     * @param event 该参数能够取得监听的对象。监听的是什么对象，就可以通过该参数获得什么对象
     */
    @Override
    public void contextInitialized(ServletContextEvent event) {
        System.out.println("进入监听器，上下文域创建了");
        ServletContext application = event.getServletContext();
        //取数据字典
        DicService dicService = (DicService) ServiceFactory.getService(new DicServiceImpl());
        Map<String, List<DicValue>> map= dicService.getAll();
        // 将取得map拆开保存到上下文对象中
        for (String key : map.keySet()) {
            application.setAttribute(key,map.get(key));
        }
        System.out.println("服务器缓存处理数据字典结束");

        //解析stage2possibility文件，将文件中保存的键值对关系处理成java中的键值对关系
        Map<String,String> possibilityMap = new HashMap<>();

        ResourceBundle resourceBundle = ResourceBundle.getBundle("stage2Possibility");
        Enumeration<String> keys = resourceBundle.getKeys();
        while (keys.hasMoreElements()){
            String key = keys.nextElement();
            String value = resourceBundle.getString(key);
            possibilityMap.put(key,value);
        }
        application.setAttribute("pMap",possibilityMap);
        System.out.println("服务器缓存处理解析stage2possibility文件结束");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        ServletContextListener.super.contextDestroyed(sce);
    }
}
