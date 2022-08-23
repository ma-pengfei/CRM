package com.itheima.crm.workbench.service;

import com.itheima.crm.workbench.domain.*;

import java.util.List;
import java.util.Map;

public interface ClueService {
    boolean save(Clue clue);

    VO<Clue> pageList(Map<String, Object> map);

    Map<String,Object> getClueById(String id);

    boolean updateClue(Clue clue);

    boolean deleteClue(String[] checkedIds);

    Clue detail(String id);

    List<ClueRemark> getRemarkListByClueId(String clueId);

    boolean updateRemarkById(ClueRemark clueRemark);

    boolean deleteRemarkById(String id);

    boolean saveRemarkById(ClueRemark clueRemark);

    boolean unbund(String id);

    boolean bund(String clueId, String[] activityIds);

    boolean convert(String clueId, Tran tran, String createBy);
}
