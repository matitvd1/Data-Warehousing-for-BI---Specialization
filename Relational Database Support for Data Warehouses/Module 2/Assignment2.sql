/* 1) Sales Order Shipments by Month and Category Code1 
Write an SQL statement to display the sum of the extended cost and the sum of the quantity.
The results should include data for shipments (transaction type 5) in calendar year 2011.
Summarize the result by calendar month and Address Category Code 1. The result should include the grouped columns
and the full totals for every combination of grouped columns. Do not use the GROUPING SETS and UNION operators. */

select dd.calmonth,
	cvd.addrcatcode1,
	sum(if2.extcost) sum_extcost,
	sum(if2.quantity) sum_quantity
from inventory_fact if2
inner join date_dim dd
	on if2.datekey = dd.datekey
inner join cust_vendor_dim cvd 
	on if2.custvendorkey = cvd.custvendorkey 
where if2.transtypekey = 5
	and dd.calyear = 2011
group by cube(dd.calmonth, cvd.addrcatcode1)
order by 1, 2;

/* 2) Sales Order Shipments by Name, Zip, and Quarter 
Write an SQL statement to display the sum of the extended cost and the number of inventory transactions.
The results should include data for shipments (transaction type 5) in calendar years 2011 and 2012.
Summarize the result by calendar quarter, customer zip code, and customer name.
The result should include the grouped columns and full set of subtotals for every combination of grouped columns.
Do not use the CUBE and UNION operators. */

select dd.calquarter,
	cvd.zip,
	cvd."name",
	sum(if2.extcost) sum_extcost,
	count(if2.inventorykey) sum_inv_tr
from inventory_fact if2
inner join date_dim dd
	on if2.datekey = dd.datekey
inner join cust_vendor_dim cvd 
	on if2.custvendorkey = cvd.custvendorkey
where if2.transtypekey = 5
	and dd.calyear in (2011, 2012)
group by grouping sets ((dd.calquarter, cvd.zip, cvd."name"),(dd.calquarter , cvd.zip),
	(dd.calquarter, cvd."name"), (cvd.zip, cvd."name"), dd.calquarter, cvd.zip, cvd."name", ())
order by 1, 2, 3;

/* 3) Transfers by Company and Branch Plant
Write an SQL statement to display the sum of the extended cost and the sum of the quantity.
The results should include data for transfers (transaction type 2). Summarize the result by company name and branch plant name.
The result should include the grouped columns and a partial set of subtotals in order of the grouped columns
(company name and branch plant name).Transfer quantities by design should sum to zero across all companies so that
the grand total should be 0 for the sum of quantity and extended cost. Do not use the GROUPING SETS and UNION operators. */
select cd.companyname, bpd.bpname , sum(if2.extcost) sum_ext_cost, sum(if2.quantity) sum_quantity 
from inventory_fact if2
inner join branch_plant_dim bpd 
	on if2.branchplantkey = bpd.branchplantkey 
inner join company_dim cd
	on bpd.companykey = cd.companykey
where if2.transtypekey = 2
group by rollup(1, 2)
order by 1, 2;


/* 4) Inventory Transactions by Transaction Description, Company, and Branch Plant
Write an SQL statement to display the sum of the extended cost and the number of inventory transactions.
The results should include data for all transaction types. Summarize the result by transaction description,
company name, and branch plant name. The result should include the grouped columns and partial totals in order of
the grouped columns (transaction description, company name, and branch plant name). Do not use the ROLLUP and UNION operators. */
select ttd.transdescription, cd.companyname, bpd.bpname, sum(if2.extcost) sum_ext_cost, count(if2.inventorykey) num_transactions
from inventory_fact if2
join trans_type_dim ttd 
	on if2.transtypekey = ttd.transtypekey
inner join branch_plant_dim bpd 
	on if2.branchplantkey = bpd.branchplantkey 
inner join company_dim cd
	on bpd.companykey = cd.companykey
group by grouping sets ((ttd.transdescription, cd.companyname, bpd.bpname),
						(ttd.transdescription, cd.companyname),
						(ttd.transdescription), ())
order by 1, 2, 3;

/* 5) Adjustments by Part Number
Write an SQL statement to display the sum of the extended cost and the number of inventory transactions.
The results should include data for shipments (transaction type 5) in calendar years 2011 and 2012.
Summarize the result by calendar year, calendar quarter, and customer name. The result should show the grouped columns
and the normal set of group by results plus partial subtotals for year and quarter concatenated with customer name.
Do not use the GROUPING SETS and UNION operators. (Hint: see the partial ROLLUP example in lesson 5). */
select dd.calyear, dd.calquarter, cvd."name", sum(if2.extcost) sum_ext_cost, count(if2.inventorykey) num_transactions
from inventory_fact if2
inner join date_dim dd
	on if2.datekey = dd.datekey
inner join cust_vendor_dim cvd 
	on if2.custvendorkey = cvd.custvendorkey 
where if2.transtypekey = 5
	and dd.calyear in (2011, 2012)
group by rollup(1, 2), 3
order by 1, 2, 3;

/* 6) Rewrite Query 1 without CUBE, ROLLUP, or GROUPING SETS
Rewrite query 1 without the usage of the CUBE ROLLUP, or GROUPING SETS operators. In rewriting the query,
you should use NULL as the default value for each column. */
select dd.calmonth,	cvd.addrcatcode1, sum(if2.extcost) sum_extcost,	sum(if2.quantity) sum_quantity
from inventory_fact if2
inner join date_dim dd on if2.datekey = dd.datekey
inner join cust_vendor_dim cvd on if2.custvendorkey = cvd.custvendorkey 
where if2.transtypekey = 5 and dd.calyear = 2011
group by 1, 2
union
select dd.calmonth,	null, sum(if2.extcost) sum_extcost,	sum(if2.quantity) sum_quantity
from inventory_fact if2
inner join date_dim dd on if2.datekey = dd.datekey
inner join cust_vendor_dim cvd on if2.custvendorkey = cvd.custvendorkey 
where if2.transtypekey = 5 and dd.calyear = 2011
group by 1
union 
select null, cvd.addrcatcode1, sum(if2.extcost) sum_extcost, sum(if2.quantity) sum_quantity
from inventory_fact if2
inner join date_dim dd on if2.datekey = dd.datekey
inner join cust_vendor_dim cvd on if2.custvendorkey = cvd.custvendorkey 
where if2.transtypekey = 5 and dd.calyear = 2011
group by 2
union
select null, null, sum(if2.extcost) sum_extcost, sum(if2.quantity) sum_quantity
from inventory_fact if2
inner join date_dim dd on if2.datekey = dd.datekey
inner join cust_vendor_dim cvd on if2.custvendorkey = cvd.custvendorkey 
where if2.transtypekey = 5 and dd.calyear = 2011
order by 1, 2;

/* 7) Rewrite Query 3 without CUBE, ROLLUP, or GROUPING SETS
Rewrite query 3 without the usage of the CUBE, ROLLUP, or GROUPING SETS operators. In rewriting the query,
you should use NULL as the default value for each column. */
select cd.companyname, bpd.bpname , sum(if2.extcost) sum_ext_cost, sum(if2.quantity) sum_quantity 
from inventory_fact if2
inner join branch_plant_dim bpd on if2.branchplantkey = bpd.branchplantkey 
inner join company_dim cd on bpd.companykey = cd.companykey
where if2.transtypekey = 2
group by 1, 2
union
select cd.companyname, null, sum(if2.extcost) sum_ext_cost, sum(if2.quantity) sum_quantity 
from inventory_fact if2
inner join branch_plant_dim bpd on if2.branchplantkey = bpd.branchplantkey 
inner join company_dim cd on bpd.companykey = cd.companykey
where if2.transtypekey = 2
group by 1
union 
select cd.companyname, null, sum(if2.extcost) sum_ext_cost, sum(if2.quantity) sum_quantity 
from inventory_fact if2
inner join branch_plant_dim bpd on if2.branchplantkey = bpd.branchplantkey 
inner join company_dim cd on bpd.companykey = cd.companykey
where if2.transtypekey = 2
group by 1
union
select null, null, sum(if2.extcost) sum_ext_cost, sum(if2.quantity) sum_quantity 
from inventory_fact if2
inner join branch_plant_dim bpd on if2.branchplantkey = bpd.branchplantkey 
inner join company_dim cd on bpd.companykey = cd.companykey
where if2.transtypekey = 2
order by 1, 2;

/* 8) Sales Order Shipments by Name and Combination of Year and Quarter
Write an SQL statement to display the sum of the extended cost and the number of inventory transactions.
The results should include data for shipments (transaction type 5) in calendar years 2011 and 2012.
Summarize the result by calendar year, calendar quarter, and customer name. The result should include the grouped
columns and the full set of subtotals for customer name and the combination of year and quarter. Do not use the
GROUPING SETS and UNION operators. (Hint: see the composite column example in lesson 5). */
select dd.calyear, dd.calquarter, cvd."name", sum(if2.extcost) sum_ext_cost, count(if2.inventorykey) num_transactions
from inventory_fact if2
inner join date_dim dd
	on if2.datekey = dd.datekey
inner join cust_vendor_dim cvd 
	on if2.custvendorkey = cvd.custvendorkey 
where if2.transtypekey = 5
	and dd.calyear in (2011, 2012)
group by cube(cvd."name", (dd.calyear, dd.calquarter))
order by 1, 2, 3;

/* 9) Sales Order Shipments by Month and Category Code1 with Group Number
Write an SQL statement to display the sum of the extended cost and the sum of the quantity.
The results should include data for shipments (transaction type 5) in calendar year 2011. Summarize the result by calendar
month and Address Category Code 1. The result should include the grouped columns and the full set of subtotals for every
combination of grouped columns along with the hierarchical group number for both grouping columns. Do not use the GROUPING SETS
and UNION operators. (Hint: see the group functions slide in lesson 5. In PostgreSQL, the grouping identifier keyword is GROUPING,
not GROUPING_ID as in Oracle). */
select dd.calmonth, cvd.addrcatcode1 , sum(if2.extcost) sum_ext_cost, count(if2.quantity) sum_quantity, grouping(dd.calmonth, cvd.addrcatcode1) group_id
from inventory_fact if2
inner join date_dim dd
	on if2.datekey = dd.datekey
inner join cust_vendor_dim cvd 
	on if2.custvendorkey = cvd.custvendorkey
where dd.calyear = 2011
	and if2.transtypekey = 5
group by cube(1, 2)
order by 1, 2;
	
/* 10) Sales Order Shipments with Subtotals by Name and Partial Subtotals by Year and Quarter
Write an SQL statement to display the sum of the extended cost and the number of inventory transactions.
The results should include data for shipments (transaction type 5) in calendar years 2011 and 2012. Summarize the result by calendar
year, calendar quarter, and customer name. The result should include the grouped columns and subtotals for customer name along with
partial subtotals for year and quarter. Do not include the normal GROUP BY totals in the result.  Do not use the UNION operator.
(Hint: see the nested rollup example in lesson 5). */
select dd.calyear, dd.calquarter, cvd."name", sum(if2.extcost) sum_ext_cost, count(if2.inventorykey) num_transactions
from inventory_fact if2
inner join date_dim dd
	on if2.datekey = dd.datekey
inner join cust_vendor_dim cvd 
	on if2.custvendorkey = cvd.custvendorkey 
where if2.transtypekey = 5
	and dd.calyear in (2011, 2012)
group by grouping sets(cvd."name", rollup(dd.calyear, dd.calquarter))
order by 1, 2, 3;
