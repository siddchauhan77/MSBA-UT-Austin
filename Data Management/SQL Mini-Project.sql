--Siddhant Chahuan
--sc54788

--Problems--
--

/*1.	Write a SELECT statement that returns following columns from the User table: first_name, last_name, email, birthdate. Then, run this statement to make sure it works correctly.
Add an ORDER BY clause to this statement that sorts the result set by last name in ascending order. Then, run this statement again to make sure it works correctly. This is a good way to build and test a statement, one clause at a time
*/

select first_name, last_name, email, birthdate
from User_table
order by last_name;

/*2.	Write a SELECT statement that returns one column from the User table named user_full_name that combines the first_name and last_name columns.
Format this column with the first name, a space, and last name like this:
John Doe
Sort the result set by first name in descending sequence.
Return only the users whose last name begins with letters of K, L, and M.
*/

select first_name || ' ' || last_name as user_full_name
from User_table
where last_name like 'K%' or last_name like 'L%' or last_name like 'M%'
order by first_name desc;

/*3.	Write a SELECT statement that returns these columns from the Video table: title, subtitle, upload_date, views, and likes. Return only the rows with an upload date between the beginning of this year and last week (i.e. between ’01-Jan-20’ and the date one week before this assignment is due). Use the BETWEEN operator. Sort the result set in descending sequence by the upload_date column. 
*/

select title, subtitle, upload_date, views ,likes
from Video
where upload_date between '01-Jan-20' and '20-Sep-20'
order by upload_date desc;

--4.	Create a duplicate of the previous query but this time update the WHERE clause to use only the following operators (<, >, <=, or >=). Keep the rest of the query the same.
select title, subtitle, upload_date, views ,likes
from Video
where upload_date >= '01-Jan-20' and upload_date <= '20-Sep-20'
order by upload_date desc;

/*5.	Write a SELECT statement that returns these column names and data from the Video table:	
video_id		The video_id column
video_size	The video_size column but with a column alias of video_size_MB
likes	The likes column with a column alias of Likes_Earned
video_length	The video_length column with a column alias of video_length_sec
video_length_min	The is a calculated column based on the logic below*.
*Divide the video_length (currently in seconds) by the number of seconds in a minute to find video length in minutes.
Use the ROWNUM pseudo column so the result set contains only the first 3 rows from the table.
Sort the result set by the column alias Likes_Earned in descending order.
NOTE: You should return only one decimal place for video_length_min. You could use ROUND but for this column we would prefer truncating (i.e. remove decimal) to see how many minutes are required at a minimum to watch most of the video. 
*/

select video_id, video_size as video_size_MB, likes as likes_earned, video_length as video_length_sec,
trunc (video_length / 60, 1) as video_length_min
from Video
where rownum <= 3
order by Likes_Earned DESC;

--6.	Now copy the above statement, but adjust it to answer the following question: Which videos (by video name) have the highest number of likes and are at least 6 minutes long? Remove all non-relevant columns from your query.

 select video_id, title, likes as Likes_Earned, video_length as video_length_sec,
 TRUNC (video_length / 60 , 1) as video_length_min
 from video
 where trunc (video_length / 60 / 1) >= 6 and likes > 1
 order by Likes_Earned DESC;
 
 
/*7.	Write a SELECT statement that returns these column names and data from the video  table:			
cc_id			The cc_id column
video_id		The video_id column
Popularity 		The likes column but with a column alias
Awards			The likes column calculated as described below (ideally would be truncated)
Post_date		The upload_date column but with a column alias
Only return rows with where the video has earned more than 10 awards. An award is earned every 5000 likes that accrued. 
*/

select cc_id, video_id, Likes as Popularity, upload_date as Post_date,
trunc (Likes / 5000 / 1) as Awards
from Video
where trunc (Likes / 5000 / 1) > 10;

--8.	Now write a query that shows the above information and includes the full name of the user that created these videos. Do not return any column except the full user name. 
 
select u.first_name || ' ' || u.last_name as full_name , cc.cc_id, v.video_id, v.Likes as Popularity, v.upload_date as Post_date, trunc (Likes / 5000 / 1) as Awards
from video v INNER JOIN content_creators cc on v.cc_id = cc.cc_id
    INNER JOIN user_table u on cc.user_id = u.user_id
where trunc (Likes / 5000 / 1) > 10;

/*
9.	Write a SELECT statement that uses the SYSDATE function to create a row with these columns:
today_unformatted	The SYSDATE function unformatted
today_formatted	The SYSDATE function in this format: MM/DD/YYYY
This displays a number for the month, a number for the day, and a four-digit year. Use a FROM clause that specifies the Dual table. Hint: You will need to implement the TO_CHAR function to format the sysdate in the format designated above.


After you write this add the following columns to the row:
likes	1000
pay_per_like	.0325
pay_per_video	10
pay_sum	The likes multiplied by the pay_per_like
video_total	The pay per video plus the pay_sum
 
Your result table contains only one row.
*/

Select sysdate as today_unformatted, to_char(sysdate, 'MM/DD/YYYY') as today_formatted, 1000 as likes, .0325 as pay_per_like , 10 as pay_per_video, 1000 * .0235 as pay_sum, 10 + (1000 * .0325) as video_total
from dual;


--10.	Now return a table that shows these pay columns for the videos in the video table. Include upload date and format as MM/DD/YYYY. Show the videos that earn the most revenue first. 

select likes, .0325 as pay_per_like , 10 as pay_per_video, likes * .0325 as pay_sum, 10 + (likes * .0325) as video_total, To_char(Upload_date, 'MM/DD/YYYY') as format_date, revenue
from Video
order by revenue DESC;

--11.	Write a SELECT statement that returns the first and last name of users, their birthdate, their status, and the comments they have made. We want to see the longest comments first.  
select u.first_name, u.last_name, u.birthdate, u.cc_flag, c.comment_body
from comments c Inner Join user_table u on c.user_id = u.user_id
order by length (c.comment_body) desc;


/*12.	Write a SELECT statement that pulls the user and their topic subscription info. Then display the following columns from the results:
user_id			The user_id column 
user_name		A concatenation of user first and last names. 
topic_id		The topic_id column
topic_name		The topic_name column
Return on the subscription details for the user(s) subscribed to the “SQL” topic. 
*/

select u.user_id, u.first_name ||' '|| u.last_name as user_name, t.topic_id, t.topic_name
from user_topic_subsc us INNER JOIN user_table u on us.user_id = u.user_id
    INNER JOIN topic t on t.topic_id = us.topic_id
where topic_name = 'SQL';    



/*13.	Write a SELECT statement that joins the appropriate tables in order to show video title, subtitle, user first_name, last_name , whether the CC_Flag is checked or not, and comment_body. Pull this for only video_id 100000 and then sort by last_name and first_name. Your results look like something like this (for a different video): 
*/


select v.title, v.subtitle, us.first_name , us.last_name, us.cc_flag, c.comment_body
from video v INNER JOIN comments c on v.video_id = c.video_id
INNER JOIN user_table us on us.user_id = c.user_id
where v.video_id = 100000
order by us.last_name, us.first_name;

--14.	Write a SELECT statement that pulls the distinct first name, last_name, and email for users that have not commented on a video yet. Use a left outer join to accomplish this to show you understand how to properly use them. Sort them by last name.

select u.first_name, u.last_name, u.email
from user_table u left join comments c on u.user_id = c.user_id
where c.comment_id is null
order by u.last_name;

/*15.	Use the UNION operator to generate a result set consisting of three columns from the Video table: 

video_tier	A calculated column that contains a value of ‘1-Top-Tier’, ‘2-Mid-Tier’, or       ‘3-Low-Tier’ 
video_id	The video_id column
revenue	The revenue column 
views	The views column

If the video has at least 30000 views, the video_tier column should contain a literal string value of ‘1-Top-Tier’. If the video has between 20000 views and 30000 views the video_tier should contain a literal string value of ‘2-Mid-Tier’. Otherwise, it should contain a value of ‘3-Low-Tier’ 

Sort the final result set by revenue descending.  
*/



select '1-top-tier' as video_tier, video_id, revenue, views
from video
where views > 30000

Union
select '2-Mid-Tier' AS video_tier, video_id, revenue, views
from video
where views between 20000 and 30000

Union
select 'Low-tier' As video_tier, video_id, revenue, views
from video 
where views < 20000
order by revenue DESC;



--16.	Write a SELECT statement to identify the most successful content creator (cc_username) in terms of revenue. Is that the same person that is most successful in terms of rewards?

select v.revenue, cc.cc_username
from content_creators cc JOIN video v on cc.cc_id = v.cc_id
order by v.revenue desc
fetch first 1 ROW ONLY;

--Rewards

select cc.cc_username, MAX (TRUNC (vv.likes / 5000)) as awards
From content_creators cc JOIN user_table u on cc.cc_id = u.user_id
    JOIN video vv on cc.cc_id = vv.cc_id
group by cc_username
order by Awards desc
fetch first 1 rows only;


--17.	Show the distinct different card types that each content creator has with their first and last name. 
select distinct u.first_name, u.last_name, cd.card_type
from creditcard cd JOIN content_creators cc on cd.contentcreator_id = cc.CC_id
    JOIN user_table u on cc.user_id = u.user_id;




















