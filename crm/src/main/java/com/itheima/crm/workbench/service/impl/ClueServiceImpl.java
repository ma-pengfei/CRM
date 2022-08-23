package com.itheima.crm.workbench.service.impl;

import com.itheima.crm.settings.dao.UserDao;
import com.itheima.crm.settings.domain.User;
import com.itheima.crm.utils.DateTimeUtil;
import com.itheima.crm.utils.SqlSessionUtil;
import com.itheima.crm.utils.UUIDUtil;
import com.itheima.crm.workbench.dao.*;
import com.itheima.crm.workbench.domain.*;
import com.itheima.crm.workbench.service.ClueService;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ClueServiceImpl implements ClueService {
  // user表
  private final UserDao userDao = SqlSessionUtil.getSqlSession().getMapper(UserDao.class);
  // 线索表
  private final ClueDao clueDao = SqlSessionUtil.getSqlSession().getMapper(ClueDao.class);
  private final ClueRemarkDao clueRemarkDao =
      SqlSessionUtil.getSqlSession().getMapper(ClueRemarkDao.class);
  private final ClueActivityRelationDao clueActivityRelationDao =
      SqlSessionUtil.getSqlSession().getMapper(ClueActivityRelationDao.class);
  // 客户表
  private final CustomerDao customerDao =
      SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);
  private final CustomerRemarkDao customerRemarkDao =
      SqlSessionUtil.getSqlSession().getMapper(CustomerRemarkDao.class);
  // 联系人表
  private final ContactsDao contactsDao =
      SqlSessionUtil.getSqlSession().getMapper(ContactsDao.class);
  private final ContactsRemarkDao contactsRemarkDao =
      SqlSessionUtil.getSqlSession().getMapper(ContactsRemarkDao.class);
  private final ContactsActivityRelationDao contactsActivityRelationDao =
      SqlSessionUtil.getSqlSession().getMapper(ContactsActivityRelationDao.class);
  // 交易表
  private final TranDao tranDao = SqlSessionUtil.getSqlSession().getMapper(TranDao.class);
  private final TranHistoryDao tranHistoryDao =
      SqlSessionUtil.getSqlSession().getMapper(TranHistoryDao.class);

  @Override
  public boolean save(Clue clue) {

    int count = clueDao.addClue(clue);

    return count == 1;
  }

  @Override
  public VO<Clue> pageList(Map<String, Object> map) {
    // 查询符合条件的总条目数
    int total = clueDao.selectCount(map);
    // 查询符合条件的线索信息列表
    List<Clue> clueList = clueDao.selectByCondition(map);

    VO<Clue> clueVO = new VO<>();
    clueVO.setDataList(clueList);
    clueVO.setTotal(total);
    return clueVO;
  }

  @Override
  public Map<String, Object> getClueById(String id) {

    Clue clue = clueDao.selectById(id);
    List<User> userList = userDao.query();
    Map<String, Object> map = new HashMap<>();
    map.put("clue", clue);
    map.put("userList", userList);
    return map;
  }

  @Override
  public boolean updateClue(Clue clue) {
    int count = clueDao.updateClue(clue);
    return count == 1;
  }

  @Override
  public boolean deleteClue(String[] checkedIds) {
    int count = clueDao.deleteClue(checkedIds);
    return count == checkedIds.length;
  }

  @Override
  public Clue detail(String id) {
    return clueDao.detail(id);
  }

  @Override
  public List<ClueRemark> getRemarkListByClueId(String clueId) {
    return clueRemarkDao.getRemarkListByClueId(clueId);
  }

  @Override
  public boolean updateRemarkById(ClueRemark clueRemark) {
    int count = clueRemarkDao.updateRemarkById(clueRemark);
    return count == 1;
  }

  @Override
  public boolean deleteRemarkById(String id) {
    int count = clueRemarkDao.deleteRemarkById(id);
    return count == 1;
  }

  @Override
  public boolean saveRemarkById(ClueRemark clueRemark) {

    int count = clueRemarkDao.saveRemarkById(clueRemark);
    return count == 1;
  }

  @Override
  public boolean unbund(String id) {

    int count = clueActivityRelationDao.unbund(id);
    return count == 1;
  }

  @Override
  public boolean bund(String clueId, String[] activityIds) {
    int count = 0;
    for (String activityId : activityIds) {
      ClueActivityRelation clueActivityRelation = new ClueActivityRelation();
      clueActivityRelation.setClueId(clueId);
      clueActivityRelation.setActivityId(activityId);
      clueActivityRelation.setId(UUIDUtil.getUUID());
      count += clueActivityRelationDao.bund(clueActivityRelation);
    }
    return count == activityIds.length;
  }

  @Override
  public boolean convert(String clueId, Tran tran, String createBy) {
    boolean flag = true;

    String createTime = DateTimeUtil.getSysTime();
    // 1.获取到线索id，通过id查询出线索对象
    Clue clue = clueDao.selectById(clueId);
    // 2.通过线索对象提取客户信息，当该客户不存在时，新建客户（根据公司名称精确匹配是否存在）
    String companyName = clue.getCompany();
    Customer customer = customerDao.selectByCompanyName(companyName);
    if (customer == null) {
      customer = new Customer();
      customer.setId(UUIDUtil.getUUID());
      customer.setOwner(clue.getOwner());
      customer.setName(companyName);
      customer.setWebsite(clue.getWebsite());
      customer.setPhone(clue.getPhone());
      customer.setCreateBy(createBy);
      customer.setCreateTime(createTime);
      customer.setContactSummary(clue.getContactSummary());
      customer.setNextContactTime(clue.getNextContactTime());
      customer.setDescription(clue.getDescription());
      customer.setAddress(clue.getAddress());
      int count1 = customerDao.addCustomer(customer);
      if (count1 != 1) {
        flag = false;
      }
    }
    // 3.通过线索对象获取联系人信息，保存联系人
    Contacts contacts = new Contacts();
    contacts.setId(UUIDUtil.getUUID());
    contacts.setOwner(clue.getOwner());
    contacts.setSource(clue.getSource());
    contacts.setCustomerId(customer.getId());
    contacts.setFullname(clue.getFullname());
    contacts.setAppellation(clue.getAppellation());
    contacts.setEmail(clue.getEmail());
    contacts.setMphone(clue.getMphone());
    contacts.setJob(clue.getJob());
    contacts.setCreateBy(createBy);
    contacts.setCreateTime(createTime);
    contacts.setDescription(clue.getDescription());
    contacts.setContactSummary(clue.getContactSummary());
    contacts.setNextContactTime(clue.getNextContactTime());
    contacts.setAddress(clue.getAddress());
    int count2 = contactsDao.addContacts(contacts);
    if (count2 != 1) {
      flag = false;
    }
    // 4.线索备注转换到客户备注以及联系人备注
    List<ClueRemark> clueRemarkList = clueRemarkDao.getRemarkListByClueId(clueId);
    for (ClueRemark clueRemark : clueRemarkList) {
      // 添加客户备注
      CustomerRemark customerRemark = new CustomerRemark();
      customerRemark.setId(UUIDUtil.getUUID());
      customerRemark.setNoteContent(clueRemark.getNoteContent());
      customerRemark.setCreateBy(createBy);
      customerRemark.setCreateTime(createTime);
      customerRemark.setEditFlag("0");
      customerRemark.setCustomerId(customer.getId());
      if (customerRemarkDao.addCustomerRemark(customerRemark) != 1) {
        flag = false;
      }
      // 添加联系人备注
      ContactsRemark contactsRemark = new ContactsRemark();
      contactsRemark.setId(UUIDUtil.getUUID());
      contactsRemark.setNoteContent(clueRemark.getNoteContent());
      contactsRemark.setCreateBy(createBy);
      contactsRemark.setCreateTime(createTime);
      contactsRemark.setEditFlag("0");
      contactsRemark.setContactsId(customer.getId());
      if (contactsRemarkDao.addContactsRemark(contactsRemark) != 1) {
        flag = false;
      }
      // 8.删除线索备注
      if (clueRemarkDao.deleteRemarkById(clueRemark.getClueId()) != 1) {
        flag = false;
      }
    }
    // 5.线索和市场活动的联系 转换到 联系人和市场活动的联系
    List<ClueActivityRelation> clueActivityRelationList =
        clueActivityRelationDao.selectActivityIdByClueId(clue.getId());
    for (ClueActivityRelation clueActivityRelation : clueActivityRelationList) {
      // 添加联系人和市场活动的联系
      ContactsActivityRelation contactsActivityRelation = new ContactsActivityRelation();
      contactsActivityRelation.setId(UUIDUtil.getUUID());
      contactsActivityRelation.setActivityId(clueActivityRelation.getActivityId());
      contactsActivityRelation.setContactsId(contacts.getId());
      if (contactsActivityRelationDao.addContactsActivityRelation(contactsActivityRelation) != 1) {
        flag = false;
      }
      // 9.解除线索和市场活动的联系
      if (clueActivityRelationDao.unbund(clueActivityRelation.getId()) != 1) {
        flag = false;
      }
    }
    // 6.如果有创建交易的需求，创建一条交易
    if (tran != null) {
      tran.setOwner(clue.getOwner());
      tran.setCustomerId(customer.getId());
      tran.setSource(clue.getSource());
      tran.setContactsId(contacts.getId());
      tran.setDescription(clue.getDescription());
      tran.setContactSummary(clue.getContactSummary());
      tran.setNextContactTime(clue.getNextContactTime());
      if (tranDao.addTran(tran) != 1) {
        flag = false;
      } else {
        // 7.如果创建了交易，就要添加一条该交易下的交易历史
        TranHistory tranHistory = new TranHistory();
        tranHistory.setId(UUIDUtil.getUUID());
        tranHistory.setStage(tran.getStage());
        tranHistory.setMoney(tran.getMoney());
        tranHistory.setExpectedDate(tran.getExpectedDate());
        tranHistory.setCreateTime(createTime);
        tranHistory.setCreateBy(createBy);
        tranHistory.setTranId(tran.getId());
        if (tranHistoryDao.addTranHistory(tranHistory) != 1) {
          flag = false;
        }
      }
    }
    // 10.删除线索
    if (clueDao.deleteClueById(clueId) != 1) {
      flag = false;
    }
    return flag;
  }
}
