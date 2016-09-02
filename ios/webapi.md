# MarketAPI

## 商品一覧

サービスに登録されている商品をすべて返します。

```
GET /items.json
```

### レスポンス例

```json
[
  {
    "id": 1,
    "name": "料理包丁",
    "description": "材料を切るときに使う、料理包丁です。",
    "price": 1000,
    "created_at": "2016-08-03T02:57:41.000Z",
    "updated_at": "2016-08-03T02:57:41.000Z",
    "image_url": "https://localhost:3000/assets/item/cooking_ryouri_houchou-35bc5437f2f2c2dd6f32f9d6b4248ce3272ff9998349fd971c4948c43819bd52.png",
    "url": "https://localhost:3000/items/1.json"
  },
  {
    "id": 2,
    "name": "フライ返し・スパチュラ",
    "description": "料理をひっくり返すときに使う、フライ返しです。",
    "price": 1000,
    "created_at": "2016-08-03T02:57:41.000Z",
    "updated_at": "2016-08-03T02:57:41.000Z",
    "image_url": "https://localhost:3000/assets/item/cooking_spatula_turner-96f54804b6ad807f97f8f9bc0bf5af7043ed2b747e56f80f32896503c21367e5.png",
    "url": "https://localhost:3000/items/2.json"
  },
  ...
]
```

## おすすめ商品一覧

現在のおすすめ商品の一覧を返します。

```
GET /items/recommended.json
```

### レスポンス例

```json
[
  {
    "id": 1,
    "name": "料理包丁",
    "description": "材料を切るときに使う、料理包丁です。",
    "price": 1000,
    "created_at": "2016-08-03T02:57:41.000Z",
    "updated_at": "2016-08-03T02:57:41.000Z",
    "image_url": "https://localhost:3000/assets/item/cooking_ryouri_houchou-35bc5437f2f2c2dd6f32f9d6b4248ce3272ff9998349fd971c4948c43819bd52.png",
    "url": "https://localhost:3000/items/1.json"
  },
  {
    "id": 2,
    "name": "フライ返し・スパチュラ",
    "description": "料理をひっくり返すときに使う、フライ返しです。",
    "price": 1000,
    "created_at": "2016-08-03T02:57:41.000Z",
    "updated_at": "2016-08-03T02:57:41.000Z",
    "image_url": "https://localhost:3000/assets/item/cooking_spatula_turner-96f54804b6ad807f97f8f9bc0bf5af7043ed2b747e56f80f32896503c21367e5.png",
    "url": "https://localhost:3000/items/2.json"
  },
  ...
]
```

## 商品詳細

指定したIDの商品詳細情報を返します。

```
GET /items/:id.json
```

### レスポンス例

```json
{
  "id": 3,
  "name": "おたま・おたまじゃくし",
  "description": "スープすくうときに使う、おたまです。",
  "price": 1000,
  "created_at": "2016-07-08T08:56:28.459Z",
  "updated_at": "2016-07-08T08:56:28.459Z",
  "image_url": "https://localhost:3000/assets/item/cooking_otama-4f6dfaa88d55b172b0af4858f530b024d80a680c0279fe73eab1ef6fa57e5b7f.png"
}
```

## カテゴリ一覧

サービスに登録されているカテゴリの一覧を返します。

```
GET /categories.json
```

### レスポンス例

```json
[
  {
    "id": 1,
    "name": "調理器具",
    "image_url": "https://localhost:3000/assets/category/kabekake_cooking-d4ec3a8fd961c28d73b75e313963ef901411f5b800a1ca64e5af833736c47f4a.png",
    "category_items_url": "https://localhost:3000/categories/1/items.json"
  },
  {
    "id": 2,
    "name": "食器",
    "image_url": "https://localhost:3000/assets/category/syokki_kataduke-ab3cd2bfe080e6ac4bbed32fd9241f43e651d7db02a56e6455ad34e6e72967b9.png",
    "category_items_url": "https://localhost:3000/categories/2/items.json"
  },
  {
    "id": 3,
    "name": "食材",
    "image_url": "https://localhost:3000/assets/category/chisanchisyou_tokusanhin-1b123ad842c656c1dadd0cf64299f90330af9d6bc1ea46538dab84b69acc9617.png",
    "category_items_url": "https://localhost:3000/categories/3/items.json"
  }
]
```

## カテゴリ別商品一覧

指定したIDのカテゴリに属する商品一覧を返します。

```
GET /categories/:category_id/items.json
```

### レスポンス例

```json
[
  {
    "id": 1,
    "name": "料理包丁",
    "description": "材料を切るときに使う、料理包丁です。",
    "price": 1000,
    "image_url": "https://localhost:3000/assets/item/cooking_ryouri_houchou-35bc5437f2f2c2dd6f32f9d6b4248ce3272ff9998349fd971c4948c43819bd52.png",
    "url": "https://localhost:3000/items/1.json"
  },
  {
    "id": 2,
    "name": "フライ返し・スパチュラ",
    "description": "料理をひっくり返すときに使う、フライ返しです。",
    "price": 1000,
    "image_url": "https://localhost:3000/assets/item/cooking_spatula_turner-96f54804b6ad807f97f8f9bc0bf5af7043ed2b747e56f80f32896503c21367e5.png",
    "url": "https://localhost:3000/items/2.json"
  },
  ...
]
```

## 商品注文

指定した情報で商品の注文を行います。注文結果を返します。

```
POST /orders
```

### 入力

|*Name*|*Type*|*Description*|
|line_items|array|後述する lineitem の 配列|

lineitem

|*Name*|*Type*|*Description*|
|item_id|integer|商品のID|
|quantity|integer|商品の個数|

### リクエストボディ例

```json
{
  "line_items": [
    {
      "item_id": 8,
      "quantity": 1
    },
    {
      "item_id": 15,
      "quantity": 2
    }
  ]
}
```

### レスポンス例

```json
{
  "id": 5,
  "ordered_at": "2016-07-11T07:41:04.781Z",
  "total": 3000,
  "status": "checked_out",
  "created_at": "2016-07-11T07:41:04.782Z",
  "updated_at": "2016-07-11T07:41:04.802Z",
  "url": "https://localhost:3000/orders/5",
  "line_items": [
    {
      "quantity": 1,
      "subtotal": 1000,
      "item": {
        "id": 8,
        "name": "寸胴",
        "price": 1000,
        "url": "https://localhost:3000/items/8"
      }
    },
    {
      "quantity": 2,
      "subtotal": 2000,
      "item": {
        "id": 15,
        "name": "お皿",
        "price": 1000,
        "url": "https://localhost:3000/items/15"
      }
    }
  ]
}
```
