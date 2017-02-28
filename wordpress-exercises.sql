-- Exercise 1: What can I do with just one table?

-- 1.1: Select all posts

select *
  from wp_posts;

-- 1.2: Count number of posts

select count(*)
  from wp_posts;

-- 1.3: Select all posts which have been modified

select id
     , post_date
     , post_modified
  from wp_posts
 where post_date < post_modified

-- 1.4: What are the different kinds of posts?

select distinct 
       post_type 
  from wp_posts;

-- 1.5: How many of each kind of post are there? Order the results in ascending order.

select post_type
     , count(*) as cnt
  from wp_posts
 group by
       post_type
 order by
       cnt asc;

-- 1.6: How many posts were added by week?

select date_trunc(post_date) week
     , count(*) from cnt
  from wp_posts
 group by
       week;