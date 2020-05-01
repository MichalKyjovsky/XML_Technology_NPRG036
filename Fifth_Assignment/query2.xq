(:This query is intended to find all fully occupied table in the restaurant. :)
<ul> {
    let $tables := fn:doc("data.xml")//table
    for $table in $tables
    return
        if ($table/capacity = $table/occupancy)
        then <li>{$table/@tableID}</li>
        else ()
}
</ul>
