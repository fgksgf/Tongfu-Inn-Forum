<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- 注册模态框 -->
<div id="register" class="modal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-body">
                <button class="close" data-dismiss="modal">
                    <span>&times;</span>
                </button>
            </div>
            <div class="modal-title">
                <h1 class="text-center">注册</h1>
            </div>
            <div class="modal-body">
                <form id="reg-form" action="register" method="post" class="form-group">
                    <div class="form-group">
                        <label class="control-label">用户名</label>
                        <input id="reg-name" type="text" class="form-control" name="username" placeholder="1-8位不含空格的字符"/>
                    </div>

                    <div class="form-group">
                        <label class="control-label">密码</label>
                        <input id="pwd1" type="password" class="form-control" name="pwd1" placeholder="6-16位字母或数字"/>
                    </div>

                    <div class="form-group">
                        <label class="control-label">确认密码</label>
                        <input type="password" class="form-control" name="pwd2" placeholder="6-16位字母或数字"/>
                    </div>

                    <div class="text-right form-group">
                        <button class="btn btn-primary" type="submit" id="reg-btn">注册</button>
                        <button class="btn btn-danger" data-dismiss="modal">取消</button>
                    </div>
                    <a href="" data-toggle="modal" data-dismiss="modal" data-target="#login">已有账号？点我登录</a>
                </form>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
    $("#reg-form").submit(function (ev) {
        ev.preventDefault();
    });

    $("#reg-btn").on("click", function () {
        var bootstrapValidator = $("#reg-form").data('bootstrapValidator');
        bootstrapValidator.validate();
        if (bootstrapValidator.isValid()) {
            $('#reg-btn').attr('disabled','disabled');

            var params = {
                username: $('#reg-name').val(),
                password: $('#pwd1').val()
            };

            $.ajax({
                type: 'POST',                       // 请求方式为post方式
                url: 'user!register',               // 请求地址
                dataType: 'json',                   // 服务器返回类型为JSON类型
                data: params,                       // 发送到服务器的数据
                success: function (data) {          // 请求成功后的回调函数
                    if (data.result === 'reg_ok') {
                        alert('注册成功,请登录!');
                        $("#reg-form").data('bootstrapValidator').resetForm(true);
                    } else {
                        alert('注册失败，请重试！');
                        $("#reg-form").data('bootstrapValidator').resetForm(true);
                    }
                    $('#reg-btn').removeAttr('disabled');
                },
                error: function () {
                    alert('连接服务器失败，请稍后重试！');
                    $('#reg-btn').removeAttr('disabled');
                }
            });
        }
    });

    $('#reg-form').bootstrapValidator({
        feedbackIcons: {
            valid: 'glyphicon glyphicon-ok',
            invalid: 'glyphicon glyphicon-remove',
            validating: 'glyphicon glyphicon-refresh'
        },
        fields: {
            username: {
                message: '用户名验证失败',
                validators: {
                    notEmpty: {
                        message: '用户名不能为空'
                    },
                    stringLength: { // 检测长度
                        min: 1,
                        max: 8,
                        message: '长度必须在1-8之间'
                    },
                    regexp: {   // 正则验证
                        regexp: /^[\u4E00-\u9FA5A-Za-z0-9]+$/,
                        message: '只能包含中文、字母或数字'
                    },
                    remote: {   // 检验用户名是否可用
                        url: 'user!hasUser',    // 验证地址
                        delay: 600,             // 设置0.6秒发送一次ajax
                        type: 'POST',           //请求方式
                        message: '用户名已存在'   // 提示消息
                    }
                }
            },
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
</script>