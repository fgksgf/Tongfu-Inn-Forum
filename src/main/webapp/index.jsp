<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" %>
<%@taglib prefix="s" uri="/struts-tags" %>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=0.3">
    <title>同福客栈论坛</title>
    <%@include file="./WEB-INF/common/import.jsp" %>
    <style>
        body {
            overflow-x: hidden;
            min-height: 100%;
            margin: 0;
            padding: 0;
        }

        .panel-title {
            font-size: 20px;
            font-weight: bold;
        }

        .panel-body {
            padding: 10px;
        }

        .panel-body span {
            margin-left: 10px;
        }

        .author,
        .post-date {
            float: right;
            margin-right: 5px;
        }

        .author a {
            color: black;
        }

        .post {
            height: 100px;
            width: 100%;
            margin-bottom: 30px;
        }

        .left {
            width: 3%;
            float: left;
            height: 100%;
            padding: 5px;
        }

        .right {
            width: 95%;
            float: right;
            height: 100%;
            margin-bottom: 0;
        }
    </style>
</head>

<body>
<%@include file="./WEB-INF/common/head.jsp" %>

<%@include file="./WEB-INF/common/jumbotron.jsp" %>

<%@include file="./WEB-INF/common/post.jsp" %>

<!-- 帖子列表 -->
<div class="container">
    <s:iterator value="posts" status="st">
    <div class="post" id="item-<s:property value="#st.count"/>"
         style="<s:if test="#st.count > 5">display: none</s:if>">
        <!-- 投票区域 -->
        <div class="left text-center">
            <a href="#" class="up-vote" pid="<s:property value="pid"/>">
                <s:if test="status[#st.index] == 1">
                    <i class="fa fa-2x fa-chevron-circle-up" aria-hidden="true"></i>
                </s:if>
                <s:else>
                    <i class="fa fa-2x fa-chevron-up" aria-hidden="true"></i>
                </s:else>
            </a>
            <span class="vote-num text-center"><s:property value="score"/></span>
            <a href="#" class="down-vote" pid="<s:property value="pid"/>">
                <s:if test="status[#st.index] == -1">
                    <i class="fa fa-2x fa-chevron-circle-down" aria-hidden="true"></i>
                </s:if>
                <s:else>
                    <i class="fa fa-2x fa-chevron-down" aria-hidden="true"></i>
                </s:else>
            </a>
        </div>

        <!-- 内容区域 -->
        <s:if test="user.status == 1">
        <div class="right panel panel-danger">
            </s:if>
            <s:else>
            <div class="right panel panel-info">
                </s:else>
                <div class="panel-heading">
                    <h2 class="panel-title">
                        <a href="post!jumpTo?pid=<s:property value="pid"/>" class="post-title" target="_blank">
                            <s:property value="title"/>
                        </a>
                        <div class="author">
                            <span class="glyphicon glyphicon-user" aria-hidden="true"></span>
                            <a href="user!userCenter?uid=<s:property value="user.uid"/>" target="_blank">
                                <s:property value="user.username"/>
                            </a>
                        </div>
                    </h2>
                </div>

                <div class="panel-body">
                    <h4>
                        <s:iterator value="labels" var="label">
                            <span class="label label-success">#<s:property value="#label.name"/></span>
                        </s:iterator>
                        <div class="post-date">
                            <span class="glyphicon glyphicon-comment"></span>
                            <span class="comment-num">
                                        <s:property value="comments[#st.index]"/>
                                    </span>
                            <span>|</span>
                            <span><s:property value="date"/></span>
                        </div>
                    </h4>
                </div>
            </div>
        </div>
        </s:iterator>

        <s:if test="#session.user != null">
            <script>
                var uid = <s:property value="#session.user.uid"/>;

                function post(param) {
                    $.ajax({
                        url: 'post!vote',
                        type: 'POST',
                        data: param,
                        dataType: 'json',
                        success: function (data) {
                            if (data.result === 'vote_ok') {
                                console.log('200');
                            }
                        },
                        error: function () {
                            alert('操作失败，请稍后重试！');
                        }
                    });
                }

                $('.up-vote').on('click', function () {
                    var up = $(this).children('i').eq(0);
                    var down = $(this).siblings('a').first().children('i').eq(0);
                    var a2 = $(this).siblings('a').first();
                    var voteNum = parseInt($(this).siblings('.vote-num').text());

                    console.log($(this).attr('pid'));
                    var param = {
                        uid: uid,
                        pid: $(this).attr('pid'),
                        status: 1,
                        score: 1
                    };

                    if (up.attr('class').search('circle') === -1
                        && down.attr('class').search('circle') === -1) {
                        // upvote
                        up.attr('class', 'fa fa-2x fa-chevron-circle-up');
                        $(this).siblings('.vote-num').first().text(voteNum + 1);
                        a2.css('pointer-events', 'none');
                        post(param);
                    } else if (up.attr('class').search('circle') !== -1
                        && down.attr('class').search('circle') === -1) {
                        // 取消upvote
                        up.attr('class', 'fa fa-2x fa-chevron-up');
                        $(this).siblings('.vote-num').first().text(voteNum - 1);
                        a2.css('pointer-events', '');
                        param.status = 0;
                        param.score = -1;
                        post(param);
                    }
                });

                $('.down-vote').on('click', function () {
                    var down = $(this).children('i').eq(0);
                    var up = $(this).siblings('a').first().children('i').eq(0);
                    var a1 = $(this).siblings('a').first();
                    var voteNum = parseInt($(this).siblings('.vote-num').first().text());
                    console.log($(this).attr('pid'));
                    var param = {
                        uid: uid,
                        pid: $('.down-vote').attr('pid'),
                        status: -1,
                        score: -1
                    };

                    if (up.attr('class').search('circle') === -1
                        && down.attr('class').search('circle') === -1) {
                        // downvote
                        down.attr('class', 'fa fa-2x fa-chevron-circle-down');
                        $(this).siblings('.vote-num').first().text(voteNum - 1);
                        a1.css('pointer-events', 'none');
                        post(param);
                    } else if (up.attr('class').search('circle') === -1
                        && down.attr('class').search('circle') !== -1) {
                        // 取消downvote
                        down.attr('class', 'fa fa-2x fa-chevron-down');
                        $(this).siblings('.vote-num').first().text(voteNum + 1);
                        a1.css('pointer-events', '');
                        param.status = 0;
                        param.score = 1;
                        post(param);
                    }
                });
            </script>
        </s:if>
    </div>

    <s:if test="posts.size() > 5">
        <%@include file="WEB-INF/common/pagination.jsp" %>
    </s:if>

    <%@include file="./WEB-INF/common/backToTop.jsp" %>
    <%@include file="./WEB-INF/common/foot.jsp" %>

</body>
</html>
