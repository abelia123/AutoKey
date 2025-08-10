# DirectionUI 8way - macOS版

マウスのサイドボタンを使用した8方向ジェスチャーショートカットツールのmacOS版です。

## 機能

Windows版と同じ8方向のジェスチャーでショートカットを実行：
- **上**: 全選択 (Cmd+A)
- **右上**: コピー (Cmd+C)
- **右**: 保存 (Cmd+S)
- **右下**: ペースト (Cmd+V)
- **下**: Enter
- **左下**: スクリーンショット (Cmd+Shift+4)
- **左**: 元に戻す (Cmd+Z)
- **左上**: 削除 (Delete)

## 必要な権限

macOSでは以下の権限設定が必要です：

1. **アクセシビリティ権限**
   - システム環境設定 > セキュリティとプライバシー > プライバシー > アクセシビリティ
   - TerminalまたはDirectionUI_8way_Mac.appを追加して許可

2. **画面収録権限**（スクリーンショット機能用）
   - システム環境設定 > セキュリティとプライバシー > プライバシー > 画面収録
   - アプリケーションを追加して許可

## インストール方法

### 方法1: ソースから実行

```bash
# 依存関係のインストール
pip3 install PyQt6 pynput pyautogui

# 実行
python3 direction_ui_8way_mac.py
```

### 方法2: アプリケーションのビルド

```bash
# ビルドスクリプトに実行権限を付与
chmod +x build_mac.sh

# ビルド実行
./build_mac.sh
```

ビルドが完了すると `dist/DirectionUI_8way_Mac.app` が作成されます。

## 自動起動設定

### 方法1: ログイン項目に追加

1. システム環境設定 > ユーザとグループ
2. 自分のユーザーアカウントを選択
3. 「ログイン項目」タブを開く
4. 「+」ボタンをクリックして `DirectionUI_8way_Mac.app` を追加

### 方法2: AppleScriptアプリケーションを使用

1. `direction_ui_startup.applescript` をScript Editorで開く
2. ファイル > 書き出す > フォーマット：アプリケーション
3. 作成したアプリケーションをログイン項目に追加

## トラブルシューティング

### マウスのサイドボタンが認識されない場合

一部のマウスではサイドボタンのマッピングが異なる場合があります。
`direction_ui_8way_mac.py` の以下の部分を編集してください：

```python
# 241行目付近
if button in [mouse.Button.x2, mouse.Button.button8, mouse.Button.button9]:
```

### 権限エラーが発生する場合

1. アプリケーションを一度終了
2. システム環境設定で権限を確認・付与
3. アプリケーションを再起動

### PyQt6のインストールエラー

Homebrew経由でPythonをインストールしている場合：

```bash
brew install python@3.11
python3.11 -m pip install PyQt6 pynput pyautogui
```

## Windows版との違い

- キーボードショートカット: `Ctrl` → `Cmd`
- フォント: Windows用フォント → macOS用フォント
- スタートアップ: VBScript → AppleScript
- 削除キー: `Backspace` → `Delete`
- スクリーンショット: `Win+Shift+S` → `Cmd+Shift+4`

## ライセンス

MIT License