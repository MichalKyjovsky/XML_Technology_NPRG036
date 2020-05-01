(:This query is intended to find all equipment in the restarant with bad
condition and find an alternative replacement in equipment-store. -> OUTER JOIN, INTEGRATION :)
let $alternativesElec := fn:doc("equipment-store.xml")//tool
return
for $eqp in fn:doc("data.xml")//equipment
where $eqp/@condition="bad"
return  element equipment-to-change { fn:data($eqp),
element found-alternatives
    {
        for $alternatives in $alternativesElec
        let $tool := $alternatives/child::*
        where fn:name($tool) = fn:data($eqp)
        order by fn:data($tool) ascending
        return $tool
    } }

