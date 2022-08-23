package com.itheima.crm.settings.dao;

import com.itheima.crm.settings.domain.User;

import java.util.List;
import java.util.Map;

public interface UserDao {

    User login(Map<String, String> map);

    List<User> query();
}
