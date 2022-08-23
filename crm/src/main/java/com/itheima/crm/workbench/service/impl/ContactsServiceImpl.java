package com.itheima.crm.workbench.service.impl;

import com.itheima.crm.utils.SqlSessionUtil;
import com.itheima.crm.workbench.dao.ContactsDao;
import com.itheima.crm.workbench.domain.Contacts;
import com.itheima.crm.workbench.service.ContactsService;

import java.util.List;

public class ContactsServiceImpl implements ContactsService {
    private final ContactsDao contactsDao = SqlSessionUtil.getSqlSession().getMapper(ContactsDao.class);

    @Override
    public List<Contacts> getContactsListByName(String name) {
        return contactsDao.getContactsListByName(name);
    }
}
