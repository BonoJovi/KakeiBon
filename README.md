# 📖 KakeiBon（家計簿）

<div align="center">

> **玄人志向の方のための、シンプルかつパワフルな家計簿アプリ**

[![Lazarus](https://img.shields.io/badge/Lazarus-Free%20Pascal-orange.svg)](https://www.lazarus-ide.org/)
[![SQLite](https://img.shields.io/badge/SQLite-3-blue.svg)](https://sqlite.org/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20Windows-lightgrey.svg)](#対応os)

[📥 ダウンロード](https://github.com/BonoJovi/KakeiBon/releases/) | [🐛 不具合報告](https://github.com/BonoJovi/KakeiBon/issues) | [🚀 Rust版](https://github.com/BonoJovi/KakeiBonByRust)

</div>

---

## ⚠️ 重要なお知らせ

**🔥 Rust版の開発が進行中です！**

より高速で安全な次世代版を開発中です。ぜひチェックしてください！

👉 **[KakeiBonByRust](https://github.com/BonoJovi/KakeiBonByRust)** - Tauri + Rust 実装版

---

## ✨ 主な特徴

### 🔤 大きな文字で見やすい
視力に障がい（弱視等）をお持ちの方向けに、フォントサイズを大きめに設計しています。

### 🎯 わかりやすいフォーカスインジケーター
入力項目の左側に黄色い丸を表示し、現在の入力位置を明確に表示します。

### ⚡ ショートカットキー対応
慣れると高速で入力可能なショートカットキーを全ボタンに用意しています。

### 🔒 完全オフライン動作
外部アクセスは一切なし。銀行連携はありませんが、個人情報が安全です。

### 💾 データの再利用
一度登録した商品データなどを再利用することで、入力時間を短縮できます。

---

## 📋 動作環境

### 対応OS

| プラットフォーム | アーキテクチャ | 対応状況 |
|------------------|----------------|----------|
| 🐧 Linux | x64 | ✅ 対応 |
| 🪟 Windows | x64 | ✅ 対応 |

### 推奨フォント

**[0xProto](https://github.com/0xType/0xProto)** - 文字認識しやすいプログラミングフォント

- **Linux**: 0xProtoのインストールを推奨
- **Windows**: Noto Sans JPを使用（標準搭載）

---

## 📥 インストール方法

### Linux環境

#### 1. フォントのインストール（推奨）
```bash
# 0xProtoフォントをダウンロード＆インストール
# https://github.com/0xType/0xProto
```

#### 2. SQLite3ライブラリのインストール
```bash
sudo apt install libsqlite3-dev -y
```

#### 3. KakeiBonの解凍と実行
```bash
# ダウンロードしたアーカイブを解凍
mkdir -p /path/to
cd /path/to
tar xvf ./KakeiBon-linux-x64-[バージョン].tar.xz

# 実行
./KakeiBon
```

### Windows環境

#### 1. SQLite3 DLLのインストール
1. [Releaseページ](https://github.com/BonoJovi/KakeiBon/releases/)から `sqlite-dll-win-x64-[バージョン].zip` をダウンロード
2. 展開したDLLファイルを以下のいずれかに配置：
   - `C:\Windows\system32\`
   - 任意のフォルダ（環境変数PATHに追加）

#### 2. KakeiBonの解凍と実行
1. [Releaseページ](https://github.com/BonoJovi/KakeiBon/releases/)から `KakeiBon-win-x64-[バージョン].zip` をダウンロード
2. ZIPファイルを解凍
3. `KakeiBon.exe` を実行

---

## 🚀 初回セットアップ

### 初回起動時の流れ

初回起動時、データベースの作成に **数秒〜10秒程度** かかります。  
自動で管理者登録画面が開くまでお待ちください。

### セットアップ手順

1. **KakeiBon起動**  
   メインメニュー画面が表示されます

2. **管理者登録**  
   自動で開く管理者登録画面でユーザーを作成します

3. **管理者でログイン**  
   作成した管理者アカウントでログインします

4. **通常ユーザの作成**  
   ユーザ管理画面から日常使用するユーザを登録します

5. **ログアウト**  
   管理者からログアウトします

6. **通常ユーザでログイン**  
   日常使用するユーザでログインします

7. **費目のカスタマイズ（任意）**  
   費目管理で「食費」「交通費」等をカスタマイズできます

8. **入出金登録開始**  
   メインメニューから入出金を登録していきます

---

## 💡 使い方のコツ

### データ登録の効率化

最初は手間がかかりますが、データが蓄積すると入力が格段に速くなります：

✅ **商品データの再利用**  
一度登録した商品を選択するだけで入力完了

✅ **ショートカットキーの活用**  
ボタンのラベルに表記されているキーを使用して高速入力

✅ **サブウィンドウでの管理**  
各項目のボタンからデータを登録・管理できます

### 入力の流れ

```
入力項目のボタンを押下
    ↓
サブウィンドウでデータを登録
    ↓
呼び出し元画面で登録データを選択
    ↓
高速入力が可能に！
```

---

## 🔐 セキュリティとプライバシー

### データの安全性

| 項目 | 状態 | 説明 |
|------|------|------|
| 外部通信 | ❌ なし | 完全オフラインで動作 |
| 銀行連携 | ❌ 非対応 | 外部サービスとの連携なし |
| データ暗号化 | ❌ 現在未対応 | データベースは平文で保存* |

> **⚠️ 重要な注意事項**
> 
> データベースは現在暗号化されていません。  
> 個人を特定できる情報（氏名、住所、電話番号等）の登録は避けてください。  
> お買い物データなどは個人情報のかたまりですので、十分ご注意ください。
> 
> *将来的に暗号化を検討していますが、不具合対応時の利便性を考慮し、現時点では未実装です。

---

## 📝 プロジェクト情報

### 開発者
**Yoshihiro NAKAHARA**  
📧 連絡先: kakeibon-dev@zundou.org

### ライセンス
**MIT License**  
詳細は[LICENSE](LICENSE)ファイルをご覧ください

### 開発環境

| ツール | 説明 |
|--------|------|
| [Pop!_OS](https://system76.com/pop/) | Linux ディストリビューション |
| [Lazarus IDE](https://www.lazarus-ide.org/) | Free Pascal 統合開発環境 |
| [SQLite3](https://sqlite.org/) | データベース |
| [0xProto](https://github.com/0xType/0xProto) | 等幅フォント |

---

## 🐛 不具合報告・機能要望

不具合や機能改善のご要望は、[GitHubのIssue](https://github.com/BonoJovi/KakeiBon/issues)よりお気軽にご報告ください。

可能な限り対応いたします！

---

## ⚖️ 免責事項

KakeiBonを使用したことによる金銭等の損害について、開発者は一切責任を負わないものとします。

ただし、不具合や機能改善案等については報告いただければ、可能な限り対処いたします。

---

## 🔗 関連プロジェクト

### 次世代版

🚀 **[KakeiBonByRust](https://github.com/BonoJovi/KakeiBonByRust)**

Rust + Tauriによる高速・安全な次世代家計簿アプリ（開発中）

**主な改善点:**
- ⚡ より高速な動作
- 🔒 Rustによる高い安全性とメモリ安全性
- 🌐 完全な多言語対応（日本語・英語）
- ♿ 強化されたアクセシビリティ機能
- 🎨 モダンなUI/UX
- 🔐 データベース暗号化対応（予定）

開発は順調に進んでおり、できるだけ日々更新しています！

---

<div align="center">

**Made with ❤️ by Yoshihiro NAKAHARA**

[⬆ トップに戻る](#-kakeibon家計簿)

</div>
