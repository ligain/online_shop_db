with recursive grouped_categories as (
		select 
			product_category.id,
			product_category."name",
			cast(product_category."name" as varchar(512)) as categories
		from product_category 
		where product_category.parent_id is null
	union 
		select 
			pc.id,
			pc."name",
			cast(grouped_categories."categories" || '/' || pc."name" as varchar(512)) as categories
		from product_category as pc
			join grouped_categories on grouped_categories.id = pc.parent_id
)
select 
	product.id, 
	product."name",
	grouped_categories."name" as category_name,
	grouped_categories."categories" as categories,
	json_agg(json_build_object('name', "attribute"."name", 'value', product_attribute.value))
from product 
join grouped_categories 
	on grouped_categories.id = product.product_category_id
join product_attribute
	on product_attribute.product_id = product.id
join "attribute"
	on "attribute".id = product_attribute.attribute_id
group by product.id, product."name", category_name, categories
having grouped_categories."name" = 'Pendant Lighting';