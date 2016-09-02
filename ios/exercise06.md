# 発展課題2 カート内商品の永続化

カートの内容がアプリケーションを終了しても保持されるようにしてください。
永続化の方法は問いません。

アプリケーションの情報を保存するには NSUserDefaults, CoreData, 外部ライブラリでは Realm を使うなど様々な方法があります。

一番手軽なのは NSUserDefaults だと思いますが、NSUserDefaults でうまく実装できたら、Realm を使った実装も試してみてください。

- Realm - https://realm.io/docs/swift/latest/
