# Retrofitを使ったAPIアクセス

Androidに付属している標準ライブラリだけでも通信を行うことは可能ですが、並列アクセスのための制御やモデル変換のための仕組みづくりなど実装しないといけない部分がかなり多くなります。
今回の講義ではHTTP通信をより簡単にするためにRetrofitというライブラリを使用します。RetrofitはREST APIをJavaのInterfaceに定義することができるライブラリです。みなさんが作ったRailsアプリはREST APIを提供しているので、Retrofitととても相性がよいです。

なお、この節で説明している内容はほぼRetrofitの使用方法です。 詳しくは[Retrofit](http://square.github.io/retrofit/)のAPIドキュメントを参照してください。

Retrofitを使ってHTTP通信をするためには、まずInterfaceとアノテーションを使ってやり取りを定義します。
アノテーションでHTTPのメソッドとパスを定義し、引数がパラメーターに、返り値がレスポンスのBodyを変換したモデルになっています。

```java
public interface MarketService {

    @GET("items/recommended.json")
    Observable<List<Item>> recommendItems();

    @GET("items/{id}.json")
    Observable<Item> item(@Path("id") int id);

}
```

次にRetrofitのインスタンスを作成します。先程作ったインターフェースをRetofitインスタンスに渡すと、HTTPリクエストの作成からレスポンスの変換までの実装を返してくれます。

```java
         String ENDPOINT = "https://your-subdomain.herokuapp.com";
        Retrofit retrofit = new Retrofit.Builder()
                .baseUrl(ENDPOINT)
                .addCallAdapterFactory(RxJavaCallAdapterFactory.create())
                .addConverterFactory(GsonConverterFactory.create())
                .build();
        MarketService service = retrofit.create(MarketService.class);
```

Retrofitは他のライブラリと組み合わせて使うことができる設計になっています。
今回はレスポンスボディをJavaのクラスに変換するため[Gson](https://github.com/google/gson)を利用し、返り値をObservableにするために[RxJava](https://github.com/ReactiveX/RxJava)を利用するので、
それぞれのプラグインを追加しましょう。`app/build.gradle`にプラグインを追記してConverterとAdapterの設定をBuilderに追加します。

```gradle
dependencies {
    compile 'com.squareup.retrofit2:retrofit:2.1.0'
    compile 'com.squareup.retrofit2:converter-gson:2.0.2'
    compile 'com.squareup.retrofit2:adapter-rxjava:2.1.0'
}
```

```java
private final static String ENDPOINT = "https://your-subdomain.herokuapp.com";
Retrofit retrofit = new Retrofit.Builder()
      .baseUrl(ENDPOINT)
      .addConverterFactory(GsonConverterFactory.create())
      .addCallAdapterFactory(RxJavaCallAdapterFactory.create())
      .build();
MarketService service = retrofit.create(MarketService.class);
```

最後にモデルクラスの修正をします。レスポンスをJavaのクラスのフィールドにマッピングするためにモデルクラスにGsonのアノテーションを書きます。

```java
public class Item {

    @SerializedName("id")
    private int id;

    @SerializedName("name")
    private String name;

}
```

Retrofitの使い方は以上ですが、Retrofitのインスタンスはアプリケーション全体で使いまわしたいのでシングルトンになるように設計しましょう。
下の実装は一例なのでどのように実装していただいても問題無いです。

```java
public class MarketServiceHolder {

    private static MarketService INSTANCE;

    public static MarketService get() {
        if (INSTANCE == null) {
            INSTANCE = createInstance();
        }
        return INSTANCE;
    }

    private static MarketService createInstance() {
        return retrofit().create(MarketService.class);
    }

    private static Retrofit retrofit() {
        final String ENDPOINT = "https://ancient-bastion-22709.herokuapp.com";
        return new Retrofit.Builder()
                .baseUrl(ENDPOINT)
                .addConverterFactory(GsonConverterFactory.create())
                .addCallAdapterFactory(RxJavaCallAdapterFactory.create())
                .build();
    }
}
```

最後にAndroidManifest.xmlにインターネットのパーミッションを追加しましょう。

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
          package="your.package.name">

    <uses-permission android:name="android.permission.INTERNET"/>
    <application
            android:name=".application.MarketApplication"
...
```

APIアクセスは以下のような書き方で出来るようになりました。RecyclerViewにダミーデータを入れていたところをAPIアクセスに置き換えてみましょう。

```java
MarketServiceHolder.get()
        .recommendItems()
        .subscribeOn(Schedulers.io())
        .observeOn(AndroidSchedulers.mainThread())
        .subscribe(new Action1<List<Item>>() {
            @Override
            public void call(List<Item> items) {

            }
        });
```

### 画像読み込み

レスポンスに画像のURLも含まれているので、ロードしてImageViewに表示する実装をします。まずItemモデルに`image_url`をマッピングするフィールドを追加します。

```java
public class Item {

    @SerializedName("id")
    private int id;

    @SerializedName("name")
    private String name;

    @SerializedName("price")
    private int price;

    @SerializedName("image_url")
    private String imageUrl;
}
```

画像の読み込み、表示の部分は[Glide](https://github.com/bumptech/glide)というライブラリに任せます。まず`app/build.gradle`にGlideを追加しましょう。

```groovy
dependencies {
   // ...
    compile 'com.github.bumptech.glide:glide:3.7.0'
}
```

使い方はとても簡単なので、RecommendAdapterを例に簡単なサンプルを書きました。詳細は[ドキュメント](https://github.com/bumptech/glide/wiki)を読みましょう。

```java
    @Override
    public void onBindViewHolder(ViewHolder holder, int position) {
        final Item item = items.get(position);
        Context context = holder.binding.getRoot().getContext();
        holder.binding.itemName.setText(item.getName());
        holder.binding.itemPrice.setText(context.getString(R.string.price, item.getPrice()));
        Glide.with(context).load(item.getImageUrl()).into(holder.binding.itemThumbnail);
        // withでインスタンスを取得し、loadでURLを読み込んで、intoにImageViewを指定する。
    }
```
