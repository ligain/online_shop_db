
# Schema documentation


## Table: `product`

### Description: 
All products in the online shop.


### Columns: 

| Column | Data type | Attributes | Default | Description |
| --- | --- | --- | --- | ---  |
| `id` | INT | PRIMARY, Not null |   |   |
| `name` | VARCHAR(100) |  |   | Product name  |
| `manufacturer_id` | INT | PRIMARY, Not null |   |  **foreign key** to column `id` on table `manufacturer`. |
| `additional_property_id` | INT | PRIMARY, Not null |   |  **foreign key** to column `id` on table `additional_property`. |
| `product_category_id` | INT | PRIMARY, Not null |   |  **foreign key** to column `id` on table `product_category`. |
| `amount` | INT |  | `0` |  If it equals to `0` product is not in sale |


### Indices: 

| Name | Columns | Type | Description |
| --- | --- | --- | --- |
| PRIMARY | `id`, `manufacturer_id`, `additional_property_id`, `product_category_id` | PRIMARY |   |
| fk_product_manufacturer1_idx | `manufacturer_id` | INDEX |   |
| fk_product_additional_property1_idx | `additional_property_id` | INDEX |   |
| fk_product_product_category1_idx | `product_category_id` | INDEX |   |


## Table: `product_category`

### Description: 
Categories for all product in the shop. They could be hierarchical. 


### Columns: 

| Column | Data type | Attributes | Default | Description |
| --- | --- | --- | --- | ---  |
| `id` | INT | PRIMARY, Not null |   |   |
| `name` | VARCHAR(100) |  |   | Name of category  |
| `slug` | VARCHAR(45) |  |   | Slug to be part of URL  |
| `parent_id` | INT |  |   | Id for parent category. If it equals to `NULL` a category is the top level  |


### Indices: 

| Name | Columns | Type | Description |
| --- | --- | --- | --- |
| PRIMARY | `id` | PRIMARY |   |


## Table: `manufacturer`

### Description: 



### Columns: 

| Column | Data type | Attributes | Default | Description |
| --- | --- | --- | --- | ---  |
| `id` | INT | PRIMARY, Not null |   |   |
| `fullname` | VARCHAR(255) |  |   | Full name of company  |
| `brand` | VARCHAR(100) |  |   | Brand name  |


### Indices: 

| Name | Columns | Type | Description |
| --- | --- | --- | --- |
| PRIMARY | `id` | PRIMARY |   |


## Table: `client`

### Description: 
Table with information of shop's customers.


### Columns: 

| Column | Data type | Attributes | Default | Description |
| --- | --- | --- | --- | ---  |
| `id` | INT | PRIMARY, Not null |   |   |
| `first_name` | VARCHAR(45) |  |   |   |
| `second_name` | VARCHAR(45) |  |   |   |
| `email` | VARCHAR(45) |  |   | `@` is mandatory symbol in the field  |
| `phone` | VARCHAR(45) |  |   | Should in format: 1-415-1234567 without `+` sign  |


### Indices: 

| Name | Columns | Type | Description |
| --- | --- | --- | --- |
| PRIMARY | `id` | PRIMARY |   |


## Table: `purchase`

### Description: 



### Columns: 

| Column | Data type | Attributes | Default | Description |
| --- | --- | --- | --- | ---  |
| `id` | INT | PRIMARY, Not null |   |   |
| `client_id` | INT | PRIMARY, Not null |   |  **foreign key** to column `id` on table `client`. |
| `created` | DATE |  |   |   |
| `modified` | DATE |  |   |   |
| `status` | SET |  | `'new'` |   |
| `payment_id` | INT | PRIMARY, Not null |   |  **foreign key** to column `id` on table `payment`. |
| `total` | INT |  |   |   |


### Indices: 

| Name | Columns | Type | Description |
| --- | --- | --- | --- |
| PRIMARY | `id`, `client_id`, `payment_id` | PRIMARY |   |
| fk_purchase_client1_idx | `client_id` | INDEX |   |
| fk_purchase_payment1_idx | `payment_id` | INDEX |   |


## Table: `payment`

### Description: 



### Columns: 

| Column | Data type | Attributes | Default | Description |
| --- | --- | --- | --- | ---  |
| `id` | INT | PRIMARY, Not null |   |   |
| `status` | ENUM |  | `'pending'` |   |
| `created` | DATE |  |   |   |
| `method` | VARCHAR(45) |  |   |   |


### Indices: 

| Name | Columns | Type | Description |
| --- | --- | --- | --- |
| PRIMARY | `id` | PRIMARY |   |


## Table: `additional_property`

### Description: 



### Columns: 

| Column | Data type | Attributes | Default | Description |
| --- | --- | --- | --- | ---  |
| `id` | INT | PRIMARY, Not null |   |   |
| `year` | VARCHAR(45) |  |   |   |
| `color` | VARCHAR(45) |  |   |   |


### Indices: 

| Name | Columns | Type | Description |
| --- | --- | --- | --- |
| PRIMARY | `id` | PRIMARY |   |


## Table: `price`

### Description: 



### Columns: 

| Column | Data type | Attributes | Default | Description |
| --- | --- | --- | --- | ---  |
| `id` | INT | PRIMARY, Not null |   |   |
| `product_id` | INT | PRIMARY, Not null |   |  **foreign key** to column `id` on table `product`. |
| `effective_date` | DATETIME |  |   |   |
| `value` | INT |  |   |   |
| `rebate` | FLOAT |  |   |   |


### Indices: 

| Name | Columns | Type | Description |
| --- | --- | --- | --- |
| PRIMARY | `id`, `product_id` | PRIMARY |   |
| fk_price_product1_idx | `product_id` | INDEX |   |


## Table: `purchase_product`

### Description: 



### Columns: 

| Column | Data type | Attributes | Default | Description |
| --- | --- | --- | --- | ---  |
| `purchase_id` | INT | PRIMARY, Not null |   |  **foreign key** to column `id` on table `purchase`. |
| `product_id` | INT | PRIMARY, Not null |   |  **foreign key** to column `id` on table `product`. |
| `price_id` | INT | PRIMARY, Not null |   |  **foreign key** to column `id` on table `price`. |


### Indices: 

| Name | Columns | Type | Description |
| --- | --- | --- | --- |
| PRIMARY | `purchase_id`, `product_id`, `price_id` | PRIMARY |   |
| fk_purchase_has_product_product1_idx | `product_id` | INDEX |   |
| fk_purchase_has_product_purchase1_idx | `purchase_id` | INDEX |   |
| fk_purchase_product_price1_idx | `price_id` | INDEX |   |


Generated by MySQL Workbench Model Documentation v1.0.0 - Copyright (c) 2015 Hieu Le