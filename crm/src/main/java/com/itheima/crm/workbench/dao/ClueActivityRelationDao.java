package com.itheima.crm.workbench.dao;

import com.itheima.crm.workbench.domain.Activity;
import com.itheima.crm.workbench.domain.ClueActivityRelation;

import java.util.List;
import java.util.Map;

public interface ClueActivityRelationDao {

    int unbund(String id);

    int bund(ClueActivityRelation clueActivityRelation);

    List<ClueActivityRelation> selectActivityIdByClueId(String clueId);

}
