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