# RecyclerViewでリストを作る

Androidでリストを表示する場合いくつかの手段がありますが、今回はRecyclerViewを利用しましょう。  
RecyclerViewは、次の5つの要素で構成されます。

* RecyclerView (View本体)
* セルのレイアウトを定義するXMLファイル
* modelクラス(表示するデータ構造を持つクラス)
* RecyclerView.Adapter(modelの情報をviewにbindする役割)
* LayoutManager(一つ一つのセルをどう配置するか決める役割)

modelクラスの情報は最終的にはAPIから取得しますが、とりあえずダミーのデータを表示させることを目指しましょう。

RecyclerViewはサポートライブラリとして提供されているので、`app/build.gradle`に追加しておきます。

```groovy
buildscript {
    ext {
        supportLibraryVersion = '24.0.0'
    }
}

dependencies {
  compile "com.android.support:appcompat-v7:$supportLibraryVersion"
  compile "com.android.support:recyclerview-v7:$supportLibraryVersion"
}
```

(サポートライブラリはバージョンを揃えて使われることを想定されているので、バージョンは定数として管理しましょう。)

レイアウトファイルにRecyclerViewを追加します。
`res>layout>activity_main`を次のように書き換えましょう。

```xml
<?xml version="1.0" encoding="utf-8"?>
<layout
        xmlns:android="http://schemas.android.com/apk/res/android">
    <LinearLayout
            android:orientation="vertical"
            android:layout_width="match_parent"
            android:layout_height="match_parent">
        <android.support.v7.widget.RecyclerView
                android:id="@+id/recycler_view"
                android:layout_width="match_parent"
                android:layout_height="match_parent"/>
    </LinearLayout>
</layout>
```

次にセルのレイアウトファイルを新規に追加します。`main>res>layout` のフォルダを二本指クリックして`New>Layout resource file`を選択して作成しましょう。

```xml
<?xml version="1.0" encoding="utf-8"?>
<layout
        xmlns:android="http://schemas.android.com/apk/res/android"
        xmlns:tool="http://schemas.android.com/tools">
    <LinearLayout
            android:orientation="horizontal"
            android:gravity="center_vertical"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content">
        <ImageView
                android:id="@+id/item_thumbnail"
                android:src="@mipmap/ic_launcher"
                android:layout_margin="10dp"
                android:layout_width="60dp"
                android:layout_height="60dp"/>
        <TextView
                android:id="@+id/item_name"
                tool:text="オレンジジュース"
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"/>
    </LinearLayout>
</layout>
```

このタイミングでビルドを行うとDataBindingのクラスが自動で生成されます。

次にモデルクラスを作ります。 `main>model`というパッケージに`Item`クラスを作りましょう。

```java
public class Item {
    private int id;

    private String name;

    private int price;

    public Item(int id, String name, int price) {
      this.id = id;
      this.name = name;
      this.price = price;
    }

    public int getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public int getPrice() {
        return price;
    }
}
```

次にAdapterクラスを作ります。  
Adapterは、次の役割を担っています。

* セルをどのように描画するか決める
* いくつセルが存在するか把握する
* 効率的にインスタンスを使いまわして高速なセルの描画を可能にする

まず新しいクラスを作ってみましょう。`main>adapter`というパッケージを作って`RecommendAdapter`というクラスを作りましょう。

```java
public class RecommendAdapter {

}
```

次に内部クラスとしてViewHolderクラスを作りましょう。

```java
public class RecommendAdapter {

  public static class ViewHolder extends RecyclerView.ViewHolder {

    private CellRecommendBinding binding;

    public ViewHolder(View itemView) {
        super(itemView);
        binding = DataBindingUtil.bind(itemView);
    }
  }
}
```

ViewHolderはfindViewByIdの結果をキャッシュすることで、スクロールをスムーズにする役割があります。

RecommendAdapterを`RecyclerView.Adapter`を継承しましょう。
`RecyclerView.Adapter`は、３つのメソッドをOverrideする必要あります。

### onCreateViewHolder(ViewGroup parent, int viewType)

onCreateViewHolderでは、Viewインスタンスを生成してViewHolderインスタンスを返す実装を書きましょう。
`LayoutInflater`はxmlで定義したレイアウトファイルからViewのインスタンスを生成することが出来ます。

### onBindViewHolder(ViewHolder holder, int position)

`onCreateViewHolder`で生成されたViewHolderインスタンスを受け取って、モデルの情報をマッピングする実装を書きましょう。

### getItemCount()

表示するアイテムがいくつあるかを返す実装を書きます。今回の場合 `items.size()`を返せば問題無いでしょう。

```java
public class RecommendAdapter extends RecyclerView.Adapter< RecommendAdapter.ViewHolder> {
    private List<Item> items = new ArrayList<>();

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        LayoutInflater inflater = LayoutInflater.from(parent.getContext());
        View view = inflater.inflate(R.layout.cell_recommend, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(ViewHolder holder, int position) {
        Item item = items.get(position);
        holder.binding.itemName.setText(item.getName());
    }

    public void add(Item item){
      items.add(item);
    }

    @Override
    public int getItemCount() {
        return items.size();
    }

    public static class ViewHolder extends RecyclerView.ViewHolder {

      private CellRecommendBinding binding;

      public ViewHolder(View itemView) {
          super(itemView);
          binding = CellRecommendBinding.bind(itemView);
      }
    }
}
```

MainActivity側の実装を書き換えます。

```java
public class MainActivity extends AppCompatActivity {
  private ActivityMainBinding binding;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    RecommendAdapter adapter = new RecommendAdapter();
    binding = DataBindingUtil.setContentView(this, R.layout.activity_main);
    binding.recyclerView.setAdapter(adapter);
    binding.recyclerView.setLayoutManager(new LinearLayoutManager(this));

    // ダミーデータの追加
    adapter.add(new Item(0, "Orange", 1000));
    adapter.add(new Item(1, "Apple", 1000));
    adapter.add(new Item(2, "Banana", 1000));
    // RecommendAdapterに更新イベントを送る
    adapter.notifyDataSetChanged();
  }
}
```
