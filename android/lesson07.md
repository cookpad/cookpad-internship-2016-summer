# Androidの非同期処理について

UIスレッドで時間のかかる処理をしてしまうと、画面が一時的に固まって体験が悪くなります。
そこで重い処理を実行する場合には、UIのレンダリングを担当するスレッドとは別のスレッドを新たに作成して、重い処理の結果をUIスレッドで受け取る（コールバックする）処理を書きます。
Android SDKが提供している非同期処理の仕組みは以下の様なものがあります。

* Thread + Handler (ワーカースレッドからUIスレッドへの処理をキューイングして実行してくれる)
* AsyncTask (スレッドプールの管理からUIスレッドへのコールバックまで非同期処理周りの処理を全て担当してくれる)
* AsyncTaskLoader (LoaderというActivityやFragmentが非同期でいい感じに値を受け取れる仕組みまで提供してくれるもの)

今回はこれらは利用しません。

# RxJava  

現在のAndroid開発では非同期処理を[RxJava](https://github.com/ReactiveX/RxJava)に任せること多くなってきています。
理由はいくつか挙げられます。

* クライアントアプリの実装が複雑になってきて、SDKが提供している非同期処理の仕組みだけでは実装するのが辛くなってきた
* モダンライブラリの多くがRxのインターフェースを用意していたり、非同期処理をRxに委譲しているものが増えてきている

RxJavaはとっつきにくい印象が持たれがちですが、生でスレッドを管理するより遥かに簡単に並列処理が記述できるので、今回を機会に挑戦してみましょう。
RxJavaについて詳しく語りたい気持ちはありますが、実践的に必要になる知識だけ紹介します。

## Observable

Observableはデータソースです。今回のアプリ開発では"APIのリクエスト"や"SQLiteへの問い合わせ"をObservableに包んで扱う予定です。
Observableに処理を包むことによって、内部が同期実行するか非同期で実行するか意識することなく扱うことが出来るようになります。

## Subscriber  

SubscriberはObservableが送ってくるイベントを受け取るためのコールバックインターフェースのことです。

## Scheduler

Schedulerは、Rx上で行われる処理をどのスレッドで実行するか指定するものです。スケジュールを指定するメソッドは2つあって、かなり重要なので覚えましょう。

* subscribeOn
  * メソッドチェーン全体の処理の実行スレッドが切り替わります。複数指定した場合は一番上のものが優先されます。指定する位置は関係がありません。
* observeOn
  * 自分より下に記述されたオペレータの実行スレッドが切り替わります。subscribeOnと異なり複数回呼び出すことが可能です。

Android開発では実行結果をUIスレッド受け取りたいことがほとんどですが、RxJavaだけでは実現できないのでRxAndroidも`app/build.gradle`に追加します。

```gradle
dependencies {
    //...
    compile 'io.reactivex:rxjava:1.1.7'
    compile 'io.reactivex:rxandroid:1.2.1'
}
```

よく使うScheduleも２つだけなので、これも覚えてしまいましょう。

* Schedulers.io()
  * 上限なしのスレッドプールからスレッドを割り当ててくれます。
* AndroidSchedulers.mainThread()
  * メインスレッド(UIスレッド)のスレッドを割り当ててくれます。

以下はRxJavaとRxAndroidを使った典型的なAPIリクエストの処理のサンプルコードですが、ここまでの理解を元にどう動くかが分かると思います。

```java
fetchrecommends() // オススメ一覧を取得するapi経由で取得するobservable
        .subscribeon(schedulers.io()) // 処理全体をワーカースレッドで実行する
        .observeon(androidschedulers.mainthread()) // ここより下の処理をuiスレッドで実行する。
        .subscribe(new action1<list<item>>() {
            @override
            public void call(list<item> items) {
                // uiスレッドで値を受け取ってrecyclerviewを更新する。
                adapter.addall(items);
                adapter.notifydatasetchanged();
            }
        }, new action1<throwable>() {
            @override
            public void call(throwable throwable) {
                // 例外時の処理を記述
            }
        }));
```
