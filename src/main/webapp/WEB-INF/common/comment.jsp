<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- 发表评论模态框 -->
<div id="comment" class="modal">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-body">
                <button class="close" data-dismiss="modal">
                    <span>&times;</span>
                </button>
            </div>
            <div class="modal-title">
                <h1 class="text-center">发表评论</h1>
            </div>
            <div class="modal-body">
                <form class="form-group">
                    <div class="form-group">
                        <div id="editor">
                            <p>友善发言的人运气都不会太差:)</p>
                        </div>
                    </div><br>
                    <div class="text-right">
                        <button class="btn btn-primary" id="comment-btn">发表</button>
                        <button class="btn btn-danger" data-dismiss="modal">取消</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript" src="/resources/js/wangEditor.min.js"></script>
<script type="text/javascript">
    var E = window.wangEditor;
    var editor = new E(document.getElementById('editor'));
    editor.customConfig.menus = [
        'bold',  // 粗体
        'italic',  // 斜体
        'link',  // 插入链接
        'quote',  // 引用
        'image',  // 插入图片
        'code'  // 插入代码
    ];
    editor.create();

    $('#comment-btn').on('click',function () {
        var c = editor.txt.html();

        if (c .length === 0) {
            alert('内容不能为空！');
            return;
        }

        $('#comment-btn').attr('disabled','disabled');

        var params = {
            username: '<s:property value="#session.user.username" />',
            content: c
        };

        console.log(params);

        $.ajax({
            type: 'POST',                     //请求方式为post方式
            url: 'post!addPost',              //请求地址
            dataType: 'json',                 //服务器返回类型为JSON类型
            data: params,                     //发送到服务器的数据
            success: function (data) {           //请求成功后的回调函数
                if (data.result === 'add_ok') {
                    location.href = 'page';
                } else {
                    alert('发帖失败！')
                }
                $('#post-btn').removeAttr('disabled');
            },
            error: function () {
                alert('连接服务器失败，请稍后重试！');
                $('#post-btn').removeAttr('disabled');
            }
        });
    });
</script>