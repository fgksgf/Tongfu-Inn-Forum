<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- 发帖模态框 -->
<div id="post" class="modal">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-body">
                <button class="close" data-dismiss="modal">
                    <span>&times;</span>
                </button>
            </div>
            <div class="modal-title">
                <h1 class="text-center">发帖</h1>
            </div>
            <div class="modal-body">
                <form class="form-group" action="">
                    <div class="form-group">
                        <label for="post-title">标题</label>
                        <input id="post-title" class="form-control" type="text" placeholder="">
                    </div>
                    <div class="form-group">
                        <div id="editor"></div>
                    </div><br>
                    <div class="form-group">
                        <label for="post-labels">标签(多个标签请使用半角分号分隔)</label>
                        <input id="post-labels" class="form-control" type="text" maxlength="20" placeholder="标签使用半角分号分隔">
                    </div>
                </form>
                <div class="text-right">
                    <button class="btn btn-primary" id="post-btn">发布</button>
                    <button class="btn btn-danger" data-dismiss="modal">取消</button>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript" src="/resources/js/wangEditor.min.js"></script>
<script type="text/javascript">
    var E = window.wangEditor;
    var editor = new E(document.getElementById('editor'));
    editor.customConfig.menus = [
        'fontSize',         // 字号
        'foreColor',        // 文字颜色
        'bold',             // 粗体
        'italic',           // 斜体
        'underline',        // 下划线
        'strikeThrough',    // 删除线
        'link',             // 插入链接
        'quote',            // 引用
        'image',            // 插入图片
        'code',             // 插入代码
        'list',             // 列表
        'justify'           // 对齐方式
    ];
    editor.create();
    var uid = '<s:property value="#session.user.uid" />';
    var status = <s:property value="#session.user.status" />;

    $('#post-btn').on('click',function () {
        if (status == -1) {
            alert('该账号已被封禁，无法发帖！');
            return;
        }

        var t = $('#post-title').val();
        var c = editor.txt.html();
        var l = $('#post-labels').val();

        if (t.length === 0) {
            alert('标题不能为空！');
            return;
        }
        if (c .length === 0) {
            alert('内容不能为空！');
            return;
        }
        if (l.length === 0) {
            alert('至少一个标签！');
            return;
        }

        $('#post-btn').attr('disabled','disabled');

        var params = {
            uid: uid,
            title: t,
            content: c,
            labels: l
        };

        $.ajax({
            type: 'POST',                     //请求方式为post方式
            url: 'post!add',              //请求地址
            dataType: 'json',                 //服务器返回类型为JSON类型
            data: params,                     //发送到服务器的数据
            success: function (data) {           //请求成功后的回调函数
                if (data.result === 'add_ok') {
                    location.href = 'page';
                } else {
                    alert('发帖失败！');
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