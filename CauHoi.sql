-- tim mon an gia cao nhat 
select * from menu where price = (select max(price) from menu);
-- lay ra teen khach hang co trang thai thanh toan
select customers.id , customers.name, orders.payment_status from customers join orders on customers.id = orders.customer_id
where orders.payment_status = 'paid';
-- function so luong mon an theo khach ma khach hang 
DELIMITER $$

create function get_total_ordered(id_customer INT)
returns VARCHAR(255)
DETERMINISTIC
begin
    DECLARE total_items INT;
    DECLARE customer_exists INT;

    select COUNT(*) into customer_exists from customers where id = id_customer;

    if customer_exists = 0 THEN
        return 'Khách hàng không tồn tại.';
    else

        select SUM(order_items.quantity) into total_items
        from orders
        join order_items ON orders.id = order_items.order_id
        where orders.customer_id = id_customer;

        if total_items IS NULL THEN
            return 'Khách hàng chưa gọi món nào.';
        else
            return total_items;
        end if;
    end if;
end $$

DELIMITER ;


select get_total_ordered(1);

-- procedure lay ten mon an theo nguyen lieu nha cung cap(truyen vao id ncc)
DELIMITER $$

create procedure get_menu_NL (IN id_sup INT)
begin 
    declare menu_count INT;
    declare supplier_exists INT;
    
	select count(*) into supplier_exists from suppliers where id = id_sup;

    if supplier_exists = 0 THEN
        select 'Nhà cung cấp không tồn tại.' AS message;
    else

		select count(menu.id) into menu_count
		from menu
		join menu_ingredients ON menu.id = menu_ingredients.menu_id
		join inventory ON menu_ingredients.inventory_id = inventory.id
		where inventory.supplier_id = id_sup;

		if menu_count = 0 then
			select 'Không có món ăn nào' AS message;
		else
			select menu.name 
			from menu
			join menu_ingredients ON menu.id = menu_ingredients.menu_id
			join inventory ON menu_ingredients.inventory_id = inventory.id
			where inventory.supplier_id = id_sup;
		end if;
	
    end if;
end $$

DELIMITER ;

call get_menu_NL(1);

-- lay ra don dat ban nhung chua den
select  reservations.id, customers.name, tables.table_number, reservations.reservation_date, reservations.status
from  reservations
join customers ON reservations.customer_id = customers.id
join tables ON reservations.table_id = tables.id
where reservations.status != 'confirmed';
