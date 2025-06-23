-- Ready-to-drink (RTD) beverages or packaged drinks offered in the cafe
CREATE TABLE "drinks" (
    "id" INTEGER,
    "Product_name" TEXT NOT NULL UNIQUE,
    "cost_price" REAL NOT NULL, --per unit0
    "selling_price" REAL NOT NULL, --perunit
    "vendors_id" INTEGER NOT NULL,
    PRIMARY KEY("id"),
    FOREIGN KEY("vendors_id") REFERENCES "vendors"("id")
);

-- this cafe sources all of its drinks from difrent local vendors so we have a table for vendors
CREATE TABLE "vendors" (
    "id" INTEGER,
    "name" TEXT NOT NULL,
    "phone" INTEGER NOT NULL,
    "email" TEXT,
    "address" TEXT,
    "contact_person" TEXT,
    PRIMARY KEY("id")
);

--things we have in store
CREATE TABLE "inventory" (
    "id" INTEGER,
    "drink_id" INTEGER NOT NULL,
    "quantity_in_stock" INTEGER NOT NULL DEFAULT 0,
    PRIMARY KEY("id"),
    FOREIGN KEY("drink_id") REFERENCES "drinks"("id")
);

--the sales of the drinks are recorded here
CREATE TABLE "sales" (
    "id" INTEGER,
    "drink_id" INTEGER NOT NULL,
    "quantity_sold" INTEGER NOT NULL,
    "sale_time" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY("id"),
    FOREIGN KEY("drink_id") REFERENCES "drinks"("id")
);

--inventory purchases
CREATE TABLE "purchases" (
    "id" INTEGER,
    "drink_id" INTEGER NOT NULL,
    "vendors_id" INTEGER NOT NULL,
    "quantity_purchased" INTEGER NOT NULL,
    "purchase_date" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY("id"),
    FOREIGN KEY("drink_id") REFERENCES "drinks"("id"),
    FOREIGN KEY("vendors_id") REFERENCES "vendors"("id")
);

--a trigger to update on inventory after sale
CREATE TRIGGER "update_after_sale"
AFTER INSERT ON "sales"
FOR EACH ROW
BEGIN
    UPDATE "inventory"
    SET "quantity_in_stock" = "quantity_in_stock" - NEW."quantity_sold"
    WHERE "drink_id" = NEW."drink_id";
END;

--a trigger to update on inventory after adding drinks

CREATE TRIGGER "update_after_drinks"
AFTER INSERT ON "drinks"
FOR EACH ROW
BEGIN
    INSERT INTO "inventory" ("drink_id")
    VALUES (NEW.id);
END;

--a trigger to update on inventory after purchase

CREATE TRIGGER "update_after_purchase"
AFTER INSERT ON "purchases"
FOR EACH ROW
BEGIN
    UPDATE "inventory"
    SET "quantity_in_stock" = "quantity_in_stock" + NEW."quantity_purchased"
    WHERE "drink_id" = NEW."drink_id";
END;
                     `
