package com.itheima.settings.test;

import com.itheima.crm.utils.DateTimeUtil;
import org.junit.Test;


public class Test1 {

    @Test
    public void test(){
        //验证失效时间
        String expireTime = "2022-03-28 10:10:10";

        String currentTime = DateTimeUtil.getSysTime();

        int count = expireTime.compareTo(currentTime);
        System.out.println("count = " + count);
    }
}
