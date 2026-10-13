# ClSlaid 的 nvimdots

## 版本与安装

- 基于 `ayamir/nvimdots` 的 **main**（不是 master），本次基点为 `aa65691`。
- 四端统一使用 **Neovim 0.12.6**。不要混用 0.13 nightly；开发版删除的 API/事件可能让插件反复报错。
- `main` 的历史结构是上游提交加 **一个**个人定制提交。`old` 和 `backup/*` 仅用于恢复旧历史。
- 克隆本 fork 到 `:echo stdpath('config')` 显示的目录：通常 Linux/macOS/WSL 是 `~/.config/nvim`，Windows 是 `%LOCALAPPDATA%/nvim`。
- 不要用下文上游安装脚本覆盖本 fork；那会重新安装 ayamir 的版本。
- 首次安装后执行 `:Lazy restore`，重启。日常恢复使用 restore，不是 `:Lazy update`。
- 跨机器同步 Git 配置和 `lazy-lock.json`，**不要复制**插件的原生二进制、Treesitter parser 或 Base46/Lua 缓存。各端分别构建。
- 新增插件的安装可能刷新锁文件；迁移旧插件目录前备份锁文件，安装完成后恢复仓库锁文件，再执行 `:Lazy restore`。

必需/常用外部工具：Git、ripgrep、Node.js（Copilot/部分语言工具）、C 编译器、tree-sitter CLI；语言服务器和调试器由 Mason 或系统包提供。使用的语言仍需对应 SDK。

## 保留的个人功能

- NvChad UI / Base46、个人启动图和 GUI 字体、终端及 buffer 快捷键。
- Rust、Haskell、TypeScript、Scala、Org、Lean、Racket/Lisp、LaTeX、Typst、Zig 的扩展配置。
- clangd、CodeLLDB、DAP UI/虚拟文本、项目配置、输入法切换。
- 最新上游的 blink.cmp 和 LSP 架构；没有退回旧 nvim-cmp API。

## 跨平台行为

| 平台/功能 | 说明 |
| --- | --- |
| Windows shell | 优先 pwsh，其次 Windows PowerShell；都没有则保留默认 shell。Git/lazygit/构建使用参数列表，避免空格路径和 shell 语法差异。 |
| WSL 剪贴板 | 只有找到 `win32yank.exe` 才覆盖剪贴板 provider；否则保留 Neovim 自动探测，可安装 win32yank 或配置 WSLg 剪贴板。 |
| 输入法 | 仅在对应工具存在时启用：macOS macism/im-select，Windows/WSL im-select.exe，Linux fcitx/ibus。 |
| Telescope 原生排序 | 优先 CMake，其次 make，需要 C 工具链；缺失时退回 Lua 排序。 |
| LuaSnip | Windows 默认不构建可选 jsregexp；普通 snippet 可用，依赖该模块的高级变换需自行安装编译依赖。 |
| SnipRun | 不在原生 Windows 启用；可在 WSL 使用。 |
| Parinfer | 有 Cargo 时才启用并编译；没有 Cargo 不影响其他语言。 |
| VimTeX | macOS 使用 Skim；Linux 检测到 zathura 才选用它；其他情况使用插件默认 viewer。检测到 tectonic 才切换编译器，否则保留 latexmk。 |
| direnv | 不再在打开终端时自动 `direnv allow`。应在信任项目后手动授权。 |

## AI 与网络

- 保留现有 `use_chat = false`；聊天插件默认关闭。
- 保留原有 Copilot 补全选择；`use_copilot = false` 可关闭它。不会默认切到需要额外付费 API key 的 Minuet 后端。
- 公共插件下载默认 HTTPS，不需要插入 CanoKey。Git 推送的 SSH 认证不受影响。
- 如需启用旧 ChatGPT/DeepSeek 配置，设置 `use_chat = true`、`OPENAI_API_HOST=https://api.deepseek.com` 和 `OPENAI_API_KEY`。不再通过 `cat ~/.config/chatgpt/key.txt` 读取凭据；旧文件未删除。也可使用新的 CodeCompanion adapter 设置。
- 机器相关覆盖放在不入库的 `lua/user/settings.lua`、`lua/user/options.lua`、`lua/user/chadrc.lua`，不要提交 API key。

## 常用入口

- `<C-n>`：文件树；`<leader>ff`：文件；`<leader>fp`：搜索；`<leader>fc`：搜索集合。
- `<A-i>` / `<A-o>`：切换 buffer；`<A-1>` … `<A-9>`：指定 buffer（不存在时不报错）。
- `<C-\>`：水平终端；`<A-\>` / `<F5>`：竖向终端；`<A-d>`：浮动终端。
- `<leader>gg`：lazygit；`<F6>`：调试启动/继续；`<F7>`：停止；`<F8>`：断点。
- `<leader>dr`：运行到光标；`<leader>dc` / `<leader>dC>`：关闭 DAP UI。
- `<leader>ft`：NvChad 主题；`:checkhealth`：依赖检查；`:messages`：查看完整报错。

## 验证与后续升级

无需安装插件的配置回归测试（包含 Linux、macOS、Windows、WSL 的平台模拟）：

```sh
nvim --headless -u NONE -i NONE -l tests/config.lua
```

真实插件安装、restore 后，在本仓库根目录运行交互事件冒烟测试（建议隔离 XDG 数据目录，可能启动终端）：

```sh
nvim --headless -i NONE -c "luafile tests/smoke.lua"
```

CI 在 Linux/macOS/Windows 跑配置回归测试；WSL 分支使用模拟测试，不能替代 WSLg、系统输入法、真实调试目标的实机验证。

升级上游前先保证工作区干净并备份：

```sh
git branch backup/before-next-upgrade
git fetch aya main
git rebase aya/main
# 解决冲突、测试，再把后续修复合入唯一的个人提交：
git add .
git commit --amend --no-edit
git rev-list --left-right --count aya/main...HEAD
# 预期：0  1
```

对已经推送过的个人提交做 rebase/amend 后才需要 `git push --force-with-lease`。不要无保护地 force push。
