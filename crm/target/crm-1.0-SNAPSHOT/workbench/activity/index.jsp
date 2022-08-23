<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" +
    request.getServerName() + ":" + request.getServerPort() +
    request.getContextPath() + "/";
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
<%--    分页插件--%>
<link href="jquery/bs_pagination/jquery.bs_pagination.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>

    <script type="text/javascript">

	$(function(){
        //为创建按钮绑定事件，打开添加操作的模态窗口
        $("#addBtn").click(function () {

            //添加时间控件
            $(".time").datetimepicker({
                minView: "month",
                language:  'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "bottom-left"
            });

            //在打开模态窗口之前，先从服务器查询用户的数据
            $.ajax({
                url: "workbench/activity/getUserList.do",
                type: "get",
                dataType: "json",
                success: function (data) {
                    var html = "<option></option>";

                    $.each(data,function (i,n){
                        html += "<option value='"+n.id+"'>"+n.name+"</option>"
                    });

                    $("#create-marketActivityOwner").html(html);
                    //将当前登录的用户设置为下拉框默认的选项
                    //在js中使用EL表达式一定要用 “” 套起来
                    $("#create-marketActivityOwner").val("${sessionScope.user.id}");

                    //展示完数据后，打开模态窗口
                    //操作模态窗口的方式：找到需要操作的模态窗口的jquery对象
                    //调用其modal方法，为方法传递参数：show：展示窗口，hidden：隐藏窗口
                    $("#createActivityModal").modal("show");
                }
            })
        })

        //给保存按钮绑定单击事件，执行添加操作
        $("#saveBtn").click(function (){
            //发起提交
            $.ajax({
                url: "workbench/activity/save.do",
                type: "post",
                data: {
                    "owner":$.trim($("#create-marketActivityOwner").val()),
                    "name":$.trim($("#create-marketActivityName").val()),
                    "startDate":$.trim($("#create-startTime").val()),
                    "endDate":$.trim($("#create-endTime").val()),
                    "cost":$.trim($("#create-cost").val()),
                    "description":$.trim($("#create-describe").val())
                },
                dataType: "json",
                success: function (data) {
                    if (data.success){
                        //添加成功
                        //清空模态窗口中添加的信息
                        //表单的jQuery对象提供了submit方法提交表单，但没有reset方法重置表单
                        //因此需要转换成原生dom对象，调用dom对象的reset方法
                        $("#activityAddFrom")[0].reset();

                        //刷新市场活动信息列表
                        // pageList(1,2);
                        //添加操作之后，应该返回到列表第一页，并保持用户输入的每页展示数量
                        // $("#activityPage").bs_pagination('getOption','currentPage')
                        pageList(1, $("#activityPage").bs_pagination('getOption','rowsPerPage'))
                        //关闭模态窗口
                        $("#createActivityModal").modal("hide");
                    } else {
                        alert(data.msg);
                    }
                }
            })
        })
        //页面加载完毕，发起异步ajax请求，查询市场活动信息列表
        //调用分页查询方法pageList(),第一页，每页两条数据
        pageList(1,2);

        //为复选框按钮绑定事件
        $("#checkBtn").click(function () {
            $("input[name=checkedBtn]").prop("checked", this.checked);
        })

        //为动态生成的复选框绑定事件：只能使用 on 方式
        $("#activityInfo").on("click", $("input[name=checkedBtn]"), function () {

            $("#checkBtn").prop("checked",
                $("input[name=checkedBtn]").length === $("input[name=checkedBtn]:checked").length);
            //选中的复选框的数量 和 复选框的数量 是否相等
        })
        //为删除按钮绑定事件，执行市场活动删除操作
        $("#deleteBtn").click(function () {

            //找到所有选中的复选框
            var $checkedBtn = $("input[name=checkedBtn]:checked");

            if ($checkedBtn.length === 0) {
                alert("请选择需要删除的记录");
            } else {
                if (confirm("确定删除所选中的记录吗")) {
                    // 选中了记录，有可能是1条，也有可能十多条。获取所有被选中的复选框的 value
                    var checkedIds = "";
                    for (let i = 0; i < $checkedBtn.length; i++) {
                        checkedIds += "id=" + $checkedBtn[i].value;
                        if (i !== parseInt($checkedBtn.length) - 1) {
                            checkedIds += "&";
                        }
                    }
                    $.ajax({
                        url: "workbench/activity/delete.do",
                        data: checkedIds,
                        type: "post",
                        dataType: "json",
                        success: function (data) {
                            if (data.success) {
                                //删除成功
                                alert("删除成功");
                                //删除成功之后，应该返回第一页，并维持每页展示记录数
                                pageList(1, $("#activityPage").bs_pagination('getOption','rowsPerPage'))
                            } else {
                                //删除失败
                                alert("删除市场活动失败")
                            }
                        }
                    })
                }
            }
        })
        //为查询按钮绑定单击事件，条件查询
        $("#queryBtn").click(function () {

            //点击查询按钮时，将搜索框中的查询条件保存到隐藏域中
            $("#hide-name").val($.trim($("#query-name").val()));
            $("#hide-owner").val($.trim($("#query-owner").val()));
            $("#hide-startDate").val($.trim($("#query-startTime").val()));
            $("#hide-endDate").val($.trim($("#query-endTime").val()));

            pageList(1, $("#activityPage").bs_pagination('getOption','rowsPerPage'))
        })
        //为修改按钮绑定单击事件，打开修改市场活动的模态窗口
        $("#editBtn").click(function () {
            // 找到选中的复选框
            var $checkedId = $("input[name=checkedBtn]:checked");

            if ($checkedId.length === 0) {
                alert("请选择需要修改的记录");
            } else if ($checkedId.length > 1){
                alert("修改的记录大于1");
            } else {
                //在打开模态窗口之前，先从服务器查询用户的数据
                $.ajax({
                    url: "workbench/activity/getActivityInfo.do",
                    data:{
                        id:$checkedId.val()
                    },
                    type: "get",
                    dataType: "json",
                    success: function (data) {
                        var html = "<option></option>";
                        //设置市场活动所有者下拉列表选项
                        $.each(data.userList, function (i,n){
                            html += "<option value='"+n.id+"'>"+n.name+"</option>"
                        });
                        $("#edit-marketActivityOwner").html(html);
                        //将当前需要修改的市场活动的所有者设置为下拉框默认的选项
                        $("#edit-marketActivityOwner").val(data.activityInfo.owner);
                        //设置其他信息
                        $("#edit-id").val(data.activityInfo.id);
                        $("#edit-marketActivityName").val(data.activityInfo.name);
                        $("#edit-startTime").val(data.activityInfo.startDate);
                        $("#edit-endTime").val(data.activityInfo.endDate);
                        $("#edit-cost").val(data.activityInfo.cost);
                        $("#edit-describe").val(data.activityInfo.description);
                        //展示完数据后，打开模态窗口
                        $("#editActivityModal").modal("show");
                    }
                })
            }
        })
        //为更新按钮绑定事件，提交修改信息
        $("#updateBtn").click(function () {
            if (confirm("确认修改")) {
                $.ajax({
                    url: "workbench/activity/updateActivityInfo.do",
                    data:{
                        "id":$.trim($("#edit-id").val()),
                        "owner":$.trim($("#edit-marketActivityOwner").val()),
                        "name":$.trim($("#edit-marketActivityName").val()),
                        "startDate":$.trim($("#edit-startTime").val()),
                        "endDate":$.trim($("#edit-endTime").val()),
                        "cost":$.trim($("#edit-cost").val()),
                        "description":$.trim($("#edit-describe").val())
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {
                        if (data.success) {
                            alert("修改成功");
                            //修改之后，应该维持在当前页，并且维持每页展现的记录数
                            pageList($("#activityPage").bs_pagination('getOption','currentPage')
                                ,$("#activityPage").bs_pagination('getOption','rowsPerPage'))

                            $("#editActivityModal").modal("hide");
                        } else {
                            alert("修改失败");
                        }
                    }
                })
            }
        })
	});

    /*
       需要调用pageList()方法的时机
        (1)页面加载完毕时
        (2)点击分页组件切换页面时
        (3)添加，修改，删除市场活动信息列表时
        (4)点击查询时，根据查询条件
    */
    function pageList(pageNumber, pageSize) {

        //每次局部刷新时，取消 全选复选框的 勾选
        $("#checkBtn").prop("checked", false);

        //查询时，重新将隐藏域中的查询条件取出赋给搜索框
        $("#query-name").val($.trim($("#hide-name").val()));
        $("#query-owner").val($.trim($("#hide-owner").val()));
        $("#query-startTime").val($.trim($("#hide-startDate").val()));
        $("#query-endTime").val($.trim($("#hide-endDate").val()));

        $.ajax({
            url: "workbench/activity/pageList.do",
            data:{
                "pageNumber":pageNumber,
                "pageSize":pageSize,
                "name":$.trim($("#query-name").val()),
                "owner":$.trim($("#query-owner").val()),
                "startDate":$.trim($("#query-startTime").val()),
                "endDate":$.trim($("#query-endTime").val())
            },
            type: "get",
            dataType: "json",
            success: function (data) {
            /*
               data需要服务器传回的信息：
                    市场活动信息列表 [{市场活动1}，{市场活动2}，{市场活动3}] List<Activity> activityList
                    分页插件需要的总条目数：{"total":100}   int total
               即：{"total":100, "dataList":[{市场活动1}，{市场活动2}，{市场活动3}]}
            */
                var html = "";
                $.each(data.dataList, function (i, n) {
                    html += "<tr class='active'>"
                    html += "<td><input type='checkbox' name='checkedBtn' value="+ n.id + "></td>"
                    html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/activity/detail.do?id=' + n.id + '\';">'+ n.name+'</a></td>';
                    html += "<td>" + n.owner + "</td>" ;
                    html += "<td>" + n.startDate + "</td>" ;
                    html += "<td>" + n.endDate + "</td>" ;
                    html += "</tr>";

                })
                //展示信息
                $("#activityInfo").html(html);

                //计算总页数
                var totalPages = data.total % pageSize === 0 ? data.total / pageSize : parseInt(data.total / pageSize) + 1;

                //数据处理完毕后，结合分页查询，对前端展现分页信息
                $("#activityPage").bs_pagination({
                    currentPage:pageNumber, //页码
                    rowsPerPage:pageSize,   //每页显示的记录条数
                    maxRowsPerPage: 20,     //每页最多显示的记录条数
                    totalPages: totalPages, //总页数
                    totalRows: data.total,  //总记录条数

                    visiblePageLinks: 5,    //显示几个卡片

                    showGoToPage: true,
                    showRowsPerPage: true,
                    showRowsInfo: true,
                    showRowsDefaultInfo: true,

                    //该回调函数，是在点击分页组件时触发的
                    onChangePage : function (event, data) {
                        pageList(data.currentPage, data.rowsPerPage)
                    }
                })

            }
        });
    }


</script>
</head>
<body>

<input type="hidden" id="hide-name">
<input type="hidden" id="hide-owner">
<input type="hidden" id="hide-startDate">
<input type="hidden" id="hide-endDate">

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form id="activityAddFrom" class="form-horizontal" role="form">
						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-marketActivityOwner">
								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-marketActivityName">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
                                <%-- 给文本框添加多个class，用空格隔开--%>
								<input type="text" class="form-control time" id="create-startTime">
							</div>
							<label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-endTime">
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
                    <%-- data-dismiss="modal" 表示关闭模态窗口--%>
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">

                        <input type="hidden" id="edit-id">
						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-marketActivityOwner">
								</select>
							</div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-marketActivityName" value="发传单">
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-startTime" value="2020-10-10">
							</div>
							<label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-endTime" value="2020-10-20">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost" value="5,000">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="query-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="query-owner">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control" type="text" id="query-startTime" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control" type="text" id="query-endTime">
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="queryBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
                    <%--
                            此时 data-toggle="modal" data-target="#createActivityModal"
                            将按钮的操作写死在按钮的属性里了，这要不方便扩展按钮的功能。
                            未来在开发中，对于触发模态窗口的操作，一定不能写死在元素的属性中，由自己设计js代码完成功能
                    --%>
				  <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="checkBtn"/></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="activityInfo">
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 30px;">
				<div id="activityPage">

				</div>

			</div>
			
		</div>
		
	</div>
</body>
</html>