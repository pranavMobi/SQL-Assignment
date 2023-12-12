#1. Write a query to Display the product details (product_class_code, product_id, product_desc, product_price,) as per the following criteria and sort them in descending order of category: a. If the category is 2050, increase the price by 2000 b. If the category is 2051, increase the price by 500 c. If the category is 2052, increase the price by 600. Hint: Use case statement. no permanent change in table required. (60 ROWS) [NOTE: PRODUCT TABLE]

select product_class_code,product_id,Product_desc,
	case 
    		WHEN PRODUCT_CLASS_CODE=2050 then PRODUCT_PRICE+2000
		WHEN PRODUCT_CLASS_CODE=2051 then PRODUCT_PRICE+500
		WHEN PRODUCT_CLASS_CODE=2050 then PRODUCT_PRICE+600
		else PRODUCT_PRICE
	end as Updated_Price from PRODUCT order by product_class_code desc;


#2. Write a query to display (product_class_desc, product_id, product_desc, product_quantity_avail ) and Show inventory status of products as below as per their available quantity: a. For Electronics and Computer categories, if available quantity is <= 10, show 'Low stock', 11 <= qty <= 30, show 'In stock', >= 31, show 'Enough stock' b. For Stationery and Clothes categories, if qty <= 20, show 'Low stock', 21 <= qty <= 80, show 'In stock', >= 81, show 'Enough stock' c. Rest of the categories, if qty <= 15 – 'Low Stock', 16 <= qty <= 50 – 'In Stock', >= 51 – 'Enough stock' For all categories, if available quantity is 0, show 'Out of stock'. Hint: Use case statement. (60 ROWS) [NOTE: TABLES TO BE USED – product, product_class]

select pc.product_class_desc, p.product_id, p.product_desc, p.product_quantity_avail,
   Case   
		WHEN pc.product_class_desc IN ('Electronics', 'Computer') THEN
				CASE
					WHEN p.product_quantity_avail <= 10 THEN 'Low stock'
					WHEN p.product_quantity_avail BETWEEN 11 AND 30 THEN 'In stock'
					ELSE 'Enough stock'
				END
        WHEN pc.product_class_desc IN ('Stationery', 'Clothes') THEN
				CASE
					WHEN p.product_quantity_avail <= 20 THEN 'Low stock'
					WHEN p.product_quantity_avail BETWEEN 21 AND 80 THEN 'In stock'
					ELSE 'Enough stock'
				END
        ELSE   CASE
					WHEN p.product_quantity_avail <= 15 THEN 'Low stock'
					WHEN p.product_quantity_avail BETWEEN 16 AND 50 THEN 'In stock'
					ELSE 'Enough stock'
		 			END
    END AS inventory_status
FROM
    product p
    JOIN product_class pc ON p.product_class_code = pc.product_class_code;



#3. Write a query to Show the count of cities in all countries other than USA & MALAYSIA, with more than 1 city, in the descending order of CITIES. (2 rows) [NOTE: ADDRESS TABLE, Do not use Distinct]

select CITY,
    COUNT(CITY) AS CITY_COUNT
FROM
    ADDRESS
WHERE
    COUNTRY NOT IN ('USA', 'MALAYSIA')
GROUP by CITY
HAVING
count(city)>1
ORDER BY
    CITY DESC;



#4. Write a query to display the customer_id,customer full name ,city,pincode,and order details (order id, product class desc, product desc, subtotal(product_quantity * product_price)) for orders shipped to cities whose pin codes do not have any 0s in them. Sort the output on customer name and subtotal. (52 ROWS) [NOTE: TABLE TO BE USED - online_customer, address, order_header, order_items, product, product_class]

SELECT
    oc.CUSTOMER_ID,
    oc.CUSTOMER_FNAME || ' ' || oc.CUSTOMER_LNAME AS customer_full_name,
    a.CITY,
    a.PINCODE,
    oh.ORDER_ID,
    pc.PRODUCT_CLASS_DESC,
    p.PRODUCT_DESC,
    SUM(oi.PRODUCT_QUANTITY * p.PRODUCT_PRICE) AS subtotal
FROM
    ONLINE_CUSTOMER oc
JOIN
    ADDRESS a ON oc.ADDRESS_ID = a.ADDRESS_ID
JOIN
    ORDER_HEADER oh ON oc.CUSTOMER_ID = oh.CUSTOMER_ID
JOIN
    ORDER_ITEMS oi ON oh.ORDER_ID = oi.ORDER_ID
JOIN
    PRODUCT p ON oi.PRODUCT_ID = p.PRODUCT_ID
JOIN
    PRODUCT_CLASS pc ON p.PRODUCT_CLASS_CODE = pc.PRODUCT_CLASS_CODE
WHERE
    a.PINCODE NOT LIKE '%0%'
GROUP BY
    oc.CUSTOMER_ID, customer_full_name, a.CITY, a.PINCODE, oh.ORDER_ID, pc.PRODUCT_CLASS_DESC, p.PRODUCT_DESC
ORDER BY
    customer_full_name, subtotal;




#5. Write a Query to display product id,product description,totalquantity(sum(product quantity) for an item which has been bought maximum no. of times (Quantity Wise) along with product id 201. (USE SUB-QUERY) (1 ROW) [NOTE: ORDER_ITEMS TABLE, PRODUCT TABLE]

SELECT
    oi.PRODUCT_ID,
    p.PRODUCT_DESC,
    SUM(oi.PRODUCT_QUANTITY) AS total_quantity
FROM
    ORDER_ITEMS oi
JOIN
    PRODUCT p ON oi.PRODUCT_ID = p.PRODUCT_ID
WHERE
    oi.PRODUCT_ID = 201
GROUP BY
    oi.PRODUCT_ID, p.PRODUCT_DESC
ORDER BY
    total_quantity DESC
LIMIT 1;


#6. Write a query to display the customer_id,customer name, email and order details (order id, product desc,product qty, subtotal(product_quantity * product_price)) for all customers even if they have not ordered any item.(225 ROWS) [NOTE: TABLE TO BE USED - online_customer, order_header, order_items, product]

SELECT 
    oc.CUSTOMER_ID,
    oc.CUSTOMER_FNAME || ' ' || oc.CUSTOMER_LNAME AS customer_name,
    oc.CUSTOMER_EMAIL,
    oh.ORDER_ID,
    p.PRODUCT_DESC,
    oi.PRODUCT_QUANTITY,
    SUM(oi.PRODUCT_QUANTITY * p.PRODUCT_PRICE) AS subtotal
FROM
    ONLINE_CUSTOMER oc
LEFT JOIN
    ORDER_HEADER oh ON oc.CUSTOMER_ID = oh.CUSTOMER_ID
LEFT JOIN
    ORDER_ITEMS oi ON oh.ORDER_ID = oi.ORDER_ID
LEFT JOIN
    PRODUCT p ON oi.PRODUCT_ID = p.PRODUCT_ID
GROUP BY
    oc.CUSTOMER_ID, customer_name, oc.CUSTOMER_EMAIL, oh.ORDER_ID, p.PRODUCT_DESC, oi.PRODUCT_QUANTITY
ORDER BY
    oc.CUSTOMER_ID, subtotal;



#7. Write a query to display carton id, (len*width*height) as carton_vol and identify the optimum carton (carton with the least volume whose volume is greater than the total volume of all items (len * width * height * product_quantity)) for a given order whose order id is 10006, Assume all items of an order are packed into one single carton (box). (1 ROW) [NOTE: CARTON TABLE]

SELECT 
    CARTON_ID,B.CARTON_VOL
FROM
    (SELECT 
        CARTON_ID, (LEN * WIDTH * HEIGHT) CARTON_VOL
    FROM
        CARTON) B
WHERE
    B.CARTON_VOL > 
    (SELECT SUM(A.opt_vol) FROM (SELECT (LEN * WIDTH * HEIGHT * PRODUCT_QUANTITY) opt_vol  FROM  PRODUCT p, ORDER_ITEMS o   WHERE       p.PRODUCT_ID = o.PRODUCT_ID
                    AND o.ORDER_ID = 10006) A)
ORDER BY 2
limit 1;



#8. Write a query to display details (customer id,customer fullname,order id,product quantity) of customers who bought more than ten (i.e. total order qty) products per shipped order. (11 ROWS) [NOTE: TABLES TO BE USED - online_customer, order_header, order_items,]

SELECT
    oc.CUSTOMER_ID,
    CONCAT(oc.CUSTOMER_FNAME, ' ', oc.CUSTOMER_LNAME) AS customer_fullname,
    oh.ORDER_ID,
    SUM(oi.PRODUCT_QUANTITY) AS total_product_quantity
FROM
    ONLINE_CUSTOMER oc
JOIN
    ORDER_HEADER oh ON oc.CUSTOMER_ID = oh.CUSTOMER_ID
JOIN
    ORDER_ITEMS oi ON oh.ORDER_ID = oi.ORDER_ID
WHERE
    oh.ORDER_SHIPMENT_DATE IS NOT NULL
GROUP BY
    oc.CUSTOMER_ID, customer_fullname, oh.ORDER_ID
    total_product_quantity > 10;



#9. Write a query to display the order_id, customer id and customer full name of customers along with (product_quantity) as total quantity of products shipped for order ids > 10060. (6 ROWS) [NOTE: TABLES TO BE USED - online_customer, order_header, order_items]

select			
    oh.ORDER_ID,
    oc.CUSTOMER_ID,
    Concat(oc.CUSTOMER_FNAME, ' ', oc.CUSTOMER_LNAME) AS customer_fullname,
    Sum(oi.PRODUCT_QUANTITY) AS total_quantity
FROM
    ONLINE_CUSTOMER oc
JOIN
    ORDER_HEADER oh ON oc.CUSTOMER_ID = oh.CUSTOMER_ID
JOIN
    ORDER_ITEMS oi ON oh.ORDER_ID = oi.ORDER_ID
WHERE
    oh.ORDER_ID > 10060
GROUP BY
    oh.ORDER_ID, oc.CUSTOMER_ID;



#10. Write a query to display product class description ,total quantity (sum(product_quantity),Total value (product_quantity * product price) and show which class of products have been shipped highest(Quantity) to countries outside India other than USA? Also show the total value of those items. (1 ROWS)[NOTE:PRODUCT TABLE,ADDRESS TABLE,ONLINE_CUSTOMER TABLE,ORDER_HEADER TABLE,ORDER_ITEMS TABLE,PRODUCT_CLASS TABLE]
  SELECT  SUB.PRODUCT_CLASS_DESC,
(SUB.TOTAL_QUANTITY * SUB.PRODUCT_PRICE) AS TOTAL_VALUE,
SUB.TOTAL_QUANTITY AS TOTAL_QUANTITY

FROM

(SELECT 
PC.PRODUCT_CLASS_DESC,
P.PRODUCT_PRICE,
SUM(OI.PRODUCT_QUANTITY) AS TOTAL_QUANTITY
FROM PRODUCT_CLASS PC
INNER JOIN PRODUCT P
ON PC.PRODUCT_CLASS_CODE = P.PRODUCT_CLASS_CODE
INNER JOIN ORDER_ITEMS OI
ON P.PRODUCT_ID = OI.PRODUCT_ID
INNER JOIN ORDER_HEADER OH
ON OI.ORDER_ID = OH.ORDER_ID
INNER JOIN ONLINE_CUSTOMER C
ON OH.CUSTOMER_ID = C.CUSTOMER_ID
INNER JOIN ADDRESS A
ON C.ADDRESS_ID = A.ADDRESS_ID

WHERE A.COUNTRY NOT IN ('India','USA')
AND OH.ORDER_STATUS = 'Shipped'

GROUP BY 1,2) SUB


ORDER BY SUB.TOTAL_QUANTITY DESC
LIMIT 1;

