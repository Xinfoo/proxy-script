#!/usr/bin/env bash
set -euo pipefail

# 配置文件默认放在 ~/.config/via-proxy/config.toml。
# 如果用户设置了 XDG_CONFIG_HOME，则遵循 XDG 规范放到该目录下。
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/via-proxy"
CONFIG_FILE="$CONFIG_DIR/config.toml"

# 首次运行时生成的默认代理地址。
# 所有代理环境变量都会使用这个 proxy 配置项。
DEFAULT_PROXY="http://127.0.0.1:7897"

# 打印简单帮助信息。
usage() {
  cat <<'EOF'
Usage:
  via <command> [args...]
  via --config
  via --help

Config:
  ~/.config/via-proxy/config.toml

Example config:
  proxy = "http://127.0.0.1:7897"
EOF
}

# 确保配置目录和配置文件存在。
# 如果 config.toml 不存在，就自动创建一份默认配置，用户之后可以直接编辑它。
ensure_config() {
  mkdir -p "$CONFIG_DIR"

  if [[ ! -f "$CONFIG_FILE" ]]; then
    cat >"$CONFIG_FILE" <<EOF
# via proxy config
# All proxy environment variables use this value.
proxy = "$DEFAULT_PROXY"
EOF
  fi
}

# 从简单的 TOML 配置里读取字符串值。
# 这里支持形如：proxy = "http://127.0.0.1:7897"
# 只做本脚本需要的最小解析：去掉注释、等号前后空白，以及外层单双引号。
read_toml_string() {
  local key="$1"
  local value

  value="$(
    awk -v key="$key" '
      BEGIN { pattern = "^[[:space:]]*" key "[[:space:]]*=" }
      $0 ~ pattern {
        line = $0
        sub(/#.*/, "", line)
        sub(/^[^=]*=[[:space:]]*/, "", line)
        sub(/^[[:space:]]*/, "", line)
        sub(/[[:space:]]*$/, "", line)
        if (line ~ /^".*"$/ || line ~ /^\047.*\047$/) {
          line = substr(line, 2, length(line) - 2)
        }
        print line
        exit
      }
    ' "$CONFIG_FILE"
  )"

  printf '%s\n' "$value"
}

main() {
  # 每次运行都先确保配置存在，这样用户第一次执行 via 时也能自动初始化。
  ensure_config

  # 处理 via 自己的参数；其余参数会被当成要执行的真实命令。
  case "${1:-}" in
    -h|--help)
      usage
      return 0
      ;;
    --config)
      printf '%s\n' "$CONFIG_FILE"
      return 0
      ;;
    --)
      shift
      if [[ $# -eq 0 ]]; then
        usage >&2
        return 2
      fi
      ;;
    "")
      usage >&2
      return 2
      ;;
  esac

  local proxy

  # 读取主代理地址，所有代理环境变量都会使用同一个值。
  proxy="$(read_toml_string proxy)"

  if [[ -z "$proxy" ]]; then
    printf 'via: missing proxy in %s\n' "$CONFIG_FILE" >&2
    return 1
  fi

  # 只给本次执行的命令临时注入常见代理环境变量，不污染当前 shell。
  # 同时设置大小写版本，兼容更多命令行工具。
  # 使用 export 注入当前进程环境，exec 会自动继承所有环境变量，
  # 包括父 shell 传递的临时变量（如 XXX=YYY via somecommand）。
  export HTTP_PROXY="$proxy"
  export HTTPS_PROXY="$proxy"
  export ALL_PROXY="$proxy"
  export RSYNC_PROXY="$proxy"
  export http_proxy="$proxy"
  export https_proxy="$proxy"
  export all_proxy="$proxy"
  export rsync_proxy="$proxy"
  exec "$@"
}

main "$@"
