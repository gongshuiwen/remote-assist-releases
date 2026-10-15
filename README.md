# Remote Assist — Customer Agent Downloads

这是 **Remote Assist / 即援** 的公开 Agent 二进制下载仓库，供获得邀请的客户临时接受工程师协助。

**仅用于分发**：这里不包含 Remote Assist 的私有应用源码。GitHub 自动生成的 `Source code (zip/tar.gz)` 仅包含本公开仓库中的说明等文件，**不是 Agent 的源码**。Agent 可执行文件位于 [Releases](https://github.com/gongshuiwen/remote-assist-releases/releases) 的 Assets 中。

## 如何接入

1. 只从熟悉且可信的工程师处获取协助邀请，并核对对方身份及协助目的。
2. 在 [Releases](https://github.com/gongshuiwen/remote-assist-releases/releases) 中选择对应 Windows / Linux / macOS 与 x64 / ARM64 的 `assist-agent_...` 文件。可按 `SHA256SUMS` 校验完整性。
3. Windows：运行下载的 EXE；Linux/macOS：在终端运行对应文件。Agent 会打开**本机中文授权窗口**。
4. 粘贴完整的 HTTPS 邀请链接，核对服务端、工程师身份、故障说明、权限范围与有效时间，再决定是否开始协助。
5. 默认只允许只读的基本信息共享。命令执行须由客户在本机选择开启，默认**每条确切命令都需要客户本机单独批准**。客户也可在本机明确选择仅本次临时会话有效的**完全访问**；界面会提示此时命令无需逐条确认，以当前用户身份执行。客户可随时撤销授权或结束协助，授权到期后失效；新会话不会继承完全访问，断线重连也不会重放任务。

客户无需创建 GitHub 账户，无需安装 Go / Node.js / Python。启动脚本 `connect.ps1` / `connect.sh` 是技术用户的可选入口，必须从可信发布仓库或发布资产获取、审阅后运行；不要执行来路不明的远程脚本。

## Windows 一行启动

确认这是可信的分发仓库，并审阅 [connect.ps1](connect.ps1) 后，在普通权限的 PowerShell 5.1 或 PowerShell 7 中粘贴：

```powershell
& ([scriptblock]::Create((irm 'https://raw.githubusercontent.com/gongshuiwen/remote-assist-releases/main/connect.ps1')))
```

脚本自动识别 Windows x64 / ARM64，下载脚本中固定的已成功发布版本 Agent 和 `SHA256SUMS`，校验通过后启动本机中文授权窗口，退出后尝试清理临时文件。下载或校验失败会停止运行，无需手工下载 EXE，也不会申请管理员权限或修改 PowerShell 执行策略。客户仍须在本机决定是否授权；请在授权窗口粘贴邀请链接。

仓库根目录的脚本固定为已成功发布的版本，随发布流水线更新；其内容与对应 Release 的启动脚本一致。`main` 地址随版本更新；需要固定版本时，可将命令中的 URL 换为具体 Release 的脚本地址，例如已经发布的 [v0.2.0-m1 脚本](https://github.com/gongshuiwen/remote-assist-releases/releases/download/v0.2.0-m1/connect.ps1)。

## 版本与安全提示

- 当前分发流程提供 **unsigned prerelease / 未签名开发预览**。Windows 未完成代码签名，macOS 未完成签名和公证；部分系统可能阻止运行。**不要为此关闭操作系统或防病毒防护。**
- SHA-256 可以核对文件与随版本发布的清单是否一致，但**不是发布者代码签名**。
- Agent 不安装系统服务、不设置开机启动、不自动提权。它不是无人值守远程控制工具。
- HTTPS 用于连接传输保护；服务端可能读取诊断请求和结果。命令执行能力不等同于只读访问或安全沙箱。
- 公开下载不意味着允许第三方修改、再分发或重新品牌化；正式分发许可与用户条款应由维护者明确公布。
- Agent 包含 Go 运行时，其 BSD 许可通知见 [GO-LICENSE](GO-LICENSE)；该通知不授予 Remote Assist 应用本身的开源许可。
- 如遇异常，请先停止协助并通过已有的可信渠道联系工程师。不要将邀请码、会话令牌、敏感日志或漏洞详情提交到公开 Issue。

**发布方式**：后续版本经人工审阅与发行决策，由维护者明确推送新版本 Tag 后，私有源码仓库的流水线自动构建并执行 CI 回归。通过后发布六种 Agent、两个启动脚本、`GO-LICENSE` 与 `SHA256SUMS` 共 10 个附件；全部附件匿名下载与校验通过后，再同步公开仓库根目录的 `connect.ps1` / `connect.sh`。已有 Release 和 Tag 不自动覆盖。Release 页面没有列出的版本即未公开发布。
