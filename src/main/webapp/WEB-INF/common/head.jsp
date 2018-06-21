<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" %>
<!-- 导航栏 -->
<nav class="navbar navbar-default navbar-fixed-top">
    <div class="container">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar"
                    aria-expanded="false" aria-controls="navbar">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand css123c4874cd1cff9" href="/page?type=1" id="title">同福客栈</a>
        </div>
        <div id="navbar" class="navbar-collapse collapse">
            <ul class="nav navbar-nav" id="nav-choice">
                <li class="active"><a href="/page?type=1">热门</a></li>
                <li><a href="/page?type=2">最新</a></li>
                <li><a href="about.jsp">关于</a></li>
            </ul>
            <form class="navbar-form navbar-left" role="search" action="search" method="post">
                <div class="form-group">
                    <input type="text" class="form-control" id="keyword" name="keyword" placeholder="帖子/用户">
                </div>
                <button id="search-btn" class="btn btn-default">搜索</button>
            </form>
            <script>
                var pathname = window.location.pathname;
                var search = window.location.search;
                if (search === '?type=2') {
                    $('#nav-choice li').attr('class','');
                    $('#nav-choice li').eq(1).attr('class','active');
                } else if (pathname.search('page') === -1) {
                    $('#nav-choice li').attr('class','');
                } else if (pathname.search('about') !== -1) {
                    $('#nav-choice li').attr('class','');
                    $('#nav-choice li').eq(2).attr('class','active');
                }
                
                $('#search-btn').on('click',function () {
                    $(this).preventDefault();
                    if ($('#keyword').val().length === 0) {
                        alert('关键词不能为空!');
                    } else {
                        $('.navbar-form').submit();
                    }
                })
            </script>

            <ul class="nav navbar-nav navbar-right">
                <s:if test="#session.user == null">
                    <li><a data-toggle="modal" data-target="#login" href="#">登录</a></li>
                    <li class="disabled"><a href="#">|</a></li>
                    <li><a data-toggle="modal" data-target="#register" href="#">注册</a></li>
                </s:if>
                <s:else>
                    <li>
                        <a href="user!userCenter?uid=<s:property value="#session.user.uid"/>">
                            <span class="glyphicon glyphicon-user" aria-hidden="true"></span>
                            <span id="user-name"><s:property value="#session.user.username" /></span>
                        </a>
                    </li>
                    <li class="disabled"><a href="#">|</a></li>
                    <li><a id="logout-link">退出登录</a></li>
                </s:else>
            </ul>
        </div>
    </div>
</nav>
<script>
    $('#logout-link').on('click', function () {
        $.ajax({
            type: 'POST',                     //请求方式为post方式
            dataType: 'json',                 //服务器返回类型为JSON类型
            url: 'user!logout',
            success: function (data) {
                if (data.result === 'logout_ok') {
                    location.reload();
                }
            }
        });
    });
</script>

<s:if test="#session.user == null">
    <%@include file="./login.jsp" %>
    <%@include file="./register.jsp" %>
</s:if>
<br>