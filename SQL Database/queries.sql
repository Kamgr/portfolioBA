--list drnks offered at cafe
SELECT * FROM drinks;

--inserting new drink in the cafe
INSERT INTO "drinks"("Product_name", "cost_price", "selling_price", "vendors_id" )
VALUES('organic apple juice', 2.99, 5.99, 1),
('coke', 2.99, 5.99, 2),
('water', 2.99, 5.99, 4),
('organic orange juice', 2.99, 5.99, 3),
('sparkling water', 2.99, 5.99, 1),
('fanta', 2.99, 5.99, 5);

--inserting new vendor
INSERT INTO "vendors"("name", "phone", "address", "contact_person")
VALUES('organic juice world', 902508, 'Euless, TX', 'Sammy');

--updating invetory with the new products
UPDATE "inventory"
SET "quantity_in_stock" = "quantity_in_stock" + 50
WHERE "drink_id"= (SELECT "id" FROM "drinks"
                    WHERE "Product_name"= 'coke');

-- list inventory items, that are about to be sold out
SELECT  drinks.Product_name , inventory.quantity_in_stock FROM drinks
JOIN inventory ON drinks.id = inventory.drink_id
WHERE "quantity_in_stock" < 5;

-- list  VENDOR information of inventory items, that are about to be sold out

SELECT  vendors.* , drinks.Product_name , inventory.quantity_in_stock FROM drinks
JOIN inventory ON drinks.id = inventory.drink_id
JOIN vendors ON drinks.vendors_id = vendors.id
WHERE "quantity_in_stock" < 5;

-- RECORD SALES
INSERT INTO "sales" ("drink_id", "quantity_sold")
VALUES (1, 5),
      (2, 5);

-- RECORD PROFIT OF 2025 by selling coke
SELECT
    SUM(sales.quantity_sold * drinks.selling_price) -
    SUM(sales.quantity_sold * drinks.cost_price) AS "profit"
FROM drinks
JOIN sales ON drinks.id = sales.drink_id
WHERE drinks.Product_name = 'coke'
  AND sales.sale_time LIKE '2025%';
