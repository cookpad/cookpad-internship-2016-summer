# Activityの画面遷移

Activityの画面遷移は序盤で紹介したとおり`Intent`という仕組みを使ってActivityを切り替えることで実現します。

```java
Intent intent = new Intent(this, MainActivity.class);
startActivity(intent);
```

Activity間で値を渡したい場合はIntentに詰め込みます。

```java
// 遷移元のActivity
Inetnt intent = new Intent(this, MainActivity.class);
intent.putExtra("key1", "value1");
intent.putExtra("key2", "value2");
startActivity(intent);
```

```java
// 遷移先のActivity
@Override
protected void onCreate(Bundle savedInstanceState) {
  Intent intent = getIntent();
  if (intent != null) {
    String xxx = intent.getStringExtra("key1");
  }
}
```

なお、上記の実装は2つ懸念点があります。

* 遷移元と遷移先の両方のActivityにキーが存在しているため管理が難しい
* 遷移先のActivityがどのような値がIntentに詰まっていることを期待しているのか把握するのが難しい

これらを解決するために遷移先のActivityにstaticメソッドを作るのが一般的な作法です。

```java
public class ItemDetailActivity extends AppCompatActivity {
    public static String EXTRA_ITEM_ID = "extra_item_id";

    public static Intent createIntent(Context context, int itemId) {
        Intent intent = new Intent(context, ItemDetailActivity.class);
        intent.putExtra(EXTRA_ITEM_ID, itemId);
        return intent;
    }
    //...
}
```


# Fragmentの画面遷移

Fragmentの画面遷移は`FragmentTransaction`という特殊なクラスを通じて行います。
`FragmentTransaction`は`FragmentManager#beginTransaction`で取得でき、遷移を実行するには最後に`commit`が必要です。

```java
// Activity内部での処理を想定
FragmentTransaction transaction = getSupportFragmentManager().beginTransaction();
// Activity上のR.id.fragment_containerの領域をCategoryFragmentに置き換える
transaction.replace(R.id.fragment_container, new CategoryFragment());
transaction.commit();
```

Androidには戻るボタンがどの端末にもついていて、戻るボタンを押すことで一つ前のActivityに戻ることが出来ます。
これは画面遷移が行われる時に現在のActivityがスタックに積まれ、戻るボタンが押されるとスタックの先頭のActivityが再開されるためです。
一方でFragmentの遷移は通常スタックに積まれない方針なので、遷移後に元のFragmentに戻りたい場合は明示的にスタックに積む宣言が必要です。

```java
FragmentTransaction transaction = getSupportFragmentManager().beginTransaction();
transaction.replace(R.id.fragment_container, new CategoryFragment());
// Fragment用のスタックに積む(引数はオプショナルなのでnullで問題ありません)
transaction.addToBackStack(null);
transaction.commit();
```

Fragmentへの値の受け渡しは、`Fragment#setArguments`を経由して行います。

```java
CategoryFragment fragment = new CategoryFragment();
Bundle bundle = new Bundle();
bundle.putString("key", "value");
fragment.setArguments(bundle);
```

```java
// 受け取り側
public class CategoryFragment extends Fragment {
    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
      Bundle args = getArguments();
      String xxx = args.getString("key");
    }
}
```

FragmentもActivity同様にstaticメソッドを利用した値の受け渡しが一般的です。

```java
public class CategoryFragment extends Fragment {
  private static final String ARGS_CATEGORY_ID = "category_id";
  private String categoryId;

  public static CategoryFragment newInstance(String CategoryId) {
    CategoryFragment fragment = new CategoryFragment();
    Bundle bundle = new Bundle();
    bundle.putString(ARGS_CATEGORY_ID, categoryId);
    fragment.setArguments(bundle);
    return fragment;
  }

  @Override
  public void onActivityCreated(Bundle savedInstanceState) {
    Bundle args = getArguments();
    categoryId = args.getString(ARGS_CATEGORY_ID);
  }

}
```

上記のコードはStringを受け取るコンストラクタを定義することで、もっとシンプルに書けると思われるかもしれません。
しかし残念ながらFragmentを継承したクラスはデフォルトコンストラクタ以外のコンストラクタを利用する事が出来ません。
これはバックグラウンドにあるFragmentのインスタンスがメモリの都合で破棄と再生成されることが関係するのですが、再生成時にはデフォルトコンストラクタが呼ばれてしまう事が原因です。
これは[ドキュメント](https://developer.android.com/reference/android/app/Fragment.html)にもはっきり書かれています。

```
All subclasses of Fragment must include a public no-argument constructor.
The framework will often re-instantiate a fragment class when needed, in particular during state restore, and needs to be able to find this constructor to instantiate it.
If the no-argument constructor is not available, a runtime exception will occur in some cases during state restore.
```

