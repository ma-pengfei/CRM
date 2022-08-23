package com.itheima.crm.settings.service.impl;

import com.itheima.crm.settings.dao.UserDao;
import com.itheima.crm.settings.domain.User;
import com.itheima.crm.settings.exception.LoginException;
import com.itheima.crm.settings.service.UserService;
import com.itheima.crm.utils.DateTimeUtil;
import com.itheima.crm.utils.SqlSessionUtil;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author Administrator
 */
public class UserServiceImpl implements UserService {

    private final UserDao userDao = SqlSessionUtil.getSqlSession().getMapper(UserDao.class);


    @Override
    public User login(String loginAct, String loginPwd, String ip) throws LoginException {
        //封装数据
        Map<String, String> map = new HashMap<>();
        map.put("loginAct",loginAct);
        map.put("loginPwd",loginPwd);
        //调用dao层方法
        User user = userDao.login(map);

        //验证用户名和密码
        if (user == null) {
            throw new LoginException("账号密码错误");
        }

        //验证失效时间
        String expireTime = user.getExpireTime();
        String currentTime = DateTimeUtil.getSysTime();
        if (expireTime.compareTo(currentTime) < 0){
            throw new LoginException("账号已失效");
        }
        //验证锁定状态
        String lockState = user.getLockState();
        if ("0".equals(lockState)){
            throw new LoginException("账号已锁定");
        }
        //验证登录IP
        String allowIps = user.getAllowIps();
        if (!allowIps.contains(ip)){
            throw new LoginException("ip地址受限");
        }
        return user;
    }

    @Override
    public List<User> getUserList() {

        return userDao.query();
    }
}
