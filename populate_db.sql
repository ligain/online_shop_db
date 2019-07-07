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
	('Pendant Lighting', 'pendant_lighting', (select id from second_level_category where name='Ceiling Lights'))


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


