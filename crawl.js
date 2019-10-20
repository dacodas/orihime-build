var grabLinks = function ()
{
    xpath = String.raw`//table[@summary="main"]/tbody/tr[5]/td[@class="summary"]//a`
    result = document.evaluate(xpath, document)

    hrefs = []

    var anchor = result.iterateNext();
    while ( anchor )
    {
        hrefs.push(anchor.href)
        anchor = result.iterateNext();
    }

    return hrefs
}

var listPageLinks = function ()
{
    // Let's assume the first table we get is the links table
    const table = document.evaluate("//table", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE).singleNodeValue
    const list_td = document.evaluate("descendant::tr/td[2]", table, null, XPathResult.FIRST_ORDERED_NODE_TYPE).singleNodeValue

    if ( !list_td.textContent.includes("ページ") )

        return []

    const anchors = document.evaluate("descendant::a", list_td)
    var links = []

    var anchor = anchors.iterateNext()
    while ( anchor )
    {
        links.push(anchor.href)
        anchor = anchors.iterateNext()
    }

    return links
}

var crawlListPage = function ()
{
    xpath = String.raw`//table[@class="list"]/tbody/tr/td[2]`
    result = document.evaluate(xpath, document)

    var titles = []
    
    var tr = result.iterateNext();
    while ( tr )
    {
        title = tr.textContent.trim()
        titles.push(title)

        tr = result.iterateNext();
    }

    return titles
}
