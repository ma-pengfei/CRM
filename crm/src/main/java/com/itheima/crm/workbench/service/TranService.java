package com.itheima.crm.workbench.service;

import com.itheima.crm.workbench.domain.*;

import java.util.List;
import java.util.Map;

public interface TranService {

    VO<Tran> pageList(Map<String, Object> map);

    boolean addTran(Tran tran);

    Tran detail(String id);

    List<TranHistory> showHistoryList(String id);

    List<TranRemark> getRemarkList(String id);
}
