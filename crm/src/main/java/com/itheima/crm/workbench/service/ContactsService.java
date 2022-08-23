package com.itheima.crm.workbench.service;

import com.itheima.crm.workbench.domain.Contacts;

import java.util.List;

public interface ContactsService {
    List<Contacts> getContactsListByName(String name);
}
