# Clickイベントを定義する

RecyclerViewを使うことでリストを表示出来るようになったので、次はタップされた時のアクションを実装しましょう。

### View#setOnClickListener

Viewクラスには`setOnClickListener`というメソッドが用意されています。
このメソッドにOnClickListenerインターフェースを渡すことで、そのViewがタップされた場合の処理を実装できます。
先ほど実装したRecommendAdapterの`onBindViewHolder`を少し書き換えて、リストのアイテムをタップしたらトーストが表示されるように変更します。
[トースト](https://developer.android.com/guide/topics/ui/notifiers/toasts.html)とは、画面下部に表示される簡易ポップアップです。

```java
@Override
public void onBindViewHolder(ViewHolder holder, int position) {
    Item item = items.get(position);
    final Context context = holder.binding.getRoot().getContext();
    holder.binding.itemName.setText(item.getName());
    holder.binding.getRoot().setOnClickListener(new View.OnClickListener() {
      @Override
      public void onClick(View view) {
        Toast.makeText(MainActivity.this, "tapped", Toast.LENGTH_SHORT).show();
      }
    });
}
```

`OnClickListener`インターフェースは、上記のように引数に無名クラスを渡す形が一般的です。

### Activity内からClickイベントを定義する

上記のクリックイベントの実装では RecommendAdapterにタップ時の振る舞いを書いていました。
しかし、タップした時の振る舞いを`RecyclerView.Adapter`に記述してしまうのは本来の役割から考えると少し違和感があります。
そこでMainActivity側にタップ時の振る舞いを書けるように実装を書き換えましょう。以下のような実装を目指します。

```java
public class MainActivity extends AppCompatActivity {
  ActivityMainBinding binding;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    RecommendAdapter adapter = new RecommendAdapter();
    // こんな感じに書けるようにする
    adapter.setClickListener(new RecommendAdapter.ClickListener() {
      @Override
      public void onClickItem(Item item, View view) {
        Toast.makeText(context, "tapped", Toast.LENGTH_SHORT).show();
      }
    });
    binding = DataBindingUtil.setContentView(this, R.layout.activity_main);
    binding.recyclerView.setAdapter(adapter);
    binding.recyclerView.setLayoutManager(new LinearLayoutManager(getContext()));
    // ...
  }
}
```

まずActivityからセットするインターフェースを定義します。
そして、RecommendAdapterのインスタンス変数に`ClickListener`を追加して、setterも定義します。
これでAcitivtyからタップ時の実装を書けるようになりました。

```java
public class RecommendAdapter extends RecyclerView.Adapter<RecommendAdapter.ViewHolder> {

    public interface ClickListener {
        void onClickItem(Item item, View view);
    }

    private ClickListener listener;

    public void setClickListener(ClickListener listener) {
        this.listener = listener;
    }
}
// ...
```

次に、タップした時にこのlistenerが発火するようにしましょう。

```java
@Override
public void onBindViewHolder(ViewHolder holder, int position) {
  Item item = items.get(position);
  Context context = holder.binding.getRoot().getContext();
  holder.binding.itemName.setText(item.getName());
  holder.binding.getRoot().setOnClickListener(new View.OnClickListener() {
    @Override
    public void onClick(View view) {
      if(listener != null) {
        listener.onClickItem(item, view);
      }
    }
  });
}
```

これでリストのアイテムをタップすると、MainActivityで記述したトーストが表示されるようになりました。
listenerは初期化時にはnullなので、呼び出す際にはnull-checkを忘れずに書きましょう。
