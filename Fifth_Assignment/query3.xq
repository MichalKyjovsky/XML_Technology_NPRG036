(:This query is intended to find all employyes which are also book authors and
list them ini alphabetic order.:)
let $cooks :=  fn:doc("data.xml")//employee

for $cook in $cooks
where every $cook-author in $cook satisfies $cook-author//author
order by $cook/name ascending
return fn:distinct-values($cook)