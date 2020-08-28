TIPS:
* 部署到[kintohub](https://app.kintohub.com/login)时，v2ray可以从网络地址读取文件配置，使用自定义的CONFIG更加灵,支持tor，不包含caddy功能
* 部署后直接访问External Access返回Bad Request即表示部署成功
* 默认配置是`https://github.com/mixool/v2ray/raw/master/kinto/config.json`，建议自行复制修改内容后放到[GIST](https://gist.github.com/)，然后设置CONFIG变量为GIST的RAW地址
