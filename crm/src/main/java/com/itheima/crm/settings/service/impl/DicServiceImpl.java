package com.itheima.crm.settings.service.impl;

import com.itheima.crm.settings.domain.DicType;
import com.itheima.crm.settings.domain.DicValue;
import com.itheima.crm.settings.service.DicService;
import com.itheima.crm.settings.dao.DicTypeDao;
import com.itheima.crm.settings.dao.DicValueDao;
import com.itheima.crm.utils.SqlSessionUtil;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DicServiceImpl implements DicService {
    private final DicTypeDao dicTypeDao = SqlSessionUtil.getSqlSession().getMapper(DicTypeDao.class);
    private final DicValueDao dicValueDao = SqlSessionUtil.getSqlSession().getMapper(DicValueDao.class);


    @Override
    public Map<String, List<DicValue>> getAll() {
        //取出所有字典类型
        List<DicType> dicTypeList = dicTypeDao.getTypeList();

        Map<String, List<DicValue>> map = new HashMap<>();
        for (DicType dicType : dicTypeList) {
            String typeCode = dicType.getCode();
            List<DicValue> dicValuesList = dicValueDao.getValueListByCode(typeCode);
            map.put(typeCode,dicValuesList);
        }

        return map;
    }
}
