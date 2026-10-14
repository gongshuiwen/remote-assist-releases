# Remote Assist — Customer Agent Downloads

这是 **Remote Assist / 即援** 的公开 Agent 二进制下载仓库，供获得邀请的客户临时接受工程师协助。

**仅用于分发**：这里不包含 Remote Assist 的私有应用源码。GitHub 自动生成的 `Source code (zip/tar.gz)` 仅包含本公开仓库中的说明等文件，**不是 Agent 的源码**。Agent 可执行文件位于 [Releases](https://github.com/gongshuiwen/remote-assist-releases/releases) 的 Assets 中。

## 如何接入

1. 只从熟悉且可信的工程师处获取协助邀请，并核对对方身份及协助目的。
2. 在 [Releases](https://github.com/gongshuiwen/remote-assist-releases/releases) 中选择对应 Windows / Linux / macOS 与 x64 / ARM64 的 `assist-agent_...` 文件。可按 `SHA256SUMS` 校验完整性。
3. Windows：运行下载的 EXE；Linux/macOS：在终端运行对应文件。Agent 会打开**本机中文授权窗口**。
4. 粘贴完整的 HTTPS 邀请链接，核对服务端、工程师身份、故障说明、权限范围与有效时间，再决定是否开始协助。
5. 默认只允许基本信息共享。即使允许工程师申请执行命令，**每条命令仍需要客户本机单独批准**。客户可以随时结束本次协助。

客户无需创建 GitHub 账户，无需安装 Go / Node.js / Python。启动脚本 `connect.ps1` / `connect.sh` 是技术用户的可选入口，必须从可信发布资产下载、审阅后运行；不要执行来路不明的远程脚本。

## 版本与安全提示

- 当前分发流程提供 **unsigned prerelease / 未签名开发预览**。Windows 未完成代码签名，macOS 未完成签名和公证；部分系统可能阻止运行。**不要为此关闭操作系统或防病毒防护。**
- SHA-256 可以核对文件与随版本发布的清单是否一致，但**不是发布者代码签名**。
- Agent 不安装系统服务、不设置开机启动、不自动提权。它不是无人值守远程控制工具。
- HTTPS 用于连接传输保护；服务端可能读取诊断请求和结果。命令执行能力不等同于只读访问或安全沙箱。
- 公开下载不意味着允许第三方修改、再分发或重新品牌化；正式分发许可与用户条款应由维护者明确公布。
- 如遇异常，请先停止协助并通过已有的可信渠道联系工程师。不要将邀请码、会话令牌、敏感日志或漏洞详情提交到公开 Issue。

**发布方式**：只有通过人工发行决策与 CI 回归的版本 Tag，才会由私有构建流水线同步到这里；Release 页面没有列出的版本即未公开发布。
