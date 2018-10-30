/* Welcome to the SQL mini project. For this project, you will use
Springboard' online SQL platform, which you can log into through the
following link:

https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

Note that, if you need to, you can also download these tables locally.

In the mini project, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */



/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */
Select name from Facilities  where  membercost > 0

/* Q2: How many facilities do not charge a fee to members? */
Select count(1) as 'Count of No Fee Facilities'  from Facilities  where  membercost = 0

/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */
Select facid, name, membercost, monthlymaintenance  from Facilities  where  (monthlymaintenance * 0.20) < membercost

/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */
Select facid, name, membercost, monthlymaintenance  from Facilities  where  facid in (1,5)

/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */
Select case when monthlymaintenance>100 then 'expensive' else 'cheap' end , name, monthlymaintenance  from Facilities 

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */
select firstname, surname  from Members where joindate = (select max(joindate) from Members)

/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */
select f.name, (firstname || '  ' || surname)  as 'Member Name'  
from Members m, Facilities f, Bookings b
where b.facid = f.facid
and b.memid = m.memid
and f.name in ('Tennis Court 1','Tennis Court 2')
group by (firstname || '  ' || surname)
order by 'Member Name'

/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */
select f.name, (firstname || '  ' || surname)  as 'Member Name' 
from Members m, Facilities f, Bookings b
where b.facid = f.facid
and b.memid = m.memid
and b.starttime like '2012-09-14%'
and(
(m.memid = 0 and (b.slots * f.guestcost) > 30)
or
(m.memid > 0 and (b.slots * f.membercost) > 30))
order by 'Member Name'

/* Q9: This time, produce the same result as in Q8, but using a subquery. */
select f.name, (firstname || '  ' || surname)  as 'Member Name' 
from Members m, Facilities f, (Select * from Bookings where starttime like '2012-09-14%') b
where b.facid = f.facid
and b.memid = m.memid
and(
(m.memid = 0 and (b.slots * f.guestcost) > 30)
or
(m.memid > 0 and (b.slots * f.membercost) > 30))
order by 'Member Name'

/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */
Select c.name, sum(c.slots * c.cost) as 'Total Revenue' from (
	select f.name,b.slots, f.guestcost as 'cost'
	from Members m, Facilities f, Bookings b
	where b.facid = f.facid
	and b.memid = m.memid
	and m.memid = 0
	Union all
	select f.name,b.slots,f.membercost as 'cost'
	from Members m, Facilities f, Bookings b
	where b.facid = f.facid
	and b.memid = m.memid
	and m.memid > 0
) c
group by c.name
having sum(c.slots * c.cost) < 1000
	

