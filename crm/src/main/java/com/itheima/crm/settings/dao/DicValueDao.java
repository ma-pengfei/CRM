package com.itheima.crm.settings.dao;

import com.itheima.crm.settings.domain.DicValue;

import java.util.List;

public interface DicValueDao {
    List<DicValue> getValueListByCode(String typeCode);
}
