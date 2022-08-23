package com.itheima.crm.workbench.dao;

import com.itheima.crm.workbench.domain.Customer;

import java.util.List;

public interface CustomerDao {

    Customer selectByCompanyName(String companyName);

    int addCustomer(Customer customer);

    List<String> getCustomerName(String name);



}
