<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String basePath = request.getScheme() + "://" +
    request.getServerName() + ":" + request.getServerPort() +
    request.getContextPath() + "/";
    /*
         JSP的九大内置对象：无需声明，直接使用
             pageContext  page
             request    response
             session
             application config
             out
             exception
     */
    //第一种方式：接受detail页面传输的参数并使用java标签展示在页面
//    String id = request.getParameter("id");
//    String fullname = request.getParameter("fullname");
//    String appellation = request.getParameter("appellation");
//    String company = request.getParameter("company");
//    String owner = request.getParameter("owner");
    //第二种方式：直接在页面中使用EL表达式 ${param.参数名}
    // EL表达式提供了许多隐含对象，其中除了四大域对象在使用时可以省略，其他隐含对象都需要声明
    // param  相当于 request.getParameter
%>
<!DOCTYPE html>
<html>
<head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>


<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

<script type="text/javascript">
	$(function(){

        //添加时间控件
        $(".time").datetimepicker({
            minView: "month",
            language:  'zh-CN',
            format: 'yyyy-mm-dd',
            autoclose: true,
            todayBtn: true,
            pickerPosition: "top-left"
        });

		$("#isCreateTransaction").click(function(){
			if(this.checked){
				$("#create-transaction2").show(200);
			}else{
				$("#create-transaction2").hide(200);
			}
		});

        //为搜索按钮绑定事件，打开搜索市场活动的模态窗口
        $("#activitySource").click(function () {
            $("#searchActivityModal").modal("show");
        })

        $("#search-activityName").keydown(function (event) {
            if (event.keyCode === 13) {
                $.ajax({
                    url:"workbench/clue/getActivityListByName.do",
                    data:{
                        "name":$.trim($("#search-activityName").val()),
                    },
                    type:"get",
                    dataType:"json",
                    success:function (data){
                        //展示市场活动数据
                            var html = "";
                        $.each(data,function (i,n){
                            html += '<tr>';
                            html += '<td><input type="radio" value="'+ n.id +'" name="checkBtn"/></td>';
                            html += '<td id="'+n.id+'">'+ n.name +'</td>';
                            html += '<td>'+ n.startDate +'</td>';
                            html += '<td>'+ n.endDate +'</td>';
                            html += '<td>'+ n.owner +'</td>';
                            html += '</tr>';
                        })
                        $("#activityBody").html(html);
                    }
                })
                return false;
            }
        })

        $("#submitActivityBtn").click(function () {
            var id = $("input[name=checkBtn]:checked").val();

            $("#activityId").val(id);
            $("#activityName").val($("#"+id).html());
            $("#search-activityName").val("");

            $("#searchActivityModal").modal("hide");
        })

        //为转换按钮添加事件，执行线索的转换操作
        $("#converBtn").click(function () {
            //根据单选框是否选中判断是否需要创建交易
            if ($("#isCreateTransaction").prop("checked")){
                //需要传输的参数：money，name,expectedDate,stage,activityId 以及 clueId，因此采用表单提交的方式
                //在提交表单时给服务器传输一个标志flag，标记是否需要创建交易
                // alert("需要创建交易")
                $("#tranForm").submit()
            } else {
                //需要传输的参数：clueId
                window.location.href = "workbench/clue/convert.do?clueId=${param.id}";
                // alert("不需要创建交易")

            }
        })
	});
</script>

</head>
<body>
	
	<!-- 搜索市场活动的模态窗口 -->
	<div class="modal fade" id="searchActivityModal" role="dialog" >
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">搜索市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" id="search-activityName" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="activityBody">
<%--							<tr>--%>
<%--								<td><input type="radio" name="activity"/></td>--%>
<%--								<td>发传单</td>--%>
<%--								<td>2020-10-10</td>--%>
<%--								<td>2020-10-20</td>--%>
<%--								<td>zhangsan</td>--%>
<%--							</tr>--%>
						</tbody>
					</table>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary" id="submitActivityBtn">提交</button>
                        <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                    </div>
				</div>
			</div>
		</div>
	</div>

	<div id="title" class="page-header" style="position: relative; left: 20px;">
		<h4>转换线索 <small>${param.fullname}${param.appellation}-${param.company}</small></h4>
	</div>
	<div id="create-customer" style="position: relative; left: 40px; height: 35px;">
		新建客户：${param.company}
	</div>
	<div id="create-contact" style="position: relative; left: 40px; height: 35px;">
		新建联系人：${param.fullname}${param.appellation}
	</div>
	<div id="create-transaction1" style="position: relative; left: 40px; height: 35px; top: 25px;">
		<input type="checkbox" id="isCreateTransaction"/>
		为客户创建交易
	</div>
	<div id="create-transaction2" style="position: relative; left: 40px; top: 20px; width: 80%; background-color: #F7F7F7; display: none;" >
	
		<form id="tranForm" action="workbench/clue/convert.do" method="post">
            <input type="hidden" name="clueId" value="${param.id}">
            <input type="hidden" name="flag" value="1">
		  <div class="form-group" style="width: 400px; position: relative; left: 20px;">
		    <label for="amountOfMoney">金额</label>
		    <input type="text" class="form-control" id="amountOfMoney" name="money">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="tradeName">交易名称</label>
		    <input type="text" class="form-control" id="tradeName" name="name">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="expectedClosingDate">预计成交日期</label>
		    <input type="text" class="form-control time" id="expectedClosingDate" name="expectedDate">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="stage">阶段</label>
		    <select id="stage"  class="form-control" name="stage">
		    	<option></option>
                <c:forEach items="${stage}" var="s">
                    <option value="${s.value}">${s.text}</option>
                </c:forEach>
		    </select>
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="activity">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="activitySource" style="text-decoration: none;"><span class="glyphicon glyphicon-search"></span></a></label>
		    <input type="text" class="form-control" id="activityName" placeholder="点击上面搜索" readonly>
              <input type="hidden" id="activityId" name="activityId">
		  </div>
		</form>
		
	</div>
	
	<div id="owner" style="position: relative; left: 40px; height: 35px; top: 50px;">
		记录的所有者：<br>
		<b>${param.owner}</b>
	</div>
	<div id="operation" style="position: relative; left: 40px; height: 35px; top: 100px;">
		<input class="btn btn-primary" type="button" id="converBtn" value="转换">
		&nbsp;&nbsp;&nbsp;&nbsp;
		<input class="btn btn-default" type="button" value="取消" onclick="window.history.back();">
	</div>
</body>
</html>