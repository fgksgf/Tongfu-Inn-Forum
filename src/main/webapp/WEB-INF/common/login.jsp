<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" %>
<!-- 登录模态框 -->
<div id="login" class="modal">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-body">
                <button class="close" data-dismiss="modal">
                    <span>&times;</span>
                </button>
            </div>
            <div class="modal-title">
                <h1 class="text-center">登录</h1>
            </div>
            <div class="modal-body">
                <form class="form-group" id="login-form">
                    <div class="form-group">
                        <label class="control-label">用户名</label>
                        <input id="login-name" class="form-control" type="text" name="username" />
                    </div>
                    <div class="form-group">
                        <label class="control-label">密码</label>
                        <input id="pwd" class="form-control" type="password" name="password" />
                    </div>
                    <div class="form-group">
                        <label class="control-label">验证码</label>
                        <div class="form-inline">
                            <input id="code" class="form-control" type="text" name="code" />
                            <img src="code!get" alt="验证码图片" id="codePic" title="点击图片换一张">
                        </div>
                    </div>
                    <br>
                </form>
                <div class="text-right">
                    <button type="button" class="btn btn-primary" id="login-btn">登录</button>
                    <button type="button" class="btn btn-danger" data-dismiss="modal">取消</button>
                </div>
                <a href="" data-toggle="modal" data-dismiss="modal" data-target="#register">还没有账号？点我注册</a>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
    $('#codePic').on('click',function(){
        $(this).attr('src',"code!get?timestamp="+new Date().getTime());
    });

    $('#login-btn').on('click', function () {
        var u = $('#login-name').val();
        var p = $('#pwd').val();
        var c = $('#code').val();

        if (u.length === 0 || p.length ===0) {
            alert('用户名或密码不能为空！');
            return;
        } else if (c.length === 0) {
            alert('请输入验证码');
            return;
        }

        $('#login-btn').attr('disabled','disabled');

        var params = {
            username: u,
            password: p,
            code: c
        };

        $.ajax({
            type: 'POST',                         //请求方式为post方式
            url: 'user!login',                         //请求地址
            dataType: 'json',                     //服务器返回类型为JSON类型
            data: params,                         //发送到服务器的数据
            success: function (data) {           //请求成功后的回调函数
                if (data.result === 'wrong_code') {
                    alert('验证码错误!');
                } else if (data.result === 'login_ok') {
                    location.href = 'page';
                } else {
                    alert('用户名或密码错误！');
                    $('#pwd').val("");
                }
                $('#login-btn').removeAttr('disabled');
            },
            error: function () {
                alert('连接服务器失败，请稍后重试！');
                $('#login-btn').removeAttr('disabled');
            }
        });
    });
</script>
