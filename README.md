
# Online shop DB

It's training model for online shop.
DB schema in the `schema/` directory

**init_db.sql** - DDL script to init DB structure

**populate_db.sql** - populates DB with demo data

**clear_db.sql** - clear all table but not remove them.

To connect to running DB container on the host machine, use following credentials:

Host: _localhost_

Port: _5433_

Database: _online_shop_

User: _docker_

Password: _docker_

## How to set up database
1) Install docker & docker-compose
```
$ docker --version
Docker version 17.03.2-ce, build f5ec1e2
$ docker-compose --version
docker-compose version 1.13.0, build 1719ceb
```
2) Clone a repository
```
$ git clone https://github.com/ligain/online_shop_db.git
```
3) Drill down a project directory
```
$ cd online_shop_db/
```
4) Run project
```
$ docker-compose up
```
To to stop a project use `docker-compose down` command.

## Transaction logic
### Add a new product
Before create a product you need to add records for manufacturer's (public.manufacturer) and product's category (`public.product_category`) tables related to a new product.

1) takes id from tables `public.manufacturer` and `public.product_category` to insert in product's table (`public.product`)
2) creates product record
3) add attributes to a product
4) creates price record for a product
```sql
-- Add product
begin;
    with product_id as (
        insert into public.product ("name", manufacturer_id, product_category_id, amount) values (
            'Product name',
            (select id from public.manufacturer where brand='Product Manufacturer' for update),
            (select id from public.product_category where "name"='Product category name' for update),
            -- Amount on a warehouse
            12
        ) returning id
    )
    -- Add product attributes
    insert into public.product_attribute (product_id, attribute_id, value) values (
        (select id from product_id),
        (select id from public."attribute" where "name"='Attribute 1' for update),
        'Attribute value 1'
    ), (
        (select id from product_id),
        (select id from public."attribute" where "name"='Attribute 2' for update),
        'Attribute value 2'
    ), (
        (select id from product_id),
        (select id from public."attribute" where "name"='Attribute 3' for update),
        'Attribute value 3'
    );

    -- Add product price
    insert into public.price (product_id, value, rebate) values (
        (select id from public.product where "name"='Product name' for update),
        -- Price in cents
        100,
        -- Rebate in %
        10
    );
commit;
```

### Add a new purchase
1) before creating a purchase it needs to be created payment transaction (`public.payment`) and also record with client info (`public.client`).
2) add a purchase record 
3) in a cart  (`public.purchase_product`) gets together data about product, price, amount in a purchase
4) calculates total sum of a purchase and inserts in a column `total` `public.purchase` table
How calculates a total sum:
Assume we have 2 products:
Product 1: 65.95$ and rebate - 9% 2 pics.
Product 2: 120.49$ and rebate 42% 1 pics.
```
2 * (65.95 - (65.95 * 0.09)) = 120.029$
1 * (120.49 - (120.49 * 0.42)) = 69.8842$
total: 189.9132$

2 * (6595 * 100 - (6595 * 9)) = 1200290 / 100 = 12002 cents
1 * (12049 * 100 - (12049 * 42)) = 698842 / 100 = 6988 cents
total: 1899132 / 100 = 18991 cents
```

```sql

-- Create a purchase
begin;
create temporary table temp_purchase_product (purchase_id int, price_id int, amount int) on commit drop;
with payment_id as (
    insert into public.payment (payment_method_id) values 
        ((select id from public.payment_method where "name"='Payment name')) returning id
), purchase_id as (
    insert into public.purchase (client_id, payment_id) values
        (
            (select id from public.client where email='Client email'),
            (select id from payment_id)
        ) returning id
), price_ids as (
    insert into public.purchase_product (purchase_id, product_id, price_id, amount) values
    (
        (select id from purchase_id),
        (select id from public.product where name='Product name'),
        (select id from public.price where product_id=(select id from public.product where name='Product name')),
        1
    ), (
        (select id from purchase_id),
        (select id from public.product where name='Product name'),
        (select id from public.price where product_id=(select id from public.product where name='Product name')),
        2
    ) returning purchase_id, price_id, amount
)
insert into temp_purchase_product select * from price_ids;

with total_price as (
    -- Calculate total price
    select 
        purchase_id, 
        round(sum((value * 100 - (value * rebate)) * amount) / 100)::int as total
    from temp_purchase_product 
    join public.price as p on temp_purchase_product.price_id = p.id 
    group by purchase_id
)
update public.purchase
set total=(select total from total_price)
where id=(select purchase_id from total_price);

commit;
```

### Edit a price for a product
Assume we have a product with id = 5 and we want to set a new price = 6596
1) for a current record (`public.price`) sets `effective_end_date` equal to current datetime
2) add a new price record with a price = 6596 without `effective_end_date`

```sql
begin;

update public.price 
set effective_end_date=now()
where product_id = 5 and effective_end_date is null;

insert into public.price (product_id, value) values
    (5, 6596);

commit;
```

## Backup
```
(host) $ docker ps
CONTAINER ID        IMAGE                COMMAND                  CREATED             STATUS              PORTS                    NAMES
b1051b9e2eaa        postgres:11-alpine   "docker-entrypoint..."   49 seconds ago      Up 48 seconds       0.0.0.0:5433->5432/tcp   online_shop_db_1_87ec5af1972a
(host) $ docker exec -t b1051b9e2eaa pg_dumpall -c -U docker > dump_online_shop.sql
```

## Restore
```
(host) $ docker ps
CONTAINER ID        IMAGE                COMMAND                  CREATED             STATUS              PORTS                    NAMES
b1051b9e2eaa        postgres:11-alpine   "docker-entrypoint..."   49 seconds ago      Up 48 seconds       0.0.0.0:5433->5432/tcp   online_shop_db_1_87ec5af1972a
(host) $ cat dump_online_shop.sql | docker exec -i b1051b9e2eaa psql -U docker -d online_shop
```

## Project Goals
The code is written for educational purposes.
