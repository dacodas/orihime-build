const puppeteer = require('puppeteer');

var fs = require('fs');
var data = fs.readFileSync('crawl.js', 'utf-8');

async function grabTitles(browser, url)
{
    const page = await browser.newPage();
    await page.goto(url)
    await page.evaluate(data)
    const titles = await page.evaluate('crawlListPage()')

    console.error("Done with " + url)

    return titles
}

async function grabListPageLinks(browser, url)
{
    const page = await browser.newPage();
    await page.goto(url)
    await page.evaluate(data)

    try 
    {
        const titles = await page.evaluate('listPageLinks()')
        console.error("Done grabbing list page links on " + url)
        return titles
    }
    catch (error)
    {
        console.error("Failed grabbing list page links on " + url)
        console.error(error);
        return []
    }
}

(async () => {

    console.error("Loading...")

    const browser = await puppeteer.launch();
    const page = await browser.newPage();
    await page.goto('https://www.aozora.gr.jp');

    page.on('console', msg => console.error(msg.text()));

    await page.evaluate(data)
    const links = await page.evaluate('grabLinks()')

    var all_links = links

    const listLinkPromises = links.map(link => grabListPageLinks(browser, link))
    const listLinks = await Promise.all(listLinkPromises)

    for ( let links of listLinks )

        all_links.push.apply(all_links, links)

    console.error(all_links)

    const promises = links.map(link => grabTitles(browser, link))
    const result = await Promise.all(promises)
    console.error(result)

    var all_titles = result[0] 

    for ( let titles of result.slice(1) )

        all_titles.push.apply(all_titles, titles)

    for ( let title of all_titles )

        console.log(title)

    await browser.close();
})();
