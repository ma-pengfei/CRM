<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" +
            request.getServerName() + ":" + request.getServerPort() +
            request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <base href="<%=basePath%>">
    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

    <script>
        $(function () {

            //当前窗口不是顶级窗口时
            if (window.top != window) {
                //将顶级窗口设置为当前窗口
                window.top.location = window.location;
            }

            //页面加载完毕后，将用户的文本框内容清空
            const loginTxt = $("#loginAct");
            loginTxt.val("");
            //页面加载完毕后，让用户的文本框自动获得焦点
            loginTxt.focus();

            //为登录按钮绑定单击事件，执行登录功能
            $("#submitBtn").click(function () {
                //验证登录操作
                login();
            })

            //为登录页窗口绑定键盘事件
            //event:该参数可以获得键盘敲击的是哪个键
            $(window).keydown(function (event) {
                //alert(event.keyCode);
                if (event.keyCode === 13) {
                    //如果取得的键位为13，表示回车键，验证登录操作
                    login();
                }
            })
        })

        function login() {
            //验证登录操作：取得用户名密码，将文本中左右的空格去掉，使用$.trim(文本)
            let loginAct = $.trim($("#loginAct").val())
            let loginPwd = $.trim($("#loginPwd").val())
            if (loginAct === "") {
                $("#msg").html("账号名不能为空");
                return false;
            }
            if (loginPwd === "") {
                $("#msg").html("账号密码不能为空");
                return false;
            }
            //从后台验证登录的相关操作，发起异步ajax请求
            $.ajax({
                url: "settings/user/login.do",
                data: {
                    "loginAct": loginAct,
                    "loginPwd": loginPwd
                },
                type: "post",
                dataType: "json",
                success: function (data) {

                    if (data.success) {
                        //登录成功
                        window.location.href = "workbench/index.jsp";
                    } else {
                        //登录失败
                        $("#msg").html(data.msg);
                    }
                }
            })
        }
    </script>
</head>
<body>
<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
    <img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
</div>
<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
    <div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">
        CRM &nbsp;<span style="font-size: 12px;">&copy;2017&nbsp;动力节点</span></div>
</div>

<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
    <div style="position: absolute; top: 0px; right: 60px;">
        <div class="page-header">
            <h1>登录</h1>
        </div>
        <form action="workbench/index.jsp" class="form-horizontal" role="form">
            <div class="form-group form-group-lg">
                <div style="width: 350px;">
                    <input class="form-control" type="text" placeholder="用户名" id="loginAct">
                </div>
                <div style="width: 350px; position: relative;top: 20px;">
                    <input class="form-control" type="password" placeholder="密码" id="loginPwd">
                </div>
                <div class="checkbox" style="position: relative;top: 30px; left: 10px;">

                    <span id="msg" style="color: firebrick"></span>

                </div>
                <button type="button" id="submitBtn" class="btn btn-primary btn-lg btn-block"
                        style="width: 350px; position: relative;top: 45px;">登录
                </button>
            </div>
        </form>
    </div>
</div>
</body>
</html>