# フリマアプリ データベース設計

## 概要
フリマアプリの主要機能であるユーザー管理、商品出品、商品購入をサポートするためのデータベース設計を記述します。
配送先情報を管理する`addresses`テーブルを追加しました。

## ER図

## テーブル定義

### users テーブル

| カラム名            | 型       | 制約           |
| :------------------ | :------- | :------------- |
| `nickname`          | `string` | `null: false`  |
| `email`             | `string` | `null: false`, `unique: true` |
| `encrypted_password` | `string` | `null: false`  |
| `first_name`        | `string` | `null: false`  |
| `last_name`         | `string` | `null: false`  |
| `first_name_kana`   | `string` | `null: false`  |
| `last_name_kana`    | `string` | `null: false`  |
| `birth_date`        | `date`   | `null: false`  |

### items テーブル

| カラム名          | 型       | 制約           |
| :---------------- | :------- | :------------- |
| `item_name`       | `string` | `null: false`  |
| `description`     | `text`   | `null: false`  |
| `category_id`     | `integer`| `null: false`  |
| `condition_id`    | `integer`| `null: false`  |
| `shipping_fee_id` | `integer`| `null: false`  |
| `prefecture_id`   | `integer`| `null: false`  |
| `shipping_day_id` | `integer`| `null: false`  |
| `price`           | `integer`| `null: false`  |
| `user`            | `references` | `null: false`, `foreign_key: true` | 
| `image`           | (Active Storageで管理) | |

### orders テーブル

| カラム名     | 型       | 制約           |
| :----------- | :------- | :------------- |
| `user`       | `references` | `null: false`, `foreign_key: true` | 
| `item`       | `references` | `null: false`, `foreign_key: true` | 

### addresses テーブル

| カラム名       | 型       | 制約           |
| :------------- | :------- | :------------- |
| `post_code`    | `string` | `null: false`  |
| `prefecture_id`| `integer`| `null: false`  |
| `city`         | `string` | `null: false`  |
| `block`        | `string` | `null: false`  |
| `building_name`| `string` |                |
| `phone_number` | `string` | `null: false`  |
| `order`        | `references` | `null: false`, `foreign_key: true` | 

## アソシエーション（関連性）

フリマアプリのデータベースにおける主要な4つのテーブル（`users`, `items`, `orders`, `addresses`）は、以下のように関連付けられています。

### 1. `users` テーブル

* **`has_many :items`**
    * **関連性**: `1対多 (One-to-Many)`
    * **説明**: 一人の`ユーザー`は、複数の`商品`を**出品**することができます。

* **`has_many :orders`**
    * **関連性**: `1対多 (One-to-Many)`
    * **説明**: 一人の`ユーザー`は、複数の`商品`を**購入**することができます。

### 2. `items` テーブル

* **`belongs_to :user`**
    * **関連性**: `多対1 (Many-to-One)`
    * **説明**: 一つの`商品`は、必ず一人の`ユーザー`によって**出品**されます。

* **`has_one :order`**
    * **関連性**: `1対1 (One-to-One)`
    * **説明**: 一つの`商品`は、**一つの`購入履歴`にのみ紐づきます**。（商品が購入されると、その商品はそれ以上購入されないため）

### 3. `orders` テーブル

* **`belongs_to :user`**
    * **関連性**: `多対1 (Many-to-One)`
    * **説明**: 一つの`購入履歴`は、必ず一人の`ユーザー`によって**行われます**。

* **`belongs_to :item`**
    * **関連性**: `多対1 (Many-to-One)`
    * **説明**: 一つの`購入履歴`は、必ず一つの`商品`に**紐づきます**。

* **`has_one :address`**
    * **関連性**: `1対1 (One-to-One)`
    * **説明**: 一つの`購入履歴`には、一つの`配送先住所`が**紐づきます**。

### 4. `addresses` テーブル

* **`belongs_to :order`**
    * **関連性**: `多対1 (Many-to-One)`
    * **説明**: 一つの`配送先住所`は、一つの`購入履歴`に**属します**。