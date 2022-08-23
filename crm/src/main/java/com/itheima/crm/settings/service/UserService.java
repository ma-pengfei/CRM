package com.itheima.crm.settings.service;

import com.itheima.crm.settings.domain.User;
import com.itheima.crm.settings.exception.LoginException;
import com.itheima.crm.workbench.domain.Clue;

import java.util.List;

/**
 * @author Administrator
 */
public interface UserService {

    User login(String loginAct, String loginPwd, String ip) throws LoginException;

    List<User> getUserList();
}
