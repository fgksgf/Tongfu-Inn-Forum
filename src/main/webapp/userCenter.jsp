<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>个人中心</title>
    <%@include file="./WEB-INF/common/import.jsp" %>
    <style>
        html {
            height: 100%;
        }

        body {
            min-height: 100%;
            margin: 0;
            padding: 0;
        }

        .panel {
            margin-top: 50px;
        }

        .userinfo {
            font-size: 20px;
        }

        .info img {
            float: left;
            margin-top: 10px;
            margin-bottom: 10px;
        }

        .col-md-2 {
            background: #fafbfc;
        }

        .panel-right {
            padding-top: 1%;
            padding-left: 3%;
        }

        .panel-right button {
            margin-right: 10px;
        }

        .collapse-form {
            width: 50%;
        }

        .post-list li {
            font-size: 20px;
            padding: 10px;
        }

        .panel-right {
            margin-left: 20px;
            padding-bottom: 10px;
        }
    </style>
</head>

<body>
<%@include file="./WEB-INF/common/head.jsp" %>

<div class="container">
    <div class="panel panel-default">
        <div class="panel-body">
            <div class="col-md-2 col-xs-2">
                <div class="info">
                    <img alt="此处应有头像" src="<s:property value="user.imgUrl"/>" class="img-thumbnail"
                         style="width: 100px;height: 100px;">
                </div>
            </div>

            <div class="col-md-8 col-xs-8 panel-right">
                <div class="userinfo">
                    <span>用户名：<s:property value="user.username"/></span><br>
                    <span>积分：<s:property value="user.credit"/></span>
                </div>
                <br>
                <s:if test="#session.user.uid == user.uid">
                    <button class="btn btn-success" type="button" data-toggle="collapse" data-target="#change-form"
                            aria-expanded="false" aria-controls="change-form">
                        修改密码
                    </button>
                    <button class="btn btn-success" type="button" data-toggle="collapse" data-target="#upload-form"
                            aria-expanded="false" aria-controls="upload-form">
                        更改头像
                    </button>

                    <div class="collapse collapse-form" id="change-form">
                        <form class="form-group well">
                            <div class="form-group">
                                <label class="control-label">新密码</label>
                                <input id="pwd1" type="password" class="form-control" name="pwd1" placeholder="6-16位字母或数字"/>
                            </div>

                            <div class="form-group">
                                <label class="control-label">确认密码</label>
                                <input type="password" class="form-control" name="pwd2" placeholder="请再次输入新密码"/>
                            </div>
                            <button class="btn btn-primary" id="change-btn">更改</button>
                        </form>
                    </div>
                    <script>
                        $('#change-form form').bootstrapValidator({
                            feedbackIcons: {
                                valid: 'glyphicon glyphicon-ok',
                                invalid: 'glyphicon glyphicon-remove',
                                validating: 'glyphicon glyphicon-refresh'
                            },
                            fields: {
                                pwd1: {
                                    validators: {
                                        notEmpty: {
                                            message: '密码不能为空'
                                        },
                                        stringLength: { //检测长度
                                            min: 6,
                                            max: 16,
                                            message: '长度必须在6-16之间'
                                        },
                                        regexp: { //正则验证
                                            regexp: /^[a-zA-Z0-9]+$/,
                                            message: '只能包含6-16位字母或数字'
                                        }
                                    }
                                },
                                pwd2: {
                                    validators: {
                                        identical: { //与指定控件内容比较是否相同，比如两次密码不一致
                                            field: 'pwd1', //指定控件name
                                            message: '两次输入的密码不一致'
                                        }
                                    }
                                }
                            }
                        });

                        $('#change-btn').on('click',function () {
                            var bootstrapValidator = $("#change-form form").data('bootstrapValidator');
                            bootstrapValidator.validate();
                            if (bootstrapValidator.isValid()) {
                                $('#change-btn').attr('disabled','disabled');

                                var params = {
                                    uid: <s:property value="#session.user.uid"/>,
                                    password: $('#pwd1').val()
                                };

                                $.ajax({
                                    type: 'POST',                         //请求方式为post方式
                                    url: 'user!changeCode',                         //请求地址
                                    dataType: 'json',                     //服务器返回类型为JSON类型
                                    data: params,                         //发送到服务器的数据
                                    success: function (data) {           //请求成功后的回调函数
                                        if (data.result === 'change_ok') {
                                            alert("修改密码成功!");
                                            $("#change-form form").data('bootstrapValidator').resetForm(true);
                                        } else {
                                            alert('修改密码失败，请重试！');
                                        }
                                        $('#change-btn').removeAttr('disabled');
                                    },
                                    error: function () {
                                        alert('连接服务器失败，请稍后重试！');
                                        $('#change-btn').removeAttr('disabled');
                                    }
                                });
                            }
                        });
                    </script>

                    <div class="collapse collapse-form" id="upload-form">
                        <div class="form-group well">
                            <h4>上传的图片文件大小不能超过1MB</h4>
                            <form enctype="multipart/form-data" method="post" action="user!updateAvatar">
                                <input type="text" hidden name="uid" value="<s:property value="#session.user.uid"/>">
                                <input type="file" id="imgUpload" name="upload" accept="image/png, image/jpeg"><br>
                            </form>
                            <button class="btn btn-primary" id="upload-btn">上传</button>
                        </div>
                    </div>
                    <script>
                        $("#upload-btn").on('click',function(){
                            // $(this).preventDefault();

                            //检验非空和文件大小
                            if($('#imgUpload').val() === '') {
                                alert('请选择图片文件!');
                                return;
                            }
                            if(!checkSize($('#imgUpload'))) {
                                alert("头像图片不能超过1M！");
                                return;
                            } else {
                                $('#upload-form form').submit();
                            }
                        });

                        // 检查上传文件大小
                        function checkSize(input) {
                            var Sys = {};
                            var flag;
                            var filesize = 0;

                            //判断浏览器种类
                            if (navigator.userAgent.indexOf("MSIE") > 0) {
                                Sys.ie=true;
                            }
                            if (navigator.userAgent.indexOf("Firefox")>0) {
                                Sys.firefox=true;
                            }

                            //获取文件大小
                            if (Sys.firefox) {
                                filesize = input.files[0].size;
                            } else if (Sys.ie){
                                var fileobject = new ActiveXObject ("Scripting.FileSystemObject");//获取上传文件的对象
                                var file = fileobject.GetFile (input.value);//获取上传的文件
                                filesize = file.Size;//文件大小
                            }

                            //判断是否符合要求
                            if (filesize / (1024 * 1024) < 1 ) {
                                flag = true;
                            } else {
                                flag = false;
                            }

                            return flag;
                        }

                    </script>
                </s:if>
            </div>
        </div>
    </div>
    <br>

    <s:if test="user.posts.size() > 0">
    <h3>发表过的帖子:</h3>
    <div class="post-list">
        <ol class="list-group">
            <s:iterator value="user.posts" status="st" var="p">
                <li class="list-group-item">
                    <span class="glyphicon glyphicon-tag" aria-hidden="true"></span>
                    <span><s:property value="#st.count"/>.&nbsp;</span>
                    <a href="post!jumpTo?pid=<s:property value="#p.pid"/>" target="_blank">
                        <s:property value="#p.title"/>
                    </a>
                    <div style="float: right;">
                        <s:property value="#p.date"/>
                        <s:if test="#session.user.uid == user.uid || #session.user.status == 1">
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
                            location.reload();
                        }
                    },
                    error: function () {
                        alert('网络错误,请稍后重试!');
                        location.reload();
                    }
                });
            }

        </script>
    </div>
    </s:if>
</div>

<%@include file="./WEB-INF/common/backToTop.jsp" %>

<%@include file="./WEB-INF/common/foot.jsp" %>
</body>

</html>
