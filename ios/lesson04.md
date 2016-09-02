# 講義4 TableView によるリストの表示

セルの設定ができたので、このセルに商品の情報を表示します。

## Item モデルを作る

*Item.swift* を Model グループ下に作ります。ファイルテンプレートは *Swift File* を選択してください。
このファイルに以下のように記述して、Item 構造体を定義します。

```swift
import Foundation

struct Item {
    let id: Int
    let name: String
    let desc: String
    let price: Int
    let imageURL: NSURL
}
```

## ViewController で Item モデルの配列を作る

`RecommendItemsViewController` のメンバ変数 `items` を追加します。
ここに先ほど定義した Item モデルをいくつか要素として代入します。

```swift
class RecommendItemsViewController: UITableViewController {
	let items: [Item] = [
	    Item(id: 1, name: "おたま", desc: "おたまです", price: 100, imageURL: NSURL(string: "http://example.com")!),
	    Item(id: 2, name: "しゃもじ", desc: "しゃもじです", price: 200, imageURL: NSURL(string: "http://example.com")!),
	    Item(id: 3, name: "菜箸", desc: "菜箸です", price: 300, imageURL: NSURL(string: "http://example.com")!),
	]
	
	...
```

## TableView DataSource を実装する

`RecommendItemsViewController` の TableView へセルを表示するための実装を行います。
TableView へ要素を表示するには `UITableViewDataSource` プロトコルのメソッドを実装する必要があります。
今回実装すべきメソッドは、そのTableViewに表示するセルの数がいくつなのか返すメソッドとその表示するセルはどのようなものなのか、どのように設定するか定義するメソッドです。

`RecommendItemsViewController` に以下の2つのメソッドを実装します。

- func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
- func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell

以下の様なコードを *RecommendItemsViewController.swift* に追加してください。
テンプレートファイルからこのクラスのファイルを作成している場合は、コメントアウトされているものがあるのでそれを利用します。

`numberOfSectionsInTableView(tableView: UITableView) -> Int` の実装が残っている場合は削除してしまってかまいません。


```swift
override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
}

override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCellWithIdentifier("RecommendItemCell", forIndexPath: indexPath) as? RecommendItemCell else {
        fatalError("Invalid cell")
    }

    let item = items[indexPath.row]
    cell.update(withItem: item)

    return cell
}
```

`RecommendItemCell` クラスにも渡した Item モデルの値をラベルなどに設定するメソッド `update(withItem item: Item)` を実装します。

```swift
func update(withItem item: Item) {
    nameLabel.text = item.name
    priceLabel.text = "\(item.price)円"
    descriptionLabel.text = item.desc
}
```

画像は次の回で設定します。

ここまで実装してビルド、アプリケーションを実行すると3つの商品が表示されるはずです。
