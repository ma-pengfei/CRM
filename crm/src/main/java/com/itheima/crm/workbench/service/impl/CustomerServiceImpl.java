package com.itheima.crm.workbench.service.impl;

import com.itheima.crm.utils.SqlSessionUtil;
import com.itheima.crm.workbench.dao.CustomerDao;
import com.itheima.crm.workbench.service.CustomerService;

import java.util.List;

public class CustomerServiceImpl implements CustomerService {
    private final CustomerDao customerDao = SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);

    @Override
    public List<String> getCustomerName(String name) {

        return customerDao.getCustomerName(name);
    }
}
