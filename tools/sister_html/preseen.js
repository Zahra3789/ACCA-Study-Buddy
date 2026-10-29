// ====================================================================== EPA1 pre-seen: Crafted Crisps (2026/27)
// A chapter of its own for the Role Simulation's pre-seen company: who they are, the market, the people and the
// factory, the 2025 accounts and the 2026 budget and cost card. Written as a study summary in our own words (the
// pre-seen itself is CIMA's and not reproduced); every figure checked against the pre-seen. Added to the RS exam's
// chapters and Sensei's Scrolls before the app starts, so the Chapter Book, battles, Boss Arena and plan all see it.
(function () {
const e = EXAMS.find(x => x.id === 'SM'); if (!e || e.chapters.some(c => c.id === 14)) return;
e.chapters.push({
  id: 14, title: 'Pre-seen: Crafted Crisps (EPA1 2026/27)', monster: 'The Crinkle-Cut Oni',
  lessons: [
    { id: 'L1', title: 'Crafted Crisps: the company and your role', outcome: 'Pre-seen - the company',
      learn: [
        { text: 'In the Role Simulation you are a [b]Finance Apprentice[/b] in the Finance Department of [b]Crafted Crisps[/b]. You help different people in the team with different tasks.\n\nEvery task in the assessment is set inside this company, so it pays to know it well.' },
        { text: '[b]Crafted Crisps[/b] is a [b]privately owned[/b] company in [b]Harland[/b], a country in Western Europe. Its currency is the [b]H$[/b].\n\nIt makes and sells premium [b]hand-cooked potato crisps, ridged crisps and popcorn[/b] from high-quality, locally sourced ingredients.' },
        { text: '[b]2007[/b]: founded by [b]Dean and Samantha Makin[/b] on their family farm, selling three flavours through local shops.\n[b]2011[/b]: wins a regional taste award, which brings national recognition.\n[b]2012[/b]: a bigger production and distribution site; it commits to paying Harland\'s living wage.' },
        { text: '[b]2013[/b]: their son [b]Jay[/b] joins and a website is launched - for [b]promotion only[/b], no online sales.\n[b]2014[/b]: a contract with a high-end national supermarket.\n[b]2017[/b]: local farmer [b]Ed Fowler[/b] buys shares, paying for new equipment (including machinery that uses less water).' },
        { text: '[b]2018[/b]: ridged crisps are added.\n[b]2019[/b]: tins as well as bags, for a more premium look, and luxury [b]popcorn[/b] is launched.\n\nToday the company is owned by the [b]Makin and Fowler families[/b]; Ed\'s daughter [b]Nicole[/b] works in the business too.' },
        { text: 'One site in the south of Harland holds the [b]Head Office, Production Facility and Distribution Centre[/b].\n\n[b]298 staff[/b]: 256 in production and 42 in management and administration.' },
        { text: '[b]2025 headline figures[/b]: revenue [b]H$66.93m[/b], gross margin [b]22%[/b], operating margin [b]7%[/b].\n\nSales go to independent retailers, larger multiple retailers in the south of Harland, the food halls of a few high-end department stores, and retailers in other European countries.' }],
      apply: { title: "Sisi's first week at Crafted Crisps", pages: [
        { text: 'Sisi starts as a Finance Apprentice at Crafted Crisps. Nathan Price, the Finance Manager, hands her a pile of invoices: potatoes from local farms, rapeseed oil, flavourings, packaging film.\n\n\'Everything we buy comes from Harland companies,\' he says. \'Local quality is the whole brand.\'' },
        { text: '\'So why do we hold so many potatoes in the stores?\' Sisi asks.\n\n\'There is only one potato crop a year,\' says Nathan. \'We harvest in September and October and keep them in climate-controlled storage for the rest of the year.\'\n\nSisi notes it down: big inventory after harvest, and storage costs all year.' }] },
      practice: [
        { type: 'choice', q: 'What is your role in the Role Simulation?', opts: ['Finance Director', 'Finance Apprentice in the Finance Department', 'Sales Senior Manager', 'External auditor'], a: 1, ex: 'You are a Finance Apprentice, working alongside different members of the Finance Department.' },
        { type: 'choice', q: 'Which currency does Crafted Crisps report in?', opts: ['GBP', 'EUR', 'H$', 'USD'], a: 2, ex: 'Crafted Crisps is based in Harland, which uses the H$.' },
        { type: 'multi', q: 'Which TWO families own Crafted Crisps?', opts: ['Makin', 'Granato', 'Fowler', 'Wren'], a: [0, 2], ex: 'The company is privately owned by the Makin and Fowler families. Ed Fowler bought shares in 2017.' },
        { type: 'choice', q: 'What is the company website used for?', opts: ['Online sales to customers', 'Promotion only - customers cannot buy from it', 'Ordering from suppliers', 'Paying staff'], a: 1, ex: 'The website has always been for promotion only; it raises the brand\'s profile but takes no orders.' },
        { type: 'input', q: 'How many people does Crafted Crisps employ in total?  (number)', accept: ['298'], display_answer: '298', ex: '256 in production + 42 in management and administration = 298.' },
        { type: 'picklist', q: 'In 2025 the gross margin was {0} and the operating margin was {1}.', lists: [['22%', '7%', '24%'], ['7%', '22%', '15%']], a: [0, 0], ex: 'Gross profit 14,716 / revenue 66,933 = 22%. Operating profit 4,723 / 66,933 = 7%.' }] },

    { id: 'L2', title: 'The market and the plans ahead', outcome: 'Pre-seen - the industry',
      learn: [
        { text: 'Crisps are [b]the most popular bagged snack[/b] in Harland: about six billion packets a year.\n\nIn 2024 the crisps, savoury snacks and nuts market was worth [b]over H$6 billion[/b].' },
        { text: 'Growth in snacks overall is [b]slowing[/b], but the [b]gourmet[/b] end keeps growing fast. Brands offering a luxury experience and bold flavours do best.\n\nMany gourmet brands began on family farms; several were later bought by [b]large global food companies[/b], which now hold most gourmet sales.' },
        { text: '[b]Trends to know[/b]:\n- demand for premium and exotic flavours\n- traditional flavours (cheese & onion, salt & vinegar) still sell best\n- nostalgic 70s and 80s snacks are back, helped by social media' },
        { text: '- supermarkets compete with their own-label crisps in unusual flavours\n- shoppers want healthier options such as popcorn (a good source of fibre) and baked crisps\n\nCrafted Crisps sits at the [b]premium end[/b]: a [b]mid-size[/b], [b]single-brand[/b] company that stands out through local, quality ingredients.' },
        { text: '[b]What\'s next[/b] (from its website):\n- a [b]reduced fat[/b] range\n- a [b]subscription and gifting[/b] service by post\n- a [b]100% compostable, plastic-free[/b] crisp bag, with a local packaging supplier\n- selling in more places' }],
      practice: [
        { type: 'choice', q: 'Which part of the snacks market is still growing rapidly?', opts: ['Value own-label crisps', 'Gourmet and premium brands', 'Multipack crisps', 'Salted nuts'], a: 1, ex: 'Overall snacks growth is slowing, but the gourmet market keeps growing fast.' },
        { type: 'multi', q: 'Which TWO are trends in the Harland crisp market?', opts: ['Interest in healthier snacks such as popcorn', 'Falling demand for exotic flavours', 'Supermarkets launching own-label crisps', 'Traditional flavours losing popularity'], a: [0, 2], ex: 'Exotic flavours are in demand and traditional flavours still sell best, so the other two are wrong.' },
        { type: 'choice', q: 'How does Crafted Crisps differentiate itself from competitors?', opts: ['Lowest prices', 'Its own delivery fleet', 'Locally sourced, high-quality ingredients', 'Selling online'], a: 2, ex: 'Its point of difference is local, quality ingredients. It has no fleet and no online sales.' },
        { type: 'choice', q: 'Who now holds most gourmet snack sales in Harland?', opts: ['Family farms', 'Large global food companies', 'Supermarket own labels', 'Department stores'], a: 1, ex: 'Global food companies bought many of the successful gourmet brands in the late 2010s.' },
        { type: 'multi', q: 'Which TWO are among Crafted Crisps\' future plans?', opts: ['A reduced fat range', 'Opening its own shops', 'A compostable, plastic-free bag', 'Buying a fleet of lorries'], a: [0, 2], ex: 'The plans are reduced fat crisps, a subscription and gifting service, a compostable bag and selling in more places.' }] },

    { id: 'L3', title: 'People, products and the factory', outcome: 'Pre-seen - the organisation',
      learn: [
        { text: '[b]The directors[/b]: Dean Makin (Managing Director), Samantha Makin (Sales), Carys Wren (Finance), Jay Makin (IT), Mahmood Hussein (R&D), Leo Granato (Production) and Isla Fenwick (Distribution).' },
        { text: '[b]Finance[/b]: Carys Wren (Finance Director) > Sarya Ghosh (Finance Senior Manager) > Nathan Price (Finance Manager) > 3 finance officers and 2 apprentices - you are one of them.\n\nStephen Reid, HR Senior Manager, also reports to Carys.' },
        { text: '[b]Production[/b] (under Leo Granato): Rob Douglas - Goods Inwards, Melissa Voss - Factory Production, Ellie Caulfield - Packaging, Jordan Edwards - Facilities.\n[b]Sales[/b] (under Samantha Makin): Nicole Fowler - Marketing, Theo Tomlin - Sales.' },
        { text: '[b]Products[/b], all natural, gluten free and MSG free:\n- [b]potato crisps[/b] in 5 flavours, in 40g bags, 150g sharing bags and 95g tins\n- [b]ridged crisps[/b] in the 3 classic flavours\n- [b]popcorn[/b], salted or sweet, in bags and tins' },
        { text: 'Production is in [b]batches[/b], through four [b]production departments[/b]: Ingredient Preparation, Cooking, Flavouring and Packing.\n\nTwo [b]service departments[/b] support them: [b]Goods Inwards[/b] (buying and holding raw materials) and [b]Facilities[/b] (maintaining production equipment).' },
        { text: 'Quality is checked all the way: ingredients on arrival, potatoes by eye and by scanner, each cooked batch\'s colour, and the flavouring drum sampled from at least 10 points.\n\nOvercooked or blemished batches are [b]thrown away[/b] - a production loss to cost.' },
        { text: '[b]Raw materials[/b]: potatoes from the family farm and three other local farms, stored after the single yearly harvest; [b]Robust[/b] corn for popcorn, dried for 3-4 weeks; local flavourings; rapeseed oil.\n\nFinished goods leave from the Distribution Centre through a [b]third-party logistics company[/b] - there is no own fleet.' }],
      practice: [
        { type: 'choice', q: 'Who is the Finance Director of Crafted Crisps?', opts: ['Sarya Ghosh', 'Carys Wren', 'Nathan Price', 'Samantha Makin'], a: 1, ex: 'Carys Wren is Finance Director; Sarya Ghosh is Finance Senior Manager and Nathan Price is Finance Manager.' },
        { type: 'multi', q: 'Which TWO are SERVICE departments?', opts: ['Goods Inwards', 'Cooking', 'Facilities', 'Packing'], a: [0, 2], ex: 'Goods Inwards and Facilities serve the four production departments (Ingredient Preparation, Cooking, Flavouring, Packing). Their costs are reapportioned to them.' },
        { type: 'choice', q: 'How are products made?', opts: ['Continuous process production', 'In batches', 'Job by job to customer order', 'Bought in finished'], a: 1, ex: 'Production is undertaken in batches - so batch costing fits.' },
        { type: 'choice', q: 'Why does Crafted Crisps hold large potato inventories after September-October?', opts: ['Prices are lowest in spring', 'There is only one potato crop a year, so it must be stored', 'Suppliers insist on it', 'To reduce storage costs'], a: 1, ex: 'There is one crop a year across Europe, so potatoes are harvested in September-October and stored in climate-controlled stores.' },
        { type: 'choice', q: 'How does Crafted Crisps deliver to its retailers?', opts: ['Its own fleet of lorries', 'Customers collect', 'A third-party logistics company', 'The postal service'], a: 2, ex: 'Distribution is outsourced to a third-party logistics company; it has no vehicles of its own.' },
        { type: 'picklist', q: 'The Production Director is {0} and the Marketing Senior Manager is {1}.', lists: [['Leo Granato', 'Jordan Edwards', 'Mahmood Hussein'], ['Nicole Fowler', 'Theo Tomlin', 'Ellie Caulfield']], a: [0, 0], ex: 'Leo Granato runs Production; Nicole Fowler (Ed\'s daughter) is Marketing Senior Manager under Samantha Makin.' }] },

    { id: 'L4', title: 'The 2025 financial statements', outcome: 'Pre-seen - performance and position',
      learn: [
        { text: '[b]Profit or loss, 2025 (2024)[/b], H$000:\nrevenue 66,933 (57,798), gross profit 14,716 (11,466), operating profit 4,723 (4,458), profit for the year 3,447 (3,232).' },
        { text: 'Revenue grew about [b]15.8%[/b]. Gross margin improved from 19.8% to [b]22.0%[/b].\n\nBut admin and distribution costs jumped from 7,008 to 9,993 (about 43%), so the operating margin [b]fell[/b] from 7.7% to [b]7.1%[/b].' },
        { text: '[b]Financial position at 31 Dec 2025[/b], H$000: property, plant and equipment 16,836; inventories 5,508; receivables 14,600; cash 745.\n\nEquity 21,330; long-term borrowings 2,464 (unchanged); payables 13,075; tax payable 820.' },
        { text: '[b]Working capital grew fast[/b]: inventories up 1,687, receivables up 4,206 and payables up 3,746.\n\nReceivables went from about [b]66 to 80 days[/b] of revenue - customers are paying more slowly.' },
        { text: '[b]Cash flow 2025[/b], H$000: cash from operations 5,120; after interest (456) and tax (770), 3,894 from operating activities.\n\nIt spent 2,721 on new PPE and paid a 993 dividend, so cash rose just [b]180[/b], from 565 to 745.' },
        { text: 'Useful checks: PPE 16,659 + additions 2,721 - depreciation 2,544 = [b]16,836[/b].\n\nRetained earnings 18,126 + profit 3,447 - dividend 993 = [b]20,580[/b].' }],
      example: { title: 'Key ratios for 2025', steps: [
        'Step 1: Profitability. Gross margin = 14,716 / 66,933 = 22.0%. Operating margin = 4,723 / 66,933 = 7.1%.',
        'Step 2: Return. ROCE = operating profit / (equity + long-term debt) = 4,723 / (21,330 + 2,464) = 19.8%.',
        'Step 3: Liquidity. Current ratio = 20,853 / 13,895 = 1.50. Quick ratio = (20,853 - 5,508) / 13,895 = 1.10.',
        'Step 4: Working capital days. Receivables 14,600 / 66,933 x 365 = 80 days. Inventory 5,508 / 52,217 x 365 = 39 days.',
        'Step 5: Gearing and interest cover. Gearing = 2,464 / 23,794 = 10.4%. Interest cover = 4,723 / 456 = 10.4 times.'],
        table: { cols: ['Ratio', 'Working', '2025'], rows: [
          { c: ['Gross margin', '14,716 / 66,933', '22.0%'], s: 1 }, { c: ['Operating margin', '4,723 / 66,933', '7.1%'], s: 1 },
          { c: ['ROCE', '4,723 / 23,794', '19.8%'], s: 2 },
          { c: ['Current ratio', '20,853 / 13,895', '1.50'], s: 3 }, { c: ['Quick ratio', '15,345 / 13,895', '1.10'], s: 3 },
          { c: ['Receivable days', '14,600 / 66,933 x 365', '80'], s: 4 }, { c: ['Inventory days', '5,508 / 52,217 x 365', '39'], s: 4 },
          { c: ['Gearing', '2,464 / 23,794', '10.4%'], s: 5 }, { c: ['Interest cover', '4,723 / 456', '10.4x'], s: 5 }] } },
      practice: [
        { type: 'input', q: 'Revenue growth from 2024 (H$57,798k) to 2025 (H$66,933k), as a %?  (1 decimal place)', accept: ['15.8'], display_answer: '15.8', ex: '(66,933 - 57,798) / 57,798 = 9,135 / 57,798 = 15.8%.' },
        { type: 'choice', q: 'Gross margin improved in 2025 but operating margin fell. Why?', opts: ['Cost of sales rose faster than revenue', 'Administration and distribution expenses rose sharply', 'Finance costs doubled', 'Tax went up'], a: 1, ex: 'Admin and distribution costs rose from 7,008 to 9,993 (about 43%), eating the gross margin gain. Finance cost was unchanged at 456.' },
        { type: 'input', q: 'Current ratio at 31 Dec 2025 (current assets 20,853, current liabilities 13,895)?  (2 decimal places)', accept: ['1.50', '1.5'], display_answer: '1.50', ex: '20,853 / 13,895 = 1.50.' },
        { type: 'input', q: 'Receivable days in 2025 (receivables 14,600, revenue 66,933)?  (nearest whole day)', accept: ['80'], display_answer: '80', ex: '14,600 / 66,933 x 365 = 79.6, so 80 days (up from about 66 in 2024).' },
        { type: 'choice', q: 'Cash went up by only H$180k in 2025. Which was the BIGGEST cash outflow on working capital?', opts: ['Increase in inventories', 'Increase in receivables', 'Increase in payables', 'Dividend'], a: 1, ex: 'Receivables rose by 4,206 - the biggest working-capital drain. Payables rising (3,746) actually helped cash.' },
        { type: 'input', q: 'ROCE for 2025 = operating profit 4,723 / (equity 21,330 + borrowings 2,464), as a %?  (1 decimal place)', accept: ['19.8'], display_answer: '19.8', ex: '4,723 / 23,794 = 19.8%.' },
        { type: 'input', q: 'Retained earnings: 18,126 at 1 Jan + profit 3,447 - dividend 993 = ?  (H$000)', accept: ['20580', '20,580'], display_answer: '20,580', ex: '18,126 + 3,447 - 993 = 20,580, as in the statement of financial position.' }] },

    { id: 'L5', title: 'The 2026 budget and the standard cost card', outcome: 'Pre-seen - budgets and standards',
      learn: [
        { text: '[b]2026 budget[/b], H$000: revenue [b]76,061[/b] (potato crisps 45,483, ridged 18,275, popcorn 12,303), gross profit [b]18,340[/b].\n\nGross margin: potato 23%, ridged 26%, popcorn 26% - [b]24% overall[/b].' },
        { text: 'Budgeted cost of sales 57,721: direct materials 26,599, direct labour 10,195, variable production overhead 4,293, fixed production overhead [b]16,634[/b].\n\nProduction overheads are absorbed at [b]facility-wide rates per direct labour hour[/b].' },
        { text: 'Budgets are prepared [b]incrementally[/b] - last year\'s figures plus a change - and standards are [b]updated once a year[/b].\n\nWatch for this in tasks: incremental budgets can carry old inefficiencies forward.' },
        { text: '[b]Standard cost card: 1,000 bags of 40g potato crisps[/b]\n- materials H$180.65 (potatoes, flavourings, oil, packaging)\n- labour [b]3.97 hours[/b] at H$19 = H$75.43' },
        { text: '- variable overhead 3.97 hours x H$8 = H$31.76\n- fixed overhead 3.97 hours x H$31 = H$123.07\n\n[b]Total standard cost H$410.91[/b] per 1,000 bags - about [b]H$0.41 a bag[/b], against a selling price of H$0.48.' }],
      example: { title: 'Building the 40g cost card', steps: [
        'Step 1: Materials. Potatoes 78.00 + flavourings 7.80 + oil 14.85 + packaging 80.00 = 180.65.',
        'Step 2: Labour. (1.70 + 0.90 + 0.47 + 0.90) = 3.97 hours x H$19 = 75.43. Prime cost = 180.65 + 75.43 = 256.08.',
        'Step 3: Variable overhead 3.97 x 8 = 31.76, so marginal production cost = 287.84.',
        'Step 4: Fixed overhead 3.97 x 31 = 123.07, so full production cost = 410.91 per 1,000 bags.'],
        table: { cols: ['Line', 'Working', 'H$ per 1,000 bags'], rows: [
          { c: ['Materials', '78.00 + 7.80 + 14.85 + 80.00', '180.65'], s: 1 },
          { c: ['Direct labour', '3.97 hrs x 19.00', '75.43'], s: 2 }, { c: ['Prime cost', '180.65 + 75.43', '256.08'], s: 2 },
          { c: ['Variable overhead', '3.97 hrs x 8.00', '31.76'], s: 3 }, { c: ['Marginal cost', '256.08 + 31.76', '287.84'], s: 3 },
          { c: ['Fixed overhead', '3.97 hrs x 31.00', '123.07'], s: 4 }, { c: ['Full production cost', '287.84 + 123.07', '410.91'], s: 4 }] } },
      practice: [
        { type: 'input', q: 'Budgeted 2026 gross profit is H$18,340k on revenue of H$76,061k. Gross margin %?  (whole number)', accept: ['24'], display_answer: '24', ex: '18,340 / 76,061 = 24.1%, so 24%.' },
        { type: 'choice', q: 'On what basis are production overheads absorbed?', opts: ['Machine hours', 'Units produced', 'Direct labour hours, at facility-wide rates', 'Percentage of materials cost'], a: 2, ex: 'Both fixed and variable production overheads are absorbed using facility-wide rates per direct labour hour.' },
        { type: 'input', q: 'Prime cost per 1,000 bags of 40g crisps = materials 180.65 + labour 75.43 = ?  (H$, 2 decimals)', accept: ['256.08'], display_answer: '256.08', ex: 'Prime cost = direct materials + direct labour = 180.65 + 75.43 = 256.08.' },
        { type: 'input', q: 'Marginal (variable) production cost per 1,000 bags = prime cost 256.08 + variable overhead 31.76 = ?  (H$, 2 decimals)', accept: ['287.84'], display_answer: '287.84', ex: '256.08 + 31.76 = 287.84. Fixed overhead is left out under marginal costing.' },
        { type: 'input', q: 'If the labour rate rose to H$20 an hour, standard labour cost per 1,000 bags = 3.97 hours x 20 = ?  (H$, 2 decimals)', accept: ['79.40', '79.4'], display_answer: '79.40', ex: '3.97 x 20 = 79.40, up from 75.43 at H$19.' },
        { type: 'choice', q: 'Crafted Crisps prepares its budgets incrementally. What is the main risk?', opts: ['Too much time spent justifying every cost', 'Past inefficiencies and slack get carried forward', 'Budgets ignore inflation', 'Managers cannot take part'], a: 1, ex: 'Incremental budgeting starts from last year\'s figures, so waste built into them tends to continue. Justifying every cost from zero is zero-based budgeting.' },
        { type: 'multi', q: 'Which TWO product groups have a budgeted gross margin of 26%?', opts: ['Potato crisps', 'Ridged crisps', 'Popcorn', 'All products together'], a: [1, 2], ex: 'Ridged crisps 4,812 / 18,275 = 26% and popcorn 3,225 / 12,303 = 26%. Potato crisps are 23% and the total 24%.' }] }],
  beats: [
    { type: 'choice', q: 'Where is Crafted Crisps based?', opts: ['Harland, in Western Europe', 'The north of Harland', 'Ireland', 'France'], a: 0, ex: 'A privately owned company in Harland; its single site is in the south of the country.' },
    { type: 'choice', q: 'Which product was added most recently (2019)?', opts: ['Ridged crisps', 'Popcorn', 'Truffle & Rosemary crisps', 'Reduced fat crisps'], a: 1, ex: 'Ridged crisps came in 2018; luxury popcorn and tins in 2019. Reduced fat crisps are only a plan.' },
    { type: 'input', q: '2025 operating profit 4,723 / finance cost 456 = interest cover?  (1 decimal place)', accept: ['10.4'], display_answer: '10.4', ex: '4,723 / 456 = 10.4 times - borrowing is comfortably covered.' },
    { type: 'choice', q: 'Which department checks and accepts raw materials when they arrive?', opts: ['Facilities', 'Goods Inwards', 'Packing', 'Distribution'], a: 1, ex: 'Goods Inwards buys raw materials, checks them on arrival and manages raw material inventory.' },
    { type: 'input', q: 'Fixed overhead per 1,000 bags = 3.97 labour hours x H$31 = ?  (H$, 2 decimals)', accept: ['123.07'], display_answer: '123.07', ex: '3.97 x 31 = 123.07.' },
    { type: 'choice', q: 'What happens to a batch that comes out overcooked?', opts: ['Sold as seconds', 'Re-flavoured', 'Taken off the line and disposed of', 'Used in popcorn'], a: 2, ex: 'Overcooked or blemished batches are removed and disposed of - a loss in the process.' },
    { type: 'input', q: 'Inventory days 2025: inventories 5,508 / cost of sales 52,217 x 365 = ?  (nearest day)', accept: ['39'], display_answer: '39', ex: '5,508 / 52,217 x 365 = 38.5, so 39 days (about 30 in 2024).' },
    { type: 'choice', q: 'Who is Finance Manager, directly above the finance officers and apprentices?', opts: ['Nathan Price', 'Sarya Ghosh', 'Stephen Reid', 'Theo Tomlin'], a: 0, ex: 'Nathan Price is Finance Manager, reporting to Sarya Ghosh (Finance Senior Manager), who reports to Carys Wren.' },
    { type: 'input', q: 'Budgeted revenue growth: 2026 budget 76,061 vs 2025 actual 66,933, as a %?  (1 decimal place)', accept: ['13.6'], display_answer: '13.6', ex: '(76,061 - 66,933) / 66,933 = 13.6%.' },
    { type: 'choice', q: 'Standard cost of one 40g bag is about H$0.41 and it sells for H$0.48. Standard gross profit per bag?', opts: ['H$0.04', 'H$0.07', 'H$0.41', 'H$0.89'], a: 1, ex: '0.48 - 0.41 = H$0.07 (exactly 0.48 - 0.411 = 0.069).' },
    { type: 'multi', q: 'Which TWO were cash outflows from investing or financing in 2025?', opts: ['PPE purchases 2,721', 'Depreciation 2,544', 'Dividend 993', 'Increase in payables 3,746'], a: [0, 2], ex: 'PPE purchases (investing) and the dividend (financing). Depreciation is not cash; payables rising is a working-capital inflow.' },
    { type: 'choice', q: 'How is the third-party logistics company relevant to costs?', opts: ['Its costs are production overheads', 'Delivery is an outsourced distribution cost', 'It owns the Distribution Centre', 'It supplies the potatoes'], a: 1, ex: 'Distribution is outsourced, so delivery costs are bought-in distribution expenses, not production costs.' }]
});
e.cards.push(
  { ch: 14, f: 'Crafted Crisps - who, where, what?', b: 'Privately owned (Makin and Fowler families), Harland, H$.\nPremium hand-cooked potato crisps, ridged crisps and popcorn from local ingredients.' },
  { ch: 14, f: 'Your role in the Role Simulation', b: 'Finance Apprentice in the Finance Department, helping different team members.' },
  { ch: 14, f: 'The single site holds...', b: 'Head Office, Production Facility and Distribution Centre (south of Harland).\n298 staff: 256 production, 42 management and admin.' },
  { ch: 14, f: 'Finance team, top to bottom', b: 'Carys Wren (FD) > Sarya Ghosh (Senior Manager) > Nathan Price (Manager) > 3 officers + 2 apprentices.' },
  { ch: 14, f: 'Production and service departments', b: 'Production: Ingredient Preparation, Cooking, Flavouring, Packing.\nService: Goods Inwards, Facilities.' },
  { ch: 14, f: '2025 revenue, gross margin, operating margin', b: 'H$66.93m, 22%, 7% (2024: 57.80m, 19.8%, 7.7%).' },
  { ch: 14, f: '2025 liquidity', b: 'Current ratio 1.50, quick ratio 1.10, receivable days 80 (66 in 2024), cash up only H$180k.' },
  { ch: 14, f: 'Why did operating margin fall in 2025?', b: 'Admin and distribution costs rose about 43% (7,008 to 9,993), more than the gross margin gain.' },
  { ch: 14, f: '2026 budget', b: 'Revenue H$76.06m, gross profit H$18.34m, 24% margin.\nPotato 23%, ridged 26%, popcorn 26%.' },
  { ch: 14, f: 'Overhead absorption basis', b: 'Facility-wide rates per direct labour hour.\nVariable H$8 / hour, fixed H$31 / hour.' },
  { ch: 14, f: 'Standard cost of 1,000 x 40g bags', b: 'Materials 180.65 + labour 75.43 + variable OH 31.76 + fixed OH 123.07 = H$410.91 (3.97 labour hours at H$19).' },
  { ch: 14, f: 'Budgeting method', b: 'Incremental budgets; standards updated once a year.' },
  { ch: 14, f: 'Why so much potato inventory?', b: 'One crop a year (harvest Sept-Oct), so potatoes are stored in climate-controlled stores all year.' },
  { ch: 14, f: 'Future plans', b: 'Reduced fat range; subscription and gifting by post; compostable plastic-free bag; more places to buy.' });
})();
