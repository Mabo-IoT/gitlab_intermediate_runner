https://gitlab.com/gitlab-org/gitlab-runner/issues/3553

这里简述了一个获取runner信息的api：

如果有人想知道：花了几个小时来解决这个愚蠢的问题（真的想要自动化注册过程），我认为获得转轮令牌的最佳和自动化的解决方法是使用这个API：

```
curl --request POST "https://gitlab.com/api/v4/runners" --form "token=<registration-token>" --form "description=test-1-20150125-test" --form "tag_list=ruby,mysql,tag1,tag2"
```

响应：

```
{"id":401513,"token":"<runner-token>"}
```

因此，基本上在请求中发送一个注册令牌，并在响应中获取转轮令牌，然后可以使用一些模板将其注入config.toml。



关于如何修改

> https://gitlab.com/gitlab-org/gitlab-ce/issues/40693
>
> https://gitlab.com/gitlab-org/gitlab-runner/issues/1539
>
> https://gitlab.com/gitlab-org/gitlab-runner/issues/1539

但好像依然不是一个好的解决方式。啧。

这里找到一个比较暴力的方法，使用sh中的sed命令进行修改。

```
sed -i 's/concurrent = 1/concurrent = 2/g' $install_file_path/config/config.toml
```

<!--一点也不优雅-->