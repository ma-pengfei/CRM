package com.itheima.crm.workbench.dao;

import com.itheima.crm.workbench.domain.Contacts;

import java.util.List;

public interface ContactsDao {

    int addContacts(Contacts contacts);

    List<Contacts> getContactsListByName(String name);
}
