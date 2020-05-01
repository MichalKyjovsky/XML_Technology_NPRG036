(:Purpose of this query is to provide list of tables which supposed to contain
another available seat in average for eventual customer. XHTML:)

<ol> {
    let $tables := fn:doc("data.xml")//table
    let $capSum := fn:sum($tables/capacity)
    let $ocupSum := fn:sum($tables/occupancy)
    for $table in $tables
    where $table[occupancy != capacity] and $table[occupancy < fn:avg($capSum - $ocupSum)]
    return <li>{
        fn:data($table/attribute::tableID), "has extra capacity for another customers."
    }
    </li>
}
</ol>