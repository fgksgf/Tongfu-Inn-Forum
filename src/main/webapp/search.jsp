<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=0.3">
    <title>查询结果</title>
    <%@include file="./WEB-INF/common/import.jsp"%>
    <style>
        .post-list li {
            font-size: 20px;
            padding: 10px;
        }

        .badge {
            margin-right: 10px;
        }
    </style>
</head>
<body>

<%@include file="./WEB-INF/common/head.jsp"%>
<br><br><br><br>

<s:if test="#session.user == null">
    <%@include file="./WEB-INF/common/login.jsp" %>
    <%@include file="./WEB-INF/common/register.jsp" %>
</s:if>

<div class="container" style="box-shadow: 0px 0px 1px #666;">
    <h2>关键字:"<s:property value="keyword"/>",搜索结果：</h2>
    <br>

    <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
        <div class="panel panel-info" id="post-result">
            <div class="panel-heading" role="tab" id="headingOne">
                <h3 class="panel-title">
                    <a role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
                        共&nbsp;<s:property value="posts.size()"/>&nbsp;个相关帖子
                    </a>
                </h3>
            </div>
            <div id="collapseOne" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="headingOne">
                <div class="panel-body">
                    <div class="post-list">
                        <ol class="list-group">
                            <s:iterator value="posts" status="st" var="p">
                                <li class="list-group-item">
                                    <span class="glyphicon glyphicon-tag" aria-hidden="true"></span>
                                    <span><s:property value="#st.count"/>.&nbsp;</span>
                                    <a href="post!jumpTo?pid=<s:property value="#p.pid"/>" target="_blank">
                                        <s:property value="#p.title"/>
                                    </a>
                                    <div style="float: right;">
                                        <s:property value="#p.date"/>
                                        <s:if test="#session.user.uid == #p.user.uid || #session.user.status == 1">
                                            <button data-pid="<s:property value="#p.pid"/>" class="btn btn-danger"
                                                    type="button" data-toggle="modal" data-target="#delete-confirm"
                                                    aria-expanded="false" aria-controls="collapseExample">
                                                删除
                                            </button>
                                        </s:if>
                                    </div>
                                </li>
                            </s:iterator>
                        </ol>
                        <!-- 删帖确认模态框 -->
                        <div class="modal" id="delete-confirm" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
                            <div class="modal-dialog" role="document">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                                        <h4 class="modal-title" id="myModalLabel">确认</h4>
                                    </div>
                                    <div class="modal-body text-center">
                                        <h3>是否确定删除这条帖子?</h3>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-danger" onclick="delPost();">是</button>
                                        <button type="button" class="btn btn-default" data-dismiss="modal">否</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <script>
                            var button;
                            var pid;

                            $('#delete-confirm').on('show.bs.modal', function (event) {
                                button = $(event.relatedTarget);
                                pid = button.data('pid');
                            });

                            function delPost() {
                                // ajax
                                var param = {
                                    pid: pid
                                };
                                console.log(pid);
                                $.ajax({
                                    url: 'post!del',
                                    data: param,
                                    type: 'POST',
                                    dataType: 'json',
                                    success: function (data) {
                                        if (data.result === 'del_ok') {
                                            alert('操作成功！');
                                            location.reload();
                                        }
                                    },
                                    error: function () {
                                        alert('网络错误,请稍后重试!');
                                    }
                                });
                            }

                        </script>
                    </div>
                </div>
            </div>
        </div>
        <br><br>
        <div class="panel panel-info" id="user-result">
            <div class="panel-heading" role="tab" id="headingTwo">
                <h3 class="panel-title">
                    <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
                        共&nbsp;<s:property value="users.size()"/>&nbsp;个相关用户
                    </a>
                </h3>
            </div>
            <div id="collapseTwo" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingTwo">
                <div class="panel-body">
                    <div class="post-list">
                        <ol class="list-group">
                            <s:iterator value="users" status="st" var="u">
                                <li class="list-group-item">
                                    <span class="glyphicon glyphicon-tag" aria-hidden="true"></span>
                                    <span><s:property value="#st.count"/>.&nbsp;</span>
                                    <a href="user!userCenter?uid=<s:property value="#u.uid"/>" target="_blank">
                                        <s:property value="#u.username"/>
                                    </a>
                                    <div style="float: right;">
                                        <span>积分：</span>
                                        <span class="badge"><s:property value="#u.credit"/></span>
                                        <s:if test="#session.user.status == 1">
                                            <button data-uid="<s:property value="#u.uid"/>" class="btn btn-danger"
                                                    type="button" data-toggle="modal" data-target="#block-confirm"
                                                    aria-expanded="false" aria-controls="collapseExample">
                                                <s:if test="#u.status == 0">封号</s:if>
                                                <s:else>解封</s:else>
                                            </button>
                                        </s:if>
                                    </div>
                                </li>
                            </s:iterator>
                        </ol>
                        <!-- 封号确认模态框 -->
                        <div class="modal" id="block-confirm" tabindex="-1" role="dialog" aria-labelledby="myModalLabel2">
                            <div class="modal-dialog" role="document">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                                        <h4 class="modal-title" id="myModalLabel2">确认</h4>
                                    </div>
                                    <div class="modal-body text-center">
                                        <h3 id="prompt"></h3>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-danger" onclick="block();">是</button>
                                        <button type="button" class="btn btn-default" data-dismiss="modal">否</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <script>
                            var button;
                            var uid;

                            $('#block-confirm').on('show.bs.modal', function (event) {
                                button = $(event.relatedTarget);
                                uid = button.data('uid');

                                if (button.text().search('封号') !== -1) {
                                    $('#prompt').text('是否确定封禁此账号?');
                                } else if (button.text().search('解封') !== -1) {
                                    $('#prompt').text('是否确定解封此账号?');
                                }
                            });

                            function block() {
                                // ajax
                                var param = {
                                    uid: uid
                                };
                                console.log(pid);
                                $.ajax({
                                    url: 'user!block',
                                    data: param,
                                    type: 'POST',
                                    dataType: 'json',
                                    success: function (data) {
                                        if (data.result === 'block_ok') {
                                            alert('操作成功！');
                                        }
                                        location.reload();
                                    },
                                    error: function () {
                                        alert('网络错误,请稍后重试!');
                                        location.reload();
                                    }
                                });
                            }
                        </script>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        var psize = <s:property value="posts.size()"/>;
        var usize = <s:property value="users.size()"/>;
        var uResult = $('#user-result');
        var pResult = $('#post-result');

        if (psize === 0) {
            $('#collapseOne').attr('class','panel-collapse collapse');
        }

        if (usize > psize) {
            uResult.after(pResult);
            $('#collapseTwo').addClass('in');
            $('#collapseOne').removeClass('in');
        }
        // else if (usize = psize) {
        //     $('#collapseOne').attr('class','')
        //     $('#collapseTwo')
        // }
    </script>

</div>

<%@include file="./WEB-INF/common/backToTop.jsp"%>
<%@include file="./WEB-INF/common/foot.jsp" %>

</body>
</html>

