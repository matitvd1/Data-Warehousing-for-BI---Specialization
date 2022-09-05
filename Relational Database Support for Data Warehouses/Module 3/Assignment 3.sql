/* 1) Ranking within the entire result
Use the RANK function to rank customers in descending order by the sum of extended cost for shipments (transaction type 5).
You should use the entire result as a single partition.
The result should include the customer name, sum of the extended cost, and rank.*/

select c_v."name",
		sum(i_f.extcost) sum_ext_cost,
		rank() over(order by sum(i_f.extcost) desc) ranking
from inventory_fact i_f, cust_vendor_dim c_v
where i_f.custvendorkey = c_v.custvendorkey 
	and i_f.custvendorkey is not null
	and i_f.transtypekey = 5
group by 1;

select c_v."name",
		sum(i_f.extcost) sum_ext_cost,
		rank() over(order by sum(i_f.extcost) desc) ranking
from inventory_fact i_f
join cust_vendor_dim c_v
	on i_f.custvendorkey = c_v.custvendorkey 
where i_f.custvendorkey is not null
	and i_f.transtypekey = 5
group by 1;

/* 2) Ranking within a partition
Use the RANK function to rank customers in descending order by the sum of extended cost for shipments (transaction type 5).
You should partition the rank values by customer state. The result should include the customer state, customer name, sum of the extended cost,
and rank. You should order the result by customer state. */

select c_v.state,
		c_v."name",
		sum(i_f.extcost) sum_ext_cost,
		rank() over(partition by c_v.state order by sum(i_f.extcost) desc) ranking
from inventory_fact i_f
join cust_vendor_dim c_v
	on i_f.custvendorkey = c_v.custvendorkey 
where i_f.custvendorkey is not null
	and i_f.transtypekey = 5
group by 1, 2
order by 1;

/* 3) Ranking and dense ranking within the entire result
Use both RANK and DENSE_RANK functions to rank customers in descending order by the count of inventory transactions for 
shipments (transaction type 5). You should use the entire result as a single partition. The result should include the customer name,
count of transactions, rank, and dense rank. */

select c_v."name",
		count(i_f.inventorykey) count_inv_tr,
		rank() over(order by count(i_f.inventorykey) desc) ranking,
		dense_rank() over(order by count(i_f.inventorykey) desc) dense_ranking
from inventory_fact i_f
join cust_vendor_dim c_v
	on i_f.custvendorkey = c_v.custvendorkey 
where i_f.custvendorkey is not null
	and i_f.transtypekey = 5
group by 1;

/* 4) Cumulative extended costs for the entire result
Calculate the cumulative sum of extended cost ordered by customer zip code, calendar year, and calendar month for
shipments (transaction type 5). The result should include the customer zip code, calendar year, calendar month, sum of the
extended cost, and cumulative sum of the extended cost. Note that the cumulative extended cost is the sum of the extended cost
in the current row plus the cumulative sum of extended costs in all previous rows. */

select c_v.zip,
		dd.calyear,
		dd.calmonth,	
		sum(i_f.extcost) sum_ext_cost,
		sum(sum(i_f.extcost)) over(order by c_v.zip, dd.calyear,
			dd.calmonth rows unbounded preceding) cum_sum
from inventory_fact i_f
join cust_vendor_dim c_v
	on i_f.custvendorkey = c_v.custvendorkey
join date_dim dd 
	on i_f.datekey = dd.datekey
where i_f.custvendorkey is not null
	and i_f.transtypekey = 5
group by 1, 2, 3;

/* 5) Cumulative extended costs for a partition
Calculate the cumulative sum of extended cost ordered by customer zip code, calendar year,
and calendar month for shipments (transaction type 5). Restart the cumulative extended cost after each combination of zip code
and calendar year. The result should include the customer zip code, calendar year, calendar month, sum of the extended cost,
and cumulative sum of the extended cost. Note that the cumulative extended cost is the sum of the extended cost in the current
row plus the cumulative sum of extended costs in all previous rows of the store zip code and years. The value of cumulative extended
cost resets in each partition (new value for zip code and year). */

select c_v.zip,
		dd.calyear,
		dd.calmonth,
		sum(i_f.extcost) sum_ext_cost,
		sum(sum(i_f.extcost)) over(partition by c_v.zip, dd.calyear 
			order by c_v.zip, dd.calyear, dd.calmonth rows unbounded preceding) cum_sum
from inventory_fact i_f
join cust_vendor_dim c_v
	on i_f.custvendorkey = c_v.custvendorkey
join date_dim dd 
	on i_f.datekey = dd.datekey
where i_f.custvendorkey is not null
	and i_f.transtypekey = 5
group by 1, 2, 3;

/* 6) Ratio to report applied to the entire result
Calculate the ratio to report of the sum of extended cost for adjustments (transaction type 1). You should sort on descending order
by sum of extended cost. The result should contain the second item id, sum of extended cost, and ratio to report. */

select imd.seconditemid ,
	sum(if2.extcost) sum_ext_cost,
	sum(if2.extcost)/sum(sum(if2.extcost)) over() ratio_to_report
from inventory_fact if2
join item_master_dim imd 
	on if2.itemmasterkey = imd.itemmasterkey
where if2.transtypekey = 1
group by 1
order by 3 desc;

-- check if ratio_to report sum 1
with temp_6 as ( 
select imd.itemcatcode2,
	sum(if2.extcost) sum_ext_cost,
	sum(if2.extcost)/sum(sum(if2.extcost)) over() ratio_to_report
from inventory_fact if2
join item_master_dim imd 
	on if2.itemmasterkey = imd.itemmasterkey
where if2.transtypekey = 1
group by 1)

select sum(ratio_to_report) from temp_6;


create temp table test_tble_6 as (
select imd.itemcatcode2,
	sum(if2.extcost) sum_ext_cost,
	sum(if2.extcost)/sum(sum(if2.extcost)) over() ratio_to_report
from inventory_fact if2
join item_master_dim imd 
	on if2.itemmasterkey = imd.itemmasterkey
where if2.transtypekey = 1
group by 1
)

select sum(ratio_to_report) from test_tble_6;

/* 7) Ratio to report applied to a partition
Calculate the ratio to report of the sum of extended cost for adjustments (transaction type 1) with partitioning on calendar year.
You should sort on ascending order by calendar year and descending order by sum of extended cost. The result should contain the calendar
year, second item id, sum of extended cost, and ratio to report. */

select dd.calyear,
	imd.seconditemid ,
	sum(if2.extcost) sum_ext_cost,
	sum(if2.extcost)/sum(sum(if2.extcost)) over(partition by dd.calyear) ratio_to_report
from inventory_fact if2
join item_master_dim imd 
	on if2.itemmasterkey = imd.itemmasterkey
join date_dim dd 
	on if2.datekey = dd.datekey 
where if2.transtypekey = 1
group by 1, 2
order by 1 asc, 3 desc;

/* 8) Cumulative distribution functions for carrying cost of all branch plants
Calculate the rank, percent_rank, and cume_dist functions of the carrying cost in the branch_plant_dim table. The result should contain
the BPName, CompanyKey, CarryingCost, rank, percent_rank, and cume_dist. */

select bpname,
	companykey,
	carryingcost,
	rank() over (order by carryingcost desc),
	percent_rank() over (order by carryingcost),
	cume_dist() over(order by carryingcost)
from branch_plant_dim
order by 4 asc;

/* 9) Determine the branch plants with the highest carrying costs (top 15%). The result should contain BPName, CompanyKey, CarryingCost,
and cume_dist. */

select *
from (
select bpname,
	companykey,
	carryingcost,
	cume_dist() over(order by carryingcost asc) cumdist
from branch_plant_dim
order by 4 desc) as tbl_9
where cumdist >= 0.85;

/*10) Cumulative distribution of extended cost for Colorado inventory
Calculate the cumulative distribution of extended cost for Colorado inventory (condition on customer state).
The result should contain the extended cost and cume_dist, ordered by extended cost. You should eliminate duplicate rows in the result. */

select distinct extcost,
	cume_dist() over(order by extcost asc) cumdist
from inventory_fact if2
inner join cust_vendor_dim cvd 
	on if2.custvendorkey = cvd.custvendorkey
where cvd.state = 'CO'
order by 2 desc;
