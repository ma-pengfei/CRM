<%@ page import="java.util.Map" %>
<%@ page import="java.util.Set" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" +
        request.getServerName() + ":" + request.getServerPort() +
        request.getContextPath() + "/";

    //取出 pMap 和 keySet
    Map<String,String> pMap = (Map<String, String>) application.getAttribute("pMap");

    Set<String> keys = pMap.keySet();
%>
<!DOCTYPE html>
<html>
<head>
    <base href="<%=basePath%>">

    <meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
    <script type="text/javascript">
    $(function (){

        //自动补全的代码，需要引插件
        $("#create-customer").typeahead({
            source:function (query,process) {
                $.get(
                    "workbench/transaction/getCustomerName.do",
                    {"name":query},
                    function (data) {
                        process(data);
                    },
                    "json"
                );
            },
            delay:500
        });

        //添加时间控件，位于下方
        $(".time1").datetimepicker({
            minView: "month",
            language:  'zh-CN',
            format: 'yyyy-mm-dd',
            autoclose: true,
            todayBtn: true,
            pickerPosition: "bottom-left"
        });

        //添加时间控件，位于上方
        $(".time2").datetimepicker({
            minView: "month",
            language:  'zh-CN',
            format: 'yyyy-mm-dd',
            autoclose: true,
            todayBtn: true,
            pickerPosition: "top-left"
        });

        $("#search-activityName").keydown(function (event) {
            if (event.keyCode === 13) {
                $.ajax({
                    url:"workbench/transaction/getActivityListByName.do",
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
                            html += '<td><input type="radio" value="'+ n.id +'" name="activityId"/></td>';
                            html += '<td id="'+n.id+'">'+ n.name +'</td>';
                            html += '<td>'+ n.startDate +'</td>';
                            html += '<td>'+ n.endDate +'</td>';
                            html += '<td>'+ n.owner +'</td>';
                            html += '</tr>';
                        })
                        $("#search-activityBody").html(html);
                    }
                })
                return false;
            }
        })

        $("#search-contactsName").keydown(function (event) {
            if (event.keyCode === 13) {
                $.ajax({
                    url:"workbench/transaction/getContactsListByName.do",
                    data:{
                        "name":$.trim($("#search-contactsName").val()),
                    },
                    type:"get",
                    dataType:"json",
                    success:function (data){
                        //展示市场活动数据
                        var html = "";
                        $.each(data,function (i,n){
                        html += '<tr>';
                        html += '<td><input type="radio" value="'+ n.id +'" name="contactsId"/></td>';
                        html += '<td id="'+n.id+'">'+ n.fullname +'</td>';
                        html += '<td>'+ n.email +'</td>';
                        html += '<td>'+n.mphone +'</td>';
                        html += '</tr>';
                        })
                        $("#search-contactsBody").html(html);
                    }
                })
                return false;
            }
        })

        $("#submitActivityBtn").click(function () {
            var id = $("input[name=activityId]:checked").val();

            $("#activityId").val(id);
            $("#create-activitySrc").val($("#"+id).html());
            $("#search-activityName").val("");

            $("#findMarketActivity").modal("hide");
        })

        $("#submitContactsBtn").click(function () {
            var id = $("input[name=contactsId]:checked").val();

            $("#contactsId").val(id);
            $("#create-contacts").val($("#"+id).html());
            $("#search-contactsName").val("");

            $("#findContacts").modal("hide");
        })

        //阶段 和 可能性 是一种 键值对的关系，并且数据量不大
        //  资格审查 -- 10   需求分析 -- 25等等
        // 通常考虑写在 properties属性配置文件中 stage2Possibility.properties
        //但这种对应关系在交易模块中会大量用到，建议将该文件解析在服务器缓存中 application.setArrtibute(文件内容)
        $("#create-stage").change(function (){
            //取得选中的阶段
            var stage = $("#create-stage").val();
            //取出阶段和可能性之间的对应关系，并且转换为js中的键值对关系：json
            //在取键值对时，key必须用 “” 包裹
            var json = {
                <%
                    for (String key : keys) {
                        String value = pMap.get(key);
                %>
                    "<%=key%>" : <%=value%>,
                <%
                    }
                %>
            };
            //取出possibility,由于json中是动态的数据，不能使用传统的json.key的方式取出value
            // 需要使用 json[key] 的方式取出value
            var possibility = json[stage];
            $("#create-possibility").val(possibility);
        })

        $("#saveBtn").click(function (){
            $("#addTranForm").submit();
        })
    })
</script>
</head>
<body>

	<!-- 查找市场活动 -->	
	<div class="modal fade" id="findMarketActivity" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找市场活动</h4>
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
					<table id="activityTable3" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
							</tr>
						</thead>
						<tbody id="search-activityBody">
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

	<!-- 查找联系人 -->	
	<div class="modal fade" id="findContacts" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找联系人</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" id="search-contactsName" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>邮箱</td>
								<td>手机</td>
							</tr>
						</thead>
						<tbody id="search-contactsBody">
<%--							<tr>--%>
<%--								<td><input type="radio" name="activity"/></td>--%>
<%--								<td>李四</td>--%>
<%--								<td>lisi@bjpowernode.com</td>--%>
<%--								<td>12345678901</td>--%>
<%--							</tr>--%>
						</tbody>
					</table>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary" id="submitContactsBtn">提交</button>
                        <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                    </div>
				</div>
			</div>
		</div>
	</div>
	
	
	<div style="position:  relative; left: 30px;">
		<h3>创建交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
			<button type="button" class="btn btn-default" onclick="window.history.back()">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form" style="position: relative; top: -30px;" id="addTranForm" action="workbench/transaction/save.do" method="post">
		<div class="form-group">
			<label for="create-transactionOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-owner" name="owner">
                    <c:forEach items="${userList}" var="u">
                        <option value="${u.id}" ${user.id eq u.id ? "selected" : ""}>${u.name}</option>
                    </c:forEach>
				</select>
			</div>
			<label for="create-amountOfMoney" class="col-sm-2 control-label">金额</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-money" name="money">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-transactionName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-name" name="name">
			</div>
			<label for="create-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control time1" id="create-expectedDate" name="expectedDate">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-accountName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-customer" name="customer" placeholder="支持自动补全，输入客户不存在则新建">
			</div>
			<label for="create-transactionStage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
			  <select class="form-control" id="create-stage" name="stage">
			  	<option></option>
                <c:forEach items="${stage}" var="s" >
                    <option value="${s.value}">${s.text}</option>
                </c:forEach>
			  </select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-transactionType" class="col-sm-2 control-label">类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-type" name="type">
				  <option></option>
                    <c:forEach items="${transactionType}" var="t" >
                        <option value="${t.value}">${t.text}</option>
                    </c:forEach>
				</select>
			</div>
			<label for="create-possibility" class="col-sm-2 control-label">可能性</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-possibility">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-clueSource" class="col-sm-2 control-label">来源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-source" name="source">
				  <option></option>
                    <c:forEach items="${source}" var="s" >
                        <option value="${s.value}">${s.text}</option>
                    </c:forEach>
				</select>
			</div>
			<label for="create-activitySrc" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" data-toggle="modal" data-target="#findMarketActivity"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-activitySrc">
                <input type="hidden" id="activityId" name="activity">
            </div>
		</div>
		
		<div class="form-group">
			<label for="create-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);" data-toggle="modal" data-target="#findContacts"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-contacts">
                <input type="hidden" id="contactsId" name="contacts">
            </div>
		</div>
		
		<div class="form-group">
			<label for="create-describe" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-description" name="description"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-contactSummary" name="contactSummary"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control time2" id="create-nextContactTime" name="nextContactTime">
			</div>
		</div>
		
	</form>
</body>
</html>