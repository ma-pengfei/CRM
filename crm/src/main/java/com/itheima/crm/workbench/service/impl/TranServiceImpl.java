package com.itheima.crm.workbench.service.impl;

import com.itheima.crm.utils.SqlSessionUtil;
import com.itheima.crm.utils.UUIDUtil;
import com.itheima.crm.workbench.dao.*;
import com.itheima.crm.workbench.domain.*;
import com.itheima.crm.workbench.service.TranService;

import java.util.List;
import java.util.Map;

/**
 * @author Administrator
 */
public class TranServiceImpl implements TranService {
    private final TranDao tranDao = SqlSessionUtil.getSqlSession().getMapper(TranDao.class);
    private final TranHistoryDao tranHistoryDao = SqlSessionUtil.getSqlSession().getMapper(TranHistoryDao.class);
    private final CustomerDao customerDao = SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);

    @Override
    public VO<Tran> pageList(Map<String, Object> map) {

        int total = tranDao.getTotal(map);
        List<Tran> tranList = tranDao.getTranList(map);

        VO<Tran> vo = new VO<>();
        vo.setTotal(total);
        vo.setDataList(tranList);

        return vo;
    }

    @Override
    public boolean addTran(Tran tran) {
        boolean flag = true;
        //获取客户姓名
        String customerName = tran.getCustomerId();
        //根据客户名 查询 客户id
        Customer customer = customerDao.selectByCompanyName(customerName);
        //如果客户不存在则创建客户
        if (customer == null) {
            customer = new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setOwner(tran.getOwner());
            customer.setCreateTime(tran.getCreateTime());
            customer.setCreateBy(tran.getCreateBy());
            customer.setName(customerName);
            customer.setDescription(tran.getDescription());
            customer.setContactSummary(tran.getContactSummary());
            customer.setNextContactTime(tran.getNextContactTime());
            if (customerDao.addCustomer(customer) != 1) {
                flag = false;
            }
        }
        //添加交易
        tran.setCustomerId(customer.getId());
        int count = tranDao.addTran(tran);
        if (count != 1){
            flag = false;
        }
        //添加交易历史
        TranHistory tranHistory = new TranHistory();
        tranHistory.setId(UUIDUtil.getUUID());
        tranHistory.setMoney(tran.getMoney());
        tranHistory.setTranId(tran.getId());
        tranHistory.setStage(tran.getStage());
        tranHistory.setExpectedDate(tran.getExpectedDate());
        tranHistory.setCreateTime(tran.getCreateTime());
        tranHistory.setCreateBy(tran.getCreateBy());
        if (tranHistoryDao.addTranHistory(tranHistory) != 1){
            flag = false;
        }
        return flag;
    }

    @Override
    public Tran detail(String id) {
        return tranDao.detail(id);
    }

    @Override
    public List<TranHistory> showHistoryList(String id) {
        return tranHistoryDao.showHistoryList(id);
    }

    @Override
    public List<TranRemark> getRemarkList(String id) {
        return tranDao.getRemarkList(id);
    }
}
