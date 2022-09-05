/** 1. Create Materialized View for 2011 Shipments
 * 1) The result should contain the sum of the extended cost, the sum of the quantity, and the count of inventory transactions. 
 * 2) These calculated amounts should be summarized by the customer vendor key and the date key.
 * 3) The result should include only sales shipment transactions (transaction type 5) for the year 2011.
 * 4) The materialized view should not contain subtotals that are created by the CUBE and the ROLLUP keywords. 
 * 5) To make the peer assessment easier, you should name your materialized view “SalesByVendorDateKeyMV2011”.
 **/
create materialized view SalesByVendorDateKeyMV2011 as
select if2.custvendorkey, if2.datekey, sum(if2.extcost) sum_ext_cost, sum(quantity) sum_quantity, count(if2.inventorykey) invetory_transactions_count 
from inventory_fact if2
inner join date_dim dd 
	on if2.datekey = dd.datekey
where if2.transtypekey = 5
	and dd.calyear = 2011
group by 1, 2
order by 1, 2;

/** 2. Create Materialized View for 2012 Shipments
* 1) The result should contain the sum of the extended cost, the sum of the quantity, and the count of inventory transactions
* 2) These calculated amounts should be summarized by the customer vendor key and the date key.
* 3) The result should include only sales shipment transactions (transaction type 5) for the year 2012.
* 4) The materialized view should not contain subtotals that are created by the CUBE and the ROLLUP keywords.
* 5) To make the peer assessment easier, you should name your materialized view “SalesByVendorDateKeyMV2012”.
**/
create materialized view SalesByVendorDateKeyMV2012 as
select if2.custvendorkey, if2.datekey, sum(if2.extcost) sum_ext_cost, sum(quantity) sum_quantity, count(if2.inventorykey) invetory_transactions_count 
from inventory_fact if2
inner join date_dim dd 
	on if2.datekey = dd.datekey
where if2.transtypekey = 5
	and dd.calyear = 2012
group by 1, 2
order by 1, 2;

--DROP MATERIALIZED VIEW if exists SalesByVendorDateKeyMV2011
--REFRESH MATERIALIZED VIEW SalesByVendorDateKeyMV2012;

/** 3. Rewrite Query 1 of the Module 2 Assignment
Using the materialized views that you created in problems 1 and 2, you should rewrite query 1 from the module 2 assignment.
You should rewrite query 1 using the materialized views to replace the fact table and possibly dimension tables.
You should not use a CREATE VIEW statement in your solution. For ease of reference, here are the requirements for query 1 of the module 2 assignment.
Write an SQL statement to display the sum of the extended cost and the sum of the quantity.
The results should include data for shipments (transaction type 5) in calendar year 2011.
Summarize the result by calendar month and Address Category Code 1.
The result should include the full set of subtotals for every combination of grouped fields.
**/

select dd.calmonth,
	cvd.addrcatcode1,
	sum(mv.sum_ext_cost) total_cost,
	sum(mv.sum_quantity) total_quantity
from SalesByVendorDateKeyMV2011 mv
inner join date_dim dd
	on mv.datekey = dd.datekey
inner join cust_vendor_dim cvd 
	on mv.custvendorkey = cvd.custvendorkey
group by cube(dd.calmonth, cvd.addrcatcode1)
order by 1, 2;


/** GET COLUMNS FROM SPECIFIC TABLE
SELECT *
FROM information_schema.columns
WHERE table_schema = 'public'
AND table_name   = 'inventory_fact'
**/

/** 4. Rewrite Query 2 of the Module 2 Assignment
Using the materialized views that you created in problems 1 and 2, you should rewrite query 2 from the module 2 assignment.
After you submit the module 2 assignment, you will have access to the solution as part of the peer assessment.
You should rewrite query 2 using the materialized views to replace the fact table and possibly dimension tables.
You can use either the CUBE or GROUPING SETS operator in your solution. You should not use a CREATE VIEW statement in your solution.
For ease of reference, here are the requirements for query 2 of the module 2 assignment.
Write an SQL statement to display the sum of the extended cost and the number of inventory transactions.
The results should include data for shipments (transaction type 5) in calendar years 2011 and 2012.
Summarize the result by calendar quarter, customer zip code, and customer name.
The result should include the grouped columns and the full set of subtotals for every combination of grouped columns.
**/
select dd.calquarter, cvd.zip, cvd."name",
	sum(mv.sum_ext_cost) total_cost, sum(mv.invetory_transactions_count) total_counts
from (
select * from SalesByVendorDateKeyMV2011
union
select * from SalesByVendorDateKeyMV2012
) mv
inner join date_dim dd
	on mv.datekey = dd.datekey
inner join cust_vendor_dim cvd 
	on mv.custvendorkey = cvd.custvendorkey
group by cube(dd.calquarter, cvd.zip, cvd."name")
order by 1, 2, 3;
