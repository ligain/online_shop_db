-- Populate manufacturer table
insert into public.manufacturer (fullname, brand) values
	('Laurel Foundry Modern Farmhouse', 'Laurel Foundry'),
	('Lucide', 'Lucide'),
	('17 Stories', '17 Stories'),
	('Rosdorf Park', 'Rosdorf Park');


-- Populate product_category table
with parent_category as (
	insert into public.product_category ("name", slug, parent_id) values
		('Lighting', 'lighting', null) returning id
), second_level_category as (
	insert into public.product_category ("name", slug, parent_id) values
		('Ceiling Lights', 'ceiling_lights', (select id from parent_category)),
		('Outdoor Lighting', 'outdoor', (select id from parent_category)),
		('Floor Lamps', 'floor_lamps', (select id from parent_category)) returning id, "name"
)
insert into public.product_category ("name", slug, parent_id) values
	('Chandeliers', 'chandeliers', (select id from second_level_category where name='Ceiling Lights')),
	('Pendant Lighting', 'pendant_lighting', (select id from second_level_category where name='Ceiling Lights'));


-- Populate attribute table
insert into public."attribute" ("name") values
	('Product Type'),
	('Max Height'),
	('Min Height'),
	('Fixture'),
	('Number of Lights'),
	('Light Direction'),
	('Primary Material'),
	('Dimmable'),
	('Bulb Base'),
	('Maximum Wattage (per Bulb)'),
	('Cord Length'),
	('Overall Weight'),
	('Wire Length'),
	('Lighting Type'),
	('Assembly Required');


-- Populate product_category_attribute table
insert into public.product_category_attribute values (
	(select id from public.product_category where "name"='Pendant Lighting' for update), 
	(select id from public."attribute" where "name"='Light Direction' for update)
);

insert into public.product_category_attribute values (
	(select id from public.product_category where "name"='Floor Lamps' for update), 
	(select id from public."attribute" where "name"='Cord Length' for update)
);


-- Populate attribute_list_value table
insert into public.attribute_list_value (attribute_id, value) values (
	(select id from public."attribute" where "name"='Fixture' for update),
	'110cm H x 79cm W x 17.5cm D'
);

insert into public.attribute_list_value (attribute_id, value) values (
	(select id from public."attribute" where "name"='Overall Weight' for update),
	'0.932kg'
);

insert into public.attribute_list_value (attribute_id, value) values (
	(select id from public."attribute" where "name"='Wire Length' for update),
	'90cm'
);


-- Populate product table
begin;
	with product_id as (
		insert into public.product ("name", manufacturer_id, product_category_id, amount) values (
			'Chaim 3-Light Kitchen Island',
			(select id from public.manufacturer where brand='Laurel Foundry' for update),
			(select id from public.product_category where "name"='Pendant Lighting' for update),
			12
		) returning id
	)
	insert into public.product_attribute (product_id, attribute_id, value) values (
		(select id from product_id),
		(select id from public."attribute" where "name"='Wire Length' for update),
		'90cm'
	), (
		(select id from product_id),
		(select id from public."attribute" where "name"='Fixture' for update),
		'110cm H x 79cm W x 17.5cm D'
	), (
		(select id from product_id),
		(select id from public."attribute" where "name"='Overall Weight' for update),
		'0.932kg'
	);
	insert into public.price (product_id, value, rebate) values (
		(select id from public.product where "name"='Chaim 3-Light Kitchen Island' for update),
		4500,
		10
	);
commit;

begin;
	with product_id as (
		insert into public.product ("name", manufacturer_id, product_category_id, amount) values (
			'Claire Outdoor Sconce with PIR Sensor',
			(select id from public.manufacturer where brand='Lucide' for update),
			(select id from public.product_category where "name"='Outdoor Lighting' for update),
			7
		) returning id
	)
	insert into public.product_attribute (product_id, attribute_id, value) values (
		(select id from product_id),
		(select id from public."attribute" where "name"='Bulb Base' for update),
		'E27/Medium (Standard)'
	), (
		(select id from product_id),
		(select id from public."attribute" where "name"='Lighting Type' for update),
		'Outdoor Sconce'
	), (
		(select id from product_id),
		(select id from public."attribute" where "name"='Overall Weight' for update),
		'2.2kg'
	);
	insert into public.price (product_id, value) values (
		(select id from public.product where "name"='Claire Outdoor Sconce with PIR Sensor' for update),
		6499
	);
commit;

begin;
	with product_id as (
		insert into public.product ("name", manufacturer_id, product_category_id, amount) values (
			'Louise Chandelier',
			(select id from public.manufacturer where brand='Rosdorf Park' for update),
			(select id from public.product_category where "name"='Chandeliers' for update),
			17
		) returning id
	)
	insert into public.product_attribute (product_id, attribute_id, value) values (
		(select id from product_id),
		(select id from public."attribute" where "name"='Max Height' for update),
		'273cm'
	), (
		(select id from product_id),
		(select id from public."attribute" where "name"='Min Height' for update),
		'103cm'
	), (
		(select id from product_id),
		(select id from public."attribute" where "name"='Overall Weight' for update),
		'4.1kg'
	), (
		(select id from product_id),
		(select id from public."attribute" where "name"='Fixture' for update),
		'78cm W x 78cm D'
	);
	insert into public.price (product_id, value, rebate) values (
		(select id from public.product where "name"='Louise Chandelier' for update),
		21600,
		42
	);
commit;

begin;
	with product_id as (
		insert into public.product ("name", manufacturer_id, product_category_id, amount) values (
			'Warrensburg 147cm Tripod Floor Lamp',
			(select id from public.manufacturer where brand='17 Stories' for update),
			(select id from public.product_category where "name"='Floor Lamps' for update),
			1
		) returning id
	)
	insert into public.product_attribute (product_id, attribute_id, value) values (
		(select id from product_id),
		(select id from public."attribute" where "name"='Max Height' for update),
		'147cm'
	), (
		(select id from product_id),
		(select id from public."attribute" where "name"='Cord Length' for update),
		'180cm'
	), (
		(select id from product_id),
		(select id from public."attribute" where "name"='Overall Weight' for update),
		'3.7kg'
	);
	insert into public.price (product_id, value, rebate) values (
		(select id from public.product where "name"='Warrensburg 147cm Tripod Floor Lamp' for update),
		12049,
		42
	);
commit;

begin;
	with product_id as (
		insert into public.product ("name", manufacturer_id, product_category_id, amount) values (
			'Isla 1-Light Dome Pendant',
			(select id from public.manufacturer where brand='Lucide' for update),
			(select id from public.product_category where "name"='Pendant Lighting' for update),
			0
		) returning id
	)
	insert into public.product_attribute (product_id, attribute_id, value) values (
		(select id from product_id),
		(select id from public."attribute" where "name"='Max Height' for update),
		'122cm'
	), (
		(select id from product_id),
		(select id from public."attribute" where "name"='Min Height' for update),
		'32cm'
	), (
		(select id from product_id),
		(select id from public."attribute" where "name"='Fixture' for update),
		'22cm H x 29cm W x 29cm D'
	), (
		(select id from product_id),
		(select id from public."attribute" where "name"='Overall Weight' for update),
		'1kg'
	);
	insert into public.price (product_id, value, rebate) values (
		(select id from public.product where "name"='Isla 1-Light Dome Pendant' for update),
		6595,
		9
	);
commit;


-- Populate client table
insert into public.client (first_name, second_name, email, phone) values 
	('John', 'Doe', 'doe@mycomp.com', '1-415-1234567'),
	('Mark', 'Smith', 'mark@google.com', '18-678-1234567'),
	('William', 'Keller', 'william@keller.com', '18-678-1234567');


-- Populate payment_method table
insert into public.payment_method values 
	(default, 'PayPal'),
	(default, 'Stripe'),
	(default, 'Bitcoin');


-- Populate purchase table
begin;
create temporary table temp_purchase_product (purchase_id int, price_id int, amount int) on commit drop;
with payment_id as (
	insert into public.payment (payment_method_id) values 
		((select id from public.payment_method where "name"='Stripe')) returning id
), purchase_id as (
	insert into public.purchase (client_id, payment_id) values
		(
			(select id from public.client where email='doe@mycomp.com'),
			(select id from payment_id)
		) returning id
), price_ids as (
	insert into public.purchase_product (purchase_id, product_id, price_id, amount) values
	(
		(select id from purchase_id),
		(select id from public.product where name='Warrensburg 147cm Tripod Floor Lamp'),
		(select id from public.price where product_id=(select id from public.product where name='Warrensburg 147cm Tripod Floor Lamp')),
		1
	), (
		(select id from purchase_id),
		(select id from public.product where name='Isla 1-Light Dome Pendant'),
		(select id from public.price where product_id=(select id from public.product where name='Isla 1-Light Dome Pendant')),
		2
	) returning purchase_id, price_id, amount
)
insert into temp_purchase_product select * from price_ids;

with total_price as (
	select 
		purchase_id, 
		round(sum(value * 100 - (value * rebate)) / 100)::int as total
	from temp_purchase_product 
	join public.price as p on temp_purchase_product.price_id = p.id 
	group by purchase_id
)
update public.purchase
set total=(select total from total_price)
where id=(select purchase_id from total_price);

commit;


-- Change price
begin;

update public.price 
set effective_end_date=now()
where product_id = 5 and effective_end_date is null;

insert into public.price (product_id, value) values
	(5, 6596);

commit;
