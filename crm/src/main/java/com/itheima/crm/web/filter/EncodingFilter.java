package com.itheima.crm.web.filter;

import javax.servlet.*;
import java.io.IOException;

/**
 * @author Administrator
 */
public class EncodingFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        System.out.println("进入中文字符编码过滤器");

        //过滤post请求中的中文乱码问题
        servletRequest.setCharacterEncoding("utf-8");

        //过滤响应流响应中的中文乱码问题
        servletResponse.setContentType("text/html;charset=utf-8");

        //将请求放行
        filterChain.doFilter(servletRequest, servletResponse);
    }

    @Override
    public void destroy() {
    }


}
