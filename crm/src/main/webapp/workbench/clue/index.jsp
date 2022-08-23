<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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


        //添加时间控件
        $(".time").datetimepicker({
            minView: "month",
            language:  'zh-CN',
            format: 'yyyy-mm-dd',
            autoclose: true,
            todayBtn: true,
            pickerPosition: "top-left"
        });

		//为创建按钮绑定事件，打开添加操作的模态窗口
        $("#addBtn").click(function () {

            $.ajax({
                url:"workbench/clue/getUserList.do",
                type:"get",
                dataType:"json",
                success:function (data){
                    var html = "<option></option>";
                    $.each(data,function (i, n){
                        html += "<option value='"+n.id+"'>"+n.name+"</option>";
                    })
                    $("#create-owner").html(html);
                    //设置当前用户为下拉列表的默认选项
                    $("#create-owner").val("${user.id}");
                    //打开模态窗口
                    $("#createClueModal").modal("show");
                }
            })
        })

        //为保存按钮添加事件，将数据提交服务器并保存
        $("#saveBtn").click(function () {
            //发起ajax起步请求9
            $.ajax({
                url:"workbench/clue/save.do",
                data:{
                    "fullname":$.trim($("#create-fullname").val()),
                    "appellation":$.trim($("#create-appellation").val()),
                    "owner":$.trim($("#create-owner").val()),
                    "company":$.trim($("#create-company").val()),
                    "job":$.trim($("#create-job").val()),
                    "email":$.trim($("#create-email").val()),
                    "phone":$.trim($("#create-phone").val()),
                    "website":$.trim($("#create-website").val()),
                    "mphone":$.trim($("#create-mphone").val()),
                    "state":$.trim($("#create-state").val()),
                    "source":$.trim($("#create-source").val()),
                    "description":$.trim($("#create-description").val()),
                    "contactSummary":$.trim($("#create-contactSummary").val()),
                    "nextContactTime":$.trim($("#create-nextContactTime").val()),
                    "address":$.trim($("#create-address").val())
                },
                type:"post",
                dataType:"json",
                success:function (data) {
                    if (data.success) {
                        alert("添加成功");
                        //清空表单中输入的内容
                        $("#clueAddForm")[0].reset();
                        //刷新线索信息列表
                        pageList(1,$("#cluePage").bs_pagination('getOption','rowsPerPage'));
                        //关闭添加操作的模态窗口
                        $("#createClueModal").modal("hide");

                    } else {
                        alert("添加失败");
                    }
                }
            })
        })

        //为全选复选框绑定单击事件
        $("#checkAllBtn").click(function (){
            $("input[name=checkBtn]").prop("checked",this.checked);
        })
        //为复选框绑定单击事件，动态生成的标签绑定事件只能使用 on 的方式
        $("#clueListBody").on("click",$("input[name=checkBtn]"),function (){
            $("#checkAllBtn").prop("checked",
                $("input[name=checkBtn]:checked").length === $("input[name=checkBtn]").length);
        })

        //为修改按钮绑定事件，打开修改模态窗口，回显数据
        $("#editBtn").click(function () {
            var $checkedBtn = $("input[name=checkBtn]:checked");

            if ($checkedBtn.length === 0){
                alert("请选择要修改的记录");
            } else if ($checkedBtn.length > 1) {
                alert("修改的记录大于1");
            } else {
                $.ajax({
                    url:"workbench/clue/getClueById.do",
                    data:{
                        "id":$checkedBtn.val()
                    },
                    type:"get",
                    dataType:"json",
                    success:function (data) {
                        /*
                            data:{"userList":userList,"clue":clue}
                         */
                        //回显数据
                        var html = "<option></option>";
                        //设置市场活动所有者下拉列表选项
                        $.each(data.userList, function (i,n){
                            html += "<option value='"+n.id+"'>"+n.name+"</option>"
                        });
                        $("#edit-owner").html(html);
                        $("#edit-owner").val(data.clue.owner);
                        $("#edit-company").val(data.clue.company);
                        $("#edit-appellation").val(data.clue.appellation);
                        $("#edit-fullname").val(data.clue.fullname);
                        $("#edit-job").val(data.clue.job);
                        $("#edit-email").val(data.clue.email);
                        $("#edit-phone").val(data.clue.phone);
                        $("#edit-website").val(data.clue.website);
                        $("#edit-mphone").val(data.clue.mphone);
                        $("#edit-state").val(data.clue.state);
                        $("#edit-source").val(data.clue.source);
                        $("#edit-description").val(data.clue.description);
                        $("#edit-contactSummary").val(data.clue.contactSummary);
                        $("#edit-nextContactTime").val(data.clue.nextContactTime);
                        $("#edit-address").val(data.clue.address);

                        //打开修改操作模态窗口
                        $("#editClueModal").modal("show");
                    }
                })
            }
        })

        //为更新按钮绑定事件，更新线索信息
        $("#updateBtn").click(function (){
            $.ajax({
                url:"workbench/clue/updateClue.do",
                data:{
                    "id":$("input[name=checkBtn]:checked").val(),
                    "owner":$("#edit-owner").val(),
                    "company":$("#edit-company").val(),
                    "appellation":$("#edit-appellation").val(),
                    "fullname":$("#edit-fullname").val(),
                    "job":$("#edit-job").val(),
                    "email":$("#edit-email").val(),
                    "phone":$("#edit-phone").val(),
                    "website":$("#edit-website").val(),
                    "mphone":$("#edit-mphone").val(),
                    "state":$("#edit-state").val(),
                    "source":$("#edit-source").val(),
                    "description":$("#edit-description").val(),
                    "contactSummary":$("#edit-contactSummary").val(),
                    "nextContactTime":$("#edit-nextContactTime").val(),
                    "address":$("#edit-address").val()
                },
                type:"post",
                dataType:"json",
                success:function (data) {
                    if (data.success) {
                        alert("修改成功");
                        //刷新线索信息列表
                        pageList($("#cluePage").bs_pagination('getOption','currentPage')
                            ,$("#cluePage").bs_pagination('getOption','rowsPerPage'))
                        //关闭修改操作的模态窗口
                        $("#editClueModal").modal("hide");
                    } else {
                        alert("修改失败");
                    }
                }
            })
        })

        //为删除按钮绑定事件，删除线索信息
        $("#deleteBtn").click(function () {
            var $checkedBtn = $("input[name=checkBtn]:checked");
            var checkedIds = "";
            $.each($checkedBtn,function (i,n){
                checkedIds += "id=" + n.value;
                if (i < $checkedBtn.length - 1) {
                    checkedIds += "&";
                }
            })
            if ($checkedBtn.length == 0) {
                alert("请选择要删除的线索");
            } else {
                if (confirm("确定要删除吗？")) {
                    $.ajax({
                        url:"workbench/clue/deleteClue.do",
                        data:checkedIds,
                        type:"post",
                        dataType:"json",
                        success:function (data) {
                            if (data.success) {
                                alert("删除成功");
                                //刷新线索信息列表
                                pageList(1,$("#cluePage").bs_pagination('getOption','rowsPerPage'))
                            } else {
                                alert("删除失败");
                            }
                        }
                    })
                }
            }
        })

        //为查询按钮绑定事件，查询线索信息
        $("#searchBtn").click(function () {

            $("#hide-name").val($.trim($("#search-name").val()));
            $("#hide-company").val($.trim($("#search-company").val()));
            $("#hide-phone").val($.trim($("#search-phone").val()));
            $("#hide-source").val($.trim($("#search-source").val()));
            $("#hide-owner").val($.trim($("#search-owner").val()));
            $("#hide-mphone").val($.trim($("#search-mphone").val()));
            $("#hide-state").val($.trim($("#search-state").val()));

            pageList(1,$("#cluePage").bs_pagination('getOption','rowsPerPage'));
            return false;
        })

        pageList(1,2);
	});

    function pageList(pageNumber, pageSize){

        $("#search-name").val($.trim($("#hide-name").val()));
        $("#search-company").val($.trim($("#hide-company").val()));
        $("#search-phone").val($.trim($("#hide-phone").val()));
        $("#search-source").val($("#hide-source").val());
        $("#search-owner").val($("#hide-owner").val());
        $("#search-mphone").val($.trim($("#hide-mphone").val()));
        $("#search-state ").val($("#hide-state").val());

        //每次局部刷新时，取消 全选复选框的 勾选
        $("#checkAllBtn").prop("checked", false);

        $.ajax({
            url:"workbench/clue/pageList.do",
            data:{
                "pageNumber":pageNumber,
                "pageSize":pageSize,
                "name":$.trim($("#search-name").val()),
                "company":$.trim($("#search-company").val()),
                "phone":$.trim($("#search-phone").val()),
                "source":$.trim($("#search-source option:checked").val()),
                "owner":$.trim($("#search-owner").val()),
                "mphone":$.trim($("#search-mphone").val()),
                "state":$.trim($("#search-state option:checked").val())
            },
            type:"get",
            dataType:"json",
            success:function (data) {
                /*
                    data:{"total":total,"dataList":clueList}
                */
                var html = "";
                $.each(data.dataList,function (i,n){
                    html += '<tr>';
                    html += '<td><input type="checkbox" name="checkBtn" value="'+ n.id +'"/></td>';
                    html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/clue/detail.do?id='+ n.id +'\';">'+n.fullname+n.appellation+'</a></td>';
                    html += '<td>'+ n.company +'</td>';
                    html += '<td>'+ n.phone +'</td>';
                    html += '<td>'+ n.mphone +'</td>';
                    html += '<td>'+ n.source +'</td>';
                    html += '<td>'+ n.owner +'</td>';
                    html += '<td>'+ n.state +'</td>';
                    html += '</tr>';
                })
                //展示数据
                $("#clueListBody").html(html);

                //计算总页数
                var totalPages = data.total % pageSize === 0 ? data.total / pageSize : parseInt(data.total / pageSize) + 1;

                //数据处理完毕后，结合分页查询，对前端展现分页信息
                $("#cluePage").bs_pagination({
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
        })
    }
</script>
</head>
<body>

<input type="hidden" id="hide-name">
<input type="hidden" id="hide-company">
<input type="hidden" id="hide-phone">
<input type="hidden" id="hide-myphone">
<input type="hidden" id="hide-owner">
<input type="hidden" id="hide-source">
<input type="hidden" id="hide-state">

	<!-- 创建线索的模态窗口 -->
	<div class="modal fade" id="createClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">创建线索</h4>
				</div>
				<div class="modal-body">
					<form id="clueAddForm" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">
								</select>
							</div>
							<label for="create-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-company">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-appellation">
                                    <option></option>
                                      <c:forEach items="${appellation}" var="a">
                                          <option value="${a.value}">${a.text}</option>
                                      </c:forEach>
								</select>
							</div>
							<label for="create-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-fullname">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
							<label for="create-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
							<label for="create-status" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-state">
								  <option></option>
                                    <c:forEach items="${clueState}" var="c">
                                      <option value="${c.value}">${c.text}</option>
                                    </c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source">
								  <option></option>
                                    <c:forEach items="${source}" var="s">
                                        <option value="${s.value}">${s.text}</option>
                                    </c:forEach>
								</select>
							</div>
						</div>
						

						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">线索描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control time" id="create-nextContactTime">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>
						
						<div style="position: relative;top: 20px;">
							<div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
							</div>
						</div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改线索的模态窗口 -->
	<div class="modal fade" id="editClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">

								</select>
							</div>
							<label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-company">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-appellation">
								  <option></option>
                                    <c:forEach items="${appellation}" var="a">
                                        <option value="${a.value}">${a.text}</option>
                                    </c:forEach>
								</select>
							</div>
							<label for="edit-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-fullname">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job">
							</div>
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone">
							</div>
							<label for="edit-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone">
							</div>
							<label for="edit-status" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-state">
								  <option></option>
                                    <c:forEach items="${clueState}" var="c">
                                        <option value="${c.value}">${c.text}</option>
                                    </c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source">
								  <option></option>
                                    <c:forEach items="${source}" var="s">
                                        <option value="${s.value}">${s.text}</option>
                                    </c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="edit-nextContactTime">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address"></textarea>
                                </div>
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
				<h3>线索列表</h3>
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
				      <input class="form-control" type="text" id="search-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司</div>
				      <input class="form-control" type="text" id="search-company">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input class="form-control" type="text" id="search-phone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索来源</div>
					  <select class="form-control" id="search-source">
					  	  <option></option>
                            <c:forEach items="${source}" var="s">
                                <option value="${s.value}">${s.text}</option>
                            </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="search-owner">
				    </div>
				  </div>
				  
				  
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">手机</div>
				      <input class="form-control" type="text" id="search-mphone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索状态</div>
					  <select class="form-control" id="search-state">
					  	<option></option>
                          <c:forEach items="${clueState}" var="c">
                              <option value="${c.value}">${c.text}</option>
                          </c:forEach>
					  </select>
				    </div>
				  </div>

				  <button type="submit" class="btn btn-default" id="searchBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 50px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="checkAllBtn"/></td>
							<td>名称</td>
							<td>公司</td>
							<td>公司座机</td>
							<td>手机</td>
							<td>线索来源</td>
							<td>所有者</td>
							<td>线索状态</td>
						</tr>
					</thead>
					<tbody id="clueListBody">

					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 60px;">
                <div id="cluePage">

                </div>
			</div>
			
		</div>
		
	</div>
</body>
</html>