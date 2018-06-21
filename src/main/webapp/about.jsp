<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%--<meta charset="utf-8">--%>
    <%--<meta http-equiv="X-UA-Compatible" content="IE=edge">--%>
    <%--<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">--%>
    <title>关于</title>
    <%@include file="./WEB-INF/common/import.jsp"%>
    <style>
        body {
            overflow-x: hidden;
            min-height: 100%;
            margin: 0;
            padding: 0;
            background: #eeeeee;
        }

        .main {
            width: 100%;
            margin-top: 2%;
            position: relative;
            height: auto;
            min-height: 1000px;
            background: #eeeeee;
            z-index: 1;
            padding-bottom: 2%;
        }

        #slogan {
            margin-top: 8%;
            margin-bottom: 5%;
        }

        .ribbon {
            float: none;
            width: 100%;
            height: 30vh;
            position: absolute;
            top: 1%;
            background: #4489FE;
            z-index: 2;
        }

        .content {
            float: none;
            width: 60%;
            position: absolute;
            top: 10%;
            left: 20%;
            display: block;
            background: #FFF;
            z-index: 3;
            padding-left: 5%;
            padding-right: 5%;
            padding-bottom: 2%;
        }

        p {
            font-size: 20px;
        }

        .signature {
            float: right;
            margin-right: 2%;
            text-align: center;
        }
    </style>
</head>

<body>
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
                <li><a href="/page?type=1">热门</a></li>
                <li><a href="/page?type=2">最新</a></li>
                <li class="active"><a href="#">关于</a></li>
            </ul>
            <form class="navbar-form navbar-left" role="search" action="search" method="post">
                <div class="form-group">
                    <input type="text" class="form-control" id="keyword" name="keyword" placeholder="帖子/用户">
                </div>
                <button id="search-btn" class="btn btn-default">搜索</button>
            </form>
            <script>
                $('#search-btn').on('click', function () {
                    $(this).preventDefault();
                    if ($('#keyword').val().length === 0) {
                        alert('关键词不能为空!');
                    } else {
                        $('.navbar-form').submit();
                    }
                })
            </script>
        </div>
    </div>
</nav>

<div class="main">
    <div class="ribbon"></div>
    <div class="content">
        <div class="text-center" id="slogan">
            <h1 class="css128ee24b461cff9" style="font-size: 50px">
                相濡以沫，不如相忘于江湖
            </h1>
        </div>

        <blockquote>
            <p>好久不见，你去哪儿啦？</p>
            <p>江湖。</p>
            <p>江湖在什么地方？</p>
            <p>我指给你看……</p>
        </blockquote>

        <br>

        <p>
            “同福客栈”这个名字，取自我个人非常喜欢的一部电视剧《武林外传》,意为有福同享。
            这里借用了这个名字及其蕴含的浓浓江湖气息。
        </p>
        <br>
        <p>
            受到著名论坛 <a href="https://www.reddit.com/" target="_blank">Reddit</a> 的启发，
            我也想尝试建立一个自由、平等、包容和互信的论坛，或者说，一个互联网的江湖。
        </p>
        <br>
        <p>
            在这里，你可以分享你觉得有趣的事情或者交流任何问题。
        </p>
        <br>
        <p>
            愿每个人都能在这里找到属于自己的江湖
        </p>

        <br>
        <h3>联系我</h3>
        <p>
            邮箱：fgksgf@gmail.com
        </p>
        <br>
        <div class="signature">
            <h2>掌柜</h2>
            <span>于2018年6月11日</span>
        </div>
    </div>
</div>

<%@include file="./WEB-INF/common/backToTop.jsp" %>

<%@include file="./WEB-INF/common/foot.jsp" %>
</body>
</html>
