package com.itheima.crm.workbench.domain;

import java.util.List;

/**
 * @author Administrator
 */
public class VO <T>{
    private List<T> dataList;
    private Integer total;

    public List<T> getDataList() {
        return dataList;
    }

    public void setDataList(List<T> dataList) {
        this.dataList = dataList;
    }

    public Integer getTotal() {
        return total;
    }

    public void setTotal(Integer total) {
        this.total = total;
    }
}
