select distinct city, state, zip from customer;

select empname, phone, email from employee
where phone like '3-%';

select resno, resname, cast(rate as int)
from resourcetbl
where cast(rate as int) between 10 and 20
order by 3 desc;

select eventno, dateauth, status 
from eventrequest
where status in ('Approved','Denied') and 
	(extract(year from dateauth) = 2018 and extract(month from dateauth) = 7); -- DATEAUTH BETWEEN '2018-07-01' AND '2018-07-31'

select l.locno, l.locname 
from "location" l
inner join facility f
	on f.facno = l.facno
where f.facname = 'Basketball arena';

select planno, count(lineno) count_lineno, sum(cast(numberfld as int)) num_resources
from eventplanline
group by planno;

select e.eventno, e.dateheld, e.custno, c.custname, e.facno, f.facname 
from eventrequest e
inner join customer c on c.custno = e.custno
inner join facility f on f.facno = e.facno
where (c.city = 'Boulder') and (extract(year from e.dateheld) = 2018);

select c.custno, c.custname, e.eventno, e.dateheld, f.facno,
	   f.facname, cast(e.estcost as float)/cast(e.estaudience as float) as cost_pp
from customer c
inner join eventrequest e on c.custno = e.custno
inner join facility f on e.facno = f.facno
where cast(e.estcost as float)/cast(e.estaudience as float) < 0.2
	and (extract(year from e.dateheld) = 2018); 

select c.custno, c.custname, sum(cast(e.estcost as int)) total_cost
from customer c 
inner join eventrequest e on c.custno = e.custno
where e.status = 'Approved'
group by 1, 2;

insert into customer values ('C1994','Soccer','Rafael Nuñez','N','Coach Messi','4225544','Cordoba','AR','5000')

delete from customer where custno = 'C1994';

update resourcetbl 
set rate = cast(rate as float) * 1.1
where resname = 'nurse';

select count(*) 
from information_schema.columns 
where table_name= 'customer';

--- SELECT Statement Problems

select e.eventno, e.dateheld, count(ep.planno)
from eventrequest e
inner join eventplan ep
	on e.eventno = ep.eventno
where ep.workdate between '2018-12-01' and '2018-12-31'
group by 1, 2
having count(ep.planno) > 1;

select ep.planno, ep.eventno, ep.workdate, ep.activity
from eventplan ep
inner join eventrequest e 
	on ep.eventno = e.eventno 
inner join facility f 
	on e.facno = f.facno 
where ep.workdate between '2018-12-01' and '2018-12-31'
	and f.facname = 'Basketball arena';

select e.eventno, e.dateheld, e.status, e.estcost
from eventrequest e
inner join eventplan ep 
	on e.eventno = ep.eventno 
inner join employee em 
	on ep.empno = em.empno 
inner join facility f 
	on e.facno = f.facno 
where em.empname = 'Mary Manager'
	and e.dateheld between '2018-10-01' and '2018-12-31'
	and f.facname = 'Basketball arena';

select el.planno, el.lineno, r.resname, el.numberfld,
	   l.locname, el.timestart, el.timeend
from eventplanline el
inner join resourcetbl r 
	on el.resno = r.resno
inner join location l
	on el.locno = l.locno
inner join eventplan ep  
	on el.planno = ep.planno
inner join facility f 
	on l.facno = f.facno 
where f.facname = 'Basketball arena'
	and ep.activity = 'Operation'
	and ep.workdate between '2018-10-01' and '2018-12-31';

--- Database Modification Problems
insert into facility values ('F104','Swimming Pool');

insert into location values ('L107','F104','Door');

insert into location values ('L108','F104','Locker Room');

update location
set locname = 'Gate'
where locname = 'Door'
	and locno = 'L107';

delete from location where locname = 'Locker Room';

--- SQL Statements with Errors 
SELECT e.eventno, e.dateheld, e.status, e.estcost
FROM eventrequest e, employee em, facility f, eventplan ep
WHERE e.facno = f.facno
  AND ep.empno = em.empno
  AND e.eventno = ep.eventno
  AND cast(e.estaudience as int) > 5000
  AND f.facname = 'Football stadium' 
  AND em.empname = 'Mary Manager';

SELECT DISTINCT eventrequest.eventno, dateheld, status, estcost
FROM eventrequest
WHERE CAST(estaudience as int) > 4000;

SELECT DISTINCT e.eventno, e.dateheld, e.status, e.estcost
FROM eventrequest e, facility f
WHERE e.facno = f.facno  
  AND cast(e.estaudience as int) > 5000
  AND f.facname = 'Football stadium';
 
SELECT DISTINCT e.eventno, e.dateheld, e.status, e.estcost
FROM eventrequest e, employee em, eventplan ep
WHERE ep.empno = em.empno 
  AND e.eventno = ep.eventno
  AND cast(e.estaudience as int) BETWEEN 5000 AND 10000
  AND em.empname = 'Mary Manager';

SELECT ep.planno, el.lineno, r.resname, el.numberfld, el.timestart, el.timeend
FROM eventrequest e, facility f, eventplan ep, eventplanline el, resourcetbl r
WHERE ep.planno = el.planno 
	AND e.facno = f.facno
    AND el.resno = r.resno
    AND e.eventno = ep.eventno
    AND f.facname = 'Basketball arena' 
    AND e.estaudience = '10000';
