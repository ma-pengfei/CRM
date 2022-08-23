package com.itheima.crm.workbench.dao;

import com.itheima.crm.workbench.domain.Tran;
import com.itheima.crm.workbench.domain.TranRemark;

import java.util.List;
import java.util.Map;

public interface TranDao {

    int addTran(Tran tran);

    List<Tran> getTranList(Map<String, Object> map);

    int getTotal(Map<String, Object> map);

    Tran detail(String id);

    List<TranRemark> getRemarkList(String id);
}
