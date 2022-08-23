package com.itheima.crm.workbench.dao;

import com.itheima.crm.workbench.domain.Clue;

import java.util.List;
import java.util.Map;

public interface ClueDao {


    int addClue(Clue clue);

    List<Clue> selectByCondition(Map<String, Object> map);

    int selectCount(Map<String, Object> map);

    Clue selectById(String id);

    int updateClue(Clue clue);

    int deleteClue(String[] id);

    Clue detail(String id);

    int deleteClueById(String clueId);
}
