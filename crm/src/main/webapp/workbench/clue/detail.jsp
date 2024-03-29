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
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){
		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});
		
		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});
		
		$(".remarkDiv").mouseover(function(){
			$(this).children("div").children("div").show();
		});
		
		$(".remarkDiv").mouseout(function(){
			$(this).children("div").children("div").hide();
		});

        $("#remarkBody").on("mouseover", ".remarkDiv",function (){
            $(this).children("div").children("div").show();
        })
        $("#remarkBody").on("mouseout", ".remarkDiv",function (){
            $(this).children("div").children("div").hide();
        })
		
		$(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		});
		
		$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		});

        $("#updateRemarkBtn").click(function (){
            var id = $("#remarkId").val();
            $.ajax({
                url:"workbench/clue/updateRemarkById.do",
                data:{
                    "noteContent":$.trim($("#noteContent").val()),
                    "id": id
                },
                type:"post",
                dataType:"json",
                success:function (data) {
                    if (data.success) {
                        alert("修改成功");
                        $("#e" + id).html(data.clueRemark.noteContent);
                        $("#s" + id).html(data.clueRemark.editTime + '由' +  data.clueRemark.editBy);

                        $("#editRemarkModal").modal("hide");
                    } else {
                        alert("修改失败");
                    }
                }
            })
        })

        $("#saveRemarkBtn").click(function () {
            $.ajax({
                url:"workbench/clue/saveRemarkById.do",
                data:{
                    "noteContent":$.trim($("#remark").val()),
                    "clueId":"${clue.id}"
                },
                type:"post",
                dataType:"json",
                success:function (data) {
                    if (data.success) {
                        alert("添加备注成功");
                        var html = "";
                        html += '<div id="' + data.clueRemark.id + '" class="remarkDiv" style="height: 60px;">';
                        html += '<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
                        html += '<div style="position: relative; top: -40px; left: 40px;" >';
                        html += '<h5  id="e' + data.clueRemark.id + '">' + data.clueRemark.noteContent + '</h5>';
                        html += '<font color="gray">线索</font> <font color="gray">-</font> <b>${clue.fullname}${clue.appellation}-${clue.company}</b> <small style="color: gray;" id="s' + data.clueRemark.id + '"> ' + data.clueRemark.createTime + '由'+ data.clueRemark.createBy +'</small>';
                        html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
                        html += '<a class="myHref" href="javascript:void(0);" onclick="editRemark(\''+ data.clueRemark.id +'\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #ff0000;"></span></a>';
                        html += '&nbsp;&nbsp;&nbsp;&nbsp;';
                        html += '<a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\''+ data.clueRemark.id +'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #ff0000;"></span></a>';
                        html += '</div>';
                        html += '</div>';
                        html += '</div>';
                        $("#remark").val("");
                        $("#remarkDiv").before(html);
                    } else {
                        alert("添加备注失败");
                    }
                }
            })
        })

        $("#editClueBtn").click(function (){
            $.ajax({
                url:"workbench/clue/getUserList.do",
                type:"get",
                dataType:"json",
                success:function (data) {
                    var html = "";
                    $.each(data,function (i, n){
                        html += "<option value='"+n.id+"'>"+n.name+"</option>";
                    })
                    $("#edit-owner").html(html);
                    //设置当前用户为下拉列表的默认选项
                    $("#edit-owner").val("${user.id}");

                    $("#edit-company").val("${clue.company}");
                    $("#edit-appellation").val("${clue.appellation}");
                    $("#edit-fullname").val("${clue.fullname}");
                    $("#edit-job").val("${clue.job}");
                    $("#edit-email").val("${clue.email}");
                    $("#edit-phone").val("${clue.phone}");
                    $("#edit-website").val("${clue.website}");
                    $("#edit-source").val("${clue.source}");
                    $("#edit-mphone").val("${clue.mphone}");
                    $("#edit-state").val("${clue.state}");
                    $("#edit-description").val("${clue.description}");
                    $("#edit-contactSummary").val("${clue.contactSummary}");
                    $("#edit-nextContactTime").val("${clue.nextContactTime}");
                    $("#edit-address").val("${clue.address}");

                    $("#editClueModal").modal("show");
                }
            })
        })

        $("#updateClueBtn").click(function (){
            $.ajax({
                url:"workbench/clue/updateClue.do",
                type:"post",
                data:{
                    "id":"${clue.id}",
                    "owner":$("#edit-owner").val(),
                    "company":$("#edit-company").val(),
                    "appellation":$("#edit-appellation").val(),
                    "fullname":$("#edit-fullname").val(),
                    "job":$("#edit-job").val(),
                    "email":$("#edit-email").val(),
                    "phone":$("#edit-phone").val(),
                    "website":$("#edit-website").val(),
                    "source":$("#edit-source").val(),
                    "mphone":$("#edit-mphone").val(),
                    "state":$("#edit-state").val(),
                    "description":$("#edit-description").val(),
                    "contactSummary":$("#edit-contactSummary").val(),
                    "nextContactTime":$("#edit-nextContactTime").val(),
                    "address":$("#edit-address").val()
                },
                type:"post",
                dataType:"json",
                success:function (data) {
                    if (data.success) {
                        alert("修改线索成功");
                        $("#editClueModal").modal("hide");
                        window.location.reload();
                    } else {
                        alert("修改线索失败");
                    }
                }
            })
        })

        $("#deleteClueBtn").click(function (){
            if (confirm("您确定删除吗？")){
                $.ajax({
                    url:"workbench/clue/deleteClue.do",
                    type:"post",
                    data:{
                        "id":"${clue.id}"
                    },
                    type:"post",
                    dataType:"json",
                    success:function (data) {
                        if (data.success) {
                            alert("删除线索成功");
                            window.history.back();
                        } else {
                            alert("删除线索失败");
                        }
                    }
                })
            }
        })

        //为关联市场活动的 搜索框 关联事件，按回车查询
        $("#add-activity-name").keydown(function (event) {

            if (event.keyCode == 13) {
                $.ajax({
                    url:"workbench/clue/queryActivityListNotRelationByName.do",
                    data:{
                        "name":$.trim($("#add-activity-name").val()),
                        "clueId":"${clue.id}"
                    },
                    type:"get",
                    dataType:"json",
                    success:function (data) {
                        var html = "";
                        $.each(data,function (i,n){
                            html += '<tr>';
                            html += '<td><input type="checkbox" name="checkBtn" value="'+ n.id +'"/></td>';
                            html += '<td>'+ n.name +'</td>';
                            html += '<td>'+ n.startDate +'</td>';
                            html += '<td>'+ n.endDate +'</td>';
                            html += '<td>'+ n.owner +'</td>';
                            html += '</tr>';
                        })
                        $("#addActivityBody").html(html);
                        $("#bundModal").modal("show");
                    }
                })
                //展现完列表后，需要将模态窗口默认的回车行为禁用掉
                return false;
            }
        })

        //为全选复选框绑定单击事件
        $("#checkAllBtn").click(function (){
            $("input[name=checkBtn]").prop("checked",this.checked);
        })
        //为复选框绑定单击事件，动态生成的标签绑定事件只能使用 on 的方式
        $("#addActivityBody").on("click",$("input[name=checkBtn]"),function (){
            $("#checkAllBtn").prop("checked",
                $("input[name=checkBtn]:checked").length === $("input[name=checkBtn]").length);
        })

        //为关联按钮添加事件，关联 市场活动 和 线索
        $("#addRelationBtn").click(function () {
            var $checkedBtn = $("input[name=checkBtn]:checked");
            var param = ""
            $.each($checkedBtn,function (i,n) {
                param += "activityId=" + n.value + "&";
            })
            param += "clueId=${clue.id}";
            alert(param)
            $.ajax({
                url:"workbench/clue/bund.do",
                data:param,
                type:"post",
                dataType:"json",
                success:function (data) {
                    if (data.success) {
                        alert("关联成功");
                        //刷新关联的市场活动信息列表
                        showActivityList();
                        //清除搜索框内容
                        $("#add-activity-name").val("");
                        //取消复选框勾选
                        $(":checkbox").prop("checked",false);
                        //清除模态窗口内容并关闭模态窗口
                        $("#addActivityBody").html("");
                        $("#bundModal").modal("hide0");
                    } else {
                        alert("关联失败");
                    }
                }
            })
        })
        showRemarkList()
        showActivityList();
	});

    function showActivityList() {
        $.ajax({
            url:"workbench/clue/getActivityListByClueId.do",
            data:{
                "clueId":"${clue.id}"
            },
            type:"get",
            dataType:"json",
            success: function (data){
                var html = ""
                $.each(data, function (i, n) {
                    html += '<tr>';
                    html += '<td>'+ n.name +'</td>';
                    html += '<td>'+ n.startDate +'</td>';
                    html += '<td>'+ n.endDate +'</td>';
                    html += '<td>'+ n.owner +'</td>';
                    html += '<td><a href="javascript:void(0);" onclick="unbund(\''+ n.id +'\')" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>';
                    html += '</tr>';
                })
                $("#activityListBody").html(html);
            }
        })
    }
    
    function unbund(id){
        if (confirm("确定解除吗？")){
            $.ajax({
                url:"workbench/clue/unbund.do",
                data:{
                    "id":id
                },
                type:"post",
                dataType:"json",
                success:function (data) {
                    if (data.success){
                        alert("解除成功")
                        //刷新市场活动关联列表
                        showActivityList();
                    } else {
                        alert("解除失败")
                    }
                }
            })
        }

    }

    function showRemarkList() {
        $.ajax({
            url:"workbench/clue/getRemarkListByClueId.do",
            data:{
                "clueId":"${clue.id}"
            },
            type:"get",
            dataType:"json",
            success: function (data){
                var html = ""
                $.each(data, function (i, n) {
                    html += '<div id="' + n.id + '" class="remarkDiv" style="height: 60px;">';
                    html += '<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
                    html += '<div style="position: relative; top: -40px; left: 40px;" >';
                    html += '<h5  id="e' + n.id + '">' + n.noteContent + '</h5>';
                    html += '<font color="gray">线索</font> <font color="gray">-</font> <b>${clue.fullname}${clue.appellation}-${clue.company}</b> <small style="color: gray;" id="s' + n.id + '"> ' + (n.editFlag == 0 ? n.createTime:n.editTime) + '由'+ (n.editFlag == 0 ? n.createBy : n.editBy) +'</small>';
                    html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
                    html += '<a class="myHref" href="javascript:void(0);" onclick="editRemark(\''+n.id+'\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #ff0000;"></span></a>';
                    html += '&nbsp;&nbsp;&nbsp;&nbsp;';
                    html += '<a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\''+n.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #ff0000;"></span></a>';
                    html += '</div>';
                    html += '</div>';
                    html += '</div>';
                })
                //append() 在元素的下方追加html  before() 在元素的上方追加html
                // $("#remark111").append(html);
                $("#remarkDiv").before(html);
            }
        })
    }

    function editRemark(id) {
        // 找到需要修改的备注的文本信息
        var noteContent = $("#e"+id).html();
        //将修改模态窗口的文本内容 设置为 需要修改的内容。
        $("#noteContent").val(noteContent);
        //将模态窗口中 隐藏域的 id 进行赋值
        $("#remarkId").val(id);
        $("#editRemarkModal").modal("show");
    }

    function deleteRemark(id){
        if (confirm("确认删除吗")){
            $.ajax({
                url:"workbench/clue/deleteRemarkById.do",
                data:{
                    "id": id
                },
                type:"post",
                dataType:"json",
                success: function (data){
                    if (data.success) {
                        alert("删除成功")
                        //找到需要删除的div，调用remove方法删除掉
                        // showRemarkList();
                        $("#"+id).remove();
                    } else {
                        alert("删除失败");
                    }
                }
            })
        }
    }

</script>

</head>
<body>

    <!-- 修改市场活动备注的模态窗口 -->
    <div class="modal fade" id="editRemarkModal" role="dialog">
        <%-- 备注的id --%>
        <input type="hidden" id="remarkId">
        <div class="modal-dialog" role="document" style="width: 40%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">修改备注</h4>
                </div>
                <div class="modal-body">
                    <form class="form-horizontal" role="form">
                        <div class="form-group">
                            <label for="edit-describe" class="col-sm-2 control-label">内容</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="noteContent"></textarea>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
                </div>
            </div>
        </div>
    </div>

	<!-- 关联市场活动的模态窗口 -->
	<div class="modal fade" id="bundModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">关联市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" id="add-activity-name" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td><input type="checkbox" id="checkAllBtn"/></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="addActivityBody">
<%--							<tr>--%>
<%--								<td><input type="checkbox"/></td>--%>
<%--								<td>发传单</td>--%>
<%--								<td>2020-10-10</td>--%>
<%--								<td>2020-10-20</td>--%>
<%--								<td>zhangsan</td>--%>
<%--							</tr>--%>
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" id="addRelationBtn">关联</button>
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
                    <h4 class="modal-title" id="myModalLabel">修改线索</h4>
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
                                <input type="text" class="form-control" id="edit-company" value="动力节点">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-call" class="col-sm-2 control-label">称呼</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <select class="form-control" id="edit-appellation">
                                    <option></option>
                                    <c:forEach items="${appellation}" var="appellation">
                                        <option value="${appellation.value}">${appellation.text}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <label for="edit-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-fullname" value="李四">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-job" class="col-sm-2 control-label">职位</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-job" value="CTO">
                            </div>
                            <label for="edit-email" class="col-sm-2 control-label">邮箱</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-phone" value="010-84846003">
                            </div>
                            <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-website" value="http://www.bjpowernode.com">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-mphone" class="col-sm-2 control-label">手机</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-mphone" value="12345678901">
                            </div>
                            <label for="edit-status" class="col-sm-2 control-label">线索状态</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <select class="form-control" id="edit-state">
                                    <c:forEach items="${clueState}" var="state">
                                        <option value="${state.value}">${state.text}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-source" class="col-sm-2 control-label">线索来源</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <select class="form-control" id="edit-source">
                                    <option></option>
                                    <c:forEach items="${source}" var="source">
                                        <option value="${source.value}">${source.text}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-description">这是一条线索的描述信息</textarea>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                        <div style="position: relative;top: 15px;">
                            <div class="form-group">
                                <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="3" id="edit-contactSummary">这个线索即将被转换</textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                                <div class="col-sm-10" style="width: 300px;">
                                    <input type="text" class="form-control" id="edit-nextContactTime" value="2017-05-01">
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address">北京大兴区大族企业湾</textarea>
                                </div>
                            </div>
                        </div>
                    </form>

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="updateClueBtn">更新</button>
                </div>
            </div>
        </div>
    </div>

	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>${clue.fullname}${clue.appellation}<small>${clue.company}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" onclick="window.location.href='workbench/clue/convert.jsp?id=${clue.id}&fullname=${clue.fullname}&appellation=${clue.appellation}&company=${clue.company}&owner=${clue.owner}';"><span class="glyphicon glyphicon-retweet"></span> 转换</button>
			<button type="button" class="btn btn-default" id="editClueBtn"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger" id="deleteClueBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.fullname}${clue.appellation}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.owner}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">公司</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.company}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">职位</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.job}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">邮箱</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.email}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.phone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">公司网站</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.website}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.mphone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">线索状态</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.state}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">线索来源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.source}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${clue.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${clue.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
                    ${clue.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
                    ${clue.contactSummary}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.nextContactTime}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 100px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
                    ${clue.address}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	
	<!-- 备注 -->
	<div id="remarkBody" style="position: relative; top: 40px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		
<%--		<!-- 备注1 -->--%>
<%--		<div class="remarkDiv" style="height: 60px;">--%>
<%--			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">--%>
<%--			<div style="position: relative; top: -40px; left: 40px;" >--%>
<%--				<h5>哎呦！</h5>--%>
<%--				<font color="gray">线索</font> <font color="gray">-</font> <b>李四先生-动力节点</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>--%>
<%--				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">--%>
<%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
<%--					&nbsp;&nbsp;&nbsp;&nbsp;--%>
<%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
<%--				</div>--%>
<%--			</div>--%>
<%--		</div>--%>

		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button type="button" class="btn btn-primary" id="saveRemarkBtn">保存</button>
				</p>
			</form>
		</div>
	</div>
	
	<!-- 市场活动 -->
	<div>
		<div style="position: relative; top: 60px; left: 40px;">
			<div class="page-header">
				<h4>市场活动</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>开始日期</td>
							<td>结束日期</td>
							<td>所有者</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="activityListBody">
<%--						<tr>--%>
<%--							<td>发传单</td>--%>
<%--							<td>2020-10-10</td>--%>
<%--							<td>2020-10-20</td>--%>
<%--							<td>zhangsan</td>--%>
<%--							<td><a href="javascript:void(0);"  style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>--%>
<%--						</tr>--%>
					</tbody>
				</table>
			</div>
			
			<div>
				<a href="javascript:void(0);" data-toggle="modal" data-target="#bundModal" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
			</div>
		</div>
	</div>
	
	
	<div style="height: 200px;"></div>
</body>
</html>