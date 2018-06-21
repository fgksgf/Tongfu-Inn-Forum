<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<button id="back" class="btn btn-warning" style="position: fixed;right: 30px;bottom: 30px;display: none">
    点我上天
</button>
<script>
    var backButton = $('#back');

    // 使用jQuery的animate()动画效果函数来实现平滑滚动到页面顶部的动画效果
    backButton.on('click', function () {
        $('html,body').animate({
            scrollTop: 0
        }, 300);
    });

    // 窗口高度的三分之一,固定值
    var windowHeight = $(window).height() / 3;

    // 监听window的scroll事件
    $(window).on('scroll', function () {
        // 如果已滚动的部分高于窗口高度的三分之一，显示按钮；否则，隐藏按钮
        if ($(window).scrollTop() >= windowHeight)
            backButton.fadeIn(300);
        else
            backButton.fadeOut(300);
    });
</script>