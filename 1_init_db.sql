
-- DROP TABLE public.manufacturer;
CREATE TABLE IF NOT EXISTS public.manufacturer (
    id serial NOT NULL,
    fullname varchar(255),
    brand varchar(100),
    PRIMARY KEY (id)
);

-- DROP TABLE public."attribute";
CREATE TABLE IF NOT EXISTS public."attribute" (
    id serial NOT NULL,
    name varchar(45),
    PRIMARY KEY (id)
);

-- DROP TABLE public.attribute_list_value;
CREATE TABLE IF NOT EXISTS public.attribute_list_value (
    attribute_id int4 NOT NULL,
    value varchar(45),
	CONSTRAINT fk_attribute_list_value_attribute1 FOREIGN KEY (attribute_id) REFERENCES attribute(id) DEFERRABLE INITIALLY DEFERRED
);

-- DROP TABLE public.product_category;
CREATE TABLE IF NOT EXISTS public.product_category (
    id serial NOT NULL,
    "name" varchar(100),
    "slug" varchar(45),
    parent_id int4,
    PRIMARY KEY (id)
);

-- DROP TABLE public.product_category_attribute;
CREATE TABLE IF NOT EXISTS public.product_category_attribute (
    product_category_id int4 NOT NULL,
    attribute_id int4 NOT NULL,
    UNIQUE (product_category_id, attribute_id),
    CONSTRAINT fk_product_category_has_attribute_product_category1 FOREIGN KEY (product_category_id) REFERENCES product_category(id) DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT fk_product_category_has_attribute_attribute1 FOREIGN KEY (attribute_id) REFERENCES "attribute"(id) DEFERRABLE INITIALLY deferred
);
CREATE INDEX fk_product_category_has_attribute_attribute1_idx ON public.product_category_attribute USING btree (product_category_id);
CREATE INDEX fk_product_category_has_attribute_product_category1_idx ON public.product_category_attribute USING btree (attribute_id);

-- DROP TABLE public.product;
CREATE TABLE IF NOT EXISTS public.product (
    id serial NOT NULL,
    "name" varchar(100) NOT NULL,
    amount int4 DEFAULT 0,
    manufacturer_id int4 NOT NULL,
    product_category_id int4 NOT NULL,
    PRIMARY KEY (id),
    CHECK (amount >= 0),
    CONSTRAINT fk_product_manufacturer1 FOREIGN KEY (manufacturer_id) REFERENCES manufacturer(id) DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT fk_product_product_category1 FOREIGN KEY (product_category_id) REFERENCES product_category(id) DEFERRABLE INITIALLY DEFERRED
);
CREATE INDEX fk_product_manufacturer1_idx ON public.product USING btree (manufacturer_id);
CREATE INDEX fk_product_product_category1_idx ON public.product USING btree (product_category_id);
CREATE INDEX name_product_idx ON public.product USING btree (name varchar_pattern_ops);

-- DROP TABLE public.product_attribute;
CREATE TABLE IF NOT EXISTS public.product_attribute (
    product_id int4 NOT NULL,
    attribute_id int4 NOT NULL,
    value varchar(45),
    UNIQUE (product_id, attribute_id),
    CONSTRAINT fk_product_has_attribute_product1 FOREIGN KEY (product_id) REFERENCES product(id) DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT fk_product_has_attribute_attribute1 FOREIGN KEY (attribute_id) REFERENCES "attribute"(id) DEFERRABLE INITIALLY DEFERRED
);
CREATE INDEX fk_product_has_attribute_attribute1_idx ON public.product_attribute USING btree (attribute_id);
CREATE INDEX fk_product_has_attribute_product1_idx ON public.product_attribute USING btree (product_id);

-- DROP TABLE public.price
CREATE TABLE IF NOT EXISTS public.price (
	id serial NOT NULL,
	product_id int4 NOT NULL,
	effective_start_date timestamp DEFAULT now(),
	effective_end_date timestamp,
	value int4 NOT NULL DEFAULT 0,
	rebate int4 NOT NULL DEFAULT 0,
	CHECK (value >= 0),
	CHECK (rebate >= 0),
	PRIMARY KEY(id),
	CONSTRAINT fk_price_product1 FOREIGN KEY (product_id) REFERENCES product(id) DEFERRABLE INITIALLY DEFERRED
);
CREATE INDEX fk_price_product1_idx ON public.price USING btree (product_id);

-- DROP TABLE public.client;
CREATE TABLE IF NOT EXISTS public.client (
    id serial NOT NULL,
    first_name varchar(100),
    second_name varchar(100),
    email varchar(100),
    phone varchar(100),
    PRIMARY KEY(id)
);
CREATE INDEX first_name_client_idx ON public.client USING btree (first_name varchar_pattern_ops);
CREATE INDEX second_name_client_idx ON public.client USING btree (second_name varchar_pattern_ops);

-- DROP TABLE public.payment_method;
CREATE TABLE IF NOT EXISTS public.payment_method (
    id serial NOT NULL,
    "name" varchar(45),
    PRIMARY KEY(id)
);

DROP TYPE IF EXISTS payment_status CASCADE;
CREATE TYPE payment_status AS ENUM('pending', 'done');

-- DROP TABLE public.payment;
CREATE TABLE IF NOT EXISTS public.payment (
	id serial NOT NULL,
	status payment_status DEFAULT 'pending',
	created timestamp DEFAULT now(),
	transaction_info text,
	payment_method_id int4 NOT NULL,
	PRIMARY KEY(id),
	CONSTRAINT fk_payment_payment_method1 FOREIGN KEY (payment_method_id) REFERENCES payment_method(id) DEFERRABLE INITIALLY DEFERRED
);
CREATE INDEX fk_payment_payment_method1_idx ON public.payment USING btree (payment_method_id);

DROP TYPE IF EXISTS purchase_status CASCADE;
CREATE TYPE purchase_status AS ENUM('new', 'paid', 'deliver', 'done', 'error');

-- DROP TABLE public.purchase;
CREATE TABLE IF NOT EXISTS public.purchase (
	id serial NOT NULL,
	client_id int4 NOT NULL,
	payment_id int4 NOT NULL,
	created timestamp DEFAULT now(),
	modified timestamp,
	status purchase_status DEFAULT 'new',
	total int4 NOT NULL DEFAULT 0,
	CHECK (total >= 0),
	PRIMARY KEY(id),
	CONSTRAINT fk_purchase_client1 FOREIGN KEY (client_id) REFERENCES client(id) DEFERRABLE INITIALLY DEFERRED,
	CONSTRAINT fk_purchase_payment1 FOREIGN KEY (payment_id) REFERENCES payment(id) DEFERRABLE INITIALLY DEFERRED
);
CREATE INDEX fk_purchase_client1_idx ON public.purchase USING btree (client_id);
CREATE INDEX fk_purchase_payment1_idx ON public.purchase USING btree (payment_id);

-- DROP TABLE public.purchase_product;
CREATE TABLE IF NOT EXISTS public.purchase_product (
	purchase_id int4 NOT NULL,
	product_id int4 NOT NULL,
	price_id int4 NOT NULL,
	amount int4 NOT NULL DEFAULT 0,
	CHECK (amount >= 0),
	CONSTRAINT fk_purchase_has_product_purchase1 FOREIGN KEY (purchase_id) REFERENCES purchase(id) DEFERRABLE INITIALLY DEFERRED,
	CONSTRAINT fk_purchase_has_product_product1 FOREIGN KEY (product_id) REFERENCES product(id) DEFERRABLE INITIALLY DEFERRED,
	CONSTRAINT fk_purchase_product_price1 FOREIGN KEY (price_id) REFERENCES price(id) DEFERRABLE INITIALLY DEFERRED
);
CREATE INDEX fk_purchase_has_product_product1_idx ON public.purchase_product USING btree (product_id);
CREATE INDEX fk_purchase_has_product_purchase1_idx ON public.purchase_product USING btree (purchase_id);
CREATE INDEX fk_purchase_product_price1_idx ON public.purchase_product USING btree (price_id);

