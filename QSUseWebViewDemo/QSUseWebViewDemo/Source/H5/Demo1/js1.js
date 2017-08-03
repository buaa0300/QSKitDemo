// 固定写法 函数名字可变
function setupWebViewJavascriptBridge(callback) {
    if (window.WebViewJavascriptBridge) {
        callback(WebViewJavascriptBridge)
    } else {
        document.addEventListener('WebViewJavascriptBridgeReady' , function() {
                                  callback(WebViewJavascriptBridge)
                                  }, false );
    }
    
    // =====以下是iOS必须的特殊处理========
    if (window.WVJBCallbacks) { return window.WVJBCallbacks.push(callback); }
    window.WVJBCallbacks = [callback];
    var WVJBIframe = document.createElement('iframe');
    WVJBIframe.style.display = 'none';
    WVJBIframe.src = 'wvjbscheme://__BRIDGE_LOADED__';
    document.documentElement.appendChild(WVJBIframe);
    setTimeout(function() { document.documentElement.removeChild(WVJBIframe) }, 0);
    // =====以上是iOS必须的特殊处理========
}

// 固定写法2 函数名字与1保持一致
setupWebViewJavascriptBridge(function(bridge) {
                             // Java 注册回调函数，第一次连接时调用 初始化函数
                             bridge.init();
                             });

// 每个方法的特殊处理
function setTitle() {
    WebViewJavascriptBridge.callHandler('_app_setTitle',
                                        '这是一个nav标题',
                                        function (response) {
                                        // 移动端回传的数据
                                        alert('移动端回传的数据:' + response);
                                        });
}

alert('测试页面');
