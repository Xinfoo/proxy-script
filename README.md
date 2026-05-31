# via-proxy

`via-proxy` 是一个很小的命令行辅助脚本，用来在执行某条命令时临时注入代理环境变量。

例如：

```sh
via curl https://example.com
via git clone https://github.com/example/project.git
via npm install
```

它不会修改当前 shell 的环境变量，只会把代理变量传给 `via` 后面的那条命令。

## 谨慎使用

这个仓库里的东西最初是给作者自己的电脑和网络环境写的，默认配置、依赖、代理端口、打包方式都不保证适合其他机器。

如果你是偶然看到这个仓库的人，请先读脚本内容再使用。尤其注意：

- 默认代理地址是 `http://127.0.0.1:7897`，你的本机不一定有这个代理服务。
- 这个脚本会设置常见代理环境变量，可能影响被执行命令的网络行为。
- 这里提供的是一个很薄的个人工具，不保证覆盖复杂 TOML 配置、认证代理、企业网络、特殊 shell 环境等场景。
- 安装前请确认你信任脚本内容，并理解它会如何执行你的命令。

## 安装

这是一个 Arch Linux 风格的软件包仓库，包含 `PKGBUILD` 和 `.SRCINFO`。

在仓库目录下可以使用：

```sh
makepkg -si
```

安装后，脚本会被安装为：

```sh
/usr/bin/via
```

运行依赖：

- `bash`
- `gawk`

## 使用方法

基本格式：

```sh
via <command> [args...]
```

示例：

```sh
via curl https://example.com
via git fetch
via rsync -av source/ target/
```

查看帮助：

```sh
via --help
```

查看配置文件路径：

```sh
via --config
```

## 配置

首次运行时，`via` 会自动创建配置文件。

默认路径是：

```sh
~/.config/via-proxy/config.toml
```

如果设置了 `XDG_CONFIG_HOME`，则路径会变为：

```sh
$XDG_CONFIG_HOME/via-proxy/config.toml
```

配置文件内容示例：

```toml
proxy = "http://127.0.0.1:7897"
```

`via` 会读取 `proxy` 这个值，并在执行命令时设置下面这些环境变量：

- `HTTP_PROXY`
- `HTTPS_PROXY`
- `ALL_PROXY`
- `RSYNC_PROXY`
- `http_proxy`
- `https_proxy`
- `all_proxy`
- `rsync_proxy`

所有变量都会使用同一个 `proxy` 地址。

## 工作方式

执行：

```sh
via curl https://example.com
```

大致等价于临时执行：

```sh
HTTP_PROXY="http://127.0.0.1:7897" \
HTTPS_PROXY="http://127.0.0.1:7897" \
ALL_PROXY="http://127.0.0.1:7897" \
curl https://example.com
```

区别是 `via` 会从配置文件读取代理地址，并同时设置大小写版本以及 `rsync` 相关变量。

## 许可证

MIT
