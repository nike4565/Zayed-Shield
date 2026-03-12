<div align="center">

<img src="https://img.shields.io/badge/🛡️_ZAYED_SHIELD-SUPPORT_CENTER-gold?style=for-the-badge&labelColor=0a0a0a" />

[![GitHub Issues](https://img.shields.io/github/issues/nike4565/Zayed-Shield?style=for-the-badge&logo=github&label=Open%20Issues&color=EF3340)](https://github.com/nike4565/Zayed-Shield/issues)
[![GitHub Discussions](https://img.shields.io/github/discussions/nike4565/Zayed-Shield?style=for-the-badge&logo=github&label=Discussions&color=4A90D9)](https://github.com/nike4565/Zayed-Shield/discussions)
[![Documentation](https://img.shields.io/badge/Docs-ARCHITECTURE.md-009A44?style=for-the-badge&logo=readthedocs&logoColor=white)](https://github.com/nike4565/Zayed-Shield/blob/main/docs/ARCHITECTURE.md)
[![Changelog](https://img.shields.io/badge/Changelog-CHANGELOG.md-FFD700?style=for-the-badge&logo=keepachangelog&logoColor=black)](https://github.com/nike4565/Zayed-Shield/blob/main/CHANGELOG.md)
[![License](https://img.shields.io/badge/License-MIT-white?style=for-the-badge&logo=opensourceinitiative&logoColor=black)](https://github.com/nike4565/Zayed-Shield/blob/main/LICENSE)

---

```
███████╗██╗   ██╗██████╗ ██████╗  ██████╗ ██████╗ ████████╗
██╔════╝██║   ██║██╔══██╗██╔══██╗██╔═══██╗██╔══██╗╚══██╔══╝
███████╗██║   ██║██████╔╝██████╔╝██║   ██║██████╔╝   ██║
╚════██║██║   ██║██╔═══╝ ██╔═══╝ ██║   ██║██╔══██╗   ██║
███████║╚██████╔╝██║     ██║     ╚██████╔╝██║  ██║   ██║
╚══════╝ ╚═════╝ ╚═╝     ╚═╝      ╚═════╝ ╚═╝  ╚═╝   ╚═╝
```

### 🤝 SUPPORT CENTER — مركز الدعم
**Zayed Shield Enterprise Security · درع زايد**

</div>

---

## 📋 Table of Contents

- [Before You Ask](#-before-you-ask)
- [Support Channels](#-support-channels)
- [Issue Templates](#-issue-templates)
- [FAQ](#-frequently-asked-questions)
- [Documentation](#-documentation)
- [Community Guidelines](#-community-guidelines)
- [Response Times](#-response-times)
- [Contact](#-contact)

---

## 🔍 Before You Ask

<div align="center">

[![Search Issues](https://img.shields.io/badge/1._Search-Existing_Issues-4A90D9?style=for-the-badge&logo=github)](https://github.com/nike4565/Zayed-Shield/issues?q=is%3Aissue)
[![Read Docs](https://img.shields.io/badge/2._Read-Documentation-009A44?style=for-the-badge&logo=readthedocs&logoColor=white)](https://github.com/nike4565/Zayed-Shield/tree/main/docs)
[![Check Changelog](https://img.shields.io/badge/3._Check-CHANGELOG-FFD700?style=for-the-badge&logo=keepachangelog&logoColor=black)](https://github.com/nike4565/Zayed-Shield/blob/main/CHANGELOG.md)

</div>

Before opening a new issue or question, please:

- 🔎 **Search** [existing issues](https://github.com/nike4565/Zayed-Shield/issues) — your question may already be answered
- 📖 **Read** the [ARCHITECTURE.md](https://github.com/nike4565/Zayed-Shield/blob/main/docs/ARCHITECTURE.md) to understand how components interact
- 📝 **Check** the [CHANGELOG.md](https://github.com/nike4565/Zayed-Shield/blob/main/CHANGELOG.md) — your issue may be fixed in a newer version
- ✅ **Confirm** you are using a [supported version](https://github.com/nike4565/Zayed-Shield/blob/main/SECURITY.md#-supported-versions)

---

## 📡 Support Channels

<div align="center">

| Channel | Purpose | Response Time | Link |
|:-------:|:-------:|:-------------:|:----:|
| 🐛 **GitHub Issues** | Bug reports & feature requests | < 48 hours | [Open Issue](https://github.com/nike4565/Zayed-Shield/issues/new/choose) |
| 💬 **GitHub Discussions** | Questions, ideas, general help | < 72 hours | [Start Discussion](https://github.com/nike4565/Zayed-Shield/discussions) |
| 🔐 **Security Advisory** | Vulnerability reports ONLY | < 24 hours | [Report Privately](https://github.com/nike4565/Zayed-Shield/security/advisories/new) |
| 📧 **Email** | Critical / Enterprise support | < 48 hours | nike494949@outlook.sa |

</div>

> ⚠️ **Security issues must NEVER be reported via public GitHub Issues.**
> Use the [Private Security Advisory](https://github.com/nike4565/Zayed-Shield/security/advisories/new) instead.

---

## 📝 Issue Templates

When opening an issue, choose the right template:

### 🐛 Bug Report

```markdown
**Environment**
- OS: [e.g., Ubuntu 24.04]
- Version: [e.g., 3.0.0]
- Component: [AI Engine / Firewall / Gateway / Forensics / Monitor]
- Node/Python version: [if applicable]

**Describe the Bug**
A clear description of what the bug is.

**Steps to Reproduce**
1. Go to '...'
2. Run '...'
3. See error

**Expected Behavior**
What you expected to happen.

**Actual Behavior**
What actually happened.

**Logs / Screenshots**
```paste logs here```

**Additional Context**
Any other relevant information.
```

---

### ✨ Feature Request

```markdown
**Feature Summary**
One-line summary of the feature.

**Problem It Solves**
What problem does this solve? Who benefits?

**Proposed Solution**
How would you implement this?

**Alternatives Considered**
What other approaches did you consider?

**Impact**
- [ ] AI Engine
- [ ] Firewall
- [ ] Gateway
- [ ] Forensics
- [ ] Monitoring Dashboard
- [ ] Documentation
- [ ] Other: ___
```

---

### ❓ Question / Help

```markdown
**What are you trying to do?**
Describe your goal clearly.

**What have you tried?**
List the steps you've already taken.

**What happened?**
Describe the result you got.

**Relevant docs checked?**
- [ ] ARCHITECTURE.md
- [ ] CHANGELOG.md
- [ ] Existing issues
- [ ] README.md
```

---

## ❓ Frequently Asked Questions

<details>
<summary><b>🔐 How does the 5-minute key rotation work?</b></summary>

The Gateway module generates a new cryptographically random 256-bit key every **300 seconds**.
The old key is immediately invalidated and a new barcode is generated.
See [`/src/gateway/`](https://github.com/nike4565/Zayed-Shield/tree/main/src/gateway) and [ARCHITECTURE.md](https://github.com/nike4565/Zayed-Shield/blob/main/docs/ARCHITECTURE.md#%EF%B8%8F-key-rotation-flow).

</details>

<details>
<summary><b>🤖 What AI model does the threat engine use?</b></summary>

Zayed Shield uses an ensemble of:
- **LSTM** for sequential traffic pattern analysis
- **CNN** for payload signature recognition
- **Behavioral baseline profiler** for anomaly detection

See [`/src/ai/`](https://github.com/nike4565/Zayed-Shield/tree/main/src/ai) for implementation details.

</details>

<details>
<summary><b>🔥 Can I use the firewall module standalone?</b></summary>

Yes. Each module in `/src/` is independently deployable.
The firewall module can run without the AI engine, though threat detection accuracy will be reduced to signature-based only.

</details>

<details>
<summary><b>📊 How do I access the live dashboard?</b></summary>

Start the monitor service from `/src/monitor/` and access it at:
```
http://localhost:3000
```
Default credentials are set during first-run setup. See the installation guide in `/docs/guides/installation.md`.

</details>

<details>
<summary><b>🔬 Can I use the forensics module on my own files?</b></summary>

Yes. The forensics module in `/src/forensics/` accepts any file input.
Run the analysis script from `/scripts/remediation/stage-3-analyze.sh`.
Reports are saved to `/archive/reports/`.

</details>

<details>
<summary><b>🇦🇪 Is this project officially affiliated with the UAE government?</b></summary>

Zayed Shield is an **independent open-source security initiative** aligned with UAE's Vision 2050 for cybersecurity. It is not an official government project, but contributions are dedicated to the UAE's digital security future.

</details>

<details>
<summary><b>📦 How do I report a vulnerability found in Zayed Shield?</b></summary>

**Never** open a public issue. Use the [Private Security Advisory](https://github.com/nike4565/Zayed-Shield/security/advisories/new) or email `nike494949@outlook.sa` encrypted with our [PGP key](https://github.com/nike4565/Zayed-Shield/blob/main/SECURITY.md#-pgp-public-key).
See our full [SECURITY.md](https://github.com/nike4565/Zayed-Shield/blob/main/SECURITY.md) for the complete disclosure process.

</details>

---

## 📚 Documentation

<div align="center">

| Document | Description | Link |
|:--------:|:-----------:|:----:|
| 📐 **ARCHITECTURE.md** | System design, folder structure, data flow | [View](https://github.com/nike4565/Zayed-Shield/blob/main/docs/ARCHITECTURE.md) |
| 📋 **CHANGELOG.md** | Full version history and release notes | [View](https://github.com/nike4565/Zayed-Shield/blob/main/CHANGELOG.md) |
| 🔐 **SECURITY.md** | Vulnerability reporting & disclosure policy | [View](https://github.com/nike4565/Zayed-Shield/blob/main/SECURITY.md) |
| 🤝 **SUPPORT.md** | This file — how to get help | [View](https://github.com/nike4565/Zayed-Shield/blob/main/SUPPORT.md) |
| 🛠️ **Installation Guide** | How to set up Zayed Shield | [View](https://github.com/nike4565/Zayed-Shield/blob/main/docs/guides/installation.md) |
| ⚙️ **Configuration Guide** | Configuration reference | [View](https://github.com/nike4565/Zayed-Shield/blob/main/docs/guides/configuration.md) |
| 📡 **API Reference** | REST API documentation | [View](https://github.com/nike4565/Zayed-Shield/blob/main/docs/guides/api-reference.md) |

</div>

---

## 🤝 Community Guidelines

When seeking or providing support, please:

- ✅ **Be respectful** — Everyone is here to learn and help
- ✅ **Be specific** — Vague questions get vague answers
- ✅ **Share context** — Include version, OS, logs, and steps to reproduce
- ✅ **Be patient** — This is a security research project; responses take time
- ✅ **Search first** — Avoid duplicating existing issues or discussions
- ❌ **Do not** share exploits or sensitive security findings in public issues
- ❌ **Do not** use support channels for off-topic discussions

---

## ⏰ Response Times

<div align="center">

```
Security Reports    ████████████████████  < 24 hours  🔴 Priority 1
Bug Reports         ████████████████      < 48 hours  🟠 Priority 2
Feature Requests    ████████              < 7 days    🟡 Priority 3
Questions           ████████████          < 72 hours  🟢 Priority 4
```

</div>

> Response times are best-effort. For **critical security issues**, use the
> [Private Advisory](https://github.com/nike4565/Zayed-Shield/security/advisories/new) channel for guaranteed fast response.

---

## 📞 Contact

<div align="center">

| | Contact |
|:---:|:---:|
| 👤 **Lead Researcher** | asrar-mared (Al-Muharib) |
| 📧 **Email** | nike494949@outlook.sa |
| 🐙 **GitHub** | [@nike4565](https://github.com/nike4565) |
| 🔐 **PGP** | `8429D4C1ECAC3080BCB84AA0982159B70BA77EFD` |
| 🌐 **Project** | [github.com/nike4565/Zayed-Shield](https://github.com/nike4565/Zayed-Shield) |

</div>

---

<div align="center">

[![Open an Issue](https://img.shields.io/badge/🐛_Open-Bug_Report-EF3340?style=for-the-badge)](https://github.com/nike4565/Zayed-Shield/issues/new?template=bug_report.md)
[![Start Discussion](https://img.shields.io/badge/💬_Start-Discussion-4A90D9?style=for-the-badge)](https://github.com/nike4565/Zayed-Shield/discussions)
[![Report Security Issue](https://img.shields.io/badge/🔐_Report-Security_Issue-009A44?style=for-the-badge)](https://github.com/nike4565/Zayed-Shield/security/advisories/new)

---

**🛡️ Zayed Shield Enterprise Security**

*Support Center · مركز الدعم*

[github.com/nike4565/Zayed-Shield](https://github.com/nike4565/Zayed-Shield)

🇦🇪 *Built for the UAE · Secured for the World* 🌍

</div>

