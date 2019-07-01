
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
    CONSTRAINT fk_product_category_has_attribute_attribute1 FOREIGN KEY (attribute_id) REFERENCES "attribute"(id) DEFERRABLE INITIALLY DEFERRED
);

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

-- DROP TABLE public.product_attribute;
CREATE TABLE IF NOT EXISTS public.product_attribute (
    product_id int4 NOT NULL,
    attribute_id int4 NOT NULL,
    value varchar(45),
    UNIQUE (product_id, attribute_id),
    CONSTRAINT fk_product_has_attribute_product1 FOREIGN KEY (product_id) REFERENCES product(id) DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT fk_product_has_attribute_attribute1 FOREIGN KEY (attribute_id) REFERENCES "attribute"(id) DEFERRABLE INITIALLY DEFERRED
);

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


