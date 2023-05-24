# Phoenix LiveView でチャットアプリを作ろう

ここでは`Phoenix LiveView`を使用してチャットアプリを作成します。

## ここで学べること

- LiveView用のルートの作成
- Liveの作成
- mount/3
- handle_event/3
- LiveViewのイベントを使用したDOMの操作
- Phoenix.PubSub
- Hook
- ユーザー認証の作成（LiveViewを使用しない認証）

## プロジェクトの作成

プロジェクトの作成をします。

```bash
$ mix phx.new chat_app
```

## 認証機能の追加

以下のコマンドで認証機能を簡単に追加できます。
今回はLiveViewは使用せずに追加します。

```bash
$ mix phx.gen.auth Accounts Account accounts
An authentication system can be created in two different ways:
- Using Phoenix.LiveView (default)
- Using Phoenix.Controller only
Do you want to create a LiveView based authentication system? [Yn] n
・・・
$ mix deps.get
$ mix ecto.migrate
```

## テーブルとスキーマの作成