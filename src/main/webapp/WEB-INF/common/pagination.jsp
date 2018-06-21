<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<br>
<div class="row text-center">
    <button type="button" class="btn btn-success btn-lg" id="load-more" style="width: 30%" data-loading-text="加载中...">
        加载更多
    </button>
</div>
<br>

<script>
    var current = 1;    // 当前是第几页
    var row = 5;        // 每页多少条
    var hasMore = true; // 是否还有未显示的条目

    function loadMore() {
        if (hasMore) {
            var $btn = $(this).button('loading');
            for (var i = 1; i <= 5; ++i) {
                var item = $('#item-' + (current * row + i));
                if (item.length > 0) {
                    item.css('display', '');
                } else {
                    hasMore = false;
                    $('#load-more').css('display', 'none');
                    break;
                }
            }
            current++;
            $btn.button('reset');
        }

        // 检查是否正好加载完所有，若是，隐藏按钮
        if (hasMore) {
            var it = $('#item-' + (current * row + 1));
            if (it.length === 0) {
                hasMore = false;
                $('#load-more').css('display', 'none');
            }
        }
    }

    // 按下“加载更多”按钮后调用指定函数
    $('#load-more').on('click', function () {
        loadMore();
    });
</script>