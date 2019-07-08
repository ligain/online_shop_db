-- Populate manufacturer table
insert into public.manufacturer (fullname, brand) values
	('Laurel Foundry Modern Farmhouse', 'Laurel Foundry'),
	('Lucide', 'Lucide'),
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
	insert into public.price (product_id, value) values (
		(select id from public.product where "name"='Chaim 3-Light Kitchen Island' for update),
		6499
	);
commit;
