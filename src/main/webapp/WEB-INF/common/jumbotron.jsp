<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- 巨幕 -->
<div class="container" id="jumbotron">
    <div class="jumbotron">
        <div class="text-center">
        <h1 class="css12821c37df1cff9" style="font-size: 70px">有人的地方就有江湖</h1>
        </div>
        <br>
        <s:if test="#session.user == null">
            <a class="btn btn-lg btn-primary" id="register-btn" data-toggle="modal" data-target="#register" role="button">成为江湖人</a>
        </s:if>
        <s:else>
            <a class="btn btn-lg btn-primary" data-toggle="modal" data-target="#post" role="button">发布江湖帖</a>
        </s:else>
        <br>
    </div>
</div>