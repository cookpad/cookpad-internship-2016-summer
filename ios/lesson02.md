# 講義2 クラスと Storyboard を関連付ける

最初の画面として *おすすめ商品一覧画面* を実装します。

iOS アプリの画面はいろいろな方法で実装することができますが、今回は以下の方針で実装します。

- 要素のレイアウトは Storyboard 上で行い、 AutoLayout を使う
- UITableView を使う
- UITableViewCell を継承したカスタムセルのクラスを作る

この回では、おすすめ商品一覧画面の ViewController クラスの作成と Storyboard への関連付けを行います。

## 画面例

![](./images/20160708095340_img20160708-8-t7lll6.png)


## 画面の処理を記述する ViewController クラスを作る

プロジェクトに `RecommendItemsViewController` クラスのファイルを追加します。
ViewController グループを右クリックし、 `New File...` を選択してファイルを追加します。

![](./images/20160720084953_img20160720-10-1xs8m6r.png)

テンプレートは Cocoa Touch Class を選択してください。

![](./images/20160720085214_img20160720-21-ro23pc.png)

以下の情報を入力してファイルを作成します。

- Class: RecommendItemsViewController
- Subclass of: UITableViewController
- Language: Swift

![](./images/20160720084925_img20160720-13-dcratj.png)

## TabBarController に新しい画面を追加する

`Main.Storyboard` ファイルを編集しておすすめ商品一覧画面の設定を行います。
`Main.Storyboard` の初期状態は以下のようになっています。

![](./images/20160720090624_img20160720-19-joj3hy.png)

`FirstView` と `SecondView` を消して新しく `TableViewController` を追加します。
プロジェクトに元から存在する *FirstViewController.swift* 、 *SecondViewController.swift* のファイルも削除してしまいましょう。

右ペインのリストから `Table View Controller` を選択して真ん中の領域にドラッグアンドドロップします。

![](./images/20160720091627_img20160720-16-n73ezt.png)

左にある Tab Bar Controller を Ctrl を押しながらクリックし、青い線を右の TableViewController に伸ばして離すと、画像の様なメニューが表示されるので `view controllers` を選択します。

![](./images/20160720091633_img20160720-16-158hexe.png)

うまくいくと以下の画像のように線で結ばれます。この操作を行うことで一つだけのタブを持ち TableViewController を表示するように設定することができました。

![](./images/20160720091356_img20160720-13-eekllo.png)

## TableViewController に RecommendItemsViewController クラスをひも付ける

追加した TableViewController を選択し、先ほどファイルを追加した RecommendItemsViewController クラスとひも付けます。
画面を選択後右ペインの項目を切り替えて、 Custom Class の項目を `RecommendItemsViewController` にします。

![](./images/20160720092258_img20160720-13-fdkdey.png)

設定した TableViewController を選択した状態で `Editor > Embed In > Navigation Controller` を選択すると選択した ViewController を NavigationController の中に入れることができます。

![](./images/20160720093549_img20160720-10-1xhz921.png)

ナビゲーションバーのタイトルも設定します。
ダブルクリックするとタイトルを入力できるので、ここでは "おすすめ" としておきましょう。

![](./images/20160720093806_img20160720-16-bwjxcm.png)

ここまで設定すると、以下の画像のようになります。

![](./images/20160720093422_img20160720-10-18jpynb.png)

ここまで設定できたら、ビルドしてアプリケーションを実行します。
空っぽのおすすめ商品一覧画面ができました。

![](./images/20160720093911_img20160720-13-12bn5uy.png)
