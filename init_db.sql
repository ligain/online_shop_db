
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
    CONSTRAINT fk_product_manufacturer1 FOREIGN KEY (manufacturer_id) REFERENCES manufacturer(id) DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT fk_product_product_category1 FOREIGN KEY (product_category_id) REFERENCES product_category(id) DEFERRABLE INITIALLY DEFERRED
);

