package com.itheima.crm.workbench.dao;

import com.itheima.crm.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkDao {

    List<ClueRemark> getRemarkListByClueId(String clueId);

    int updateRemarkById(ClueRemark clueRemark);

    int deleteRemarkById(String id);

    int saveRemarkById(ClueRemark clueRemark);
}
