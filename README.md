# フリマアプリ データベース設計

## 概要
フリマアプリの主要機能であるユーザー管理、商品出品、商品購入をサポートするためのデータベース設計を記述します。

## テーブル定義

### users テーブル

| カラム名            | 型          | 制約                                 |
| :------------------ | :---------- | :----------------------------------- |
| `id`                | `BIGINT`    | `PRIMARY KEY`, `NOT NULL`, `AUTO_INCREMENT` |
| `nickname`          | `VARCHAR(255)` | `NOT NULL`                           |
| `email`             | `VARCHAR(255)` | `NOT NULL`, `UNIQUE`                 |
| `encrypted_password` | `VARCHAR(255)` | `NOT NULL`                           |
| `first_name`        | `VARCHAR(255)` | `NOT NULL`                           |
| `last_name`         | `VARCHAR(255)` | `NOT NULL`                           |
| `first_name_kana`   | `VARCHAR(255)` | `NOT NULL`                           |
| `last_name_kana`    | `VARCHAR(255)` | `NOT NULL`                           |
| `birth_date`        | `DATE`      | `NOT NULL`                           |
| `created_at`        | `DATETIME`  | `NOT NULL`                           |
| `updated_at`        | `DATETIME`  | `NOT NULL`                           |

### items テーブル

| カラム名          | 型          | 制約                                 |
| :---------------- | :---------- | :----------------------------------- |
| `id`              | `BIGINT`    | `PRIMARY KEY`, `NOT NULL`, `AUTO_INCREMENT` |
| `item_name`       | `VARCHAR(255)` | `NOT NULL`                           |
| `description`     | `TEXT`      | `NOT NULL`                           |
| `category_id`     | `INTEGER`   | `NOT NULL`, `FOREIGN KEY`            |
| `condition_id`    | `INTEGER`   | `NOT NULL`, `FOREIGN KEY`            |
| `shipping_fee_id` | `INTEGER`   | `NOT NULL`, `FOREIGN KEY`            |
| `prefecture_id`   | `INTEGER`   | `NOT NULL`, `FOREIGN KEY`            |
| `shipping_day_id` | `INTEGER`   | `NOT NULL`, `FOREIGN KEY`            |
| `price`           | `INTEGER`   | `NOT NULL`, `>300, <9,999,999`      |
| `user_id`         | `BIGINT`    | `NOT NULL`, `FOREIGN KEY`            |
| `created_at`      | `DATETIME`  | `NOT NULL`                           |
| `updated_at`      | `DATETIME`  | `NOT NULL`                           |
| `image`           | (Active Storageで管理) |                              |

### orders テーブル

| カラム名     | 型          | 制約                                 |
| :----------- | :---------- | :----------------------------------- |
| `id`         | `BIGINT`    | `PRIMARY KEY`, `NOT NULL`, `AUTO_INCREMENT` |
| `user_id`    | `BIGINT`    | `NOT NULL`, `FOREIGN KEY`            |
| `item_id`    | `BIGINT`    | `NOT NULL`, `FOREIGN KEY`, `UNIQUE`  |
| `created_at` | `DATETIME`  | `NOT NULL`                           |
| `updated_at` | `DATETIME`  | `NOT NULL`                           |

### addresses テーブル

| カラム名          | 型          | 制約                                 |
| :---------------- | :---------- | :----------------------------------- |
| `id`              | `BIGINT`    | `PRIMARY KEY`, `NOT NULL`, `AUTO_INCREMENT` |
| `post_code`       | `VARCHAR(255)` | `NOT NULL`                           |
| `prefecture_id`   | `INTEGER`   | `NOT NULL`, `FOREIGN KEY`            |
| `city`            | `VARCHAR(255)` | `NOT NULL`                           |
| `block`           | `VARCHAR(255)` | `NOT NULL`                           |
| `building_name`   | `VARCHAR(255)` | `NULL` (任意項目)                    |
| `phone_number`    | `VARCHAR(255)` | `NOT NULL`                           |
| `order_id`        | `BIGINT`    | `NOT NULL`, `FOREIGN KEY`, `UNIQUE`  |
| `created_at`      | `DATETIME`  | `NOT NULL`                           |
| `updated_at`      | `DATETIME`  | `NOT NULL`                           |

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

### 4. `addresses` テーブル (新規)

* **`belongs_to :order`**
    * **関連性**: `多対1 (Many-to-One)`
    * **説明**: 一つの`配送先住所`は、一つの`購入履歴`に**属します**。