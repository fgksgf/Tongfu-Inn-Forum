<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" %>
<%@taglib prefix="s" uri="/struts-tags" %>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=0.3">
    <title><s:property value="p.title"/>--[同福客栈]</title>
    <%@include file="./WEB-INF/common/import.jsp" %>
    <style>
        #post-detail {
            margin-top: 50px;
        }

        .left {
            text-align: center;
            background: #fafbfc;
        }

        .host-label {
            margin-top: 8px;
            margin-bottom: 10px;
        }

        .userinfo {
            margin-top: 5px;
        }

        .right {
            background: #FFF;
            font-size: 20px;
            padding-top: 2%;
            padding-left: 3%;
            margin-bottom: 3%;
        }

        .avatar {
            margin-top: 5px;
            margin-bottom: 0;
        }

        .floor-msg {
            margin-bottom: 10px;
        }

        .floor-num {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 5px;
        }

        .floor-date {
            font-size: 14px;
        }

        .title-area {
            text-align: center;
        }

        .operation button{
            margin-bottom: 8px;
        }
    </style>
</head>

<body>
<%@include file="./WEB-INF/common/head.jsp" %>

<div class="container" id="post-detail">
    <!-- 楼主内容 -->
    <div class="row">
        <div class="panel panel-default title-area well">
            <h1><s:property value="p.title"/></h1>
        </div>

        <div class="panel panel-default">
            <div class="panel-body">
                <div class="col-md-2 left">
                    <div class="avatar">
                        <img alt="headimg" style="width: 100px;"
                             src="<s:property value="p.user.imgUrl"/>" class="img-thumbnail">
                    </div>

                    <h3 class="host-label">
                        <span class="label label-info">楼主</span>
                    </h3>
                    <h6 class="userinfo">
                        <a class="btn btn-default" role="button"
                                href="user!userCenter?uid=<s:property value="p.user.uid"/>">
                            <s:property value="p.user.username"/>
                            <span class="badge"><s:property value="p.user.credit"/></span>
                        </a>
                    </h6>

                    <div class="floor-msg">
                        <div class="floor-msg">
                            <span class="floor-date">
                                <s:property value="p.date"/>
                            </span>
                        </div>
                    </div>
                </div>

                <div class="col-md-8 right">
                    <s:property value="p.content" escapeHtml="false"/>
                    <br>
                    <div style="height: 2px;width: 100%;margin: 0 auto;background:#cccccc;"></div>
                    <br>
                    <s:if test="#session.user != null">
                    <div class="operation text-right">
                        <button class="btn btn-success"
                                onclick="scrollToBottom();">回复</button>
                        <!--<button class="btn btn-warning">举报</button>-->
                    </div>
                    </s:if>
                </div>
            </div>
        </div>
    </div>
    <script>
        function scrollToBottom() {
            $('html,body').animate({
                scrollTop: $('.reply').offset().top-60
            }, 400);
        }
    </script>

    <h3>共&nbsp;<s:property value="comments.size()"/>&nbsp;条评论</h3>

    <!-- 帖子回复 -->
    <div class="comments">
        <div class="row">
            <!-- 回复楼层 -->
            <s:iterator value="comments" status="st" var="c">
            <div class="panel panel-default" id="item-<s:property value="#st.count"/>" style="<s:if test="#st.count > 5">display: none</s:if>">
                <div class="panel-body">
                    <div class="col-md-2 left">
                        <div class="avatar">
                            <img alt="此处应有头像" style="width: 100px;height: 100px;"
                                 src="<s:property value="#c.user.imgUrl"/>" class="img-thumbnail">
                        </div>

                        <s:if test="p.user.uid == #c.user.uid">
                            <h3 class="host-label">
                                <span class="label label-info">楼主</span>
                            </h3>
                        </s:if>

                        <h6 class="userinfo">
                            <a class="btn btn-default" role="button"
                                    href="user!userCenter?uid=<s:property value="#c.user.uid"/>">
                                <s:property value="#c.user.username"/>
                                <span class="badge"><s:property value="#c.user.credit"/></span>
                            </a>
                        </h6>

                        <div class="floor-msg">
                            <span class="floor-num">
                                <s:property value="#st.count"/>楼
                            </span><br>
                            <span class="floor-date">
                                <s:property value="#c.date"/>
                            </span>
                        </div>
                    </div>
                    <div class="col-md-8 right">
                        <s:property value="#c.content" escapeHtml="false"/>
                    </div>

                    <div class="operation btn-group-vertical" style="float: right">
                        <s:if test="#session.user != null">
                            <button class="btn btn-success"
                                    onclick="scrollToBottom();">回复</button>
                        </s:if>
                        <s:if test="#c.user.uid == #session.user.uid || #session.user.status == 1">
                        <button class="btn btn-danger" type="button" data-toggle="modal"
                                data-target="#delete-confirm" data-cid="<s:property value="#c.cid"/>">删除</button>
                        </s:if>
                    </div>
                </div>
            </div>
            </s:iterator>

            <s:if test="#session.user != null">
            <!-- 删除评论确认模态框 -->
            <div class="modal" id="delete-confirm" tabindex="-1" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                            <h4 class="modal-title" id="myModalLabel">确认</h4>
                        </div>
                        <div class="modal-body text-center">
                            <h3>是否确定删除这条评论?</h3>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-danger" onclick="delComment();">是</button>
                            <button type="button" class="btn btn-default" data-dismiss="modal">否</button>
                        </div>
                    </div>
                </div>
            </div>
            <script>
                var button;
                var cid;

                $('#delete-confirm').on('show.bs.modal', function (event) {
                    button = $(event.relatedTarget);
                    cid = button.data('cid');
                });

                function delComment() {
                    // ajax
                    var param = {
                        cid: cid
                    };
                    console.log(cid);
                    $.ajax({
                        url: 'comment!del',
                        data: param,
                        type: 'POST',
                        dataType: 'json',
                        success: function (data) {
                            if (data.result !== 'del_ok') {
                                alert('操作失败！');
                            }
                            location.reload();
                        },
                        error: function () {
                            alert('网络错误,请稍后重试!');
                        }
                    });
                }
            </script>
            </s:if>
        </div>
    </div>

    <s:if test="comments.size() > 5">
    <%@include file="./WEB-INF/common/pagination.jsp"%>
    </s:if>

    <!-- 回复区 -->
    <div class="reply">
        <s:if test="#session.user != null && #session.user.status != -1">
            <h3 class="text-center">发表回复</h3>
            <form class="form-group">
                <div class="form-group">
                    <div id="editor">
                        <p>友善发言的人运气都不会太差:)</p>
                    </div>
                </div>
                <div class="text-center">
                    <button class="btn btn-primary">发表</button>
                </div>
            </form>
            <script type="text/javascript" src="./resources/js/wangEditor.min.js"></script>
            <script type="text/javascript">
                var E = window.wangEditor;
                var editor = new E(document.getElementById('editor'));
                editor.customConfig.menus = [
                    'fontSize',         // 字号
                    'foreColor',        // 文字颜色
                    'bold',             // 粗体
                    'italic',           // 斜体
                    'underline',        // 下划线
                    'strikeThrough',    // 删除线
                    'link',             // 插入链接
                    'quote',            // 引用
                    'image',            // 插入图片
                    'code',             // 插入代码
                    'list',             // 列表
                    'justify'           // 对齐方式
                ];
                editor.create();

                $('.reply button').on('click', function () {
                    var c = editor.txt.html();
                    if (c.length === 0) {
                        alert('内容不能为空！');
                        return;
                    }

                    $('.reply button').attr('disabled','disabled');

                    var params = {
                        uid: '<s:property value="#session.user.uid" />',
                        content: c,
                        pid: <s:property value="p.pid"/>
                    };

                    $.ajax({
                        type: 'POST',                     //请求方式为post方式
                        url: 'comment!add',              //请求地址
                        dataType: 'json',                 //服务器返回类型为JSON类型
                        data: params,                     //发送到服务器的数据
                        success: function (data) {           //请求成功后的回调函数
                            if (data.result === 'add_ok') {
                                if (typeof(hasMore) !== 'undefined') {
                                    while (hasMore) {
                                        loadMore();
                                    }
                                }
                                $('body').animate({scrollTop: $('.comments .row').children().last().offset().top}, 400);
                                console.log(data.html);
                                $('.comments .row').append(data.html);
                                editor.txt.html('');
                            } else {
                                alert('发表失败！')
                            }
                            $('.reply button').removeAttr('disabled');
                        },
                        error: function () {
                            alert('连接服务器失败，请稍后重试！');
                            $('.reply button').removeAttr('disabled');
                        }
                    });
                });
            </script>
        </s:if>
        <s:elseif test="#session.user == null">
            <h3 class="text-center">
                请先<a data-toggle="modal" data-target="#login" href="">登录</a>再发表回复</h3>
        </s:elseif>
    </div>
</div>

<%@include file="./WEB-INF/common/backToTop.jsp"%>

<%@include file="./WEB-INF/common/foot.jsp" %>

</body>
</html>
