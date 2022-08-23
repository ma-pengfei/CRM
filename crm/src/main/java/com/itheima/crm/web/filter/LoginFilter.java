package com.itheima.crm.web.filter;

import com.itheima.crm.settings.domain.User;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * @author Administrator
 */
public class LoginFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        System.out.println("进入验证是否登录过滤器");

        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;

        String servletPath = request.getServletPath();
        if ("/login.jsp".equals(servletPath) || "/settings/user/login.do".equals(servletPath)) {
            filterChain.doFilter(servletRequest,servletResponse);
        } else {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");

            //如果user不为null，说明登陆过
            if (user != null) {
                filterChain.doFilter(servletRequest, servletResponse);
            } else {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
            }
        }




    }

    @Override
    public void destroy() {
    }


}
