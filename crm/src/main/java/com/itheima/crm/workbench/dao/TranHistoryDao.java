package com.itheima.crm.workbench.dao;

import com.itheima.crm.workbench.domain.TranHistory;

import java.util.List;

public interface TranHistoryDao {

    int addTranHistory(TranHistory tranHistory);

    List<TranHistory> showHistoryList(String id);
}
