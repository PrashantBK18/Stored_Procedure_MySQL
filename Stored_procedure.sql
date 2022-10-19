Create database Stored_Procedure;
select * from products;
select * from sales;

alter table sales
modify order_id int
not null auto_increment;

drop procedure if exists pr_by_products;

DELIMITER $$
create procedure pr_by_products(p_product_name varchar(40), p_quntity int)
begin
declare v_product_code varchar(20);
declare v_price float;
declare v_cnt int;

select count(1)
into v_cnt
from products
where product_name = p_product_name
and qty_remaining >= p_quntity;

if v_cnt > 0 then
	   select product_code, price
	   into v_product_code, v_price
	   from products
	   where Product_Name = p_product_name;

	   insert into sales (order_id,order_date, product_code, qty_ordered, sale_price)
	   values (cast(now()as date), v_product_code, p_quntity, (v_price * p_quntity));

	   update products
	   set qty_remaining = (qty_remaining - p_quntity),
	   qty_sold = (qty_sold + p_quntity)
	   where product_code = v_product_code;

       select 'Product sold';
else
       select 'Insufficient Quntity';
end if;

end $$

CALL pr_by_products('Ipad',6)