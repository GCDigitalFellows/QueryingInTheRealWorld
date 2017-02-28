-- Exercise 1: How often was each publication added during the first half of 2016?

-- 1.0: Join all the necessary tables, without any filter or aggregation 

select *
  from items i
  join itemData id on id.itemid = i.itemID
  join fields f on f.fieldid = id.fieldid
  join itemDataValues idv on idv.valueid = id.valueid;

-- 1.1: Select only the items added in the first half of 2016

select *
  from items i
 where i.dateAdded between '2016-01-01' and '2016-07-01';

-- 1.2: Select only the unique names of the fields for these items

select f.fieldName
  from items i
  join itemData id on id.itemid = i.itemID
  join fields f on f.fieldid = id.fieldid
 where i.dateAdded between '2016-01-01' and '2016-07-01';

-- 1.3: Select all the field name and value pairs

select f.fieldName
     , idv.value
  from items i
  join itemData id on id.itemid = i.itemID
  join fields f on f.fieldid = id.fieldid
  join itemDataValues idv on idv.valueid = id.valueid
 where i.dateAdded between '2016-01-01' and '2016-07-01';

-- 1.4: Aggregated the number of unique values for the publicationTitle field

select idv.value
     , count(*) as cnt
  from items i
  join itemData id on id.itemid = i.itemID
  join fields f on f.fieldid = id.fieldid
  join itemDataValues idv on idv.valueid = id.valueid
 where i.dateAdded between '2016-01-01' and '2016-07-01'
 group by
       idv.value;

-- 1.5: Finish by sorting the above aggregation from high to low

select idv.value
     , count(*) as cnt
  from items i
  join itemData id on id.itemid = i.itemID
  join fields f on f.fieldid = id.fieldid
  join itemDataValues idv on idv.valueid = id.valueid
 where i.dateAdded between '2016-01-01' and '2016-07-01'
 group by
       idv.value
 order by
       count(*) desc;

-- Exercise 2: What were the top five most active weeks in terms of items added to your library?

-- 2.0: Join the necessary tables

select i.dateAdded
  from items i;

-- 2.1: Extract the week from the dateAdded

select i.dateAdded
     , extract_week(..) as week
  from item i;

-- 2.2: Aggregate by the new week field

select 