# アプリ内のデータの永続化する

Androidアプリ開発で端末内にデータを永続化する機構は二つあります。

* SharedPreference
* SQLite
* ファイルに書き込む

SharedPreferenceはAndroid独自の仕組みです。アプリの設定情報を保存するための仕組みでいわゆるkey-valueストアのインターフェースを提供します。裏側ではXMLで保存されます。
SQLiteは有名な軽量のデータベースなので、詳細は省略します。
今回は買い物カゴの状態を永続化させることが目的なので、データの保存先はSharedPreferenceよりSQLiteが向いています。

# Orma

[Orma](https://github.com/gfx/Android-Orma)は非常に高速に動作するSQLiteのORマッパーです。cookpadのAndroidアプリもOrmaを採用しています。
まず導入の準備をします。 プロジェクトルートの`build.gradle`を開きandroid-aptを追加しましょう。
aptとは、Javaのコードを自動生成してくれる仕組みのことで、Data Bindingでも使っています。こちらの記事に詳しい解説があります。  
[Androidでaptのライブラリを作るときの高速道路](http://qiita.com/rejasupotaro/items/b9b89f88348222b46708)

```diff
buildscript {
    repositories {
        jcenter()
    }
    dependencies {
        classpath 'com.android.tools.build:gradle:2.1.2'
+        classpath 'com.neenbedankt.gradle.plugins:android-apt:1.8'
    }
}
```

`app/build.gradle`のdependenciesにOrmaを追加しましょう。

```groovy
apply plugin: 'com.neenbedankt.android-apt'

dependencies {
    // ....
    apt 'com.github.gfx.android.orma:orma-processor:2.5.2'
    compile 'com.github.gfx.android.orma:orma:2.5.2'
}
```

次にSQLiteのテーブルを作ります。OrmaではJavaのクラスを使ってテーブルのスキーマを定義できます。

```java
@Table
public class CartItem {

    @PrimaryKey(autoincrement = true)
    public long id;

    @Column(indexed = true)
    public int itemId;

    @Column
    public String name;

    @Column
    public int price;

    @Column
    public int count;

    public CartItem() {
    }
}
```

ここまで書いたら一度ビルドを実行しましょう。 aptの機能でSQLiteを操作するクラスが作成されます。

Ormaは`OrmaDatabase`というインスタンスを通してSQLiteを操作しますが、Retrofitと同様にインスタンスはシングルトンとして扱いたいのでHolderクラスを作ります。

```java
public class OrmaHolder {

    static OrmaDatabase INSTANCE;

    public static OrmaDatabase get(Context context) {
        if (INSTANCE == null) {
            INSTANCE = createInstance(context);
        }
        return INSTANCE;
    }

    private static OrmaDatabase createInstance(Context context) {
        return OrmaDatabase.builder(context).build();
    }
}
```

SQLiteからレコードを取得してリスト表示したい場合の処理はこのような実装になります。

```java
OrmaHolder.get(context)
        .selectFromCartItem()
        .executeAsObservable()
        .subscribeOn(Schedulers.io())
        .observeOn(AndroidSchedulers.mainThread())
        .toList()
        .subscribe(new Action1<List<CartItem>>() {
            @Override
            public void call(List<CartItem> items) {
                adapter.addAll(items);
                adapter.notifyDataSetChanged();
            }
        });
```

SQLiteにレコードを追加したい場合はこのような感じです。

```java
Observable.fromAsync(new Action1<AsyncEmitter<CartItem>>() {
    @Override
    public void call(AsyncEmitter<CartItem> emitter) {
                CartItem cartItem = CartItem.createCartItem(item); // CartItemを何かしらの方法で作る
                orma.insertIntoCartItem(cartItem);
                emitter.onNext(cartItem);
                emitter.onCompleted();  
    }
}, AsyncEmitter.BackpressureMode.NONE)
.subscribeOn(Schedulers.io())
.observeOn(AndroidSchedulers.mainThread())
.subscribe(new Action1<CartItem>() {
    @Override
    public void call(CartItem item) {
        
    }
});

```
