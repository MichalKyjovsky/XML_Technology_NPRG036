(:Intention of this query is to create a function which returns all amployees books
in form of circular message -> FUNCTION, XHTML:)

declare function local:cook-author($cook-name, $bookstore) as element()*
{
    for $book in $bookstore
    where $book[author = $cook-name]
    return
        <p> {"Employee ", $cook-name, " is an autor of ", $book/title/text()}</p>
};


let $cooks := fn:doc("data.xml")//employee
let $books := fn:doc("book-store.xml")//book
for $cook in $cooks
where every $cook-author in $cook satisfies $cook-author//author
return <div>
    { local:cook-author($cook/ child::name/text (), $books) }
</div>
