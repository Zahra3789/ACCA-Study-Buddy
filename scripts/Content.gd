extends Node
# Autoload singleton "Content" — ALL game text and questions live here as plain
# data, so everything is compiled into the APK (no external files needed to run).
#
# ============================  STRUCTURE  ============================
# EXAMS -> each exam -> chapters -> beats.
#   EXAMS = [ { id, name, chapters:[ { id, title, monster, beats:[...] } ] } ]
#
# Beat types:
#   story     : {speaker, text}
#   taccount  : {speaker, text, name, dr[], cr[], dr_total, cr_total}
#   choice    : {q, opts[], a, ex}                 # tap; a = index of answer (0-based)
#   input     : {q, accept[], display_answer, ex}  # type the number/term
#
# ============================  HOW TO GROW IT  ============================
# * Add questions to a chapter  -> add more choice/input beats to its "beats".
# * Add a chapter (new monster) -> copy a chapter block, change id/title/monster/beats.
# * Add a whole new exam         -> copy an EXAMS block (e.g. {"id":"MA", ...}).
#
# Planned modes (next build): a mixed general-knowledge boss, a question bank by
# topic/type, and a timed 2-hour exam mock — all reuse these question pools.
#
# note: these are ORIGINAL exam-style questions. Don't paste the Exam Kit
# in wholesale (copyright). Individual questions you own can be added one at a time.

const EXAMS := [
	{
		"id": "FFA",
		"name": "FFA - Foundations of Financial Accounting",
		# Chapters follow the FA/FFA study text (26 chapters) so they can be cross-referenced with the book.
		"chapters": [
			{
				"id": 1, "title": "Introduction to accounting", "monster": "The Gatekeeper Spirit",
				"beats": [
					{"type":"choice","q":"Who are the PRIMARY users of general purpose financial statements?","opts":["Investors, lenders and other creditors","Competitors","Tax inspectors only","The general public"],"a":0,"ex":"The Conceptual Framework names existing and potential investors, lenders and other creditors as the primary users."}
				],
				# Ch 1 learning objectives: A1(a)-(e), A2(a), A3(a), A3(b), A5(a), A5(b).
				"lessons": [
					{
						"id": "L1", "title": "What is financial reporting?",
						"outcome": "A1(a) Define financial reporting; A1(e) Nature, principles and scope of financial reporting",
						"apply": {"title": "Zuru's Lemonade Stand - the shoebox", "pages": [
							{"text": "Zuru opens a hot yuzu-lemonade stand at the dojo gate with [b]500[/b] of her own savings. Every day she drops receipts, invoices and a handful of coins into a [b]shoebox[/b]. After a month her friend Hana asks: \"So - did you make any money?\"\n\nZuru has no idea. The shoebox knows, but it isn't talking."},
							{"text": "[b]Financial reporting[/b] is turning that shoebox into answers:\n- [b]How did the stand perform[/b] this month? (income less expenses = profit)\n- [b]What does it own and owe[/b] at the end of the month? (cart, lemons, cash, the money owed to the lemon supplier)\n\nThe answers are written up as financial statements that anyone can read - Hana, a lender, the tax office."},
							{"text": "The flow is always the same, from a lemonade stand to a bank:\n[b]Record[/b] every transaction -> [b]Summarise[/b] them in accounts -> [b]Report[/b] the totals in financial statements.\n\nThe next 25 chapters teach exactly that journey - with Zuru's stand growing as we go.", "table": {"cols": ["Shoebox item", "What it tells the accounts"], "rows": [{"c": ["Till roll: 100 cups x 2", "Sales 200"]}, {"c": ["Kenji's lemon invoice", "Purchases 80, owed to Kenji"]}, {"c": ["Receipt for the cart", "An asset, 200"]}, {"c": ["Stall rent receipt", "Expense 40"]}]}}
						]},
						"learn": [
							{"text": "Every business makes [b]transactions[/b]: it sells goods, buys stock, pays wages, borrows money. On their own these are just thousands of separate events."},
							{"text": "[b]Financial reporting[/b] turns them into useful information in three stages:\n[b]Recording[/b] - writing every transaction down.\n[b]Analysing[/b] - sorting them into categories (sales, wages, rent...).\n[b]Summarising[/b] - adding them up into the financial statements."},
							{"text": "[b]Nature:[/b] financial reports are mainly for people [b]outside[/b] the business - investors, lenders, suppliers - who can't ask for their own tailor-made reports. So they get [b]general purpose financial statements[/b]."},
							{"text": "[b]Principles:[/b] to be trusted and compared, reports follow agreed rules - accounting [b]concepts[/b] and [b]IFRS Accounting Standards[/b] (Chapters 2 and 3).\n\n[b]Scope:[/b] the main financial statements plus [b]notes[/b] that explain the figures, usually prepared every year."},
							{"text": "One key idea from day one: the [b]separate entity concept[/b]. The business is treated as separate from its owner, so the owner's personal spending never goes into the business's records - even for a one-person business."}
						],
						"example": {"title": "Mia's Bakery: from events to statements", "table": {"cols": ["Stage", "What happens", "Mia's Bakery"], "rows": [
							{"c": ["Record", "Each transaction is written down", "Sold 40 cakes for 120"], "s": 1},
							{"c": ["Analyse", "Sorted into categories", "120 goes to 'Sales'"], "s": 2},
							{"c": ["Summarise", "Totals go into the statements", "Sales for the year 52,000"], "s": 3}]},
							"steps": ["Recording: every sale, purchase and payment is written down when it happens.", "Analysing: each one is sorted into the right category so like items sit together.", "Summarising: the categories are totalled into the financial statements, e.g. sales of 52,000 for the year."]},
						"practice": [
							{"type": "choice", "q": "Financial reporting is best described as:", "opts": ["Recording, analysing and summarising financial data", "Preparing budgets and forecasts for managers", "Calculating the tax a business owes", "Checking the financial statements are free from error"], "a": 0, "ex": "Financial reporting records, analyses and summarises financial data. Budgets are management accounting, and checking for errors is the auditor's role."},
							{"type": "choice", "q": "General purpose financial statements are prepared for:", "opts": ["A wide range of external users who cannot demand reports tailored to their needs", "Managers only", "The tax authority only", "One specific lender"], "a": 0, "ex": "General purpose statements serve external users - investors, lenders and other creditors - who rely on them because they can't ask for their own reports."},
							{"type": "picklist", "q": "The owner's personal shopping is {0} in the business's records because of the {1} concept.", "lists": [["excluded", "included"], ["separate entity", "going concern", "prudence"]], "a": [0, 0], "ex": "The separate entity concept keeps the owner's personal affairs out of the business's records."},
							{"type": "multi", "q": "Which TWO of the following fall within the scope of financial reporting?", "opts": ["Producing a statement of financial position at the year-end", "Preparing notes that explain the figures", "Setting next year's sales targets", "Deciding staff pay rises"], "a": [0, 1], "ex": "Financial reporting covers the financial statements and their notes. Targets and pay decisions are management decisions."}
						]
					},
					{
						"id": "L2", "title": "Sole trader, partnership or company?",
						"outcome": "A1(b) Types of business entity; A1(c) Legal differences; A1(d) Advantages and disadvantages",
						"apply": {"title": "Zuru's Lemonade Stand - who owns it?", "pages": [
							{"text": "Month 1: Zuru runs the stand alone. She is a [b]sole trader[/b]. All the profit is hers - but so is all the risk. If the cart rolls into a parked car, the owner can come after [b]Zuru's own savings[/b], not just the stand's cash. There is no legal line between Zuru and the business."},
							{"text": "Month 3: Hana joins, putting in 300 and working weekends. Now it is a [b]partnership[/b]. They share the profits in whatever ratio they agree, make decisions together - and each is still personally liable for the partnership's debts."},
							{"text": "Month 12: a cafe wants to stock Zuru's lemonade and a bank will lend for a second cart. They form [b]Zuru Lemonade Ltd[/b]. The company is a [b]separate legal person[/b]: it owns the carts, signs the contracts and owes the debts. Zuru and Hana are shareholders with [b]limited liability[/b] - the most they can lose is what they paid for their shares. The price: more rules, accounts to file, and directors' duties (Lesson 5).", "table": {"cols": ["", "Sole trader", "Partnership", "Company"], "rows": [{"c": ["Owners", "Zuru", "Zuru + Hana", "Shareholders"]}, {"c": ["Liability", "Unlimited", "Unlimited", "Limited to shares"]}, {"c": ["Separate legal person?", "No", "No", "Yes"]}, {"c": ["Set-up and admin", "Easy", "Easy, agreement", "Formal, accounts filed"]}]}}
						]},
						"learn": [
							{"text": "There are three types of business entity to know: the [b]sole trader[/b], the [b]partnership[/b] and the [b]limited liability company[/b]."},
							{"text": "[b]Sole trader:[/b] a business owned and run by [b]one person[/b]. Easy and cheap to set up, the owner keeps all the profit and has full control, and the accounts stay private.\n\nBut the owner has [b]unlimited liability[/b]: if the business can't pay its debts, the owner's personal assets (house, savings) can be used to pay them."},
							{"text": "[b]Partnership:[/b] two or more people carrying on a business together [b]with a view to profit[/b]. A partnership agreement usually sets out how profits are shared.\n\nMore people means more money and skills - but partners normally have unlimited liability, can disagree, and can be liable for each other's business debts."},
							{"text": "[b]Limited liability company:[/b] a [b]separate legal person[/b] - it owns assets, owes debts, signs contracts and can sue or be sued in its own name. It is owned by [b]shareholders[/b] and run by [b]directors[/b]."},
							{"text": "[b]Limited liability[/b]: shareholders can lose only what they invested in their shares - their personal assets are protected. The company also continues if its shareholders change, and can raise money by issuing shares.\n\nThe cost: more [b]regulation[/b] - company law, published accounts, and an audit for larger companies."},
							{"text": "Remember the difference between [b]law[/b] and [b]accounting[/b]: legally a sole trader and their business are the same person, but in the [b]accounts[/b] we still treat the business separately (the separate entity concept)."}
						],
						"example": {"title": "Comparing the three", "table": {"cols": ["", "Sole trader", "Partnership", "Company"], "rows": [
							{"c": ["Owners", "1 person", "2 or more partners", "Shareholders"], "s": 1},
							{"c": ["Separate legal person?", "No", "No", "Yes"], "s": 2},
							{"c": ["Owners' liability", "Unlimited", "Usually unlimited", "Limited to shares"], "s": 2},
							{"c": ["Raising finance", "Hard", "Partners' capital", "Easier - issue shares"], "s": 3},
							{"c": ["Regulation and publishing", "Low", "Low", "High"], "s": 3}]},
							"steps": ["Who owns it: one person, two or more partners, or shareholders.", "The big legal difference: only a company is a separate legal person, so only shareholders have limited liability.", "The trade-off: a company can raise finance more easily, but faces far more regulation and must publish its accounts."]},
						"practice": [
							{"type": "sort", "q": "Match each feature to the type of business entity.", "buckets": ["Sole trader", "Partnership", "Company"], "items": [["Owned and run by one person", 0], ["Two or more people in business together for profit", 1], ["Owners' liability limited to their shares", 2], ["Can sue and be sued in its own name", 2], ["Profits shared under an agreement between the owners", 1], ["One owner takes all the profit and all the risk", 0]], "ex": "A company is a separate legal person with limited liability. Partnerships share profits under an agreement. A sole trader is one owner with all the profit and risk."},
							{"type": "multi", "q": "Which TWO are advantages of operating as a limited liability company rather than as a sole trader?", "opts": ["Shareholders' personal assets are protected from the business's debts", "It is easier to raise finance by issuing shares", "There are fewer legal and regulatory requirements", "Its accounts do not need to be published"], "a": [0, 1], "ex": "Limited liability and easier fundraising are advantages. Companies face MORE regulation and must publish their accounts - those are disadvantages."},
							{"type": "choice", "q": "Which of the following is a DISADVANTAGE of being a sole trader?", "opts": ["Unlimited personal liability for the business's debts", "Annual accounts must be published", "Profits must be shared with shareholders", "Directors must be appointed"], "a": 0, "ex": "A sole trader's personal assets are at risk. The other options describe companies."},
							{"type": "choice", "q": "Which statement about a limited liability company is TRUE?", "opts": ["It continues to exist even if its shareholders change", "It is legally the same person as its shareholders", "Its shareholders are personally liable for all its debts", "It cannot borrow money in its own name"], "a": 0, "ex": "A company is a separate legal person, so it carries on when shares change hands, can borrow in its own name, and its shareholders' liability is limited."},
							{"type": "choice", "q": "A partnership cannot pay all its debts from business assets. Normally:", "opts": ["The partners are personally liable for the unpaid debts", "The unpaid debts are written off", "Only the partner who ran up the debt is liable", "The debts are transferred to a new company"], "a": 0, "ex": "Partners normally have unlimited liability, so creditors can claim the unpaid debts from the partners personally."}
						]
					},
					{
						"id": "L3", "title": "The financial statements and the five elements",
						"outcome": "A3(a) Purpose of each financial statement; A3(b) Define assets, liabilities, equity, income and expenses",
						"apply": {"title": "Zuru's Lemonade Stand - month 1 in two statements", "pages": [
							{"text": "Zuru's first month, sorted out of the shoebox:\n- Put in [b]500[/b] of savings (capital)\n- Bought a cart for [b]200[/b] cash\n- Bought lemons, yuzu and sugar for [b]80[/b] on credit from Kenji, the greengrocer\n- Sold 100 cups at 2 = [b]200[/b] cash\n- Used [b]60[/b] of the ingredients; 20 are still in the box\n- Paid [b]40[/b] stall rent\n\nEvery one of these is an asset, a liability, equity, income or an expense."},
							{"text": "The [b]statement of profit or loss[/b] answers \"did I make money?\" - income less expenses for the month.", "table": {"cols": ["Statement of profit or loss - month 1", ""], "rows": [{"c": ["Sales (income)", "200"]}, {"c": ["Cost of ingredients used (expense)", "(60)"]}, {"c": ["Stall rent (expense)", "(40)"]}, {"c": ["Profit for the month", "100"], "b": true}]}},
							{"text": "The [b]statement of financial position[/b] answers \"what do I own and owe right now?\" Cash: 500 - 200 + 200 - 40 = 460. Notice it balances: assets 680 = equity 600 + liabilities 80. Equity went up by exactly the 100 profit.", "table": {"cols": ["Statement of financial position - end of month 1", ""], "rows": [{"c": ["Cart (asset)", "200"]}, {"c": ["Ingredients left (asset)", "20"]}, {"c": ["Cash (asset)", "460"]}, {"c": ["Total assets", "680"], "b": true}, {"c": ["Capital 500 + profit 100 (equity)", "600"]}, {"c": ["Owed to Kenji (liability)", "80"]}, {"c": ["Equity + liabilities", "680"], "b": true}]}}
						]},
						"learn": [
							{"text": "The main financial statements:\n[b]Statement of financial position[/b] (SOFP) - assets and liabilities at ONE date, a snapshot.\n[b]Statement of profit or loss and other comprehensive income[/b] - income and expenses over a PERIOD: did the business make a profit?"},
							{"text": "[b]Statement of changes in equity[/b] (SOCE) - how the owners' interest moved in the period: profit, dividends, new shares.\n[b]Statement of cash flows[/b] (SOCF) - where cash came from and went, split into operating, investing and financing."},
							{"text": "The statements are built from five [b]elements[/b]. An [b]asset[/b] is a present economic resource the entity [b]controls[/b] as a result of [b]past events[/b]. An economic resource is a right that can produce economic benefits - e.g. a van, inventory, money owed by customers."},
							{"text": "A [b]liability[/b] is a present [b]obligation[/b] to transfer an economic resource as a result of [b]past events[/b] - a duty the entity has no practical ability to avoid, e.g. a bank loan or money owed to suppliers."},
							{"text": "[b]Equity[/b] is what is left for the owners: [b]Assets - Liabilities = Equity[/b].\n\n[b]Income[/b] increases equity (more assets or fewer liabilities), and [b]expenses[/b] decrease it. Money paid IN by owners is not income, and money taken OUT by owners is not an expense."}
						],
						"example": {"title": "Sorting Mia's Bakery items into elements", "table": {"cols": ["Item", "Element", "Why"], "rows": [
							{"c": ["Oven owned by the bakery", "Asset", "Resource it controls"], "s": 1}, {"c": ["Cakes in stock", "Asset", "Will be sold for cash"], "s": 1},
							{"c": ["Bank loan", "Liability", "Must be repaid"], "s": 2}, {"c": ["Owed to the flour supplier", "Liability", "Must be paid"], "s": 2},
							{"c": ["Cake sales", "Income", "Increases equity"], "s": 3}, {"c": ["Staff wages", "Expense", "Decreases equity"], "s": 3},
							{"c": ["Mia's capital", "Equity", "Assets - liabilities"], "s": 4}]},
							"steps": ["Things the bakery controls that bring future benefit are assets: the oven and the cakes in stock.", "Things it is obliged to pay are liabilities: the bank loan and the supplier.", "Sales increase equity (income); wages reduce it (expense).", "What's left for Mia after the liabilities is her equity (capital)."]},
						"practice": [
							{"type": "choice", "q": "Which statement shows a business's financial PERFORMANCE over a period?", "opts": ["Statement of profit or loss and other comprehensive income", "Statement of financial position", "Statement of changes in equity", "The general ledger"], "a": 0, "ex": "Performance (profit or loss) over a period is in the SOPL and OCI. The SOFP is a snapshot of position at one date."},
							{"type": "sort", "q": "Classify each item as one of the elements.", "buckets": ["Asset", "Liability", "Income", "Expense"], "items": [["Delivery van owned", 0], ["Bank loan", 1], ["Sales to customers", 2], ["Wages for the year", 3], ["Amounts owed by customers", 0], ["Amounts owed to suppliers", 1]], "ex": "Resources the business controls are assets; obligations are liabilities; sales increase equity (income); wages decrease it (expense)."},
							{"type": "input", "q": "A business has total assets of 85,000 and total liabilities of 32,000. What is its equity?  (number)", "accept": ["53000"], "display_answer": "53,000", "ex": "Equity = Assets - Liabilities = 85,000 - 32,000 = 53,000."},
							{"type": "picklist", "q": "A liability is a present {0} of the entity to transfer an economic resource as a result of {1} events.", "lists": [["obligation", "right", "expense"], ["past", "future", "expected"]], "a": [0, 0], "ex": "A liability is a present OBLIGATION arising from PAST events."},
							{"type": "choice", "q": "Which of the following is NOT income?", "opts": ["Capital paid into the business by the owner", "Sales revenue", "Interest received", "Rent received from a tenant"], "a": 0, "ex": "Contributions from the owners increase equity but are not income. The others are income."}
						]
					},
					{
						"id": "L4", "title": "Who uses financial statements, and why?",
						"outcome": "A2(a) Users of financial statements and their information needs",
						"apply": {"title": "Zuru's Lemonade Stand - who wants to see the numbers?", "pages": [
							{"text": "Zuru pins month 1's statements (profit 100, assets 680) to the cart. Within a week, six different people want a look - and each is asking a [b]different question[/b]."},
							{"text": "", "table": {"cols": ["Who", "Their question", "What they look at"], "rows": [{"c": ["Zuru (manager/owner)", "Is yuzu or plain selling better? Can I afford a heater?", "Sales by flavour, cash"]}, {"c": ["Hana (lender of 300)", "Will I get my 300 back, plus interest?", "Profit, cash, debts"]}, {"c": ["Kenji (supplier)", "Will she pay my 80 on time? Give her more credit?", "Cash, what she owes"]}, {"c": ["Tax office", "How much tax is due on 100 profit?", "Profit"]}, {"c": ["Bank", "Lend for a second cart?", "Profit trend, assets, debts"]}, {"c": ["Yuki (weekend helper)", "Is my job safe? Can she pay me?", "Profit, cash"]}]}},
							{"text": "Same statements, different needs. The owner-manager wants detail (management information, daily); outsiders only get the published statements, so those must be clear, reliable and comparable. That is why chapters 2 and 3 are about the [b]rules[/b] and the [b]qualities[/b] of good financial information."}
						]},
						"learn": [
							{"text": "Different people read the same statements for different reasons. The exam tests [b]who[/b] the users are and [b]what each needs[/b]."},
							{"text": "[b]Management[/b] - detailed information to plan, control and make decisions (they get far more detail than outsiders).\n[b]Shareholders / investors[/b] - profit and returns: buy, hold or sell? Dividends?"},
							{"text": "[b]Lenders[/b] (banks) - can the business repay the loan and interest?\n[b]Suppliers and other trade creditors[/b] - will we be paid on time?\n[b]Customers[/b] - will the business keep trading and supplying us?"},
							{"text": "[b]Employees[/b] - job security and the ability to pay wages and pensions.\n[b]Government[/b] - tax, statistics and regulation.\n[b]Analysts and advisers[/b] - to advise their clients.\n[b]The public[/b] - the effect on jobs, the local economy and the environment."}
						],
						"example": {"title": "Users and their needs", "table": {"cols": ["User", "Main question"], "rows": [
							{"c": ["Shareholders", "Is my investment earning a good return?"], "s": 1}, {"c": ["Lenders", "Can they repay me with interest?"], "s": 1},
							{"c": ["Suppliers", "Will I be paid on time?"], "s": 2}, {"c": ["Employees", "Is my job and pay secure?"], "s": 2},
							{"c": ["Government", "How much tax? Economic statistics?"], "s": 3}, {"c": ["Management", "How do we plan and control?"], "s": 3}]},
							"steps": ["Investors and lenders: return on investment versus ability to repay.", "Suppliers and employees: being paid, and the business continuing.", "Government needs tax and statistics; management needs detailed information for decisions."]},
						"practice": [
							{"type": "choice", "q": "A bank is deciding whether to lend to a business. It is MOST interested in:", "opts": ["Whether the business can repay the loan and interest", "The dividend paid to shareholders", "The number of employees", "The business's market share"], "a": 0, "ex": "Lenders care most about repayment of the loan and interest - liquidity and future cash flows."},
							{"type": "choice", "q": "Which user needs the MOST detailed information, to plan and control the business?", "opts": ["Management", "Shareholders", "Government", "The public"], "a": 0, "ex": "Managers run the business day to day, so they need detailed internal information beyond the published statements."},
							{"type": "multi", "q": "Which TWO of the following are information needs of employees?", "opts": ["Job security", "Whether wages and pensions can be paid", "The tax due to the government", "Whether to buy more shares"], "a": [0, 1], "ex": "Employees want to know their jobs and pay are secure. Tax is the government's interest; buying shares is an investor's decision."},
							{"type": "sort", "q": "Match each information need to the user most interested in it.", "buckets": ["Shareholders", "Lenders", "Government"], "items": [["Whether to buy, hold or sell shares", 0], ["Dividend prospects", 0], ["Security for a loan", 1], ["Ability to pay interest", 1], ["Tax due", 2], ["Economic statistics", 2]], "ex": "Shareholders focus on returns; lenders on repayment and security; government on tax and statistics."}
						]
					},
					{
						"id": "L5", "title": "Corporate governance and directors' duties",
						"outcome": "A5(a) Governance in preparing financial statements; A5(b) Directors' duties for the financial statements",
						"apply": {"title": "Zuru Lemonade Ltd - someone else's money", "pages": [
							{"text": "Zuru Lemonade Ltd needs a second cart and a proper kitchen. Hana's uncle Taro puts in [b]2,000[/b] for shares - but he lives 300 miles away and will never squeeze a lemon. Zuru and Hana are the [b]directors[/b]; Taro is an [b]owner who is not there[/b].\n\nThat gap between the people who own a company and the people who run it is what [b]governance[/b] is about."},
							{"text": "Taro only sees the company through its [b]financial statements[/b]. So the law puts duties on the directors:\n- keep [b]proper accounting records[/b] (no more shoebox)\n- prepare financial statements each year that give a [b]true and fair view[/b], following the standards\n- [b]act in the company's interest[/b], not their own - Zuru can't pay herself a bonus out of Taro's 2,000 and hide it\n- [b]file[/b] the accounts so they are public"},
							{"text": "If the company grows, the shareholders may appoint an [b]auditor[/b] to check that the statements are true and fair - Taro's independent pair of eyes. Good governance (clear duties, honest records, independent checks) is what lets strangers trust the numbers and invest."}
						]},
						"learn": [
							{"text": "[b]Corporate governance[/b] is the system by which companies are [b]directed and controlled[/b]."},
							{"text": "Why it matters: in a company the [b]owners[/b] (shareholders) and the [b]managers[/b] (directors) are often different people. Directors might act in their own interest - for example making profit look better to earn a bonus. Good governance protects the owners from that conflict of interest."},
							{"text": "The [b]directors[/b] are responsible for the financial statements. They must:\n- prepare statements that give a [b]true and fair view[/b] and follow the applicable rules (e.g. IFRS)\n- keep [b]adequate accounting records[/b]\n- choose suitable accounting policies and apply them consistently"},
							{"text": "They must also:\n- make reasonable judgements and estimates\n- assess whether the company is a [b]going concern[/b]\n- protect the company's assets and set up [b]internal controls[/b] to prevent and detect fraud and error"},
							{"text": "The [b]external auditor[/b] checks the statements and gives an independent [b]opinion[/b] on them - but responsibility for preparing them always stays with the [b]directors[/b]."}
						],
						"practice": [
							{"type": "choice", "q": "Corporate governance is:", "opts": ["The system by which companies are directed and controlled", "The audit of a company's financial statements", "The tax rules that apply to companies", "The process of issuing new shares"], "a": 0, "ex": "Corporate governance is the system by which companies are directed and controlled."},
							{"type": "choice", "q": "Who is responsible for preparing a company's financial statements?", "opts": ["The directors", "The external auditors", "The shareholders", "The tax authority"], "a": 0, "ex": "The directors prepare the statements. The auditor only gives an opinion on them."},
							{"type": "multi", "q": "Which TWO are responsibilities of directors in relation to the financial statements?", "opts": ["Keeping adequate accounting records", "Taking reasonable steps to prevent and detect fraud", "Giving an independent opinion on the financial statements", "Guaranteeing that the company makes a profit"], "a": [0, 1], "ex": "Directors keep proper records and set up controls against fraud and error. The independent opinion is the auditor's job, and nobody can guarantee a profit."},
							{"type": "choice", "q": "Good corporate governance is important MAINLY because:", "opts": ["The owners and the managers of a company are often different people", "Companies must pay tax", "Sole traders have unlimited liability", "Financial statements are prepared annually"], "a": 0, "ex": "Separating ownership (shareholders) from control (directors) can create conflicts of interest - governance manages that."},
							{"type": "picklist", "q": "The external auditor {0} the financial statements, but responsibility for them stays with the {1}.", "lists": [["gives an opinion on", "prepares", "approves"], ["directors", "auditors", "shareholders"]], "a": [0, 0], "ex": "Auditors give an independent opinion; directors remain responsible for preparing the statements."}
						]
					}
				]
			},
			{
				"id": 2, "title": "The regulatory framework", "monster": "The Standards Sentinel",
				"beats": [
					{"type":"choice","q":"Which body writes IFRS Standards?","opts":["The IASB","The external auditors","The IFRS Foundation","The directors"],"a":0,"ex":"The IASB develops and issues IFRS Standards; the IFRS Foundation oversees it."}
				],
				# Ch 2 learning objectives: A4(a), A4(b). Exam: knowledge questions on what each body does.
				"lessons": [
					{
						"id": "L1", "title": "Who sets the rules?",
						"outcome": "A4(a) The regulatory system: IFRS Foundation, IASB, IFRS Advisory Council, IFRS Interpretations Committee, ISSB",
						"apply": {"title": "Zuru's Lemonade Stand - whose rules?", "pages": [
							{"text": "Zuru asks three people the same question: \"My cart cost 200 - is that an expense this month, or not?\"\n- Hana: \"Expense, you paid cash.\"\n- Kenji: \"Spread it over the years you use it.\"\n- Taro: \"Depends how much tax you want to pay.\"\n\nThree answers, three different profits. If every business picked its own rules, nobody could compare Zuru's stand with the cafe down the road. That is why there are [b]accounting standards[/b]."},
							{"text": "The people behind the rules, mapped to Zuru's question:", "table": {"cols": ["Body", "What it does", "For Zuru"], "rows": [{"c": ["IFRS Foundation", "Oversees everything, raises funds", "Keeps the rule-makers independent"]}, {"c": ["IASB", "Writes the IFRS Accounting Standards", "The standard that says: cart = asset, spread the cost"]}, {"c": ["IFRS Interpretations Committee", "Clarifies standards when practice is unclear", "If people read the cart rule two ways"]}, {"c": ["IFRS Advisory Council", "Advises the IASB on priorities", "Tells the IASB what small businesses need"]}, {"c": ["ISSB", "Writes sustainability disclosure standards", "If Zuru Lemonade Ltd reports its paper-cup footprint"]}]}},
							{"text": "The standards themselves have no legal force - each country decides whether to adopt them, and in many countries company law then requires them. The pay-off: a Zuru Lemonade statement reads the same way in Tokyo, London or Lagos, so Taro can compare it with any other business he might invest in."}
						]},
						"learn": [
							{"text": "Without rules, every business could present its figures however it liked - and nobody could trust or compare them. The regulatory system aims for [b]one set of high-quality, global standards[/b], so financial statements are comparable and reliable across the world."},
							{"text": "[b]IFRS Foundation[/b] - the parent body at the top. It [b]oversees[/b] the whole system, [b]appoints[/b] the members of the other bodies, and [b]raises the finance[/b] to run them."},
							{"text": "[b]International Accounting Standards Board (IASB)[/b] - the independent [b]standard setter[/b]. It develops and issues [b]IFRS Accounting Standards[/b] and revises older ones. Its members are experts from different parts of the world."},
							{"text": "[b]IFRS Advisory Council[/b] - the [b]adviser[/b]. It advises the IASB on its agenda, priorities and timetable for new standards, and points out issues the Interpretations Committee may need to look at."},
							{"text": "[b]IFRS Interpretations Committee (IFRIC)[/b] - the [b]interpreter[/b]. It issues guidance on how to apply existing standards, and on new reporting issues no standard covers. It [b]reports to the IASB[/b], which approves its interpretations."},
							{"text": "[b]International Sustainability Standards Board (ISSB)[/b] - sets standards for [b]sustainability-related disclosures[/b] (e.g. climate risks), giving investors information about a company's sustainability risks and opportunities."},
							{"text": "Memory hook:\n[b]Foundation[/b] funds and appoints.\n[b]Board (IASB)[/b] writes the standards.\n[b]Council[/b] gives advice.\n[b]Committee (IFRIC)[/b] interprets.\n[b]ISSB[/b] = sustainability."}
						],
						"example": {"title": "The bodies and their jobs", "table": {"cols": ["Body", "Its job"], "rows": [
							{"c": ["IFRS Foundation", "Oversees, appoints members, raises finance"], "s": 1},
							{"c": ["IASB", "Develops and issues IFRS Accounting Standards"], "s": 2},
							{"c": ["IFRS Advisory Council", "Advises the IASB on agenda and timetable"], "s": 3},
							{"c": ["IFRIC", "Interprets existing standards; reports to the IASB"], "s": 3},
							{"c": ["ISSB", "Sustainability disclosure standards"], "s": 4}]},
							"steps": ["At the top: the IFRS Foundation funds the system and appoints everyone else.", "The IASB is the one that actually writes and issues the accounting standards.", "Two helpers: the Advisory Council advises on what to work on; IFRIC explains how to apply standards.", "The ISSB is separate from accounting standards: it sets sustainability disclosure standards."]},
						"practice": [
							{"type": "sort", "q": "Match each role to the body that carries it out.", "buckets": ["IFRS Foundation", "IASB", "IFRIC"], "items": [["Appoints the members of the IASB", 0], ["Raises finance for the system", 0], ["Issues new IFRS Accounting Standards", 1], ["Revises existing standards", 1], ["Gives guidance where no standard covers an issue", 2], ["Explains how to apply an existing standard", 2]], "ex": "The Foundation funds and appoints; the IASB writes and revises standards; IFRIC interprets them."},
							{"type": "choice", "q": "Which body advises the IASB on its agenda and the timetable for developing standards?", "opts": ["IFRS Advisory Council", "IFRS Interpretations Committee", "IFRS Foundation", "ISSB"], "a": 0, "ex": "The Advisory Council's role is to advise the IASB on its agenda, priorities and timetable."},
							{"type": "choice", "q": "The IFRS Interpretations Committee reports to:", "opts": ["The IASB", "The IFRS Advisory Council", "The ISSB", "National governments"], "a": 0, "ex": "IFRIC reports to the IASB, which approves its interpretations."},
							{"type": "choice", "q": "Information about a company's climate-related risks and opportunities would be covered by standards from the:", "opts": ["ISSB", "IASB", "IFRS Advisory Council", "IFRS Interpretations Committee"], "a": 0, "ex": "The ISSB sets IFRS Sustainability Disclosure Standards, such as climate-related disclosures."},
							{"type": "multi", "q": "Which TWO of the following are roles of the IFRS Foundation?", "opts": ["Appointing members of the IASB", "Raising finance for the standard-setting system", "Issuing IFRS Accounting Standards", "Interpreting how to apply a standard"], "a": [0, 1], "ex": "The Foundation oversees, appoints and funds. Issuing standards is the IASB's job; interpreting them is IFRIC's."}
						]
					},
					{
						"id": "L2", "title": "What IFRS Accounting Standards do",
						"outcome": "A4(b) Role of IFRS Accounting Standards in preparing financial statements",
						"apply": {"title": "Zuru's Lemonade Stand - a standard for every question", "pages": [
							{"text": "At the end of month 2 Zuru has a list of \"how do I show this?\" questions. A standard does not tell her how to run the stand - it tells her how to [b]recognise, measure and present[/b] what happened, the same way as everyone else.", "table": {"cols": ["Zuru's question", "Standard", "The answer"], "rows": [{"c": ["20 of lemons left - what are they worth?", "IAS 2 Inventories", "Lower of cost and what they would sell for"]}, {"c": ["The cart - expense or asset?", "IAS 16 Property, plant and equipment", "Asset; depreciate over its useful life"]}, {"c": ["How do I lay out the statements?", "IAS 1 / IFRS 18", "Set formats and subtotals"]}, {"c": ["A student paid in advance for 10 cups", "IFRS 15 Revenue", "Revenue when the cups are handed over, not when paid"]}, {"c": ["The dojo may sue over a spilt urn", "IAS 37 Provisions", "Provide if probable and measurable; otherwise disclose"]}]}},
							{"text": "Because the rules are shared, Hana can read Zuru's statements without asking what each line means, and Taro can compare them with the cafe's. Standards give the statements their [b]credibility[/b]: the same transaction, reported the same way, everywhere."}
						]},
						"learn": [
							{"text": "IFRS Accounting Standards tell preparers how each transaction or event should be:\n[b]Recognised[/b] - does it go into the statements at all?\n[b]Measured[/b] - at what amount?\n[b]Presented[/b] - where and how is it shown?\n[b]Disclosed[/b] - what must the notes explain?"},
							{"text": "Why they help:\n- [b]Comparability[/b] between companies and countries\n- Less choice, so less scope for 'creative accounting'\n- [b]Credibility[/b] - investors trust statements prepared under known rules\n- One set of rules for international groups"},
							{"text": "Names: newer standards are called [b]IFRS[/b] (e.g. IFRS 15 Revenue); older ones are [b]IAS[/b] (e.g. IAS 2 Inventories). Older IASs still apply unless they have been replaced - together they are all 'IFRS Accounting Standards'."},
							{"text": "Standards you will meet in this course:\nIAS 2 Inventories - IAS 7 Statement of cash flows - IAS 10 Events after the reporting period - IAS 16 Property, plant and equipment - IAS 37 Provisions - IAS 38 Intangible assets - IFRS 10 Consolidated financial statements."},
							{"text": "Standards are not law on their own. Each country's law or regulator decides who must use them - for example, many countries require listed companies to use IFRS. Companies must still follow their national company law as well."}
						],
						"practice": [
							{"type": "picklist", "q": "IFRS Accounting Standards set out how transactions are {0}, measured, {1} and disclosed in financial statements.", "lists": [["recognised", "audited", "taxed"], ["presented", "approved", "budgeted"]], "a": [0, 0], "ex": "Standards cover recognition, measurement, presentation and disclosure."},
							{"type": "multi", "q": "Which TWO are benefits of companies using IFRS Accounting Standards?", "opts": ["Financial statements are more comparable between countries", "Investors can place more trust in the figures", "Companies no longer need an audit", "Companies no longer have to follow national law"], "a": [0, 1], "ex": "Standards improve comparability and credibility. They don't remove the need for an audit or for national law."},
							{"type": "choice", "q": "IAS 2 deals with:", "opts": ["Inventories", "Property, plant and equipment", "Provisions", "Statements of cash flows"], "a": 0, "ex": "IAS 2 Inventories. IAS 16 is PPE, IAS 37 provisions and IAS 7 cash flows."},
							{"type": "choice", "q": "An older IAS that has not been replaced by an IFRS:", "opts": ["Still applies", "No longer applies", "Applies only to sole traders", "Applies only if national law repeats it word for word"], "a": 0, "ex": "Older IASs remain in force unless they are withdrawn or replaced."}
						]
					}
				]
			},
			{
				"id": 3, "title": "The qualitative characteristics of financial information", "monster": "The Mirror Kitsune",
				"beats": [
					{"type":"story","speaker":"Sensei Otter","text":"At the dojo gate floats the [b]Gatekeeper Spirit[/b]. It will not let you pass until you know WHY accounts exist and what makes them useful."},
					{"type":"story","speaker":"Sensei Otter","text":"Its lore: statements serve [b]investors, lenders and creditors[/b]. The two [b]fundamental[/b] qualities are [b]Relevance[/b] and [b]Faithful representation[/b]; the enhancing four are Comparability, Verifiability, Timeliness, Understandability. And the [b]accruals[/b] idea: record income and expenses when earned or incurred, not when cash moves."},
					{"type":"choice","q":"Which is a FUNDAMENTAL qualitative characteristic?","opts":["Comparability","Faithful representation","Timeliness","Verifiability"],"a":1,"ex":"Relevance and faithful representation are fundamental; the other four are enhancing."},
					{"type":"choice","q":"Recognising income and expenses when earned or incurred (not when cash moves) is the:","opts":["Prudence concept","Accruals (matching) concept","Going concern assumption","Historical cost concept"],"a":1,"ex":"The accruals concept matches income and expenses to the period they relate to."},
					{"type":"choice","q":"Accounting for a business separately from its owner is the:","opts":["Business (separate) entity concept","Going concern assumption","Materiality concept","Consistency concept"],"a":0,"ex":"The separate entity concept keeps the owner's personal affairs out of the business accounts."},
					{"type":"choice","q":"If the going concern basis does NOT apply, it is assumed the business will:","opts":["Keep expanding","Cease trading in the foreseeable future","Become tax exempt","Convert to a company"],"a":1,"ex":"Going concern failing means the entity may cease trading, which changes asset and liability values."},
					{"type":"choice","q":"Exercising caution so assets and income are not overstated is:","opts":["Comparability","Prudence","Timeliness","Understandability"],"a":1,"ex":"Prudence is caution under uncertainty."},
					{"type":"choice","q":"Information is material if:","opts":["It is a large round number","Omitting or misstating it could influence users decisions","It appears in the notes","It is over 1,000"],"a":1,"ex":"Materiality is judged by whether omitting or misstating it could influence users economic decisions."},
					{"type":"choice","q":"Under the Conceptual Framework, an ASSET is:","opts":["A present economic resource controlled by the entity as a result of past events","Anything the business owns outright","Cash and bank balances only","Any item with a market value"],"a":0,"ex":"An asset is a present economic resource (a right with the potential to produce economic benefits) controlled by the entity as a result of past events."},
					{"type":"choice","q":"Information that helps users predict future outcomes or confirm past ones is:","opts":["Relevant","Verifiable","Timely","Understandable"],"a":0,"ex":"Relevant information has predictive value, confirmatory value, or both."},
					{"type":"choice","q":"Using the same accounting policies from one year to the next mainly supports:","opts":["Comparability","Timeliness","Materiality","Going concern"],"a":0,"ex":"Consistent policies let users compare one period with another."},
					{"type":"choice","q":"A LIABILITY is:","opts":["A present obligation of the entity to transfer an economic resource as a result of past events","Any future cost the business expects","The owner's capital","An expense not yet paid in cash only"],"a":0,"ex":"A liability is a present obligation, arising from past events, to transfer an economic resource."}
				],
				# Ch 3 learning objectives: A3(a), A3(b), B1(a), B2(a). Exam: qualitative characteristics (e.g. what makes information relevant) and the elements.
				"lessons": [
					{
						"id": "L1", "title": "The objective: accruals and going concern",
						"outcome": "B1(a) Key concepts: going concern and accrual accounting",
						"apply": {"title": "Zuru's Lemonade Stand - December's tab", "pages": [
							{"text": "In December the dojo students run a [b]tab[/b]: 50 cups at 2, paid in January. December's stall rent of 40 is also paid late, in January.\n\nCash view of December: nothing came in for those cups, nothing went out for rent. [b]Accruals view[/b]: the lemonade was sold and the stall was used in December - so December gets [b]revenue 100[/b] and [b]rent expense 40[/b], whatever the cash did."},
							{"text": "", "table": {"cols": ["December", "Cash basis", "Accruals basis"], "rows": [{"c": ["Tab sales (paid Jan)", "0", "100"]}, {"c": ["Rent (paid Jan)", "0", "(40)"]}, {"c": ["Cash sales", "160", "160"]}, {"c": ["Ingredients used", "(70)", "(70)"]}, {"c": ["Profit", "90", "150"], "b": true}]}},
							{"text": "[b]Going concern[/b]: Zuru intends to keep trading, so her cart is shown at cost less wear (200 less depreciation), and her 20 of lemons at cost. If she were shutting the stand in January, everything would be shown at what it would fetch in a quick sale - the cart maybe 120, the lemons almost nothing. Same cart, very different number: the assumption comes first."}
						]},
						"learn": [
							{"text": "The [b]objective[/b] of general purpose financial reporting is to give [b]useful financial information[/b] to existing and potential [b]investors, lenders and other creditors[/b], to help them decide whether to provide resources to the business."},
							{"text": "Two ideas sit underneath everything. The first is [b]accrual accounting[/b]: the effects of transactions are recorded in the period they [b]happen[/b] - even if the cash is received or paid in a different period."},
							{"text": "Example: a sale on credit on 20 December, paid on 15 January. Under accrual accounting the sale belongs to [b]December's[/b] year, because that is when it happened. Cash timing doesn't matter."},
							{"text": "The second is [b]going concern[/b]: we assume the business will carry on trading for the [b]foreseeable future[/b]. That's why assets are shown at cost less depreciation, not at what they'd fetch in a closing-down sale."},
							{"text": "If the business is NOT a going concern - it is about to close - the statements are prepared on a different basis, e.g. assets at what they could be sold for (break-up values)."}
						],
						"example": {"title": "When does it count?", "table": {"cols": ["Event", "Cash moves", "Counts in year to 31 Dec 20X5?"], "rows": [
							{"c": ["Credit sale on 20 Dec 20X5", "Jan 20X6", "Yes - sale happened in 20X5"], "s": 1},
							{"c": ["December electricity used", "Paid Feb 20X6", "Yes - an accrued expense"], "s": 2},
							{"c": ["Rent for Jan 20X6 paid early", "Dec 20X5", "No - it is a prepayment"], "s": 3}]},
							"steps": ["The sale happened in December, so it is 20X5 income even though the cash arrives in January.", "Electricity used in December is a 20X5 expense even though the bill is paid later.", "Rent paid in December for January belongs to 20X6 - paying early doesn't make it this year's cost."]},
						"practice": [
							{"type": "choice", "q": "Recognising income and expenses when they happen, rather than when cash moves, is:", "opts": ["Accrual accounting", "Going concern", "Prudence", "Consistency"], "a": 0, "ex": "Accrual accounting matches transactions to the period in which they happen."},
							{"type": "choice", "q": "The going concern assumption means the business is expected to:", "opts": ["Continue in operation for the foreseeable future", "Make a profit every year", "Sell its assets at the year-end", "Pay all its liabilities immediately"], "a": 0, "ex": "Going concern assumes the business will keep operating for the foreseeable future."},
							{"type": "picklist", "q": "Goods are sold on credit on 28 June. The year-end is 30 June and the customer pays in August. The sale is recorded in the year to {0} because of {1}.", "lists": [["30 June this year", "30 June next year"], ["accrual accounting", "going concern", "materiality"]], "a": [0, 0], "ex": "The sale happened in June, so it belongs to this year - accrual accounting ignores when the cash arrives."},
							{"type": "choice", "q": "A business is about to close down. Its assets are MOST likely to be valued at:", "opts": ["What they could be sold for", "Historical cost less depreciation", "Their original cost", "Nil"], "a": 0, "ex": "If the going concern basis no longer applies, assets are valued at their realisable (break-up) values."}
						]
					},
					{
						"id": "L2", "title": "The other key concepts",
						"outcome": "B1(a) Materiality, offsetting, consistency, prudence, duality, business entity, substance over form",
						"apply": {"title": "Zuru's Lemonade Stand - seven concepts in one week", "pages": [
							{"text": "One week at the stand, one concept a day:\n\n[b]Mon - Materiality.[/b] Zuru buys a 2 lemon squeezer. It will last years, but 2 is trivial - she expenses it. No one's decision changes over 2.\n\n[b]Tue - Business entity.[/b] She buys a 30 scarf with stand cash. Not an expense of the stand: it is [b]drawings[/b] - the owner taking value out.\n\n[b]Wed - Duality.[/b] Kenji delivers 80 of lemons on credit: inventory up 80 AND a liability up 80. Every transaction has two sides."},
							{"text": "[b]Thu - Offsetting.[/b] Zuru owes Kenji 80; Kenji owes her 20 for the lemonade he drank. She shows a liability of 80 and an asset of 20 - not a net 60. Hiding one inside the other hides information.\n\n[b]Fri - Prudence.[/b] A student who owes 10 on the tab has vanished. Zuru does not count the 10 as good money. Prudence means caution under uncertainty - not deliberately understating profit.\n\n[b]Sat - Consistency.[/b] She values leftover lemons the same way every month, so months can be compared."},
							{"text": "[b]Sun - Substance over form.[/b] Zuru \"rents\" a second cart for 3 years at 8 a month, and it becomes hers at the end. Legally a rental; in substance she has bought a cart on credit. The accounts follow the [b]economic reality[/b]: an asset and a liability, not a rent expense.", "table": {"cols": ["Concept", "The test"], "rows": [{"c": ["Materiality", "Would leaving it out change a decision?"]}, {"c": ["Business entity", "Is this the stand's, or Zuru's own?"]}, {"c": ["Duality", "What are the two sides?"]}, {"c": ["Offsetting", "Show both, don't net"]}, {"c": ["Prudence", "Don't count uncertain gains"]}, {"c": ["Consistency", "Same method, every period"]}, {"c": ["Substance over form", "What really happened, not the label"]}]}}
						]},
						"learn": [
							{"text": "[b]Materiality[/b]: information is material if leaving it out or getting it wrong could [b]influence users' decisions[/b]. It depends on [b]size and nature[/b] - a small amount can still be material (e.g. a director's loan)."},
							{"text": "[b]Offsetting[/b]: don't net assets against liabilities, or income against expenses, unless a standard allows it. A 10,000 receivable and an 8,000 payable are shown separately, not as 2,000."},
							{"text": "[b]Consistency[/b]: use the same accounting policies from one period to the next, so years can be compared. Change only if a standard requires it or the change gives more reliable and relevant information."},
							{"text": "[b]Prudence[/b]: be cautious when things are uncertain - don't overstate assets or income, or understate liabilities or expenses. But prudence does NOT allow deliberately understating profit."},
							{"text": "[b]Duality[/b]: every transaction has two effects - the basis of double entry (Chapter 5).\n[b]Business entity[/b]: the business is separate from its owner (Chapter 1)."},
							{"text": "[b]Substance over form[/b]: record the economic reality, not just the legal form. Example: goods 'sold' to a bank with a promise to buy them back at a higher price are really a [b]loan[/b], so they are recorded as one."},
							{"text": "[b]Historical cost and current value[/b] - the two ways of measuring items - are covered in Lesson 4."}
						],
						"example": {"title": "Concepts in action", "table": {"cols": ["Situation", "Concept"], "rows": [
							{"c": ["Receivable 10,000 and payable 8,000 shown separately", "Offsetting"], "s": 1},
							{"c": ["Same depreciation method as last year", "Consistency"], "s": 1},
							{"c": ["A likely loss is provided for; a possible gain is not counted", "Prudence"], "s": 2},
							{"c": ["Sale-and-buyback treated as a loan", "Substance over form"], "s": 2},
							{"c": ["A 50 error ignored in a business with 5m revenue", "Materiality"], "s": 3}]},
							"steps": ["Offsetting and consistency keep the statements clear and comparable.", "Prudence is about caution under uncertainty; substance over form is about economic reality.", "Materiality: tiny amounts that couldn't change anyone's decision don't need special treatment."]},
						"practice": [
							{"type": "sort", "q": "Match each situation to the concept it shows.", "buckets": ["Prudence", "Consistency", "Substance over form"], "items": [["Not recognising a gain that is only possible", 0], ["Not overstating the value of inventory", 0], ["Using the same depreciation method every year", 1], ["Using the same inventory valuation method every year", 1], ["Recording a sale-and-buyback deal as a loan", 2], ["Recording what a transaction really is, not just its legal form", 2]], "ex": "Prudence is caution; consistency is the same policies each year; substance over form records economic reality."},
							{"type": "choice", "q": "Information is MATERIAL if:", "opts": ["Omitting or misstating it could influence users' decisions", "It is over 5% of profit", "It is shown in the notes", "It has been audited"], "a": 0, "ex": "Materiality is about influence on decisions - judged by size AND nature, not a fixed percentage."},
							{"type": "choice", "q": "A business shows a receivable of 6,000 and a payable of 4,000 to the same company as a net receivable of 2,000. Which concept has it broken?", "opts": ["Offsetting", "Duality", "Going concern", "Business entity"], "a": 0, "ex": "Assets and liabilities shouldn't be netted off unless a standard permits it."},
							{"type": "choice", "q": "Every transaction having two effects is the concept of:", "opts": ["Duality", "Materiality", "Prudence", "Accruals"], "a": 0, "ex": "Duality - the reason every debit has a matching credit."}
						]
					},
					{
						"id": "L3", "title": "What makes information useful?",
						"outcome": "B2(a) Qualitative characteristics: relevance, faithful representation, comparability, verifiability, timeliness, understandability",
						"apply": {"title": "Zuru's Lemonade Stand - Hana's loan decision", "pages": [
							{"text": "Hana is deciding whether to lend Zuru 300 for a heater. Zuru hands over a report. Hana's reactions show the two [b]fundamental[/b] qualities:\n\n[b]Relevance[/b] - \"I need the last three months' profit and cash, not your school project from 2019.\" Information that can change her decision.\n\n[b]Faithful representation[/b] - \"You've left out the 80 you owe Kenji.\" Complete, neutral, free from error - the picture must match reality."},
							{"text": "Then the four [b]enhancing[/b] qualities:", "table": {"cols": ["Quality", "Hana says"], "rows": [{"c": ["Comparability", "Same layout as last month, so I can see the trend"]}, {"c": ["Verifiability", "Show me the shoebox - receipts back every number"]}, {"c": ["Timeliness", "October's figures in November, not next summer"]}, {"c": ["Understandability", "One page, plain words - not a 40-page novel"]}]}},
							{"text": "Notice the order: enhancing qualities only help if the information is relevant and faithfully represented first. A beautifully laid-out, on-time report that leaves out Kenji's 80 is still useless to Hana. And there is a [b]cost constraint[/b]: Zuru won't hire an accountant to value every lemon - the benefit must be worth the cost."}
						]},
						"learn": [
							{"text": "The [b]qualitative characteristics[/b] describe what makes financial information useful. There are two [b]fundamental[/b] ones - information must have BOTH - and four [b]enhancing[/b] ones that make it better."},
							{"text": "Fundamental 1 - [b]Relevance[/b]: the information could make a difference to users' decisions. It has [b]predictive value[/b] (helps forecast the future) and/or [b]confirmatory value[/b] (confirms or corrects past expectations). [b]Materiality[/b] is part of relevance."},
							{"text": "Fundamental 2 - [b]Faithful representation[/b]: the information shows what it claims to show. It is [b]complete[/b] (nothing needed is missing), [b]neutral[/b] (not biased) and [b]free from error[/b]. It reflects the substance of transactions."},
							{"text": "Enhancing:\n[b]Comparability[/b] - can be compared with other businesses and other years.\n[b]Verifiability[/b] - different knowledgeable people would agree it is a faithful representation.\n[b]Timeliness[/b] - available in time to influence decisions.\n[b]Understandability[/b] - classified and presented clearly and concisely."},
							{"text": "Enhancing characteristics can't rescue information that is irrelevant or misleading - they only improve information that already has the two fundamental ones.\n\n[b]The cost constraint[/b]: the benefits of reporting information must justify the cost of providing it."}
						],
						"example": {"title": "The characteristics as questions", "table": {"cols": ["Characteristic", "Ask yourself"], "rows": [
							{"c": ["Relevance", "Could it change a decision?"], "s": 1}, {"c": ["Faithful representation", "Complete, neutral, free from error?"], "s": 1},
							{"c": ["Comparability", "Can I compare it with last year or rivals?"], "s": 2}, {"c": ["Verifiability", "Would independent experts agree?"], "s": 2},
							{"c": ["Timeliness", "Did it arrive in time to be used?"], "s": 3}, {"c": ["Understandability", "Is it clear and concise?"], "s": 3}]},
							"steps": ["The two fundamental characteristics - information needs both.", "Two enhancing ones: comparability and verifiability.", "The other two enhancing ones: timeliness and understandability."]},
						"practice": [
							{"type": "multi", "q": "Which TWO are FUNDAMENTAL qualitative characteristics?", "opts": ["Relevance", "Faithful representation", "Comparability", "Timeliness"], "a": [0, 1], "ex": "Relevance and faithful representation are fundamental; comparability, verifiability, timeliness and understandability are enhancing."},
							{"type": "choice", "q": "Information that is complete, neutral and free from error is:", "opts": ["A faithful representation", "Relevant", "Timely", "Comparable"], "a": 0, "ex": "Complete, neutral and free from error are the three parts of faithful representation."},
							{"type": "choice", "q": "Information with predictive value or confirmatory value is:", "opts": ["Relevant", "Verifiable", "Understandable", "Comparable"], "a": 0, "ex": "Predictive and confirmatory value make information relevant - able to make a difference to decisions."},
							{"type": "sort", "q": "Match each description to the enhancing characteristic.", "buckets": ["Comparability", "Verifiability", "Timeliness", "Understandability"], "items": [["Can be compared with last year's figures", 0], ["Independent experts would reach the same conclusion", 1], ["Available before decisions are made", 2], ["Classified and presented clearly and concisely", 3]], "ex": "Comparability across years and entities; verifiability by independent people; timeliness for decisions; understandability through clear presentation."},
							{"type": "choice", "q": "The cost constraint means:", "opts": ["The benefits of reporting information must justify its cost", "Financial statements must be prepared at the lowest cost", "Only material costs are reported", "Costs must be reported at historical cost"], "a": 0, "ex": "Information is only worth reporting if its benefits justify the cost of providing and using it."}
						]
					},
					{
						"id": "L4", "title": "Measuring items: historical cost and current value",
						"outcome": "B1(a) Historical cost and current value; A3(b) The elements (recap)",
						"apply": {"title": "Zuru's Lemonade Stand - what is the cart worth?", "pages": [
							{"text": "A year on, four people put a number on Zuru's cart:\n- The receipt says she paid [b]200[/b].\n- The cart shop says a new one is now [b]260[/b].\n- A second-hand buyer offers [b]150[/b].\n- Zuru reckons the cart will earn her far more than any of those over the next few years.\n\nAll four are legitimate measurement bases. The statements have to pick one - and say which."},
							{"text": "", "table": {"cols": ["Basis", "Cart", "Idea"], "rows": [{"c": ["Historical cost", "200 less depreciation", "What was paid; objective, verifiable"]}, {"c": ["Current cost", "260 less depreciation", "Cost to replace it today"]}, {"c": ["Fair value / realisable value", "150", "What it would sell for now"]}, {"c": ["Value in use", "Future earnings, discounted", "What it is worth to Zuru's business"]}]}},
							{"text": "Most of FA uses [b]historical cost[/b]: the cart stays at 200 less depreciation because the receipt proves it and no one has to guess. Current values come in only where a standard asks for them - for example if Zuru chose to [b]revalue[/b] the cart (Chapter 8), or when inventory has fallen below cost (Chapter 7). Whichever basis is used, the cart is still an [b]asset[/b]: a resource she controls, from a past event, expected to bring economic benefits."}
						]},
						"learn": [
							{"text": "Quick recap from Chapter 1: the elements are [b]assets, liabilities, equity, income and expenses[/b]. Once we know an item is (say) an asset, we must decide [b]what amount[/b] to show it at - its [b]measurement basis[/b]."},
							{"text": "[b]Historical cost[/b] - the most common basis. The amount at the date of the transaction and not updated afterwards.\nAsset: what it cost to buy or make, plus transaction costs.\nLiability: what was received for taking it on, less transaction costs."},
							{"text": "[b]Current value[/b] - updated to reflect conditions at the measurement date. Three types:\n[b]Fair value[/b] - the price you'd get selling an asset (or pay to transfer a liability) in an orderly transaction between market participants."},
							{"text": "[b]Value in use[/b] (assets) / [b]fulfilment value[/b] (liabilities) - the present value of the cash flows expected from using the asset, or needed to settle the liability.\n[b]Current cost[/b] - what an equivalent asset would cost today."}
						],
						"example": {"title": "One delivery van, four measures", "table": {"cols": ["Basis", "Amount", "Why"], "rows": [
							{"c": ["Historical cost", "20,000", "What was paid 3 years ago"], "s": 1},
							{"c": ["Current cost", "24,000", "A similar van costs this today"], "s": 2},
							{"c": ["Fair value", "15,000", "What it would sell for now"], "s": 3},
							{"c": ["Value in use", "18,000", "PV of cash it will help earn"], "s": 4}]},
							"steps": ["Historical cost stays at the 20,000 paid (less depreciation in practice).", "Current cost asks what an equivalent asset would cost today: 24,000.", "Fair value asks what a buyer would pay for this van now: 15,000.", "Value in use asks what the van is worth to the business through the cash it helps generate: 18,000."]},
						"practice": [
							{"type": "choice", "q": "The MOST commonly used measurement basis is:", "opts": ["Historical cost", "Fair value", "Current cost", "Value in use"], "a": 0, "ex": "Historical cost is the most common basis."},
							{"type": "sort", "q": "Match each description to the measurement basis.", "buckets": ["Historical cost", "Fair value", "Value in use", "Current cost"], "items": [["The price paid when the asset was bought", 0], ["The price it would sell for between market participants today", 1], ["Present value of the cash flows from using the asset", 2], ["What an equivalent asset would cost today", 3]], "ex": "Historical cost = past price; fair value = selling price now; value in use = PV of cash flows from use; current cost = replacement cost now."},
							{"type": "picklist", "q": "Under historical cost, an asset is measured at its cost {0} transaction costs, and the amount is {1} afterwards.", "lists": [["plus", "less"], ["not updated", "updated every year"]], "a": [0, 0], "ex": "Historical cost = cost plus transaction costs, fixed at the transaction date."},
							{"type": "choice", "q": "The present value of cash flows a business expects to pay to settle a liability is its:", "opts": ["Fulfilment value", "Fair value", "Historical cost", "Value in use"], "a": 0, "ex": "Fulfilment value is the liability version of value in use."}
						]
					}
				]
			},
			{
				"id": 4, "title": "Financial transactions and accounting systems", "monster": "The Paperwork Poltergeist",
				"beats": [
					{"type":"choice","q":"Which is NOT a book of prime entry?","opts":["The nominal (general) ledger","Sales day book","Cash book","The journal"],"a":0,"ex":"The nominal ledger holds the accounts; prime-entry books feed it."},
					{"type":"choice","q":"Credit sales invoices are first recorded in the:","opts":["Sales day book","Purchase day book","Cash book","Petty cash book"],"a":0,"ex":"The sales day book lists credit sales invoices before they are posted to the ledgers."}
				],
				# Ch 4 learning objectives: C1(a), C1(b), C1(d), C1(e), C1(f), C2(a), C2(b), D1(a), D1(b), D2(a), D2(b).
				"lessons": [
					{
						"id": "L1", "title": "Business transactions and their documents",
						"outcome": "C1(a) Main data sources; C1(b) Business documents; C1(f) Main types of transaction",
						"apply": {"title": "Zuru's Lemonade Stand - a Tuesday in paper", "pages": [
							{"text": "One ordinary Tuesday at the stand, and the paper trail it leaves:\n\n08:00 Kenji drops off lemons with a [b]delivery note[/b]; his [b]invoice[/b] for 80 arrives by email - a [b]credit purchase[/b].\n10:00 The dojo orders 20 cups for a class: Zuru raises a [b]sales invoice[/b] for 40 - a [b]credit sale[/b].\n12:00 A student brings back a cold cup; Zuru issues a [b]credit note[/b] for 2 - a [b]sales return[/b].\n14:00 Zuru pays 3 for napkins from the tin and fills in a [b]petty cash voucher[/b]."},
							{"text": "16:00 She pays Kenji last week's 70 by bank transfer and sends a [b]remittance advice[/b] so he knows which invoice it covers.\n17:00 Cash sales for the day, 150, are on the [b]till roll[/b] and paid into the bank with a [b]paying-in slip[/b].\nEnd of month: the [b]bank statement[/b] and Kenji's [b]supplier statement[/b] arrive - the two documents she will check her own records against (Chapters 14 and 15)."},
							{"text": "", "table": {"cols": ["Document", "Transaction", "Goes into"], "rows": [{"c": ["Purchase invoice (Kenji)", "Credit purchase 80", "Purchases day book"]}, {"c": ["Sales invoice (dojo)", "Credit sale 40", "Sales day book"]}, {"c": ["Credit note issued", "Sales return 2", "Sales returns day book"]}, {"c": ["Till roll / paying-in slip", "Cash sale 150", "Cash book"]}, {"c": ["Remittance advice", "Payment to Kenji 70", "Cash book"]}, {"c": ["Petty cash voucher", "Napkins 3", "Petty cash book"]}]}}
						]},
						"learn": [
							{"text": "The main [b]business transactions[/b] are: [b]sales[/b] (cash or on credit), [b]purchases[/b] (cash or on credit), [b]payments[/b] and [b]receipts[/b]."},
							{"text": "Every transaction leaves a [b]document[/b]. These documents are the [b]data sources[/b] of the accounting system - the evidence each entry is based on."},
							{"text": "A credit sale, step by step:\n[b]Quotation[/b] - seller tells the customer the price.\n[b]Purchase order[/b] - customer formally orders.\n[b]Sales order[/b] - seller's internal record of the order.\n[b]Goods despatched note[/b] - goes out with the goods."},
							{"text": "Then:\n[b]Goods received note[/b] - the customer records what actually arrived.\n[b]Sales invoice[/b] - asks for payment (to the customer it is a [b]purchase invoice[/b]).\n[b]Supplier statement[/b] - summary of what the customer owes."},
							{"text": "Finally:\n[b]Remittance advice[/b] - sent by the customer with payment, saying which invoices are being paid.\n[b]Receipt[/b] - confirms money was received."},
							{"text": "If goods are faulty or returned:\n[b]Credit note[/b] - issued by the SELLER, reducing what the customer owes.\n[b]Debit note[/b] - issued by the BUYER, asking the seller for a credit note."}
						],
						"example": {"title": "One credit sale, start to finish", "table": {"cols": ["Step", "Document", "Sent by"], "rows": [
							{"c": ["1", "Quotation", "Seller"], "s": 1}, {"c": ["2", "Purchase order", "Buyer"], "s": 1},
							{"c": ["3", "Goods despatched note", "Seller"], "s": 2}, {"c": ["4", "Goods received note", "Buyer (internal)"], "s": 2},
							{"c": ["5", "Sales invoice", "Seller"], "s": 3}, {"c": ["6", "Supplier statement", "Seller"], "s": 3},
							{"c": ["7", "Remittance advice + payment", "Buyer"], "s": 4}, {"c": ["8", "Receipt", "Seller"], "s": 4}]},
							"steps": ["Agreeing the deal: the seller quotes, the buyer places a purchase order.", "Delivering: a despatch note goes with the goods; the buyer checks them on a goods received note.", "Billing: the seller invoices, then sends a statement of what's owed.", "Paying: the buyer pays with a remittance advice; the seller issues a receipt."]},
						"practice": [
							{"type": "sort", "q": "Who sends each document?", "buckets": ["Seller", "Buyer"], "items": [["Quotation", 0], ["Purchase order", 1], ["Sales invoice", 0], ["Credit note", 0], ["Debit note", 1], ["Remittance advice", 1]], "ex": "The seller quotes, invoices and issues credit notes. The buyer orders, raises debit notes and sends remittance advices with payment."},
							{"type": "choice", "q": "A goods received note is used to:", "opts": ["Record the goods actually received from a supplier", "Ask a customer for payment", "Confirm payment has been received", "Reduce the amount a customer owes"], "a": 0, "ex": "The GRN records what arrived, so it can be checked against the order and the invoice."},
							{"type": "choice", "q": "A customer returns faulty goods. The seller issues a:", "opts": ["Credit note", "Debit note", "Remittance advice", "Purchase order"], "a": 0, "ex": "The seller's credit note reduces the amount the customer owes."},
							{"type": "choice", "q": "A remittance advice:", "opts": ["Accompanies a payment and shows which invoices are being paid", "Lists goods despatched to a customer", "Requests a quotation", "Is the seller's record of an order"], "a": 0, "ex": "The remittance advice tells the seller what the payment covers."}
						]
					},
					{
						"id": "L2", "title": "Books of prime entry, ledgers and petty cash",
						"outcome": "C2(a) Types of ledger account; C2(b) How data is first recorded; D1(a)(b) Sales, purchases and returns; D2(a)(b) Cash and petty cash",
						"apply": {"title": "Zuru's Lemonade Stand - from shoebox to books", "pages": [
							{"text": "The shoebox is retired. Zuru now keeps [b]books of prime entry[/b] - one list per kind of transaction - and posts the totals to the [b]general ledger[/b] once a week.\n\nTuesday's paperwork lands like this:\n- Kenji's invoice 80 -> [b]purchases day book[/b]\n- Dojo invoice 40 -> [b]sales day book[/b]\n- Credit note 2 -> [b]sales returns day book[/b]\n- Bank receipts and payments -> [b]cash book[/b]\n- Napkins 3 -> [b]petty cash book[/b]"},
							{"text": "At the week's end the day-book totals are posted. One line each to the general ledger (the total), plus one line per customer or supplier to the [b]memorandum[/b] ledgers so she knows who owes what.", "table": {"cols": ["Book", "Week total", "General ledger posting", "Memorandum ledger"], "rows": [{"c": ["Sales day book", "140", "Dr Receivables 140, Cr Sales 140", "Dojo 40, cafe 100"]}, {"c": ["Purchases day book", "80", "Dr Purchases 80, Cr Payables 80", "Kenji 80"]}, {"c": ["Sales returns day book", "2", "Dr Sales returns 2, Cr Receivables 2", "Student tab -2"]}, {"c": ["Cash book", "receipts 220 / payments 110", "Dr Cash 220, Cr Cash 110", "-"]}]}},
							{"text": "[b]Petty cash[/b] runs on an [b]imprest[/b] of 50. Over the week Zuru spends 12 (napkins 3, ice 9), each with a voucher. On Friday she tops the tin back up to 50 by taking exactly 12 from the bank - so the tin always starts the week at 50 and the vouchers plus coins always add to 50.", "table": {"cols": ["Petty cash", ""], "rows": [{"c": ["Float (imprest)", "50"]}, {"c": ["Spent: napkins 3 + ice 9", "(12)"]}, {"c": ["Coins left in the tin", "38"]}, {"c": ["Top-up from bank", "12"]}, {"c": ["Float restored", "50"], "b": true}]}}
						]},
						"learn": [
							{"text": "Documents are first listed in [b]books of prime entry[/b] - the first place a transaction is recorded:\n[b]Sales day book[/b] - credit sales invoices\n[b]Purchase day book[/b] - credit purchase invoices\n[b]Sales returns day book[/b] and [b]purchase returns day book[/b] - credit notes"},
							{"text": "And:\n[b]Cash book[/b] - money in and out of the bank\n[b]Petty cash book[/b] - small cash payments\n[b]Journal[/b] - anything that doesn't go in another book (e.g. corrections, depreciation)"},
							{"text": "Totals from the books of prime entry are posted to the [b]general ledger[/b] (also called the nominal ledger) - one account for each type of asset, liability, capital, income and expense. Separate [b]receivables[/b] and [b]payables ledgers[/b] keep an account for each customer and supplier."},
							{"text": "The basic entries (more in Chapter 5):\nCredit sale: Dr Receivables, Cr Sales\nCredit purchase: Dr Purchases, Cr Payables\nSales return: Dr Sales returns, Cr Receivables\nPurchase return: Dr Payables, Cr Purchase returns\nMoney received: Dr Bank"},
							{"text": "[b]Petty cash[/b] covers small payments like stamps or taxis. Most businesses use an [b]imprest system[/b]: a fixed float (e.g. 200). Each payment needs a voucher; at the end of the period the float is topped up by the amount spent, back to 200. This keeps control of cash and records every small expense."}
						],
						"example": {"title": "Where each document goes first", "table": {"cols": ["Document", "Book of prime entry", "Then posted to"], "rows": [
							{"c": ["Sales invoice (credit)", "Sales day book", "Receivables + Sales"], "s": 1},
							{"c": ["Supplier invoice (credit)", "Purchase day book", "Purchases + Payables"], "s": 1},
							{"c": ["Credit note to a customer", "Sales returns day book", "Sales returns + Receivables"], "s": 2},
							{"c": ["Cheque received", "Cash book", "Bank + Receivables"], "s": 3},
							{"c": ["Taxi receipt", "Petty cash book", "Travel expenses"], "s": 3}]},
							"steps": ["Invoices on credit go to the day books.", "Credit notes go to the returns day books.", "Money through the bank goes to the cash book; small cash spends go to the petty cash book."]},
						"practice": [
							{"type": "sort", "q": "Which book of prime entry records each item first?", "buckets": ["Sales day book", "Purchase day book", "Cash book"], "items": [["Invoice sent to a credit customer", 0], ["Invoice received from a supplier", 1], ["Payment to a supplier by bank transfer", 2], ["Cheque received from a customer", 2]], "ex": "Credit sales invoices go to the sales day book, supplier invoices to the purchase day book, and bank receipts and payments to the cash book."},
							{"type": "input", "q": "A petty cash imprest is 250. Vouchers for the month total 183. How much cash is needed to restore the imprest?  (number)", "accept": ["183"], "display_answer": "183", "ex": "Under the imprest system, the top-up equals what was spent: 183, bringing the float back to 250."},
							{"type": "choice", "q": "A customer returns goods bought on credit. The entry is:", "opts": ["Dr Sales returns, Cr Receivables", "Dr Receivables, Cr Sales returns", "Dr Purchases, Cr Payables", "Dr Bank, Cr Sales"], "a": 0, "ex": "Sales returns reduce income (debit) and reduce what the customer owes (credit receivables)."},
							{"type": "choice", "q": "The main purpose of a petty cash record is to:", "opts": ["Control small cash payments and record them as expenses", "Record credit sales", "Record bank transfers", "Record purchases of non-current assets"], "a": 0, "ex": "Petty cash records keep control of small cash spends and make sure each is recorded."}
						]
					},
					{
						"id": "L3", "title": "Computerised accounting systems",
						"outcome": "C1(d) Computerised accounting systems and the cloud; C1(e) How the system provides useful information",
						"apply": {"title": "Zuru's Lemonade Stand - the app", "pages": [
							{"text": "Month 4: Zuru moves the books onto a [b]cloud accounting app[/b] on her phone. Now when the dojo orders 20 cups she taps once: the app creates the invoice, posts Dr Receivables / Cr Sales, updates the dojo's balance and emails the invoice. Kenji's invoice is photographed and read automatically.\n\nThe double entry has not changed - the app just does it for her, every time, without arithmetic slips."},
							{"text": "What she gets back is [b]useful information[/b] on demand:\n- a trial balance and draft statements any day, not just at month end\n- yuzu outsells plain 3 to 1 on cold days - stock more yuzu\n- an [b]aged receivables[/b] list: the student tab is 45 days old - chase it\n- the data lives on the cloud, so Hana can log in from home and the phone falling in the snow loses nothing"},
							{"text": "The warnings still apply. [b]Garbage in, garbage out[/b]: if Zuru keys 400 instead of 40, the app will happily produce a wrong trial balance. So she sets [b]access controls[/b] (Yuki can enter sales but not delete them), keeps the [b]source documents[/b], and reconciles to the bank statement every month - exactly as she would on paper.", "table": {"cols": ["Benefit", "Risk / control"], "rows": [{"c": ["Speed, no casting errors", "Input errors - check source documents"]}, {"c": ["Instant reports and analysis", "Rubbish in, rubbish out"]}, {"c": ["Access anywhere, automatic backup", "Passwords, access levels, internet needed"]}, {"c": ["Bank feed matches payments", "Still reconcile every month"]}]}}
						]},
						"learn": [
							{"text": "Most businesses use [b]accounting software[/b]: either an [b]off-the-shelf[/b] package (cheaper, ready to use) or a [b]bespoke[/b] package (built for that business - fits exactly, but costs more)."},
							{"text": "The main module is the [b]general ledger[/b]. Other modules feed it: the [b]receivables ledger[/b], [b]payables ledger[/b], [b]non-current assets register[/b], [b]inventory system[/b] and payroll."},
							{"text": "Key features:\n[b]Controls[/b] - passwords, access levels and validation checks (e.g. rejecting an invoice with no account code).\n[b]Standing data[/b] - information that rarely changes: customer names, addresses, credit limits, prices.\n[b]Account codes[/b] - each account has a code so entries post to the right place."},
							{"text": "Access: software is either [b]installed on local computers[/b], or [b]cloud-based[/b] - data stored on external servers and reached over the internet. Cloud benefits: work from anywhere, automatic updates and backups. Risks: data security and needing a reliable internet connection."},
							{"text": "A good system gives [b]accurate, timely information[/b] - instant reports and balances - and helps the business meet its [b]policies and deadlines[/b], e.g. warning when a customer goes over their credit limit, or producing month-end reports on time."}
						],
						"practice": [
							{"type": "choice", "q": "A customer's name, address and credit limit, stored in the accounting system, are examples of:", "opts": ["Standing data", "Transaction data", "Account codes", "Validation checks"], "a": 0, "ex": "Standing data rarely changes and is used again and again."},
							{"type": "multi", "q": "Which TWO are advantages of cloud-based accounting software?", "opts": ["It can be accessed from any location with internet", "Updates and backups are handled automatically", "It works without an internet connection", "There is no risk to data security"], "a": [0, 1], "ex": "Cloud software can be used anywhere and is updated and backed up automatically - but it needs internet access and still carries security risks."},
							{"type": "choice", "q": "Accounting software written specially for one business is:", "opts": ["A bespoke package", "An off-the-shelf package", "A standing data file", "A general ledger"], "a": 0, "ex": "Bespoke software is custom-built; off-the-shelf software is bought ready-made."},
							{"type": "choice", "q": "The system rejects a sales invoice entered without a customer account code. This is an example of:", "opts": ["A control (validation check)", "Standing data", "A cloud backup", "A book of prime entry"], "a": 0, "ex": "Validation checks are controls that stop incomplete or invalid data being entered."}
						]
					}
				]
			},
			{
				"id": 5, "title": "Ledger accounts and double entry", "monster": "The Double-Entry Oni",
				"beats": [
					{"type":"story","speaker":"Sensei Otter","text":"A shadow stirs in the first hall... the [b]Double-Entry Oni[/b]. It feeds on sloppy books. To wound it you must think in two sides: every move has a [b]debit[/b] and a [b]credit[/b]."},
					{"type":"story","speaker":"Sensei Otter","text":"The law of this dojo, the [b]accounting equation[/b]:\n\n[b]ASSETS = CAPITAL + LIABILITIES[/b]\n\nAnd the stance, [b]DEAD CLIC[/b]:\nDEbit = Expenses, Assets, Drawings\nCredit = Liabilities, Income, Capital."},
					{"type":"taccount","speaker":"Sensei Otter","text":"Watch a ledger account balance. Both sides must total the same, and that balance is the Oni's weak point:","name":"Cash account","dr":["Capital 1,000","Sales 500"],"cr":["Purchases 300","Rent 200","Balance c/d 1,000"],"dr_total":"1,500","cr_total":"1,500"},
					{"type":"choice","q":"Complete the law:  Assets =","opts":["Capital + Liabilities","Capital - Liabilities","Liabilities - Capital","Income + Expenses"],"a":0,"ex":"Assets = Capital + Liabilities (Net assets = Capital)."},
					{"type":"input","q":"Assets are 70,000 and capital is 45,000. What are the liabilities?  (number)","accept":["25000"],"display_answer":"25,000","ex":"Liabilities = Assets - Capital = 70,000 - 45,000 = 25,000."},
					{"type":"choice","q":"A cash sale is made. Which entry strikes true?","opts":["Dr Cash, Cr Sales","Dr Sales, Cr Cash","Dr Cash, Cr Capital","Dr Purchases, Cr Cash"],"a":0,"ex":"Cash (an asset) rises, so Dr Cash; income rises, so Cr Sales."},
					{"type":"choice","q":"Goods for resale are bought on credit. The entry is:","opts":["Dr Purchases, Cr Payables","Dr Payables, Cr Purchases","Dr Purchases, Cr Cash","Dr Cash, Cr Payables"],"a":0,"ex":"Purchases rise (Dr) and a liability to the supplier is created (Cr Payables)."},
					{"type":"input","q":"Capital was 40,000. Profit 18,000, drawings 11,000. Closing capital = ?  (number)","accept":["47000"],"display_answer":"47,000","ex":"40,000 + profit 18,000 - drawings 11,000 = 47,000."},
					{"type":"choice","q":"Under DEAD CLIC, which is a DEBIT?","opts":["An asset","A liability","Income","Capital"],"a":0,"ex":"Assets, expenses and drawings are debits."},
					{"type":"input","q":"A trial balance shows total debits of 63,500. Total credits must be?  (number)","accept":["63500"],"display_answer":"63,500","ex":"A trial balance balances only when total debits equal total credits."},
					{"type":"choice","q":"The owner takes 500 cash out of the business for personal use. The entry is:","opts":["Dr Drawings, Cr Cash","Dr Cash, Cr Drawings","Dr Wages, Cr Cash","Dr Capital, Cr Drawings"],"a":0,"ex":"Drawings rise (debit) and cash falls (credit)."},
					{"type":"choice","q":"The business pays a credit supplier 800 by bank transfer. The entry is:","opts":["Dr Payables, Cr Bank","Dr Bank, Cr Payables","Dr Purchases, Cr Bank","Dr Payables, Cr Purchases"],"a":0,"ex":"The liability to the supplier falls (debit) and cash at bank falls (credit)."},
					{"type":"input","q":"Assets are 30,000 and liabilities are 12,000. Capital = ?  (number)","accept":["18000"],"display_answer":"18,000","ex":"Capital = Assets - Liabilities = 30,000 - 12,000 = 18,000."}
				],
				# Ch 5 learning objectives: C1(f), C2(a), C2(b), C2(c), C2(e), D1(a), D1(b), D2(a).
				# Exam: identify the correct double entry, and (Section B) pick accounts to debit/credit and the amount.
				"lessons": [
					{
						"id": "L1", "title": "Ledger accounts and the rules of double entry",
						"outcome": "C2(a) Types of general ledger account; C1(f) Main types of transaction",
						"apply": {"title": "Zuru's Lemonade Stand - the first T-accounts", "pages": [
							{"text": "Day 1 of the stand, in double entry. Every transaction touches [b]two accounts[/b], one debit and one credit, equal amounts. [b]DEAD CLIC[/b]: Debits increase Expenses, Assets, Drawings; Credits increase Liabilities, Income, Capital.", "table": {"cols": ["Transaction", "Debit", "Credit", "Why"], "rows": [{"c": ["Zuru puts in 500 savings", "Cash 500", "Capital 500", "Asset up, capital up"]}, {"c": ["Buys cart for 200 cash", "Cart 200", "Cash 200", "One asset up, another down"]}, {"c": ["Lemons 80 on credit from Kenji", "Purchases 80", "Payables (Kenji) 80", "Expense up, liability up"]}, {"c": ["Sells 100 cups for 200 cash", "Cash 200", "Sales 200", "Asset up, income up"]}, {"c": ["Pays stall rent 40", "Rent 40", "Cash 40", "Expense up, asset down"]}]}},
							{"text": "The cash account alone, as a T-account. Debits on the left (money in), credits on the right (money out):", "table": {"cols": ["Cash - Dr", "", "Cash - Cr", ""], "rows": [{"c": ["Capital", "500", "Cart", "200"]}, {"c": ["Sales", "200", "Rent", "40"]}, {"c": ["", "", "Balance c/d", "460"], "b": true}, {"c": ["Total", "700", "Total", "700"], "b": true}]}},
							{"text": "Each account has a [b]type[/b], and the type tells you its normal side: Cash and Cart are [b]assets[/b] (debit balances), Sales is [b]income[/b] (credit), Rent and Purchases are [b]expenses[/b] (debit), Payables is a [b]liability[/b] (credit), Capital is [b]capital[/b] (credit). Add every debit and every credit across all the accounts and they are equal - 1,020 each. That is the whole trick."}
						]},
						"learn": [
							{"text": "The [b]general ledger[/b] holds one [b]account[/b] for every item that will appear in the statement of financial position or the statement of profit or loss: Bank, Sales, Rent, Payables, Capital..."},
							{"text": "Accounts are drawn as [b]T accounts[/b]: the account name on top, [b]debits on the left[/b] and [b]credits on the right[/b]. Every entry says which other account took the opposite side."},
							{"text": "[b]Double entry[/b]: every transaction is recorded twice - once as a debit and once as a credit, for the same amount. So [b]total debits always equal total credits[/b]."},
							{"text": "Which side? Remember [b]DEAD CLIC[/b]:\n[b]D[/b]ebit increases [b]E[/b]xpenses, [b]A[/b]ssets, [b]D[/b]rawings.\n[b]C[/b]redit increases [b]L[/b]iabilities, [b]I[/b]ncome, [b]C[/b]apital.\nTo DEcrease an item, post to the opposite side."},
							{"text": "Method for any transaction:\n1. Which two accounts are affected?\n2. Is each one going up or down?\n3. Use DEAD CLIC to pick the side for each.\nE.g. paying rent from the bank: Rent (expense) goes UP -> debit. Bank (asset) goes DOWN -> credit."}
						],
						"example": {"title": "Using the three-step method", "table": {"cols": ["Transaction", "Account up/down", "Entry"], "rows": [
							{"c": ["Owner pays in 5,000 capital", "Bank up, Capital up", "Dr Bank, Cr Capital"], "s": 1},
							{"c": ["Rent of 800 paid", "Rent up, Bank down", "Dr Rent, Cr Bank"], "s": 2},
							{"c": ["Loan of 3,000 received", "Bank up, Loan up", "Dr Bank, Cr Loan"], "s": 3},
							{"c": ["Loan repaid 1,000", "Loan down, Bank down", "Dr Loan, Cr Bank"], "s": 4}]},
							"steps": ["Bank is an asset going up (debit); capital goes up (credit).", "Rent is an expense going up (debit); bank goes down (credit).", "Bank up (debit); the loan is a liability going up (credit).", "Repaying: the liability goes DOWN, so debit it; bank goes down (credit)."]},
						"practice": [
							{"type": "choice", "q": "Under DEAD CLIC, a CREDIT entry increases:", "opts": ["Liabilities, income and capital", "Expenses, assets and drawings", "Assets and income", "Expenses and liabilities"], "a": 0, "ex": "Credit increases Liabilities, Income and Capital; debit increases Expenses, Assets and Drawings."},
							{"type": "picklist", "q": "The business pays electricity of 400 from its bank account: Debit {0}, Credit {1}.", "lists": [["Electricity expense", "Bank", "Payables"], ["Bank", "Electricity expense", "Capital"]], "a": [0, 0], "ex": "The expense goes up (debit) and the bank asset goes down (credit)."},
							{"type": "choice", "q": "A bank loan of 2,000 is repaid. The entry is:", "opts": ["Dr Loan, Cr Bank", "Dr Bank, Cr Loan", "Dr Loan interest, Cr Bank", "Dr Capital, Cr Loan"], "a": 0, "ex": "The liability falls (debit) and cash falls (credit)."},
							{"type": "input", "q": "After a month of entries, total debits in the ledger are 48,750. What must total credits be?  (number)", "accept": ["48750"], "display_answer": "48,750", "ex": "Double entry means every debit has an equal credit, so totals must agree."}
						]
					},
					{
						"id": "L2", "title": "Recording sales, purchases, returns and cash",
						"outcome": "D1(a) Sales and purchases; D1(b) Sales and purchase returns; D2(a) Cash in the bank account; C2(b) How data is first recorded",
						"apply": {"title": "Zuru's Lemonade Stand - a week on credit", "pages": [
							{"text": "Week 6. The dojo and the cafe now buy on credit, and Zuru buys on credit from Kenji. Six transactions, each with its double entry:", "table": {"cols": ["", "Debit", "Credit"], "rows": [{"c": ["Sells 20 cups to the dojo on credit, 40", "Receivables 40", "Sales 40"]}, {"c": ["Buys lemons from Kenji on credit, 80", "Purchases 80", "Payables 80"]}, {"c": ["Dojo returns a cold cup, credit note 2", "Sales returns 2", "Receivables 2"]}, {"c": ["Sends a mouldy crate back to Kenji, 10", "Payables 10", "Purchase returns 10"]}, {"c": ["Dojo pays what it owes, 38", "Cash 38", "Receivables 38"]}, {"c": ["Zuru pays Kenji, 70", "Payables 70", "Cash 70"]}]}},
							{"text": "Follow the dojo through its receivables account: 40 invoiced, less 2 returned, less 38 received = nil. Follow Kenji through payables: 80 owed, less 10 returned, less 70 paid = nil. Returns go [b]back the way the original entry came[/b]: a sales return is the opposite of a sale; a purchase return is the opposite of a purchase.", "table": {"cols": ["Receivables (dojo) - Dr", "", "Cr", ""], "rows": [{"c": ["Sales", "40", "Sales returns", "2"]}, {"c": ["", "", "Cash", "38"]}, {"c": ["Total", "40", "Total", "40"], "b": true}]}},
							{"text": "In the books of prime entry these six lines are three day-book entries (sales, purchases, returns) and two cash-book entries - posted to the ledger in totals, with the dojo and Kenji tracked individually in the receivables and payables ledgers. Cash sales skip receivables altogether: Dr Cash, Cr Sales, straight from the till roll."}
						]},
						"learn": [
							{"text": "[b]Cash vs credit[/b]: in a cash transaction the bank moves now. On credit, a [b]receivable[/b] (customer owes us) or [b]payable[/b] (we owe a supplier) is created first, and the bank moves later when payment is made."},
							{"text": "Sales:\nCash sale: [b]Dr Bank, Cr Sales[/b]\nCredit sale: [b]Dr Receivables, Cr Sales[/b]\nCustomer later pays: [b]Dr Bank, Cr Receivables[/b]"},
							{"text": "Purchases of goods for resale:\nCash purchase: [b]Dr Purchases, Cr Bank[/b]\nCredit purchase: [b]Dr Purchases, Cr Payables[/b]\nWe later pay the supplier: [b]Dr Payables, Cr Bank[/b]"},
							{"text": "Returns:\nCustomer returns goods (sales returns / returns inwards): [b]Dr Sales returns, Cr Receivables[/b]\nWe return goods to a supplier (purchase returns / returns outwards): [b]Dr Payables, Cr Purchase returns[/b]"},
							{"text": "Owner's transactions:\nOwner pays in capital: [b]Dr Bank, Cr Capital[/b]\nOwner takes cash out (drawings): [b]Dr Drawings, Cr Bank[/b]\nOwner takes goods for personal use: [b]Dr Drawings, Cr Purchases[/b]"}
						],
						"example": {"title": "Sam's Phone Repairs - first month", "table": {"cols": ["Transaction", "Debit", "Credit", "$"], "rows": [
							{"c": ["Sam pays in capital", "Bank", "Capital", "10,000"], "s": 1},
							{"c": ["Buys parts on credit", "Purchases", "Payables", "2,400"], "s": 2},
							{"c": ["Repairs paid in cash", "Bank", "Sales", "1,500"], "s": 3},
							{"c": ["Repairs on credit", "Receivables", "Sales", "900"], "s": 3},
							{"c": ["Returns faulty parts", "Payables", "Purchase returns", "300"], "s": 4},
							{"c": ["Pays the supplier", "Payables", "Bank", "2,100"], "s": 5},
							{"c": ["Sam takes cash out", "Drawings", "Bank", "600"], "s": 6}]},
							"steps": ["Capital in: the bank goes up, and so does Sam's capital.", "Parts bought on credit: purchases go up, and we owe the supplier.", "Sales: cash sales go to the bank; credit sales create a receivable.", "Returning parts reduces what we owe (debit payables) and reduces purchases (credit purchase returns).", "Paying the supplier the remaining 2,400 - 300 = 2,100 clears the payable.", "Drawings: Sam's personal withdrawal - never an expense of the business."]},
						"practice": [
							{"type": "choice", "q": "Goods are sold on credit for 1,200. The entry is:", "opts": ["Dr Receivables, Cr Sales", "Dr Sales, Cr Receivables", "Dr Bank, Cr Sales", "Dr Receivables, Cr Bank"], "a": 0, "ex": "On credit, the customer owes us (debit receivables) and income rises (credit sales)."},
							{"type": "picklist", "q": "A business returns damaged goods costing 350 to a credit supplier: Debit {0} 350, Credit {1} 350.", "lists": [["Payables", "Purchases", "Bank"], ["Purchase returns", "Payables", "Sales returns"]], "a": [0, 0], "ex": "We owe the supplier less (debit payables) and purchases are reduced (credit purchase returns)."},
							{"type": "choice", "q": "The owner takes goods costing 200 for personal use. The entry is:", "opts": ["Dr Drawings, Cr Purchases", "Dr Purchases, Cr Drawings", "Dr Drawings, Cr Sales", "Dr Expenses, Cr Inventory"], "a": 0, "ex": "Drawings go up, and purchases are reduced because the goods are no longer for resale."},
							{"type": "sort", "q": "Which account is DEBITED in each transaction?", "buckets": ["Bank", "Receivables", "Payables"], "items": [["Cash sale", 0], ["Credit sale", 1], ["Customer pays what they owe", 0], ["We pay a supplier", 2], ["We return goods to a supplier", 2], ["Customer is invoiced for a service", 1]], "ex": "Cash coming in debits the bank; a credit sale debits receivables; paying or returning goods to a supplier debits payables."},
							{"type": "input", "q": "A customer buys goods on credit for 900, returns goods worth 150, then pays 500. How much does the customer still owe?  (number)", "accept": ["250"], "display_answer": "250", "ex": "900 - 150 returned - 500 paid = 250 still owed."}
						]
					},
					{
						"id": "L3", "title": "The journal",
						"outcome": "C2(c) Journal entries and posting them to the ledger; C2(d) Correct journals from a narrative",
						"apply": {"title": "Zuru's Lemonade Stand - the odd ones out", "pages": [
							{"text": "Most of Zuru's transactions are routine and flow through the day books and cash book. Three things this month are [b]not[/b] routine - and anything that has no day book of its own goes through the [b]journal[/b], with a narrative saying why:\n\n1. Zuru takes 30 of lemonade home for a party.\n2. Yuki keyed the 15 sugar invoice to the Cart account by mistake.\n3. Month-end depreciation on the cart, 5."},
							{"text": "", "table": {"cols": ["Journal", "Dr", "Cr", "Narrative"], "rows": [{"c": ["Drawings 30 / Purchases 30", "30", "30", "Lemonade taken by the owner for personal use"]}, {"c": ["Purchases 15 / Cart 15", "15", "15", "Correction: sugar invoice posted to non-current assets in error"]}, {"c": ["Depreciation expense 5 / Accumulated depreciation 5", "5", "5", "Cart depreciation for the month"]}]}},
							{"text": "Each journal is then [b]posted[/b] to the two ledger accounts it names. Notice the correction: the wrong entry (Dr Cart 15) is reversed by crediting Cart, and the right account (Purchases) is debited. The journal is the audit trail - six months later, Hana can see exactly why 15 moved out of Cart and who authorised it."}
						]},
						"learn": [
							{"text": "The [b]journal[/b] is the book of prime entry for transactions that don't go through the day books or cash book: corrections of errors, depreciation, year-end adjustments, unusual items."},
							{"text": "A journal entry shows:\n- the [b]date[/b]\n- the account(s) to [b]debit[/b] (listed first)\n- the account(s) to [b]credit[/b] (listed second, indented)\n- the amounts\n- a short [b]narrative[/b] explaining why"},
							{"text": "Example:\n[b]Dr Motor vehicles 18,000[/b]\n[b]   Cr Payables 18,000[/b]\nBeing a van bought on credit from Fleet Ltd.\n\nIt is then [b]posted[/b] to the two ledger accounts like any other entry."},
							{"text": "Exam tip: in an objective test you'll often be given a narrative ('the owner paid a business bill from her personal bank account') and asked for the journal. Use the three-step method: which accounts, up or down, which side."}
						],
						"practice": [
							{"type": "picklist", "q": "A van costing 18,000 is bought on credit. Journal: Debit {0} 18,000, Credit {1} 18,000.", "lists": [["Motor vehicles", "Motor expenses", "Payables"], ["Payables", "Bank", "Motor vehicles"]], "a": [0, 0], "ex": "The van is a non-current asset (debit) and a liability to the supplier is created (credit payables)."},
							{"type": "choice", "q": "Which of the following would normally be recorded in the journal?", "opts": ["The year-end depreciation charge", "A credit sales invoice", "A payment received from a customer", "A supplier's invoice"], "a": 0, "ex": "Depreciation is a non-routine adjustment, so it goes through the journal. The others have their own day books or the cash book."},
							{"type": "choice", "q": "The owner pays a business electricity bill of 300 from their PERSONAL bank account. The journal is:", "opts": ["Dr Electricity, Cr Capital", "Dr Electricity, Cr Bank", "Dr Capital, Cr Electricity", "Dr Drawings, Cr Electricity"], "a": 0, "ex": "It is a business expense (debit), funded by the owner - so it is extra capital introduced (credit capital). The business bank didn't move."},
							{"type": "choice", "q": "In a journal entry, the narrative:", "opts": ["Briefly explains the reason for the entry", "Shows the balance carried down", "Lists the books of prime entry", "Records the cash paid"], "a": 0, "ex": "The narrative explains why the entry was made, giving an audit trail."}
						]
					},
					{
						"id": "L4", "title": "Balancing off and closing the accounts",
						"outcome": "C2(e) Balance and close general ledger accounts at the year-end",
						"apply": {"title": "Zuru's Lemonade Stand - closing the month", "pages": [
							{"text": "End of month 1. Every account is [b]balanced off[/b]: add up both sides, and the difference is the balance carried down to next month.", "table": {"cols": ["Cash - Dr", "", "Cr", ""], "rows": [{"c": ["Capital", "500", "Cart", "200"]}, {"c": ["Sales", "200", "Rent", "40"]}, {"c": ["", "", "Balance c/d", "460"], "b": true}, {"c": ["", "700", "", "700"], "b": true}, {"c": ["Balance b/d", "460", "", ""]}]}},
							{"text": "Now the two kinds of account part ways.\n\n[b]Assets, liabilities and capital[/b] (cash 460, cart 200, Kenji 80, capital 500) keep their balances - they are [b]carried down[/b] into month 2, because Zuru still has the cash, still owns the cart, still owes Kenji.\n\n[b]Income and expenses[/b] (sales 200, purchases 80, rent 40) are [b]closed[/b]: their balances are transferred to the profit or loss account, so they start month 2 at nil. The month's story is over."},
							{"text": "The profit or loss account collects them: sales 200 less cost of ingredients used 60 (purchases 80 less 20 still in the box) less rent 40 = [b]profit 100[/b], which is transferred to capital: 500 + 100 = 600. The list of all the balances b/d - cash 460, cart 200, inventory 20, Kenji 80, capital 600 - is the [b]trial balance[/b], and debits equal credits: 680 each. Chapter 6 starts there."}
						]},
						"learn": [
							{"text": "At the end of a period each account is [b]balanced off[/b]:\n1. Total both sides.\n2. Put the difference on the SMALLER side as [b]balance carried down (c/d)[/b], so both sides total the same.\n3. Bring it down on the OTHER side as [b]balance brought down (b/d)[/b] to start the next period."},
							{"text": "A [b]debit balance[/b] b/d (more debits) means an asset, expense or drawings. A [b]credit balance[/b] b/d means a liability, income or capital."},
							{"text": "At the [b]year-end[/b] the two kinds of account are treated differently:\n[b]SOFP accounts[/b] (assets, liabilities, capital) keep their balances - they are carried down into next year.\n[b]SOPL accounts[/b] (income and expenses) are [b]closed[/b] - their balances are transferred to the profit or loss account, so next year starts at zero."},
							{"text": "The profit or loss account then shows the profit for the year, which is transferred to [b]capital[/b]. These balances are what go into the trial balance (Chapter 6)."}
						],
						"example": {"title": "Balancing Sam's bank account", "table": {"cols": ["Bank account", "Dr $", "Cr $"], "rows": [
							{"c": ["Capital", "10,000", ""], "s": 1}, {"c": ["Sales", "1,500", ""], "s": 1}, {"c": ["Payables", "", "2,100"], "s": 1}, {"c": ["Drawings", "", "600"], "s": 1},
							{"c": ["Balance c/d", "", "8,800"], "s": 2},
							{"c": ["Totals", "11,500", "11,500"], "s": 3, "b": true},
							{"c": ["Balance b/d", "8,800", ""], "s": 4, "b": true}]},
							"steps": ["List the entries: debits total 11,500, credits total 2,700.", "The difference, 8,800, goes on the smaller (credit) side as balance c/d.", "Both sides now total 11,500.", "Bring 8,800 down on the debit side: Sam has 8,800 in the bank (an asset) at the start of next month."]},
						"practice": [
							{"type": "input", "q": "A bank account has debits totalling 14,600 and credits totalling 9,250. What is the balance brought down?  (number)", "accept": ["5350"], "display_answer": "5,350 (debit)", "ex": "14,600 - 9,250 = 5,350. Debits are bigger, so it is a debit balance b/d - cash in the bank."},
							{"type": "picklist", "q": "The balance carried down goes on the {0} side, and is brought down on the {1} side.", "lists": [["smaller", "larger"], ["opposite", "same"]], "a": [0, 0], "ex": "Balance c/d fills up the smaller side; balance b/d then appears on the opposite side."},
							{"type": "multi", "q": "Which TWO accounts would be CLOSED to the profit or loss account at the year-end, rather than carried forward?", "opts": ["Rent expense", "Sales", "Trade payables", "Motor vehicles"], "a": [0, 1], "ex": "Income and expense accounts are closed to profit or loss. Payables and vehicles are SOFP accounts and carry their balances forward."},
							{"type": "choice", "q": "A payables account has a credit balance brought down. This means:", "opts": ["The business owes money to suppliers", "Suppliers owe money to the business", "The business has cash in the bank", "There is an error in the account"], "a": 0, "ex": "A credit balance on payables is a liability - money owed to suppliers."}
						]
					}
				]
			},
			{
				"id": 6, "title": "From trial balance to financial statements", "monster": "The Trial-Balance Golem",
				"beats": [
					{"type":"story","speaker":"Sensei Otter","text":"The hulking [b]Trial-Balance Golem[/b] guards the path to the financial statements. Strike it with the formats."},
					{"type":"story","speaker":"Sensei Otter","text":"[b]Gross profit = Revenue - Cost of sales[/b]. Cost of sales = Opening inventory + Purchases - Closing inventory. The SOFP always balances: [b]Total assets = Capital + Total liabilities[/b]."},
					{"type":"input","q":"Revenue 90,000, opening inventory 8,000, purchases 55,000, closing inventory 6,000. Gross profit = ?  (number)","accept":["33000"],"display_answer":"33,000","ex":"COS = 8,000 + 55,000 - 6,000 = 57,000. Gross profit = 90,000 - 57,000 = 33,000."},
					{"type":"choice","q":"Which is a NON-current asset?","opts":["Inventory","Trade receivables","Machinery","Bank overdraft"],"a":2,"ex":"Machinery is property, plant and equipment - a non-current asset."},
					{"type":"input","q":"Revenue 120,000, cost of sales 70,000, expenses 30,000. Profit for the year = ?  (number)","accept":["20000"],"display_answer":"20,000","ex":"Gross profit 50,000 less expenses 30,000 = 20,000."},
					{"type":"choice","q":"Carriage inwards (delivery on goods bought) is:","opts":["Included in cost of sales","An administrative expense","Ignored","Added to revenue"],"a":0,"ex":"Carriage inwards is part of the cost of purchases."},
					{"type":"choice","q":"Which appears in the statement of profit or loss?","opts":["Trade payables","The depreciation charge for the year","Bank loan","Share capital"],"a":1,"ex":"The depreciation charge is an expense in the SOPL."},
					{"type":"choice","q":"A prepayment at the year-end is shown as a:","opts":["Non-current asset","Current asset","Current liability","Reduction of capital"],"a":1,"ex":"A prepayment is value paid in advance - a current asset."},
					{"type":"choice","q":"A bank overdraft is shown as a:","opts":["Current asset","Current liability","Non-current liability","Part of capital"],"a":1,"ex":"An overdraft is repayable on demand - a current liability."},
					{"type":"choice","q":"The statement showing performance over a period is the:","opts":["Statement of financial position","Statement of profit or loss","Trial balance","List of balances"],"a":1,"ex":"The SOPL shows performance over the period; the SOFP is a snapshot."},
					{"type":"input","q":"Revenue 200,000 and gross profit 60,000. Cost of sales = ?  (number)","accept":["140000"],"display_answer":"140,000","ex":"Cost of sales = Revenue - Gross profit = 200,000 - 60,000 = 140,000."},
					{"type":"choice","q":"Carriage outwards (delivery of goods to customers) is:","opts":["A distribution expense","Part of cost of sales","Deducted from revenue","A non-current asset"],"a":0,"ex":"Carriage outwards is a selling/distribution expense; carriage INWARDS goes in cost of sales."},
					{"type":"choice","q":"Returns inwards (goods sent back by customers) are:","opts":["Deducted from revenue","Added to purchases","An administrative expense","Deducted from purchases"],"a":0,"ex":"Returns inwards reduce sales; returns outwards reduce purchases."},
					{"type":"input","q":"Current assets 45,000 and current liabilities 30,000. Net current assets = ?  (number)","accept":["15000"],"display_answer":"15,000","ex":"Net current assets = 45,000 - 30,000 = 15,000."}
				],
				# Lessons: learn -> worked example -> practice battle. Tables: rows {"c": cells, "s": step shown, "b": bold}.
				"lessons": [
					{"id":"L1","title":"What is a trial balance?","outcome":"F1(a) Purpose of a trial balance; F1(d) Limitations of a trial balance; F2(b) Errors a trial balance does not reveal","apply":{"title":"Zuru's Lemonade Stand - the month-1 trial balance","pages":[{"text":"End of month 1. Zuru balances off every account (Chapter 5) and lists the balances - debits in one column, credits in the other. That list is her first [b]trial balance[/b].","table":{"cols":["Zuru's Lemonade Stand - TB at end of month 1","Dr","Cr"],"rows":[{"c":["Cash","460",""]},{"c":["Cart","200",""]},{"c":["Purchases (lemons, yuzu, sugar)","80",""]},{"c":["Stall rent","40",""]},{"c":["Sales","","200"]},{"c":["Trade payables (Kenji)","","80"]},{"c":["Capital","","500"]},{"c":["Total","780","780"],"b":true}]}},{"text":"Both columns add to [b]780[/b] - every transaction had an equal debit and credit, so they should. The TB's job is to prove that arithmetic and to be the [b]starting point[/b] for the statements.\n\nNotice what is NOT in it: the [b]20 of ingredients still in the box[/b]. Closing inventory is counted at the month-end and given as a separate note - the TB has no idea it exists."},{"text":"Hana spots something: Zuru's 15 of sugar was debited to [b]Cart[/b] instead of Purchases. Debits 15, credits 15 - the TB still balanced perfectly. A balanced TB only proves equal totals, not that every entry is in the [b]right[/b] account. Errors of principle, omission, commission, original entry, reversal and compensating errors all slip through. If the totals had NOT agreed, she would park the difference in a [b]suspense account[/b] until she found it (Chapter 16)."}]},"learn":[{"text":"Every transaction is posted to the ledger with a [b]debit[/b] and a [b]credit[/b]. At the end of the period each account is balanced off, and the balances are listed. That list is the [b]trial balance[/b] (TB)."},{"text":"Debit balances go in one column and credit balances in the other. Every entry had two equal sides, so the two columns should [b]add up to the same total[/b].","table":{"cols":["Kenji Traders - TB at 31 Dec 20X5","Dr $","Cr $"],"rows":[{"c":["Sales revenue","","120,000"]},{"c":["Purchases","70,000",""]},{"c":["Inventory at 1 Jan 20X5","8,000",""]},{"c":["Rent","9,000",""]},{"c":["Wages","14,000",""]},{"c":["Electricity","3,000",""]},{"c":["Motor van - cost","20,000",""]},{"c":["Motor van - accumulated depreciation","","8,000"]},{"c":["Trade receivables","11,000",""]},{"c":["Bank","5,000",""]},{"c":["Trade payables","","7,000"]},{"c":["Capital at 1 Jan 20X5","","15,000"]},{"c":["Drawings","10,000",""]},{"c":["Total","150,000","150,000"],"b":true}]}},{"text":"The TB is the starting point for the financial statements. Some figures are NOT in it yet - for example [b]closing inventory[/b] is counted at the year-end and given to you as a separate note."},{"text":"Careful: a TB that balances can still be wrong. Errors of [b]omission, commission, principle, original entry, reversal[/b] and [b]compensating errors[/b] all leave the two totals equal."},{"text":"If the totals do NOT agree, the difference is put in a [b]suspense account[/b] until the error is found and corrected with a journal."}],"practice":[{"type":"choice","q":"Which of the following errors would cause the trial balance totals to disagree?","opts":["A credit sale was left out of the books completely","A payment was posted to the wrong supplier's account","Rent of 500 was debited to rent as 500 but credited to bank as 50","The purchase of a van was debited to motor expenses"],"a":2,"ex":"Debits of 500 and credits of 50 are unequal, so the TB disagrees by 450. The others are omission, commission and principle errors, which keep the TB in balance."},{"type":"multi","q":"Which TWO of the following errors would NOT be revealed by extracting a trial balance?","opts":["An error of omission","A single-sided entry","An error of principle","An addition error in one ledger account"],"a":[0,2],"ex":"Omission and principle errors keep debits equal to credits. A single-sided entry or a casting error in one account makes the totals differ."},{"type":"picklist","q":"A trial balance has debits of 84,250 and credits of 83,450. A suspense account of {0} is opened on the {1} side.","lists":[["400","800","1,600"],["debit","credit"]],"a":[1,1],"ex":"Debits exceed credits by 84,250 - 83,450 = 800, so the suspense account needs an 800 CREDIT to make the TB balance."},{"type":"input","q":"Using Kenji Traders' trial balance, what is the total of the debit column?  (number)","accept":["150000"],"display_answer":"150,000","ex":"70,000 + 8,000 + 9,000 + 14,000 + 3,000 + 20,000 + 11,000 + 5,000 + 10,000 = 150,000, which equals the credit total."}]},
					{"id":"L2","title":"Which side does it go?","outcome":"F1(b) Extract ledger balances into a trial balance; F1(d) Which side each balance sits on","apply":{"title":"Zuru's Lemonade Stand - sorting the balances","pages":[{"text":"Month 2 brings new accounts, and Zuru has to put each balance on the right side of the TB. [b]DEAD CLIC[/b]: Debit balances are Expenses, Assets and Drawings; Credit balances are Liabilities, Income and Capital.","table":{"cols":["Balance","Side","Because"],"rows":[{"c":["Cart 200","Dr","Asset"]},{"c":["Sales 350","Cr","Income"]},{"c":["Yuki's wages 60","Dr","Expense"]},{"c":["Loan from Hana 300","Cr","Liability"]},{"c":["Drawings 30 (lemonade taken home)","Dr","Reduces capital"]},{"c":["Capital 600","Cr","Owner's stake"]}]}},{"text":"Then the tricky ones:\n- [b]Accumulated depreciation[/b] on the cart, 5: a [b]credit[/b] - it reduces an asset, it isn't a liability.\n- [b]Bank overdraft[/b] (if the heater pushes cash below zero): a [b]credit[/b] - money owed to the bank.\n- [b]Sales returns[/b] 2 (the cold cup): a [b]debit[/b] - it cancels income.\n- [b]Purchase returns[/b] 10 (the mouldy crate): a [b]credit[/b] - it cancels an expense.\n- [b]Discounts received[/b] from Kenji: a [b]credit[/b] - income."},{"text":"Zuru's rule of thumb: ask what the account IS (asset, liability, income, expense, capital) and the side follows. If an account exists only to [b]reduce[/b] another (accumulated depreciation, returns, allowance for receivables), it sits on the [b]opposite[/b] side to the thing it reduces."}]},"learn":[{"text":"Remember [b]DEAD CLIC[/b]. Debit balances: Expenses, Assets, Drawings. Credit balances: Liabilities, Income, Capital."},{"text":"Watch the tricky ones. [b]Accumulated depreciation[/b] and the [b]allowance for receivables[/b] are CREDITS - they reduce an asset. A [b]bank overdraft[/b] is a credit - money owed to the bank."},{"text":"[b]Returns inwards[/b] (customers send goods back) are a debit - they reduce sales. [b]Returns outwards[/b] (you send goods back) are a credit - they reduce purchases. [b]Discounts received[/b] are income, so a credit."}],"example":{"title":"Sorting balances","table":{"cols":["Balance","Side","Why"],"rows":[{"c":["Purchases","Dr","Expense"],"s":1},{"c":["Sales revenue","Cr","Income"],"s":1},{"c":["Accumulated depreciation","Cr","Reduces an asset"],"s":2},{"c":["Drawings","Dr","Owner takes value out"],"s":2},{"c":["Bank overdraft","Cr","Liability to the bank"],"s":3},{"c":["Returns inwards","Dr","Reduces income"],"s":3}]},"steps":["Start with the easy ones: purchases are an expense (debit) and sales are income (credit).","Accumulated depreciation sits against the asset, so it is a credit. Drawings reduce capital, so they are a debit.","An overdraft is owed to the bank - a credit. Returns inwards cancel part of a sale - a debit."]},"practice":[{"type":"sort","q":"Place each balance on the side it appears in the trial balance.","buckets":["Debit","Credit"],"items":[["Opening inventory",0],["Discounts received",1],["Allowance for receivables",1],["Carriage inwards",0],["Returns outwards",1],["Prepayment",0]],"ex":"Inventory, carriage inwards (an expense) and prepayments (an asset) are debits. Discounts received (income), the allowance (reduces receivables) and returns outwards (reduce purchases) are credits."},{"type":"choice","q":"Which of the following balances appears on the CREDIT side of a trial balance?","opts":["Carriage inwards","Accumulated depreciation","Drawings","Prepaid rent"],"a":1,"ex":"Accumulated depreciation reduces the cost of non-current assets, so it is a credit balance."},{"type":"input","q":"Debit balances total 96,000 and credit balances total 71,500, before the capital account. What is the capital balance?  (number)","accept":["24500"],"display_answer":"24,500","ex":"Capital is a credit balance: 96,000 - 71,500 = 24,500 makes the two columns equal."},{"type":"choice","q":"The bank account is overdrawn by 2,300. In the trial balance this appears as:","opts":["A debit of 2,300","A credit of 2,300","It is not included","A debit in the suspense account"],"a":1,"ex":"An overdraft is money owed to the bank - a liability, so a credit balance."}]},
					{"id":"L3","title":"From the TB to the statement of profit or loss","outcome":"G2(a) Calculate revenue, cost of sales, gross profit and profit for the year; G2(b) Prepare a sole trader's SOPL from the trial balance","apply":{"title":"Zuru's Lemonade Stand - TB to profit","pages":[{"text":"From the month-1 TB (sales 200, purchases 80, rent 40) plus the note that [b]20 of ingredients are left[/b], Zuru builds the statement of profit or loss. Only the [b]income and expense[/b] balances come across; the assets, liabilities and capital wait for the SOFP.","table":{"cols":["SOPL - month 1","",""],"rows":[{"c":["Sales revenue","","200"]},{"c":["Opening inventory","0",""]},{"c":["Purchases","80",""]},{"c":["Closing inventory (note)","(20)",""]},{"c":["Cost of sales","","(60)"]},{"c":["Gross profit","","140"],"b":true},{"c":["Stall rent","","(40)"]},{"c":["Profit for the month","","100"],"b":true}]}},{"text":"Two things to notice:\n- [b]Cost of sales[/b] is what she USED, not what she bought: 80 bought less 20 still in the box = 60.\n- [b]Gross profit[/b] (140) is the lemonade margin; [b]profit for the month[/b] (100) is what is left after running costs.\n\nIn month 2 the 20 left over becomes [b]opening inventory[/b], and carriage inwards on Kenji's deliveries joins cost of sales; carriage outwards (delivering to the cafe) is a distribution expense below gross profit."}]},"learn":[{"text":"The [b]statement of profit or loss[/b] (SOPL) takes every income and expense balance from the TB and works out the profit for the year."},{"text":"The format:\nRevenue\nless Cost of sales\n= [b]Gross profit[/b]\nless Expenses\n= [b]Profit for the year[/b]"},{"text":"[b]Cost of sales = Opening inventory + Purchases + Carriage inwards - Closing inventory[/b]. Closing inventory comes from the year-end count note, not from the TB."},{"text":"Expenses include rent, wages, electricity, depreciation and irrecoverable debts - each adjusted for accruals and prepayments at the year-end."}],"example":{"title":"Kenji Traders' SOPL","table":{"cols":["SOPL for the year to 31 Dec 20X5","$","$"],"rows":[{"c":["Revenue","","120,000"],"s":1,"b":true},{"c":["Opening inventory","8,000",""],"s":2},{"c":["Purchases","70,000",""],"s":2},{"c":["Closing inventory (note)","(10,000)",""],"s":2},{"c":["Cost of sales","","(68,000)"],"s":2},{"c":["Gross profit","","52,000"],"s":3,"b":true},{"c":["Rent","9,000",""],"s":4},{"c":["Wages","14,000",""],"s":4},{"c":["Electricity","3,000",""],"s":4},{"c":["Total expenses","","(26,000)"],"s":4},{"c":["Profit for the year","","26,000"],"s":5,"b":true}]},"steps":["Start with revenue: the 120,000 credit balance from the TB.","Cost of sales: opening inventory 8,000 + purchases 70,000 - closing inventory 10,000 (from the note) = 68,000.","Gross profit = 120,000 - 68,000 = 52,000.","Now the expenses from the TB: rent 9,000 + wages 14,000 + electricity 3,000 = 26,000.","Profit for the year = 52,000 - 26,000 = [b]26,000[/b]. Next lesson, this profit goes into the SOFP."]},"practice":[{"type":"input","q":"Revenue 95,000; opening inventory 6,000; purchases 52,000; closing inventory 7,500; expenses 21,000. Profit for the year = ?  (number)","accept":["23500"],"display_answer":"23,500","ex":"Cost of sales = 6,000 + 52,000 - 7,500 = 50,500. Gross profit = 95,000 - 50,500 = 44,500. Profit = 44,500 - 21,000 = 23,500."},{"type":"multi","q":"Which TWO of the following are included in cost of sales?","opts":["Carriage inwards","Opening inventory","Carriage outwards","Depreciation of delivery vans"],"a":[0,1],"ex":"Cost of sales = opening inventory + purchases + carriage inwards - closing inventory. Carriage outwards and delivery van depreciation are distribution expenses."},{"type":"picklist","q":"Closing inventory is {0} in the statement of profit or loss and shown as a {1} in the statement of financial position.","lists":[["deducted in cost of sales","added to cost of sales","added to revenue"],["current asset","non-current asset","current liability"]],"a":[0,0],"ex":"Closing inventory reduces cost of sales (it has not been sold) and is a current asset at the year-end. It appears in BOTH statements."},{"type":"choice","q":"Which of the following is shown as an expense in the statement of profit or loss?","opts":["Drawings","Repayment of a bank loan","Depreciation charge for the year","Purchase of a new van"],"a":2,"ex":"Depreciation is an expense. Drawings reduce capital, a loan repayment reduces a liability and a van is a non-current asset."}]},
					{"id":"L4","title":"From the TB to the statement of financial position","outcome":"G1(a) Recognise how the accounting equation and business entity shape the SOFP; G1(b) Prepare a sole trader's SOFP from the trial balance","apply":{"title":"Zuru's Lemonade Stand - TB to position","pages":[{"text":"The remaining TB balances - cart, cash, Kenji, capital - plus the closing inventory (again!) and the profit just calculated make the statement of financial position.","table":{"cols":["SOFP - end of month 1","",""],"rows":[{"c":["Non-current asset: cart","","200"]},{"c":["Inventory","20",""]},{"c":["Cash","460",""]},{"c":["Current assets","","480"]},{"c":["Total assets","","680"],"b":true},{"c":["Capital at start","500",""]},{"c":["Profit for the month","100",""]},{"c":["Drawings","(0)",""]},{"c":["Closing capital","","600"]},{"c":["Current liability: Kenji","","80"]},{"c":["Capital + liabilities","","680"],"b":true}]}},{"text":"It balances - 680 both sides - because the TB balanced and every figure went somewhere. [b]Closing inventory appears twice[/b]: in cost of sales (reducing the expense) and here as a current asset. One count, two statements.\n\n[b]Business entity[/b] shows up in the capital section: Zuru's own 500 is what the BUSINESS owes HER. Her savings account, her bike, her rent at home - none of it belongs on this page. If she had taken 30 of lemonade home, it would appear as drawings, cutting closing capital to 570."}]},"learn":[{"text":"The [b]statement of financial position[/b] (SOFP) shows what the business owns and owes at the year-end: assets, capital and liabilities."},{"text":"Non-current assets are shown at [b]carrying amount[/b] (cost - accumulated depreciation). Current assets: [b]closing inventory[/b], receivables, prepayments and bank."},{"text":"Capital: [b]Opening capital + Profit for the year - Drawings = Closing capital[/b]. Then the liabilities: payables, accruals, overdraft and loans."},{"text":"Always check: [b]Total assets = Capital + Liabilities[/b]. If it doesn't balance, something has been missed or counted twice."}],"example":{"title":"Kenji Traders' SOFP","table":{"cols":["SOFP at 31 Dec 20X5","$","$"],"rows":[{"c":["Motor van (20,000 - 8,000)","","12,000"],"s":1},{"c":["Inventory","10,000",""],"s":2},{"c":["Trade receivables","11,000",""],"s":2},{"c":["Bank","5,000",""],"s":2},{"c":["Current assets","","26,000"],"s":2},{"c":["Total assets","","38,000"],"s":3,"b":true},{"c":["Capital at 1 Jan 20X5","15,000",""],"s":4},{"c":["Profit for the year","26,000",""],"s":4},{"c":["Drawings","(10,000)",""],"s":4},{"c":["Closing capital","","31,000"],"s":4},{"c":["Trade payables","","7,000"],"s":5},{"c":["Capital + liabilities","","38,000"],"s":5,"b":true}]},"steps":["Non-current assets at carrying amount: van 20,000 - 8,000 = 12,000.","Current assets: closing inventory 10,000 (the same figure taken off cost of sales), receivables 11,000 and bank 5,000 = 26,000.","Total assets = 12,000 + 26,000 = 38,000.","Capital: 15,000 + profit 26,000 - drawings 10,000 = 31,000.","Liabilities: trade payables 7,000. Capital + liabilities = 38,000 = total assets. [b]It balances![/b]"]},"practice":[{"type":"input","q":"Opening capital 30,000; profit 18,500; drawings 12,000; capital introduced 5,000. Closing capital = ?  (number)","accept":["41500"],"display_answer":"41,500","ex":"30,000 + 5,000 + 18,500 - 12,000 = 41,500."},{"type":"multi","q":"Which TWO of the following are current liabilities?","opts":["Accrued electricity","Bank overdraft","Prepaid insurance","Bank loan repayable in five years"],"a":[0,1],"ex":"Accruals and overdrafts are due within 12 months. A prepayment is a current asset and a five-year loan is non-current."},{"type":"input","q":"Machinery cost 45,000. Accumulated depreciation brought forward 12,000; this year's charge 4,500. Carrying amount in the SOFP = ?  (number)","accept":["28500"],"display_answer":"28,500","ex":"45,000 - (12,000 + 4,500) = 28,500."},{"type":"choice","q":"In a sole trader's SOFP, drawings are shown as:","opts":["An expense","A deduction from capital","A current liability","A current asset"],"a":1,"ex":"Drawings are value the owner took out, so they reduce capital."}]},
					{
						"id": "L5", "title": "The opening trial balance and the accounting equation",
						"outcome": "F1(c) Extracts of an opening trial balance; C1(c) Explain and apply the accounting equation",
						"apply": {"title": "Zuru's Lemonade Stand - day 1 of month 2", "pages": [
							{"text": "Month 2 opens with only the [b]SOFP accounts[/b] on the books. Sales, purchases and rent were closed off to profit, so they start at nil - last month's story is already inside capital (500 + 100).", "table": {"cols": ["Opening TB - 1st of month 2", "Dr", "Cr"], "rows": [{"c": ["Cash", "460", ""]}, {"c": ["Cart", "200", ""]}, {"c": ["Inventory", "20", ""]}, {"c": ["Trade payables (Kenji)", "", "80"]}, {"c": ["Capital", "", "600"]}, {"c": ["Total", "680", "680"], "b": true}]}},
							{"text": "That opening TB is the [b]accounting equation[/b] written as a list:\n[b]Assets 680 = Capital 600 + Liabilities 80[/b]\n\nWatch it stay in balance on day 1:\n- Buys 50 of lemons for cash: assets still 680 (cash -50, inventory +50).\n- Pays Kenji 80: assets 600, liabilities 0, capital 600.\n- Sells 30 cups for 60 cash, using 20 of lemons: assets 640 (+60 -20), capital 640 (profit 40).\n\nEvery transaction nudges two things and the equation never breaks - that is duality, and it is why the TB will balance again at the end of month 2."}
						]},
						"learn": [
							{"text": "An [b]opening trial balance[/b] lists the balances on the first day of a new period. Only [b]SOFP accounts[/b] appear: assets, liabilities and capital - the balances brought down from last year."},
							{"text": "Income and expense accounts are NOT in the opening trial balance: they were closed to the profit or loss account at the year-end, so they start the new year at nil. Last year's profit is already inside the capital balance."},
							{"text": "The [b]accounting equation[/b] is the SOFP in one line:\n[b]Assets = Capital + Liabilities[/b]\nBecause every transaction has two sides (duality), the equation always stays in balance."},
							{"text": "Capital grows and shrinks in a fixed way:\n[b]Closing capital = Opening capital + Capital introduced + Profit - Drawings[/b]\nAnd capital = net assets (assets - liabilities)."},
							{"text": "That lets you find a missing figure - a favourite exam question:\n[b]Profit = Closing net assets - Opening net assets + Drawings - Capital introduced[/b]"}
						],
						"example": {"title": "Kenji Traders' opening trial balance at 1 Jan 20X6", "table": {"cols": ["Opening TB at 1 Jan 20X6", "Dr $", "Cr $"], "rows": [
							{"c": ["Motor van - cost", "20,000", ""], "s": 1}, {"c": ["Inventory", "10,000", ""], "s": 1}, {"c": ["Trade receivables", "11,000", ""], "s": 1}, {"c": ["Bank", "5,000", ""], "s": 1},
							{"c": ["Motor van - accumulated depreciation", "", "8,000"], "s": 2}, {"c": ["Trade payables", "", "7,000"], "s": 2},
							{"c": ["Capital (15,000 + 26,000 - 10,000)", "", "31,000"], "s": 3},
							{"c": ["Total", "46,000", "46,000"], "s": 4, "b": true}]},
							"steps": ["The assets carried forward from Kenji's SOFP at 31 December become debit balances.", "Accumulated depreciation and payables are credit balances.", "Capital now includes last year's profit less drawings: 31,000. There is no sales, wages or rent - those started again at nil.", "Debits 46,000 = credits 46,000. It balances."]},
						"practice": [
							{"type": "multi", "q": "Which TWO balances would appear in an opening trial balance?", "opts": ["Trade payables", "Inventory", "Sales revenue", "Wages"], "a": [0, 1], "ex": "Only SOFP balances are carried forward. Sales and wages were closed to profit or loss at the year-end."},
							{"type": "input", "q": "Net assets were 42,000 at the start of the year and 51,000 at the end. Drawings were 13,000 and the owner introduced 5,000 of capital. Profit for the year = ?  (number)", "accept": ["17000"], "display_answer": "17,000", "ex": "Profit = 51,000 - 42,000 + 13,000 - 5,000 = 17,000."},
							{"type": "sort", "q": "Is each balance reported in the statement of financial position or the statement of profit or loss?", "buckets": ["SOFP", "SOPL"], "items": [["Trade receivables", 0], ["Rent", 1], ["Bank loan", 0], ["Sales revenue", 1], ["Accumulated depreciation", 0], ["Carriage inwards", 1]], "ex": "Assets, liabilities and accumulated depreciation go in the SOFP; income and expenses (including carriage inwards) go in the SOPL."},
							{"type": "input", "q": "Opening capital 25,000; closing capital 31,500; drawings 8,000; no new capital introduced. Profit for the year = ?  (number)", "accept": ["14500"], "display_answer": "14,500", "ex": "31,500 = 25,000 + profit - 8,000, so profit = 31,500 - 25,000 + 8,000 = 14,500."},
							{"type": "picklist", "q": "Assets are 64,000 and capital is 39,000, so liabilities are {0}. If the owner then takes 1,000 cash as drawings, assets {1}.", "lists": [["25,000", "103,000", "39,000"], ["fall by 1,000", "rise by 1,000", "do not change"]], "a": [0, 0], "ex": "Liabilities = 64,000 - 39,000 = 25,000. Drawings take cash out, so assets (and capital) both fall by 1,000."}
						]
					}
				],
				# Section B style multi-task question (15 marks, part marks per blank).
				"mtq": {"title":"Section B: Hana's Flower Shop","monster":"The Trial-Balance Golem","marks":15,"scenario":[{"text":"Hana runs a flower shop as a sole trader. Her trial balance at [b]30 June 20X6[/b] is below."},{"table":{"cols":["Trial balance at 30 June 20X6","Dr $","Cr $"],"rows":[{"c":["Revenue","","186,000"]},{"c":["Purchases","98,000",""]},{"c":["Inventory at 1 July 20X5","12,000",""]},{"c":["Wages","31,000",""]},{"c":["Rent","12,000",""]},{"c":["Insurance","2,400",""]},{"c":["Electricity","4,100",""]},{"c":["Shop fittings - cost","40,000",""]},{"c":["Shop fittings - accumulated depreciation at 1 July 20X5","","16,000"]},{"c":["Trade receivables","9,000",""]},{"c":["Bank","6,500",""]},{"c":["Trade payables","","8,200"]},{"c":["Drawings","18,000",""]},{"c":["Capital at 1 July 20X5","","22,800"]},{"c":["Total","233,000","233,000"],"b":true}]}},{"text":"[b]Notes[/b]\n1. Inventory at 30 June 20X6 was counted at 14,500.\n2. Shop fittings are depreciated at 10% a year on cost (straight line).\n3. Electricity of 700 is owed at 30 June 20X6.\n4. The insurance of 2,400 was paid on 1 January 20X6 for the year to 31 December 20X6. It is the only insurance for the year.\n5. A receivable of 600 is irrecoverable and must be written off."}],"tasks":[{"title":"Task 1: Statement of profit or loss for the year to 30 June 20X6","intro":"Enter the missing figures. Type amounts as positive numbers.","rows":[{"c":["Revenue","186,000"]},{"c":["Cost of sales","#cos"]},{"c":["Wages","31,000"]},{"c":["Rent","12,000"]},{"c":["Insurance","#ins"]},{"c":["Electricity","#elec"]},{"c":["Depreciation","#dep"]},{"c":["Irrecoverable debts","600"]},{"c":["Profit for the year","#profit"],"b":true}],"blanks":{"cos":{"accept":["95500"],"show":"95,500","marks":2,"ex":"12,000 + 98,000 - 14,500 = 95,500."},"ins":{"accept":["1200"],"show":"1,200","marks":2,"ex":"Only January to June 20X6 belongs to this year: 6/12 x 2,400 = 1,200. The other 1,200 is a prepayment."},"elec":{"accept":["4800"],"show":"4,800","marks":2,"ex":"4,100 paid + 700 accrued = 4,800."},"dep":{"accept":["4000"],"show":"4,000","marks":1,"ex":"10% x 40,000 cost = 4,000."},"profit":{"accept":["36900"],"show":"36,900","marks":1,"ex":"Gross profit 90,500 less expenses (31,000 + 12,000 + 1,200 + 4,800 + 4,000 + 600 = 53,600) = 36,900."}}},{"title":"Task 2: Statement of financial position at 30 June 20X6","intro":"Enter the missing figures.","rows":[{"c":["Shop fittings (carrying amount)","#fit"]},{"c":["Inventory","14,500"]},{"c":["Trade receivables","#rec"]},{"c":["Prepayment","#pre"]},{"c":["Bank","6,500"]},{"c":["Capital at 1 July 20X5","22,800"]},{"c":["Profit for the year","(from Task 1)"]},{"c":["Drawings","(18,000)"]},{"c":["Closing capital","#cap"],"b":true},{"c":["Current liabilities (payables + accrual)","#cl"]}],"blanks":{"fit":{"accept":["20000"],"show":"20,000","marks":1,"ex":"40,000 - (16,000 + 4,000) = 20,000."},"rec":{"accept":["8400"],"show":"8,400","marks":1,"ex":"9,000 - 600 written off = 8,400."},"pre":{"accept":["1200"],"show":"1,200","marks":1,"ex":"Insurance for July to December 20X6 was paid in advance: 1,200."},"cap":{"accept":["41700"],"show":"41,700","marks":2,"ex":"22,800 + 36,900 - 18,000 = 41,700."},"cl":{"accept":["8900"],"show":"8,900","marks":2,"ex":"Trade payables 8,200 + electricity accrual 700 = 8,900. Check: assets 20,000 + 14,500 + 8,400 + 1,200 + 6,500 = 50,600 = 41,700 + 8,900."}}}]}
			},
			{
				"id": 7, "title": "Inventory", "monster": "The Stockpile Slime",
				"beats": [
					{"type":"story","speaker":"Sensei Otter","text":"The [b]Stockpile Slime[/b] hoards goods in a quivering heap. Value its hoard correctly to make it shrink."},
					{"type":"story","speaker":"Sensei Otter","text":"Inventory = [b]lower of cost and NRV[/b]. NRV = selling price - costs to complete - costs to sell. [b]Cost of sales = Opening + Purchases - Closing[/b]. FIFO: oldest sold first; [b]LIFO is not allowed[/b]."},
					{"type":"choice","q":"Inventory is valued at:","opts":["Cost only","The lower of cost and net realisable value","Selling price","The higher of cost and NRV"],"a":1,"ex":"Prudence requires the lower of cost and NRV."},
					{"type":"choice","q":"Which method is NOT allowed under IFRS?","opts":["FIFO","Weighted average cost","LIFO","Periodic weighted average"],"a":2,"ex":"LIFO is not permitted in the financial statements."},
					{"type":"input","q":"Opening inventory 5,000, purchases 40,000, closing inventory 7,000. Cost of sales = ?  (number)","accept":["38000"],"display_answer":"38,000","ex":"COS = 5,000 + 40,000 - 7,000 = 38,000."},
					{"type":"input","q":"Opening inventory 12,000, purchases 60,000, closing inventory 9,000. Cost of sales = ?  (number)","accept":["63000"],"display_answer":"63,000","ex":"COS = 12,000 + 60,000 - 9,000 = 63,000."},
					{"type":"input","q":"FIFO: bought 100 units at 5 then 100 at 7, sold 120. Value of closing inventory (80 units)?  (number)","accept":["560"],"display_answer":"560","ex":"FIFO leaves the newest 80 units at 7 each = 560."},
					{"type":"choice","q":"Net realisable value is:","opts":["Selling price minus costs to complete and sell","Original purchase cost","Replacement cost","Selling price including tax"],"a":0,"ex":"NRV = selling price - costs to complete - costs to sell."},
					{"type":"choice","q":"Which cost is EXCLUDED from the cost of inventory?","opts":["Purchase price","Import duties","Storage of finished goods","Conversion costs"],"a":2,"ex":"Storage of finished goods does not bring inventory to its present condition."},
					{"type":"choice","q":"Closing inventory was overstated. The effect on profit is:","opts":["Profit understated","Profit overstated","No effect","Profit halved"],"a":1,"ex":"Higher closing inventory reduces cost of sales, so profit is overstated."},
					{"type":"input","q":"An item cost 800. It will sell for 1,000 after costs to complete of 150 and selling costs of 100. Inventory value = ?  (number)","accept":["750"],"display_answer":"750","ex":"NRV = 1,000 - 150 - 100 = 750, which is below cost of 800, so value at 750."},
					{"type":"input","q":"50 damaged units cost 20 each and will now sell for 12 each (no selling costs). Write-down needed = ?  (number)","accept":["400"],"display_answer":"400","ex":"NRV 12 is below cost 20: 50 x (20 - 12) = 400."},
					{"type":"choice","q":"Under a PERPETUAL inventory system:","opts":["Inventory records are updated after every receipt and issue","Inventory is only counted at the year-end","Inventory is never counted","Only LIFO can be used"],"a":0,"ex":"Perpetual = a running balance after every movement; periodic = counted at intervals."},
					{"type":"choice","q":"Closing inventory was UNDERSTATED by 2,000. This year's profit is:","opts":["Understated by 2,000","Overstated by 2,000","Unaffected","Understated by 4,000"],"a":0,"ex":"Lower closing inventory raises cost of sales, so profit is understated by 2,000."}
				],
				# Ch 7 learning objectives: D3(a)-(g). Exam: 'cost' vs 'NRV', calculations, opening and closing inventory adjustments.
				"lessons": [
					{
						"id": "L1", "title": "Why inventory needs adjusting",
						"outcome": "D3(a) Need for inventory adjustments; D3(b) Record cost of sales and closing inventory; D3(e) Continuous vs period-end records",
						"apply": {"title": "Zuru's Lemonade Stand - counting the lemons", "pages": [
							{"text": "Month 2: Zuru started with [b]20[/b] of ingredients, bought [b]300[/b] from Kenji, and on the last evening counts what is left in the cold box: [b]45[/b]. Purchases are NOT the cost of what she sold - some of it is still sitting there.", "table": {"cols": ["Cost of sales - month 2", ""], "rows": [{"c": ["Opening inventory", "20"]}, {"c": ["Purchases", "300"]}, {"c": ["Closing inventory (counted)", "(45)"]}, {"c": ["Cost of sales", "275"], "b": true}]}},
							{"text": "The month-end adjustment is the same every time:\n[b]Dr Inventory (SOFP) 45, Cr Cost of sales (SOPL) 45[/b] for the closing count, after the opening 20 has been moved into cost of sales. The 45 becomes next month's opening inventory."},
							{"text": "Her cloud app keeps a [b]continuous record[/b] - it thinks 50 is left, because it deducts a recipe amount every time a cup is sold. The physical count says 45. The 5 difference is the splashes, the burst lemon and the cup Yuki dropped. The [b]count wins[/b], and the 5 of wastage goes into cost of sales. A business with only [b]period-end[/b] records (the shoebox days) has no running figure at all - the count IS the only number."}
						]},
						"learn": [
							{"text": "During the year, goods bought for resale are debited to [b]Purchases[/b]. But not everything bought is sold - some is still on the shelf at the year-end. That unsold stock is [b]closing inventory[/b]."},
							{"text": "To match costs with sales (accruals), only the cost of goods actually SOLD should be an expense:\n[b]Cost of sales = Opening inventory + Purchases - Closing inventory[/b]"},
							{"text": "Two year-end entries do this:\n[b]Opening inventory[/b] (last year's closing stock, now being sold): Dr Cost of sales (SOPL), Cr Inventory (SOFP).\n[b]Closing inventory[/b] (unsold at the year-end): Dr Inventory (SOFP), Cr Cost of sales (SOPL)."},
							{"text": "So closing inventory appears [b]twice[/b]: it reduces cost of sales in the SOPL, and it is a [b]current asset[/b] in the SOFP. Next year it becomes opening inventory."},
							{"text": "Recording inventory:\n[b]Period-end (periodic) system[/b] - inventory is counted at the year-end to find closing inventory.\n[b]Continuous (perpetual) system[/b] - the records are updated after every receipt and issue, so there's always a running balance (still checked by counts from time to time)."}
						],
						"example": {"title": "Ana's Shoes - cost of sales", "table": {"cols": ["", "$", "$"], "rows": [
							{"c": ["Sales", "", "80,000"], "s": 1, "b": true},
							{"c": ["Opening inventory", "6,000", ""], "s": 2}, {"c": ["Purchases", "50,000", ""], "s": 2},
							{"c": ["Goods available for sale", "56,000", ""], "s": 3},
							{"c": ["Closing inventory", "(9,000)", ""], "s": 4}, {"c": ["Cost of sales", "", "(47,000)"], "s": 4},
							{"c": ["Gross profit", "", "33,000"], "s": 5, "b": true}]},
							"steps": ["Start with sales of 80,000.", "Add opening inventory (bought last year, sold this year) to this year's purchases.", "That's everything available to sell: 56,000.", "Take off what is still unsold at the year-end, 9,000: cost of sales is 47,000.", "Gross profit = 80,000 - 47,000 = 33,000. And the 9,000 also goes into the SOFP as a current asset."]},
						"practice": [
							{"type": "input", "q": "Opening inventory 7,500; purchases 62,000; closing inventory 8,200. Cost of sales = ?  (number)", "accept": ["61300"], "display_answer": "61,300", "ex": "7,500 + 62,000 - 8,200 = 61,300."},
							{"type": "picklist", "q": "To record closing inventory: Debit {0}, Credit {1}.", "lists": [["Inventory (SOFP)", "Cost of sales (SOPL)", "Purchases"], ["Cost of sales (SOPL)", "Inventory (SOFP)", "Payables"]], "a": [0, 0], "ex": "Closing inventory is an asset (debit inventory) and reduces cost of sales (credit cost of sales)."},
							{"type": "choice", "q": "A system that updates inventory records after every purchase and sale is:", "opts": ["A continuous (perpetual) inventory system", "A period-end inventory system", "FIFO", "The imprest system"], "a": 0, "ex": "Continuous records give a running balance; period-end systems rely on a count at the year-end."},
							{"type": "multi", "q": "Where does closing inventory appear in the financial statements? Select TWO.", "opts": ["As a deduction in cost of sales", "As a current asset in the SOFP", "As a non-current asset", "As an expense below gross profit"], "a": [0, 1], "ex": "Closing inventory reduces cost of sales and is shown as a current asset."}
						]
					},
					{
						"id": "L2", "title": "Valuing inventory: cost or NRV",
						"outcome": "D3(c) IFRS valuation of inventory (IAS 2); D3(d) Costs included in inventory",
						"apply": {"title": "Zuru's Lemonade Stand - the soft crate of yuzu", "pages": [
							{"text": "A crate of yuzu cost [b]40[/b] from Kenji plus [b]6[/b] delivery. By month-end it is going soft. Zuru reckons the lemonade she can still make from it will sell for [b]25[/b], but she will need [b]5[/b] of sugar to mask the taste.\n\nIAS 2: inventory is valued at the [b]lower of cost and net realisable value[/b], item by item."},
							{"text": "", "table": {"cols": ["The yuzu crate", ""], "rows": [{"c": ["Cost: 40 purchase + 6 carriage inwards", "46"]}, {"c": ["NRV: 25 selling price - 5 costs to complete", "20"]}, {"c": ["Value in the SOFP (the lower)", "20"], "b": true}, {"c": ["Write-down charged to cost of sales", "26"]}]}},
							{"text": "What counts as [b]cost[/b]: the purchase price, carriage [b]inwards[/b], import duties - anything to get the goods to the stand and ready to use. What does NOT: the stall rent while the crate sat there (storage), Yuki's time selling it, carriage [b]outwards[/b] to the cafe. Those are expenses of the period, not of the lemons.\n\nThe fresh crates stay at cost (46 each) - only the one whose NRV fell below cost is written down."}
						]},
						"learn": [
							{"text": "IAS 2 says inventory is valued at the [b]lower of cost and net realisable value (NRV)[/b]. This is prudence: never show inventory at more than it will bring in."},
							{"text": "[b]Cost[/b] includes all costs of bringing the inventory to its present [b]location and condition[/b]:\n- purchase price (less trade discounts), import duties, carriage inwards\n- costs of conversion - direct labour and production overheads\n- other costs needed to get it there"},
							{"text": "NOT included in cost:\n- selling and distribution costs\n- general administration overheads\n- storage costs (unless needed between production stages)\n- abnormal waste\n- recoverable sales tax"},
							{"text": "[b]NRV = Selling price - costs to complete - costs to sell[/b]\nNRV falls below cost when goods are damaged, out of date, or selling prices have dropped."},
							{"text": "Compare cost and NRV [b]item by item[/b] (or for groups of similar items) - not for the total inventory, or losses on some items would be hidden by gains on others."}
						],
						"example": {"title": "Lower of cost and NRV, item by item", "table": {"cols": ["Item", "Cost", "NRV", "Value"], "rows": [
							{"c": ["Boots", "4,000", "6,500", "4,000"], "s": 1},
							{"c": ["Sandals (damaged)", "3,000", "1,800", "1,800"], "s": 2},
							{"c": ["Trainers", "5,000", "5,200", "5,000"], "s": 3},
							{"c": ["Inventory value", "12,000", "13,500", "10,800"], "s": 4, "b": true}]},
							"steps": ["Boots: cost 4,000 is lower than NRV - use cost.", "Sandals are damaged: NRV 1,800 is below cost - write down to 1,800.", "Trainers: cost 5,000 is lower - use cost.", "Total 10,800. Comparing totals (12,000 vs 13,500) would wrongly give 12,000 and hide the sandals' loss."]},
						"practice": [
							{"type": "input", "q": "An item cost 500. It can be sold for 650 after repairs of 120 and selling costs of 80. At what amount should it be valued?  (number)", "accept": ["450"], "display_answer": "450", "ex": "NRV = 650 - 120 - 80 = 450, which is lower than cost 500, so value at 450."},
							{"type": "multi", "q": "Which TWO costs should be INCLUDED in the cost of inventory?", "opts": ["Import duties on goods bought", "Carriage inwards", "Delivery costs to customers", "Head office administration costs"], "a": [0, 1], "ex": "Import duties and carriage inwards bring goods to their present location. Delivery to customers is a selling cost; head office admin isn't part of cost."},
							{"type": "choice", "q": "Under IAS 2, inventory is valued at:", "opts": ["The lower of cost and net realisable value", "The higher of cost and net realisable value", "Selling price", "Replacement cost"], "a": 0, "ex": "Lower of cost and NRV, compared item by item."},
							{"type": "input", "q": "Three items: A cost 200 NRV 300; B cost 450 NRV 380; C cost 150 NRV 160. Total inventory value = ?  (number)", "accept": ["730"], "display_answer": "730", "ex": "A 200 + B 380 (NRV) + C 150 = 730."}
						]
					},
					{
						"id": "L3", "title": "FIFO and AVCO",
						"outcome": "D3(f) Closing inventory by FIFO and AVCO (periodic and continuous weighted average)",
						"apply": {"title": "Zuru's Lemonade Stand - which lemons did she use?", "pages": [
							{"text": "Lemon prices rose in month 3. Zuru bought [b]10 crates at 8[/b] on the 2nd and [b]10 crates at 10[/b] on the 16th, and used [b]12 crates[/b]. Eight are left - but which eight? She can't tell one lemon from another, so IAS 2 lets her ASSUME a cost flow."},
							{"text": "", "table": {"cols": ["Method", "Assumption", "Closing inventory (8 crates)", "Cost of sales (12)"], "rows": [{"c": ["FIFO", "First in, first out: the 8 at 8 went first, so what is left is the newest", "8 x 10 = 80", "(10 x 8) + (2 x 10) = 100"]}, {"c": ["AVCO (periodic)", "One average for the month: (80 + 100) / 20 = 9 per crate", "8 x 9 = 72", "12 x 9 = 108"]}]}},
							{"text": "[b]Continuous AVCO[/b] re-averages after every delivery instead of once a month: if she had used 6 crates before the 16th (all at 8), the new average after the second delivery would be (4 x 8 + 10 x 10) / 14 = 9.43, and the next 6 used would cost 9.43 each. Same idea, more arithmetic - the exam tells you which version to use.\n\n[b]LIFO[/b] (newest first) is not allowed under IFRS."}
						]},
						"learn": [
							{"text": "When identical items are bought at different prices, we need a rule for which cost goes out with each sale. IFRS allows [b]FIFO[/b] and [b]AVCO[/b]. ([b]LIFO is not allowed.[/b])"},
							{"text": "[b]FIFO - first in, first out[/b]: the OLDEST items are assumed sold first, so closing inventory is valued at the MOST RECENT prices."},
							{"text": "[b]AVCO - average cost[/b], two versions:\n[b]Periodic weighted average[/b]: one average for the whole period = total cost of all units available / total units available.\n[b]Continuous weighted average[/b]: a new average is worked out after EVERY purchase, and issues are costed at the latest average."},
							{"text": "Tip: lay it out as a table - date, units in, units out, balance - and work line by line. The worked example shows all three methods on the same data."}
						],
						"example": {"title": "January: three methods, same data", "table": {"cols": ["Step", "FIFO", "Periodic AVCO", "Continuous AVCO"], "rows": [
							{"c": ["1 Jan buy 100 @ 10; 10 Jan buy 200 @ 13", "100@10, 200@13", "-", "300 units, 3,600 = 12.00 each"], "s": 1},
							{"c": ["15 Jan sell 150", "Out: 100@10 + 50@13", "-", "Out: 150 @ 12.00 = 1,800; left 150 = 1,800"], "s": 2},
							{"c": ["20 Jan buy 100 @ 16", "Left: 150@13 + 100@16", "-", "250 units, 3,400 = 13.60 each"], "s": 3},
							{"c": ["31 Jan sell 120", "Out: 120@13", "Average: 5,200 / 400 = 13.00", "Out: 120 @ 13.60 = 1,632"], "s": 4},
							{"c": ["Closing inventory (130 units)", "30@13 + 100@16 = 1,990", "130 x 13.00 = 1,690", "3,400 - 1,632 = 1,768"], "s": 5, "b": true}]},
							"steps": ["Two purchases: 300 units. Continuous AVCO works out an average straight away: 3,600 / 300 = 12.00.", "Sell 150. FIFO uses the oldest first: all 100 @ 10 plus 50 @ 13. Continuous AVCO issues at 12.00.", "Buy 100 more @ 16. Continuous AVCO re-averages: (1,800 + 1,600) / 250 = 13.60.", "Sell 120. FIFO takes them from the 150 left @ 13. Periodic AVCO only needs the period average: total purchases 5,200 / 400 units = 13.00.", "130 units remain. FIFO 1,990 (newest prices), periodic AVCO 1,690, continuous AVCO 1,768."]},
						"practice": [
							{"type": "input", "q": "Using the worked example's January data, what is closing inventory under FIFO?  (number)", "accept": ["1990"], "display_answer": "1,990", "ex": "FIFO leaves the newest units: 30 @ 13 + 100 @ 16 = 390 + 1,600 = 1,990."},
							{"type": "input", "q": "Bought 200 units @ 5 and 300 units @ 6 in the period; sold 350. Periodic weighted average: closing inventory = ?  (number)", "accept": ["840"], "display_answer": "840", "ex": "Average = (1,000 + 1,800) / 500 = 5.60. Closing 150 units x 5.60 = 840."},
							{"type": "input", "q": "FIFO: bought 80 @ 20, then 120 @ 25. Sold 100. Closing inventory = ?  (number)", "accept": ["2500"], "display_answer": "2,500", "ex": "Sold the 80 @ 20 and 20 @ 25. Left: 100 @ 25 = 2,500."},
							{"type": "choice", "q": "Which inventory valuation method is NOT permitted under IFRS?", "opts": ["LIFO", "FIFO", "Periodic weighted average", "Continuous weighted average"], "a": 0, "ex": "LIFO is not allowed under IAS 2."},
							{"type": "choice", "q": "Under continuous weighted average, a new average cost is calculated:", "opts": ["After every purchase", "Once, at the end of the period", "Only when goods are sold", "Never - the first price is used"], "a": 0, "ex": "Continuous AVCO recalculates after each receipt; periodic AVCO calculates one average for the period."}
						]
					},
					{
						"id": "L4", "title": "Effect on profit and assets",
						"outcome": "D3(g) Impact of inventory valuation methods on profit and assets",
						"apply": {"title": "Zuru's Lemonade Stand - the same lemons, two profits", "pages": [
							{"text": "Same month 3, same 12 crates used, same sales of 400. The only thing that changes is the cost-flow assumption:", "table": {"cols": ["", "FIFO", "AVCO"], "rows": [{"c": ["Sales", "400", "400"]}, {"c": ["Cost of sales", "(100)", "(108)"]}, {"c": ["Gross profit", "300", "292"], "b": true}, {"c": ["Inventory in the SOFP", "80", "72"]}]}},
							{"text": "When prices are [b]rising[/b], FIFO leaves the newest (dearest) lemons in inventory, so closing inventory is [b]higher[/b], cost of sales is [b]lower[/b] and profit is [b]higher[/b] - by exactly the 8 difference in closing inventory. Falling prices flip it.\n\nThat is why [b]consistency[/b] matters: if Zuru switched methods whenever it flattered her profit, Hana could not compare one month with the next."},
							{"text": "And it is why a counting mistake bites twice. If Yuki over-counts and closing inventory is recorded as 90 instead of 80:\n- this month's cost of sales is 10 too low -> profit [b]overstated[/b] by 10, inventory overstated by 10;\n- next month opens with 90 instead of 80 -> cost of sales 10 too high -> profit [b]understated[/b] by 10.\n\nOver two months it cancels out, but each month on its own is wrong - and the exam loves asking which way."}
						]},
						"learn": [
							{"text": "The valuation method changes the split of cost between [b]cost of sales[/b] (SOPL) and [b]closing inventory[/b] (SOFP). The total cost is the same - only the timing differs."},
							{"text": "When prices are [b]rising[/b], FIFO leaves the newest, dearest units in inventory:\n[b]FIFO -> higher closing inventory -> lower cost of sales -> higher profit[/b] than AVCO.\nWhen prices are falling, the opposite happens."},
							{"text": "Errors matter too. Closing inventory [b]overstated[/b] by X -> cost of sales too low -> [b]profit overstated by X[/b] this year, and assets overstated.\nBecause this year's closing inventory is next year's opening inventory, [b]next year's profit is understated[/b] by X."}
						],
						"example": {"title": "January data: FIFO vs AVCO", "table": {"cols": ["", "FIFO", "Periodic AVCO"], "rows": [
							{"c": ["Total cost of goods (5,200)", "5,200", "5,200"], "s": 1},
							{"c": ["Closing inventory", "(1,990)", "(1,690)"], "s": 2},
							{"c": ["Cost of sales", "3,210", "3,510"], "s": 3, "b": true}]},
							"steps": ["Both methods start from the same 5,200 of purchases.", "With rising prices, FIFO's closing inventory is higher.", "So FIFO's cost of sales is 300 lower - and profit 300 higher - than periodic AVCO."]},
						"practice": [
							{"type": "picklist", "q": "When prices are rising, FIFO gives a {0} closing inventory and a {1} profit than AVCO.", "lists": [["higher", "lower"], ["higher", "lower"]], "a": [0, 0], "ex": "FIFO values inventory at the latest (higher) prices, reducing cost of sales and increasing profit."},
							{"type": "choice", "q": "Closing inventory was overstated by 3,000. The effect on this year's profit is:", "opts": ["Overstated by 3,000", "Understated by 3,000", "No effect", "Overstated by 6,000"], "a": 0, "ex": "Too much closing inventory means cost of sales is too low, so profit is overstated by 3,000."},
							{"type": "choice", "q": "This year's closing inventory was overstated by 3,000 and not corrected. NEXT year's profit will be:", "opts": ["Understated by 3,000", "Overstated by 3,000", "Unaffected", "Understated by 6,000"], "a": 0, "ex": "The overstated figure becomes next year's opening inventory, increasing next year's cost of sales and understating profit."},
							{"type": "input", "q": "Purchases in the year cost 40,000 (no opening inventory). Closing inventory is 7,000 under FIFO and 6,200 under AVCO. How much higher is FIFO profit?  (number)", "accept": ["800"], "display_answer": "800", "ex": "FIFO cost of sales 33,000 vs AVCO 33,800, so FIFO profit is 800 higher."}
						]
					}
				]
			},
			{
				"id": 8, "title": "Tangible non-current assets", "monster": "The Depreciation Dragon",
				"beats": [
					{"type":"story","speaker":"Sensei Otter","text":"The ancient [b]Depreciation Dragon[/b] wears away all it touches. Spread its cost correctly and it cannot overwhelm you."},
					{"type":"story","speaker":"Sensei Otter","text":"[b]Carrying amount = Cost - Accumulated depreciation[/b]. Straight line = (Cost - residual) / life. Reducing balance = fixed % of carrying amount. [b]Profit/(loss) on disposal = proceeds - carrying amount[/b]."},
					{"type":"taccount","speaker":"Sensei Otter","text":"The disposal account gathers everything about the asset sold; the balancing figure is the profit or loss:","name":"Disposal account","dr":["Asset at cost 20,000","Profit on disposal 2,000"],"cr":["Accumulated depreciation 14,000","Sale proceeds 8,000"],"dr_total":"22,000","cr_total":"22,000"},
					{"type":"input","q":"Cost 50,000, residual value 5,000, useful life 5 years. Straight-line depreciation per year = ?  (number)","accept":["9000"],"display_answer":"9,000","ex":"(50,000 - 5,000) / 5 = 9,000 per year."},
					{"type":"input","q":"Reducing balance at 25% on a carrying amount of 16,000. The charge = ?  (number)","accept":["4000"],"display_answer":"4,000","ex":"25% x 16,000 = 4,000."},
					{"type":"input","q":"Asset cost 30,000, accumulated depreciation 18,000, sold for 10,000. The LOSS on disposal = ?  (number)","accept":["2000"],"display_answer":"2,000","ex":"Carrying amount 12,000; proceeds 10,000 - 12,000 = 2,000 loss."},
					{"type":"choice","q":"Carrying amount =","opts":["Cost - Accumulated depreciation","Cost - Residual value","Cost + depreciation","Proceeds - cost"],"a":0,"ex":"Carrying amount (NBV) = Cost - Accumulated depreciation."},
					{"type":"choice","q":"A gain on revaluing a non-current asset upwards is reported in:","opts":["Profit or loss","Other comprehensive income and a revaluation surplus","Cost of sales","Retained earnings as realised profit"],"a":1,"ex":"The gain is unrealised, so it goes to OCI and a non-distributable revaluation surplus."},
					{"type":"input","q":"A machine costing 24,000 is bought on 1 April. 4-year life, nil residual, straight line, charged monthly. Charge for the year to 31 December = ?  (number)","accept":["4500"],"display_answer":"4,500","ex":"24,000 / 4 = 6,000 a year x 9/12 (April-December) = 4,500."},
					{"type":"input","q":"Cost 40,000, reducing balance at 20% a year. Carrying amount after 2 years = ?  (number)","accept":["25600"],"display_answer":"25,600","ex":"Year 1: 40,000 x 80% = 32,000. Year 2: 32,000 x 80% = 25,600."},
					{"type":"choice","q":"When an asset is sold, the sale proceeds are posted:","opts":["Dr Cash, Cr Disposal account","Dr Disposal account, Cr Cash","Dr Cash, Cr Revenue","Dr Cash, Cr Asset at cost"],"a":0,"ex":"Proceeds are credited to the disposal account, which then shows the profit or loss."}
				],
				# Ch 8 learning objectives: D4(a)-(j), D5(a)-(g), G3(b)(i). Exam: depreciation, asset values (cost and revalued), cost components; can be Section B.
				"lessons": [
					{
						"id": "L1", "title": "Capital or revenue? What goes into cost",
						"outcome": "D4(a) Define non-current assets; D4(b) Current vs non-current; D4(c)(d) Capital vs revenue expenditure",
						"apply": {"title": "Zuru's Lemonade Stand - the second cart", "pages": [
							{"text": "Month 4: business is good, so Zuru buys a bigger insulated cart for [b]600[/b]. The invoice has extras: [b]40[/b] delivery, [b]60[/b] to fit the heater and paint the Zuru logo, and [b]15[/b] for the first tank of gas. A week later a wheel needs a [b]25[/b] repair.\n\nThe cart will serve the stand for years: a [b]non-current asset[/b]. The lemons inside it will be gone by Friday: a [b]current asset[/b]."},
							{"text": "", "table": {"cols": ["Spend", "Capital or revenue?", "Why"], "rows": [{"c": ["Cart 600", "Capital", "The asset itself"]}, {"c": ["Delivery 40", "Capital", "Getting it to the stand"]}, {"c": ["Heater fitting + logo 60", "Capital", "Getting it ready to use"]}, {"c": ["First tank of gas 15", "Revenue", "Running cost"]}, {"c": ["Wheel repair 25", "Revenue", "Keeps it going, doesn't improve it"]}, {"c": ["Cost capitalised", "700", ""], "b": true}]}},
							{"text": "So the cart goes into the SOFP at [b]700[/b] and is depreciated over its life (next lesson); the gas and the repair hit the SOPL this month. Get it the wrong way round and both statements are wrong: calling the 60 fitting a repair would understate assets by 60 and understate profit by 60 this month (then overstate it in later years, when depreciation is lower)."}
						]},
						"learn": [
							{"text": "A [b]non-current asset[/b] is used in the business over [b]more than one year[/b] and is not held for resale - e.g. buildings, machinery, vehicles, computers. A [b]current asset[/b] will be used up or turned into cash within a year - inventory, receivables, cash."},
							{"text": "[b]Capital expenditure[/b] creates or improves a non-current asset. It is [b]capitalised[/b]: shown in the SOFP and depreciated over the years it is used.\n[b]Revenue expenditure[/b] maintains assets or runs the business - repairs, maintenance, insurance. It is an [b]expense[/b] in the SOPL straight away."},
							{"text": "An asset is recorded at [b]cost[/b]: the purchase price plus all [b]directly attributable costs[/b] of getting it to its location and ready to use:\n- delivery and handling\n- site preparation and installation\n- professional fees (e.g. legal fees, architect)\n- import duties"},
							{"text": "NOT part of cost (expense them):\n- staff training\n- general overheads and admin\n- repairs and maintenance (incl. maintenance contracts)\n- [b]recoverable sales tax[/b] (it is reclaimed - Chapter 13)"},
							{"text": "Watch out: an [b]improvement[/b] that increases an asset's capacity or life (e.g. an extension) is capital; [b]restoring[/b] it to how it was (e.g. repainting, fixing a roof) is revenue."}
						],
						"example": {"title": "Cost of a new machine", "table": {"cols": ["Item", "$", "Treatment"], "rows": [
							{"c": ["Purchase price", "50,000", "Capitalise"], "s": 1},
							{"c": ["Delivery", "2,000", "Capitalise"], "s": 2}, {"c": ["Installation", "3,000", "Capitalise"], "s": 2},
							{"c": ["Sales tax (recoverable)", "10,000", "Reclaim - not cost"], "s": 3}, {"c": ["Staff training", "1,500", "Expense"], "s": 3}, {"c": ["1-year maintenance contract", "1,200", "Expense"], "s": 3},
							{"c": ["Cost capitalised", "55,000", ""], "s": 4, "b": true}]},
							"steps": ["Start with the purchase price.", "Delivery and installation get it working where it's needed: capitalise.", "Recoverable sales tax is reclaimed; training and maintenance are running costs: expense.", "Cost capitalised = 50,000 + 2,000 + 3,000 = 55,000."]},
						"practice": [
							{"type": "input", "q": "A machine costs 40,000 plus recoverable sales tax of 8,000. Delivery 1,500, installation 2,500, staff training 900. At what cost is it capitalised?  (number)", "accept": ["44000"], "display_answer": "44,000", "ex": "40,000 + 1,500 + 2,500 = 44,000. Recoverable sales tax and training are excluded."},
							{"type": "sort", "q": "Capital or revenue expenditure?", "buckets": ["Capital", "Revenue"], "items": [["Building an extension to the factory", 0], ["Repainting the office", 1], ["Buying a delivery van", 0], ["Annual van insurance", 1], ["Legal fees on buying land", 0], ["Repairing a leaking roof", 1]], "ex": "Capital creates or improves an asset; revenue maintains it or runs the business."},
							{"type": "multi", "q": "Which TWO costs can be included in the cost of a new machine?", "opts": ["Installation costs", "Delivery costs", "Training staff to use it", "An annual maintenance contract"], "a": [0, 1], "ex": "Installation and delivery are directly attributable. Training and maintenance are expensed."},
							{"type": "choice", "q": "Which of the following is a NON-current asset for a car dealer?", "opts": ["The showroom building", "Cars held for sale", "Amounts owed by customers", "Cash in the bank"], "a": 0, "ex": "The showroom is used long-term. Cars held for resale are inventory - a current asset."}
						]
					},
					{
						"id": "L2", "title": "Depreciation: methods and entries",
						"outcome": "D5(a) Purpose of depreciation; D5(b) Straight line and reducing balance; D5(c) When each is appropriate; D5(d)(g) Recording depreciation",
						"apply": {"title": "Zuru's Lemonade Stand - spreading the cart's cost", "pages": [
							{"text": "The new cart cost [b]700[/b]. Zuru expects to use it for [b]5 years[/b] and sell it for about [b]100[/b] at the end. Charging 700 to month 4 would wreck that month's profit for an asset that earns for five years - so [b]depreciation[/b] spreads the cost over the years that benefit (the accruals concept again)."},
							{"text": "", "table": {"cols": ["Year", "Straight line: (700 - 100) / 5", "Reducing balance 30%"], "rows": [{"c": ["1", "120", "210 (30% x 700)"]}, {"c": ["2", "120", "147 (30% x 490)"]}, {"c": ["3", "120", "103 (30% x 343)"]}, {"c": ["Carrying amount after 3 years", "700 - 360 = 340", "700 - 460 = 240"], "b": true}]}},
							{"text": "[b]Straight line[/b] suits assets that wear evenly - the cart, the heater. [b]Reducing balance[/b] suits things that lose most value early and cost more to maintain later - Zuru's card reader or a van. Either way the entry each year is:\n[b]Dr Depreciation expense (SOPL), Cr Accumulated depreciation (SOFP)[/b]\n\nThe cart stays at cost 700 in the ledger; accumulated depreciation builds up beside it, and the SOFP shows the difference - the [b]carrying amount[/b]. Depreciation is a book entry: no cash leaves when it is charged."}
						]},
						"learn": [
							{"text": "[b]Depreciation[/b] spreads the cost of a non-current asset (less any residual value) over its [b]useful life[/b], matching the cost against the periods that benefit (accruals). It is NOT an attempt to show what the asset is worth. [b]Land[/b] usually has an unlimited life, so it is not depreciated."},
							{"text": "[b]Straight line[/b]: (Cost - Residual value) / Useful life. The same charge every year - suits assets used evenly over their life, e.g. buildings, fixtures."},
							{"text": "[b]Reducing (diminishing) balance[/b]: a fixed % x [b]carrying amount[/b] at the start of the year. The charge is higher in early years - suits assets that give more benefit when new, e.g. vehicles and computers."},
							{"text": "Part-years: check the policy. Either a [b]full year[/b] in the year of purchase, or [b]pro rata[/b] (monthly) from the date of purchase."},
							{"text": "The entry: [b]Dr Depreciation expense[/b] (SOPL), [b]Cr Accumulated depreciation[/b] (SOFP).\nIn the SOFP: [b]Carrying amount = Cost - Accumulated depreciation[/b]. The cost account itself never changes."}
						],
						"example": {"title": "Van: cost 24,000, residual 4,000, 4 years", "table": {"cols": ["Year", "Straight line", "Reducing balance 40%"], "rows": [
							{"c": ["1", "5,000", "24,000 x 40% = 9,600"], "s": 1},
							{"c": ["2", "5,000", "14,400 x 40% = 5,760"], "s": 2},
							{"c": ["3", "5,000", "8,640 x 40% = 3,456"], "s": 3},
							{"c": ["Carrying amount after 3 years", "24,000 - 15,000 = 9,000", "8,640 - 3,456 = 5,184"], "s": 4, "b": true}]},
							"steps": ["Straight line: (24,000 - 4,000) / 4 = 5,000 every year. Reducing balance year 1: 40% of 24,000.", "Year 2: reducing balance applies 40% to the NEW carrying amount, 14,400.", "Year 3: 40% of 8,640. The charge keeps falling.", "After 3 years: straight line leaves 9,000; reducing balance leaves 5,184."]},
						"practice": [
							{"type": "input", "q": "A machine costing 36,000 (residual value 6,000, 5-year life) is bought on 1 October. Straight line, charged monthly. Depreciation for the year to 31 December = ?  (number)", "accept": ["1500"], "display_answer": "1,500", "ex": "(36,000 - 6,000) / 5 = 6,000 a year x 3/12 = 1,500."},
							{"type": "input", "q": "Cost 20,000, depreciated at 30% reducing balance. Charge for year 3 = ?  (number)", "accept": ["2940"], "display_answer": "2,940", "ex": "Year 1: 6,000 (CA 14,000). Year 2: 4,200 (CA 9,800). Year 3: 30% x 9,800 = 2,940."},
							{"type": "picklist", "q": "To record depreciation: Debit {0}, Credit {1}.", "lists": [["Depreciation expense", "Accumulated depreciation", "Asset cost"], ["Accumulated depreciation", "Depreciation expense", "Asset cost"]], "a": [0, 0], "ex": "The expense goes to the SOPL; accumulated depreciation builds up in the SOFP against the asset's cost."},
							{"type": "choice", "q": "Reducing balance depreciation is MOST appropriate for an asset that:", "opts": ["Gives more benefit in its early years", "Is used evenly over its life", "Has an unlimited life", "Is held for resale"], "a": 0, "ex": "Reducing balance front-loads the charge, matching assets like vehicles that are most useful (and lose value fastest) when new."},
							{"type": "choice", "q": "The purpose of depreciation is to:", "opts": ["Spread the cost of an asset over its useful life", "Show the market value of the asset", "Set aside cash to replace the asset", "Reduce tax"], "a": 0, "ex": "Depreciation allocates cost over the useful life. It isn't a valuation and doesn't put cash aside."}
						]
					},
					{
						"id": "L3", "title": "Disposals and part exchange",
						"outcome": "D4(e) Record acquisition and disposal; D4(f) Gains or losses on disposal, including part exchange",
						"apply": {"title": "Zuru's Lemonade Stand - goodbye, old cart", "pages": [
							{"text": "With the new cart in service, the original 200 cart (accumulated depreciation so far [b]80[/b], carrying amount [b]120[/b]) is sold to a dojo student for [b]150[/b] cash.\n\nThe disposal account collects every piece: cost out, accumulated depreciation out, proceeds in - and whatever is left is the profit or loss on disposal.", "table": {"cols": ["Disposal account - Dr", "", "Cr", ""], "rows": [{"c": ["Cart (cost)", "200", "Accumulated depreciation", "80"]}, {"c": ["Profit on disposal (SOPL)", "30", "Cash (proceeds)", "150"]}, {"c": ["", "230", "", "230"], "b": true}]}},
							{"text": "Proceeds 150 against a carrying amount of 120 = [b]profit 30[/b]. Had the student paid only 100, it would be a [b]loss of 20[/b]. Either way the cart and its depreciation are gone from the ledger: Dr Disposal / Cr Cart 200, Dr Acc dep / Cr Disposal 80, Dr Cash / Cr Disposal 150."},
							{"text": "[b]Part exchange[/b]: suppose instead the cart dealer took the old cart in against the new 700 one, allowing [b]150[/b]. Zuru pays only [b]550[/b] cash. The 150 allowance is the 'proceeds' of the old cart (credited to disposal) AND part of the cost of the new one (debited to Cart). Same profit on disposal, 30; new cart still recorded at its full cost of 700."}
						]},
						"learn": [
							{"text": "When an asset is sold or scrapped, we remove it from the books and work out the [b]profit or loss on disposal[/b]:\n[b]Proceeds - Carrying amount = Profit (or loss)[/b]"},
							{"text": "Using a [b]disposal account[/b]:\n1. Dr Disposal, Cr Asset cost - remove the cost\n2. Dr Accumulated depreciation, Cr Disposal - remove the depreciation\n3. Dr Bank, Cr Disposal - the proceeds\nThe balancing figure is the profit (credit side) or loss (debit side), taken to the SOPL."},
							{"text": "[b]Part exchange[/b]: an old asset is traded in against a new one. The [b]part exchange allowance[/b] acts as the sale proceeds of the old asset.\nOld asset: Dr Asset cost (new), Cr Disposal - with the allowance.\nThe [b]new asset's cost[/b] is its full price = cash paid + part exchange allowance."}
						],
						"example": {"title": "Trading in an old van", "table": {"cols": ["Disposal account", "Dr $", "Cr $"], "rows": [
							{"c": ["Old van - cost", "20,000", ""], "s": 1},
							{"c": ["Accumulated depreciation", "", "14,000"], "s": 2},
							{"c": ["Part exchange allowance", "", "5,000"], "s": 3},
							{"c": ["Loss on disposal (to SOPL)", "", "1,000"], "s": 4},
							{"c": ["Totals", "20,000", "20,000"], "s": 4, "b": true},
							{"c": ["New van cost = 25,000 cash + 5,000 allowance", "30,000", ""], "s": 5, "b": true}]},
							"steps": ["Remove the old van's cost of 20,000 into the disposal account.", "Remove its accumulated depreciation of 14,000. Carrying amount = 6,000.", "The dealer gives a 5,000 part exchange allowance - that's the 'proceeds'.", "Proceeds 5,000 - carrying amount 6,000 = loss of 1,000.", "The new van (price 30,000) is recorded at its full cost: 25,000 cash plus the 5,000 allowance."]},
						"practice": [
							{"type": "input", "q": "An asset cost 45,000 and has accumulated depreciation of 30,000. It is sold for 18,500. Profit on disposal = ?  (number)", "accept": ["3500"], "display_answer": "3,500", "ex": "Carrying amount 15,000. Proceeds 18,500 - 15,000 = 3,500 profit."},
							{"type": "input", "q": "A new machine priced at 60,000 is bought by paying 52,000 cash plus trading in an old machine. At what cost is the NEW machine recorded?  (number)", "accept": ["60000"], "display_answer": "60,000", "ex": "The new asset is recorded at full cost: 52,000 cash + 8,000 part exchange allowance = 60,000."},
							{"type": "picklist", "q": "On disposal, accumulated depreciation is removed: Debit {0}, Credit {1}.", "lists": [["Accumulated depreciation", "Disposal account", "Depreciation expense"], ["Disposal account", "Accumulated depreciation", "Bank"]], "a": [0, 0], "ex": "Accumulated depreciation (a credit balance) is cleared by a debit, with the credit to the disposal account."},
							{"type": "choice", "q": "In a part exchange, the part exchange allowance on the old asset is treated as:", "opts": ["The sale proceeds of the old asset", "A discount on the new asset", "Depreciation", "Income from sales"], "a": 0, "ex": "The allowance is the 'proceeds' used to work out the profit or loss on the old asset."}
						]
					},
					{
						"id": "L4", "title": "Revaluations",
						"outcome": "D4(g) Record a revaluation; D4(h) Disposal of a revalued asset; D5(e) Depreciation on revalued assets and excess depreciation transfer",
						"apply": {"title": "Zuru Lemonade Ltd - the kiosk goes up in value", "pages": [
							{"text": "Year 2 of the company: Zuru Lemonade Ltd buys a small kiosk by the station for [b]20,000[/b] (10,000 land, 10,000 building over 20 years). Two years later a surveyor values the kiosk at [b]26,000[/b]. The land can't be depreciated; the building has accumulated depreciation of 1,000, so the carrying amount is 19,000.\n\nThe company chooses to [b]revalue[/b]: Dr Kiosk 6,000 (to 26,000 and the 1,000 acc dep is cleared), [b]Cr Revaluation surplus 7,000[/b] - through other comprehensive income, NOT profit. The gain is not realised; nobody has sold anything."},
							{"text": "From now on depreciation is based on the [b]revalued[/b] building. Say the building part is now 15,000 with 18 years left: [b]833 a year[/b] instead of the old 500. The extra 333 a year is the [b]excess depreciation[/b], and each year the company may move it: Dr Revaluation surplus 333, Cr Retained earnings 333 - so profits available for dividends aren't penalised for a paper gain.", "table": {"cols": ["Each year after the revaluation", "Dr", "Cr"], "rows": [{"c": ["Depreciation expense / Acc dep", "833", "833"]}, {"c": ["Revaluation surplus / Retained earnings (excess)", "333", "333"]}]}},
							{"text": "If the kiosk is later [b]sold[/b], the disposal works as usual on the revalued carrying amount - and whatever is left in the revaluation surplus for that kiosk is transferred to retained earnings (Dr Revaluation surplus, Cr Retained earnings). It never goes through profit or loss: the gain was recognised in OCI when it arose, and is 'realised' only by the transfer."}
						]},
						"learn": [
							{"text": "A business may choose to show assets at a [b]revalued amount[/b] (fair value) instead of cost. It's an accounting policy choice - but if one asset is revalued, the [b]whole class[/b] of similar assets must be, and kept up to date."},
							{"text": "To revalue upwards:\n- [b]Dr Asset[/b] - increase from cost to the valuation\n- [b]Dr Accumulated depreciation[/b] - wipe it out\n- [b]Cr Revaluation surplus[/b] - the gain\nThe gain is unrealised, so it goes to [b]other comprehensive income[/b] and the [b]revaluation surplus[/b] in equity - NOT to profit or loss."},
							{"text": "After revaluing, depreciation is based on the [b]revalued amount[/b] over the remaining useful life. The extra depreciation versus the original cost basis is the [b]excess depreciation[/b]. It may be transferred each year: [b]Dr Revaluation surplus, Cr Retained earnings[/b] (a movement within equity - not through profit or loss)."},
							{"text": "Selling a revalued asset: profit or loss = proceeds - [b]revalued[/b] carrying amount. Any revaluation surplus left for that asset is transferred to [b]retained earnings[/b] - it does not go through profit or loss."}
						],
						"example": {"title": "Revaluing a building", "table": {"cols": ["", "$"], "rows": [
							{"c": ["Cost 500,000, 50-year life: depreciation 10,000 a year", ""], "s": 1},
							{"c": ["After 10 years: carrying amount (500,000 - 100,000)", "400,000"], "s": 1},
							{"c": ["Revalued to", "600,000"], "s": 2}, {"c": ["Revaluation surplus (600,000 - 400,000)", "200,000"], "s": 2, "b": true},
							{"c": ["New depreciation: 600,000 / 40 remaining years", "15,000"], "s": 3},
							{"c": ["Excess depreciation transferred (15,000 - 10,000)", "5,000"], "s": 4, "b": true}]},
							"steps": ["Before revaluing, the building has a carrying amount of 400,000 after 10 years.", "It is revalued to 600,000: Dr Building 100,000 (500,000 to 600,000), Dr Accumulated depreciation 100,000, Cr Revaluation surplus 200,000.", "Depreciation is now the revalued amount over the 40 years left: 15,000 a year.", "That's 5,000 more than on cost, so 5,000 a year can move from the revaluation surplus to retained earnings."]},
						"practice": [
							{"type": "input", "q": "Land cost 120,000 and is revalued to 175,000. What is credited to the revaluation surplus?  (number)", "accept": ["55000"], "display_answer": "55,000", "ex": "175,000 - 120,000 = 55,000. Land isn't depreciated, so there's no accumulated depreciation to remove."},
							{"type": "choice", "q": "A gain on revaluing a building upwards is reported in:", "opts": ["Other comprehensive income and the revaluation surplus", "Profit or loss as income", "Retained earnings directly", "Revenue"], "a": 0, "ex": "Revaluation gains are unrealised: they go to OCI and the revaluation surplus in equity."},
							{"type": "input", "q": "A building with a carrying amount of 300,000 and 30 years' remaining life is revalued to 450,000. What is the new annual depreciation charge?  (number)", "accept": ["15000"], "display_answer": "15,000", "ex": "450,000 / 30 years = 15,000 a year."},
							{"type": "picklist", "q": "The excess depreciation transfer is: Debit {0}, Credit {1}.", "lists": [["Revaluation surplus", "Depreciation expense", "Retained earnings"], ["Retained earnings", "Revaluation surplus", "Profit or loss"]], "a": [0, 0], "ex": "The transfer moves the realised part of the surplus to retained earnings, within equity."},
							{"type": "choice", "q": "If one office building is revalued, the business must:", "opts": ["Revalue all assets in the same class", "Revalue all its non-current assets", "Stop depreciating the building", "Revalue it only once"], "a": 0, "ex": "Revaluation applies to the whole class of assets and must be kept up to date."}
						]
					},
					{
						"id": "L5", "title": "Changes in estimates, the asset register and disclosure",
						"outcome": "D5(f) Changes in useful life or residual value; D4(j) Non-current asset register; D4(i) G3(b)(i) Disclosure of balances and movements",
						"apply": {"title": "Zuru's Lemonade Stand - the cart won't last five years", "pages": [
							{"text": "After two winters the 700 cart (straight line, 120 a year, carrying amount [b]460[/b]) is rusting faster than expected. Zuru now thinks it has only [b]2 more years[/b] and will fetch [b]40[/b], not 100. She does NOT go back and change years 1 and 2 - a change of estimate works [b]prospectively[/b]: spread what is left over what is left.\n\n[b](460 - 40) / 2 = 210 a year[/b] from now on."},
							{"text": "Her [b]non-current asset register[/b] is the list behind the ledger total - one line per asset, so she can prove the cart account's 700 and check nothing has gone missing.", "table": {"cols": ["Asset", "Date", "Cost", "Method", "Acc dep", "Carrying amount", "Location"], "rows": [{"c": ["Cart 2 (insulated)", "Month 4", "700", "SL 2 yrs left", "240", "460", "Dojo gate"]}, {"c": ["Heater", "Month 4", "90", "SL 3 yrs", "30", "60", "Cart 2"]}, {"c": ["Card reader", "Month 5", "120", "RB 30%", "36", "84", "Cart 2"]}]}},
							{"text": "In the company's accounts the same information appears as the [b]property, plant and equipment note[/b]: cost at the start, additions, disposals, cost at the end; then the same for accumulated depreciation; then the carrying amounts. Every number in the note ties back to the register - which is why exam questions ask you to rebuild the movements from a few clues."}
						]},
						"learn": [
							{"text": "Useful life and residual value are [b]estimates[/b], reviewed regularly. If they change, past depreciation is NOT corrected. Instead the [b]remaining carrying amount[/b] (less any new residual value) is spread over the [b]remaining useful life[/b] from now on."},
							{"text": "A [b]non-current asset register[/b] lists every asset: description, location, cost, date bought, depreciation method and accumulated depreciation. It helps control assets - they can be physically checked against it - and its totals are reconciled to the general ledger."},
							{"text": "The financial statements include a [b]disclosure note[/b] showing, for each class of asset:\n- cost or valuation: opening balance, additions, disposals, revaluations, closing balance\n- accumulated depreciation: opening, charge for the year, disposals, closing\n- carrying amounts at the start and end of the year"}
						],
						"example": {"title": "PPE disclosure note - machinery", "table": {"cols": ["Machinery", "$"], "rows": [
							{"c": ["Cost at 1 Jan", "120,000"], "s": 1}, {"c": ["Additions", "30,000"], "s": 1}, {"c": ["Disposals", "(20,000)"], "s": 1}, {"c": ["Cost at 31 Dec", "130,000"], "s": 1, "b": true},
							{"c": ["Accumulated depreciation at 1 Jan", "50,000"], "s": 2}, {"c": ["Charge for the year", "14,000"], "s": 2}, {"c": ["Disposals", "(14,000)"], "s": 2}, {"c": ["Accumulated depreciation at 31 Dec", "50,000"], "s": 2, "b": true},
							{"c": ["Carrying amount at 1 Jan (120,000 - 50,000)", "70,000"], "s": 3}, {"c": ["Carrying amount at 31 Dec (130,000 - 50,000)", "80,000"], "s": 3, "b": true}]},
							"steps": ["Cost moves for additions and disposals.", "Accumulated depreciation moves for the year's charge and for the depreciation on assets sold.", "Carrying amount = cost - accumulated depreciation, at the start and the end of the year."]},
						"practice": [
							{"type": "input", "q": "A machine cost 60,000 with a 10-year life and no residual value. After 4 years, its remaining life is revised to 3 years. New annual depreciation = ?  (number)", "accept": ["12000"], "display_answer": "12,000", "ex": "Carrying amount after 4 years = 60,000 - 24,000 = 36,000. Spread over the 3 years left: 12,000 a year."},
							{"type": "input", "q": "Carrying amount 25,000. The remaining life is now estimated at 5 years with a new residual value of 5,000. Annual depreciation = ?  (number)", "accept": ["4000"], "display_answer": "4,000", "ex": "(25,000 - 5,000) / 5 = 4,000."},
							{"type": "choice", "q": "The MAIN purpose of a non-current asset register is to:", "opts": ["Keep control of the business's non-current assets", "Record the sale of inventory", "Replace the general ledger", "Calculate sales tax"], "a": 0, "ex": "The register records details of each asset so they can be checked, controlled and reconciled to the ledger."},
							{"type": "input", "q": "Accumulated depreciation was 40,000 at the start of the year. The charge for the year was 9,000 and depreciation of 6,000 was removed on a disposal. Closing accumulated depreciation = ?  (number)", "accept": ["43000"], "display_answer": "43,000", "ex": "40,000 + 9,000 - 6,000 = 43,000."}
						]
					}
				]
			},
			{
				"id": 9, "title": "Intangible non-current assets", "monster": "The Phantom Patent",
				"beats": [
					{"type":"choice","q":"Research costs are:","opts":["Always expensed","Always capitalised","Amortised","Added to goodwill"],"a":0,"ex":"Research is always expensed; only qualifying development may be capitalised."},
					{"type":"choice","q":"Amortisation is charged on:","opts":["Land","Intangible assets with a finite life","Inventory","Cash"],"a":1,"ex":"Amortisation spreads the cost of a finite-life intangible; land is not depreciated."},
					{"type":"choice","q":"Development costs that meet all the IAS 38 criteria are:","opts":["Capitalised as an intangible asset","Always expensed","Added to inventory","Credited to reserves"],"a":0,"ex":"Qualifying development is capitalised and amortised; research is always expensed."}
				],
				# Ch 9 learning objectives: D6(a)-(f), G3(b)(i). Exam: tangible vs intangible, research vs development criteria, amortisation.
				"lessons": [
					{
						"id": "L1", "title": "What is an intangible asset?",
						"outcome": "D6(a) Tangible vs intangible assets; D6(b) Types of intangible asset",
						"apply": {"title": "Zuru's Lemonade Stand - a name worth protecting", "pages": [
							{"text": "A rival stand starts calling itself 'Zuru's'. Zuru pays a lawyer [b]500[/b] to register the trademark [b]YUZURU[/b]. She can't touch it or park it at the dojo gate, but it is hers, it came from a past transaction, and it will bring money in for years: an [b]intangible non-current asset[/b], recorded at 500.\n\nThe cart is tangible - it has physical substance. The trademark is not - it is a legal right."},
							{"text": "", "table": {"cols": ["Intangible", "Zuru's version", "In the accounts?"], "rows": [{"c": ["Trademark / brand", "YUZURU, registered for 500", "Yes - purchased, at cost"]}, {"c": ["Licence", "Market-stall licence, 200 for 2 years", "Yes - at cost, amortised"]}, {"c": ["Development costs", "The bottled-lemonade project (next lesson)", "Yes, if the criteria are met"]}, {"c": ["Purchased goodwill", "Paying more than the assets are worth when she buys the rival stand (Chapter 23)", "Yes - only when bought"]}, {"c": ["Internally generated goodwill", "Her loyal customers and reputation", "No - never recognised"]}]}},
							{"text": "The loyal customers are the odd one out: real value, but no reliable cost and no transaction, so IAS 38 says it stays off the SOFP. The same goes for staff know-how and Zuru's own recipe. Only what was [b]bought[/b], or developed under strict rules, makes it onto the page."}
						]},
						"learn": [
							{"text": "A [b]tangible[/b] non-current asset has physical substance - you can touch it: buildings, machines, vans. An [b]intangible[/b] asset is an identifiable, non-monetary asset [b]without physical substance[/b]."},
							{"text": "Examples of intangible assets:\n- patents, trademarks and copyrights\n- licences and franchises\n- computer software\n- capitalised [b]development[/b] costs\n- [b]purchased goodwill[/b] (paid for when buying another business)"},
							{"text": "Internally generated goodwill - the reputation a business builds up itself - is [b]not[/b] recognised as an asset: it can't be measured reliably. Only goodwill that has been [b]paid for[/b] in an acquisition is recognised."}
						],
						"practice": [
							{"type": "multi", "q": "Which TWO of the following are intangible assets?", "opts": ["A patent", "A trademark bought from another company", "Inventory of finished goods", "A delivery van"], "a": [0, 1], "ex": "Patents and trademarks have no physical substance. Inventory is a current asset and a van is tangible."},
							{"type": "choice", "q": "An intangible asset is an identifiable, non-monetary asset:", "opts": ["Without physical substance", "Held for resale", "That is always worth more than its cost", "That must be revalued every year"], "a": 0, "ex": "The key feature is having no physical substance."},
							{"type": "choice", "q": "A business has built up a strong reputation over 20 years. Its internally generated goodwill is:", "opts": ["Not recognised as an asset", "Recognised at its estimated value", "Recognised and amortised", "Shown as a current asset"], "a": 0, "ex": "Internally generated goodwill cannot be measured reliably, so it is not recognised. Only purchased goodwill is."}
						]
					},
					{
						"id": "L2", "title": "Research vs development",
						"outcome": "D6(c) Research and development under IFRS (IAS 38); D6(d) Calculate amounts to capitalise or expense",
						"apply": {"title": "Zuru's Lemonade Stand - bottling the recipe", "pages": [
							{"text": "Zuru wants to sell bottled YUZURU in the cafe. First she spends [b]300[/b] trying flavours and asking customers what they'd pay - she has no idea yet whether it will work. That is [b]research[/b]: expense it, always.\n\nThen the recipe is settled, the cafe signs an order, a bottler quotes, and Hana's loan covers the run. From that point she spends [b]800[/b] on labels, a test batch and safety certification: [b]development[/b] - and it meets every IAS 38 test, so it is capitalised."},
							{"text": "", "table": {"cols": ["IAS 38 development test", "Zuru's evidence"], "rows": [{"c": ["Probable future economic benefits", "Cafe order for 200 bottles a month"]}, {"c": ["Intention to complete and sell", "Launch date set"]}, {"c": ["Resources to complete", "Hana's loan, bottler booked"]}, {"c": ["Ability to use or sell it", "Trademark registered, cafe contract"]}, {"c": ["Technical feasibility", "Test batch keeps for 30 days"]}, {"c": ["Expenditure reliably measured", "Invoices for labels, batch, certificate"]}]}},
							{"text": "So: SOPL expense [b]300[/b] (research), intangible asset [b]800[/b] (development), amortised from the day bottles start selling (next lesson). If any one test fails - say the bottler couldn't be found - the 800 is expensed too, and once expensed it can never be reinstated as an asset."}
						]},
						"learn": [
							{"text": "[b]Research[/b] is original investigation to gain new knowledge. There's no guarantee it will ever produce profit, so research costs are ALWAYS [b]expensed[/b]: Dr Research expense (SOPL), Cr Bank."},
							{"text": "[b]Development[/b] applies research to design or produce new or improved products, before commercial production starts. Development costs MUST be [b]capitalised[/b] as an intangible asset if ALL the [b]PIRATE[/b] criteria are met:"},
							{"text": "[b]P[/b]robable future economic benefits\n[b]I[/b]ntention to complete the asset and use or sell it\n[b]R[/b]esources available to complete it\n[b]A[/b]bility to use or sell it\n[b]T[/b]echnically feasible\n[b]E[/b]xpenditure can be measured reliably"},
							{"text": "Development costs spent BEFORE all the criteria are met are expensed, and are [b]never reinstated[/b] later. Only costs from the date the criteria are met are capitalised: Dr Intangible asset (SOFP), Cr Bank / Payables."}
						],
						"example": {"title": "Project Bloom", "table": {"cols": ["Period", "Cost $", "Treatment"], "rows": [
							{"c": ["Jan-Mar: research", "30,000", "Expense"], "s": 1},
							{"c": ["April: development, criteria not yet met", "20,000", "Expense"], "s": 2},
							{"c": ["May-June: criteria all met from 1 May", "48,000", "Capitalise"], "s": 3},
							{"c": ["Expensed in total", "50,000", ""], "s": 4, "b": true}, {"c": ["Capitalised as an intangible asset", "48,000", ""], "s": 4, "b": true}]},
							"steps": ["Research is always an expense.", "Development before all PIRATE criteria are met is also an expense.", "From 1 May all criteria are met, so the development costs are capitalised.", "Totals: 50,000 to the SOPL and 48,000 to the SOFP. The April costs stay expensed."]},
						"practice": [
							{"type": "input", "q": "A project spent 12,000 on research, then 8,000 on development before the IAS 38 criteria were met and 25,000 after. How much is capitalised?  (number)", "accept": ["25000"], "display_answer": "25,000", "ex": "Only development costs incurred after all criteria are met are capitalised: 25,000."},
							{"type": "sort", "q": "Research or development?", "buckets": ["Research", "Development"], "items": [["Testing whether a new material conducts heat", 0], ["Searching for alternative uses of a chemical", 0], ["Building a prototype of a new product", 1], ["Testing a pre-production model", 1]], "ex": "Gaining new knowledge is research; applying it to design and test products before production is development."},
							{"type": "multi", "q": "Which TWO are among the criteria for capitalising development costs?", "opts": ["The project is technically feasible", "Adequate resources are available to complete it", "The project has been running for over a year", "The costs relate to original research"], "a": [0, 1], "ex": "Technical feasibility and resources are part of PIRATE. Duration isn't a criterion, and research is always expensed."},
							{"type": "choice", "q": "Development costs expensed last year now meet the criteria. They are:", "opts": ["Not reinstated - they stay expensed", "Reinstated as an asset", "Added to this year's research costs", "Credited to retained earnings"], "a": 0, "ex": "Costs once expensed are never reinstated as an asset."}
						]
					},
					{
						"id": "L3", "title": "Amortisation and disclosure",
						"outcome": "D6(e) Purpose of amortisation; D6(f) Calculate and account for amortisation; G3(b)(i) Disclosure of intangible assets",
						"apply": {"title": "Zuru's Lemonade Stand - the trademark wears out too", "pages": [
							{"text": "[b]Amortisation[/b] is depreciation for intangibles - spreading the cost over the years the asset earns. The YUZURU trademark (500) is registered for [b]10 years[/b]: 50 a year, straight line. The development cost (800) is spread over the [b]4 years[/b] the bottled product is expected to sell: 200 a year, starting when sales start - not when the money was spent.", "table": {"cols": ["Each year", "Dr", "Cr"], "rows": [{"c": ["Amortisation expense (SOPL) / Accumulated amortisation", "250", "250"]}]}},
							{"text": "After two years the intangible assets note in the company's accounts looks like this - the same shape as the PPE note:", "table": {"cols": ["Intangible assets", "Trademark", "Development", "Total"], "rows": [{"c": ["Cost at start", "500", "800", "1,300"]}, {"c": ["Additions", "-", "-", "-"]}, {"c": ["Cost at end", "500", "800", "1,300"]}, {"c": ["Amortisation at start", "50", "200", "250"]}, {"c": ["Charge for the year", "50", "200", "250"]}, {"c": ["Amortisation at end", "100", "400", "500"]}, {"c": ["Carrying amount at end", "400", "400", "800"], "b": true}]}},
							{"text": "Two reminders the examiner likes: an intangible with an [b]indefinite[/b] life (a brand the company intends to renew forever) is not amortised but is tested for impairment each year; and research spending never appears in this note at all - it was expensed the year it happened."}
						]},
						"learn": [
							{"text": "[b]Amortisation[/b] is depreciation for intangible assets: an intangible with a [b]finite[/b] useful life has its cost spread over that life, matching it against the revenue it helps earn."},
							{"text": "Capitalised development costs are amortised from when the asset is [b]available for use[/b] - usually when [b]commercial production / sales begin[/b] - over the period expected to benefit. Pro-rate for part-years if the policy says so."},
							{"text": "The entry: [b]Dr Amortisation expense[/b] (SOPL), [b]Cr Intangible asset[/b] (accumulated amortisation, SOFP).\nThe disclosure note works like the PPE note: cost, additions, amortisation charge and carrying amounts."}
						],
						"example": {"title": "Amortising Project Bloom", "table": {"cols": ["", "$"], "rows": [
							{"c": ["Capitalised development costs", "48,000"], "s": 1},
							{"c": ["Sales begin 1 October; useful life 4 years", ""], "s": 2},
							{"c": ["Amortisation for year to 31 Dec: 48,000 / 4 x 3/12", "3,000"], "s": 3, "b": true},
							{"c": ["Carrying amount at 31 Dec", "45,000"], "s": 3, "b": true}]},
							"steps": ["The asset is the 48,000 capitalised.", "Amortisation starts when sales begin - 1 October - over the 4-year life.", "12,000 a year x 3/12 = 3,000 for this year, leaving 45,000."]},
						"practice": [
							{"type": "input", "q": "Development costs of 60,000 are capitalised. Sales of the product begin on 1 April; useful life 5 years; amortisation is pro rata. Year-end 31 December. Amortisation charge = ?  (number)", "accept": ["9000"], "display_answer": "9,000", "ex": "60,000 / 5 = 12,000 a year x 9/12 = 9,000."},
							{"type": "choice", "q": "Amortisation of capitalised development costs normally starts when:", "opts": ["Commercial production or sales begin", "Research begins", "The costs are first incurred", "The year-end is reached"], "a": 0, "ex": "Amortisation starts when the asset is available for use - when the product starts generating benefits."},
							{"type": "picklist", "q": "To record amortisation: Debit {0}, Credit {1}.", "lists": [["Amortisation expense", "Intangible asset", "Research expense"], ["Intangible asset (accumulated amortisation)", "Amortisation expense", "Bank"]], "a": [0, 0], "ex": "The charge is an expense; the credit reduces the intangible asset's carrying amount."}
						]
					}
				]
			},
			{
				"id": 10, "title": "Accruals and prepayments", "monster": "The Timing Wraith",
				"beats": [
					{"type":"story","speaker":"Sensei Otter","text":"The [b]Timing Wraith[/b] shifts costs between years to confuse you. Match each to its proper period and it loses its power."},
					{"type":"story","speaker":"Sensei Otter","text":"[b]Accrual[/b] = used but unpaid = a LIABILITY (Dr Expense, Cr Accruals). [b]Prepayment[/b] = paid ahead = an ASSET. [b]Deferred income[/b] = cash received early = a liability. [b]Accrued income[/b] = earned, awaited = an asset."},
					{"type":"choice","q":"An accrued (unpaid) expense is shown as a:","opts":["Asset","Liability","Reduction of capital","Revenue"],"a":1,"ex":"An accrual is an obligation to pay for something used - a liability."},
					{"type":"choice","q":"A prepayment is shown as a:","opts":["Asset","Liability","Expense only","Revenue"],"a":0,"ex":"A prepayment is value paid for but not yet used - an asset."},
					{"type":"input","q":"Rent of 12,000 was paid for the year to 30 April. At 31 December the prepayment = ?  (number)","accept":["4000"],"display_answer":"4,000","ex":"4 months (Jan-Apr) prepaid: 4/12 x 12,000 = 4,000."},
					{"type":"input","q":"Insurance of 2,400 was paid for the year to 31 March. At 31 December the prepayment = ?  (number)","accept":["600"],"display_answer":"600","ex":"3 months (Jan-Mar) prepaid: 3/12 x 2,400 = 600."},
					{"type":"choice","q":"The entry to accrue an expense at the year-end is:","opts":["Dr Accruals, Cr Expense","Dr Expense, Cr Accruals","Dr Prepayment, Cr Expense","Dr Cash, Cr Expense"],"a":1,"ex":"Accruing increases the expense (Dr) and creates a liability (Cr Accruals)."},
					{"type":"choice","q":"Cash received in advance for a service not yet provided is:","opts":["Accrued income (asset)","Deferred income (liability)","A prepayment (asset)","Revenue now"],"a":1,"ex":"Income received before the service is deferred income - a liability."},
					{"type":"choice","q":"Service earned but not yet received at the year-end is:","opts":["Deferred income (liability)","Accrued income (asset)","An accrual (liability)","Ignored"],"a":1,"ex":"Income earned but not received is accrued income - an asset."},
					{"type":"choice","q":"To reverse an opening accrual at the start of the next period:","opts":["Dr Accruals, Cr Expense","Dr Expense, Cr Accruals","Dr Cash, Cr Accruals","No entry"],"a":0,"ex":"Reversing an accrual is the opposite of creating it."},
					{"type":"input","q":"The electricity bill of 900 for the quarter to 31 January is paid in February. Year-end 31 December. Accrual = ?  (number)","accept":["600"],"display_answer":"600","ex":"November and December are used but unpaid: 2/3 x 900 = 600."},
					{"type":"input","q":"Rent paid in the year 14,000. Opening prepayment 1,000; closing prepayment 1,500. Rent expense = ?  (number)","accept":["13500"],"display_answer":"13,500","ex":"Expense = 14,000 + 1,000 (opening prepayment used) - 1,500 (closing prepayment) = 13,500."},
					{"type":"input","q":"Opening accrual 400, cash paid 5,200, closing accrual 600. Expense for the year = ?  (number)","accept":["5400"],"display_answer":"5,400","ex":"Expense = 5,200 - 400 (paid for last year) + 600 (owed for this year) = 5,400."},
					{"type":"choice","q":"Forgetting to record a closing accrual makes profit:","opts":["Overstated","Understated","Unaffected","Doubled"],"a":0,"ex":"The expense is too low, so profit is too high (and liabilities too low)."}
				],
				# Ch 10 learning objectives: D7(a)-(f). Exam: SOFP accrual/prepayment, SOPL expense, journals - for income AND expenses.
				"lessons": [
					{
						"id": "L1", "title": "Accruals: used but not yet paid",
						"outcome": "D7(a) Apply accrual accounting; D7(b) Calculate the adjustment; D7(d) Journals to create and reverse",
						"apply": {"title": "Zuru's Lemonade Stand - December's heater bill", "pages": [
							{"text": "Zuru's year-end is 31 December. The heater ran all December, but the gas company bills quarterly: the [b]90[/b] for December arrives on 10 January. The stall rent for December, [b]40[/b], is also paid late, in January.\n\nAccruals basis: the gas and the stall were [b]used[/b] in December, so December must carry the cost - whether or not an invoice has arrived."},
							{"text": "", "table": {"cols": ["31 December", "Dr", "Cr"], "rows": [{"c": ["Heating expense / Accruals", "90", "90"]}, {"c": ["Rent expense / Accruals", "40", "40"]}, {"c": ["1 January (reverse)", "", ""], "b": true}, {"c": ["Accruals / Heating expense", "90", "90"]}, {"c": ["Accruals / Rent expense", "40", "40"]}]}},
							{"text": "The [b]accrual[/b] of 130 sits in current liabilities at 31 December - money owed for services already consumed. On 1 January it is reversed, so when the real 90 gas bill is posted in January the expense nets to nil in the new year: December paid for December. If Zuru forgot the accrual, December's profit would be overstated by 130 and the year-end liabilities understated by 130."}
						]},
						"learn": [
							{"text": "Accrual accounting says expenses belong to the period in which they are [b]used[/b], not when they are paid (Chapter 3). So at the year-end we check: has anything been used that hasn't been paid or even billed yet?"},
							{"text": "An [b]accrual[/b] (accrued expense) is an expense used in the period but [b]unpaid[/b] at the year-end. Typical examples: electricity, gas, phone, interest - often billed after the period ends."},
							{"text": "The entry: [b]Dr Expense[/b] (SOPL - increases the cost), [b]Cr Accruals[/b] (SOFP - a current liability, because we owe it).\n\nNext period, the accrual is [b]reversed[/b]: Dr Accruals, Cr Expense - so when the bill is paid, the cost isn't counted twice."},
							{"text": "Working out the accrual: find the months used but not yet billed, and take that fraction of the bill. If the bill isn't known yet, use a [b]reasonable estimate[/b]."}
						],
						"example": {"title": "Electricity: year-end 31 December", "table": {"cols": ["", "$"], "rows": [
							{"c": ["Bills paid during the year (Jan-Oct usage)", "3,200"], "s": 1},
							{"c": ["Bill for Nov-Jan arrives in February: 900", ""], "s": 2},
							{"c": ["Nov + Dec used this year: 2/3 x 900 = accrual", "600"], "s": 2},
							{"c": ["Electricity expense in SOPL (3,200 + 600)", "3,800"], "s": 3, "b": true},
							{"c": ["Accrual in SOFP (current liability)", "600"], "s": 3, "b": true}]},
							"steps": ["During the year, 3,200 was paid for January to October.", "November and December were used this year but are only billed in February: 2 of the 3 months = 600.", "Dr Electricity 600, Cr Accruals 600. Expense 3,800; a 600 liability in the SOFP."]},
						"practice": [
							{"type": "input", "q": "Year-end 31 March. The phone bill for the quarter to 30 April (1,500) is paid in May. What accrual is needed?  (number)", "accept": ["1000"], "display_answer": "1,000", "ex": "February and March are used this year: 2/3 x 1,500 = 1,000."},
							{"type": "picklist", "q": "To record an accrued expense: Debit {0}, Credit {1}.", "lists": [["the expense (SOPL)", "Accruals (SOFP)", "Bank"], ["Accruals (SOFP)", "the expense (SOPL)", "Prepayments (SOFP)"]], "a": [0, 0], "ex": "The expense goes up and a liability is created."},
							{"type": "choice", "q": "An accrued expense is shown in the statement of financial position as:", "opts": ["A current liability", "A current asset", "A non-current liability", "A reduction of capital"], "a": 0, "ex": "It is owed at the year-end - a current liability."},
							{"type": "choice", "q": "At the start of the next period, last year's accrual is reversed by:", "opts": ["Dr Accruals, Cr Expense", "Dr Expense, Cr Accruals", "Dr Bank, Cr Accruals", "No entry is needed"], "a": 0, "ex": "Reversing is the opposite of creating it, so when the bill is paid the cost lands in the right year."}
						]
					},
					{
						"id": "L2", "title": "Prepayments: paid in advance",
						"outcome": "D7(a)(b) Prepayments; D7(d) Journals to create and reverse",
						"apply": {"title": "Zuru's Lemonade Stand - a year of insurance, paid up front", "pages": [
							{"text": "On 1 October Zuru pays [b]240[/b] for twelve months of cart insurance. By 31 December only [b]three months[/b] (60) have been used up; the other [b]nine months[/b] (180) belong to next year.\n\nA [b]prepayment[/b] moves the unused part out of this year's expenses and into the SOFP as a current asset - she has paid for a service she hasn't yet had."},
							{"text": "", "table": {"cols": ["", "Dr", "Cr"], "rows": [{"c": ["1 Oct: Insurance expense / Cash", "240", "240"]}, {"c": ["31 Dec: Prepayments / Insurance expense (9/12 x 240)", "180", "180"]}, {"c": ["1 Jan: Insurance expense / Prepayments (reverse)", "180", "180"]}]}},
							{"text": "Result: this year's SOPL shows insurance of [b]60[/b] (3 months), the SOFP shows a prepayment asset of [b]180[/b], and next year starts with 180 of expense already in place for its nine months. Accruals and prepayments are mirror images: an accrual is a cost used but not yet paid (liability); a prepayment is a cost paid but not yet used (asset)."}
						]},
						"learn": [
							{"text": "A [b]prepayment[/b] (prepaid expense) is an expense [b]paid in advance[/b] that belongs to the NEXT period. Typical examples: rent, insurance, subscriptions paid ahead."},
							{"text": "At the year-end the unused part is taken out of this year's expense and carried forward as an [b]asset[/b] (the business has paid for a benefit it hasn't used yet):\n[b]Dr Prepayments[/b] (SOFP - current asset), [b]Cr Expense[/b] (SOPL - reduces the cost)."},
							{"text": "Next period it is reversed: Dr Expense, Cr Prepayments - the cost lands in the year it was used."},
							{"text": "Working: count the months [b]after[/b] the year-end that have already been paid for, and take that fraction of the payment."}
						],
						"example": {"title": "Rent: year-end 31 December", "table": {"cols": ["", "$"], "rows": [
							{"c": ["1 April: paid 12 months' rent to 31 March next year", "12,000"], "s": 1},
							{"c": ["Jan-Mar next year paid for already: 3/12 x 12,000", "3,000"], "s": 2},
							{"c": ["Rent expense this year (Apr-Dec): 12,000 - 3,000", "9,000"], "s": 3, "b": true},
							{"c": ["Prepayment in SOFP (current asset)", "3,000"], "s": 3, "b": true}]},
							"steps": ["12,000 covers April this year to March next year.", "January to March next year (3 months) has been paid for but not used: 3,000.", "Dr Prepayments 3,000, Cr Rent 3,000. Expense 9,000; asset 3,000."]},
						"practice": [
							{"type": "input", "q": "Year-end 30 June. Insurance of 4,800 was paid on 1 March for the year to 28 February. Prepayment at 30 June = ?  (number)", "accept": ["3200"], "display_answer": "3,200", "ex": "July to February is 8 months still to come: 8/12 x 4,800 = 3,200."},
							{"type": "picklist", "q": "To record a prepaid expense: Debit {0}, Credit {1}.", "lists": [["Prepayments (SOFP)", "the expense (SOPL)", "Accruals (SOFP)"], ["the expense (SOPL)", "Prepayments (SOFP)", "Bank"]], "a": [0, 0], "ex": "The unused part becomes an asset and the expense is reduced."},
							{"type": "choice", "q": "A prepayment is shown in the statement of financial position as:", "opts": ["A current asset", "A current liability", "Part of non-current assets", "A reduction of capital"], "a": 0, "ex": "It is a benefit paid for but not yet used - a current asset."},
							{"type": "input", "q": "Rent paid in the year 14,000. Opening prepayment 1,000; closing prepayment 1,500. Rent expense for the year = ?  (number)", "accept": ["13500"], "display_answer": "13,500", "ex": "14,000 + 1,000 used from last year - 1,500 carried forward = 13,500."}
						]
					},
					{
						"id": "L3", "title": "Accrued income and deferred income",
						"outcome": "D7(a)(b) Accrued income and deferred income; D7(d) Journals",
						"apply": {"title": "Zuru's Lemonade Stand - income can be early or late too", "pages": [
							{"text": "Two December arrangements:\n- The cafe pays Zuru a [b]commission of 50 a month[/b] for every month it stocks YUZURU. December's 50 isn't paid until 15 January.\n- The dojo pays [b]120 in advance[/b] on 20 December for lemonade at its January open day.\n\nSame accruals logic, pointing the other way."},
							{"text": "", "table": {"cols": ["31 December", "Dr", "Cr", "Why"], "rows": [{"c": ["Accrued income (SOFP asset) / Commission income", "50", "50", "Earned in December, not yet received"]}, {"c": ["Cash / Deferred income (SOFP liability)", "120", "120", "Received in December, not yet earned"]}]}},
							{"text": "[b]Accrued income[/b] is a receivable in all but name - December's commission counts as December income. [b]Deferred income[/b] is the opposite: the dojo's 120 is a liability until the open day, because Zuru still owes them the lemonade (IFRS 15: revenue when the cups are handed over, not when cash arrives). In January both unwind: the 50 arrives and clears the accrued income; the open day happens and the 120 becomes revenue."}
						]},
						"learn": [
							{"text": "The same idea works for [b]income[/b]. Income belongs to the period in which it is [b]earned[/b], whenever the cash arrives."},
							{"text": "[b]Accrued income[/b]: earned this period but not yet received or invoiced - e.g. rent we're owed by a tenant, commission earned.\n[b]Dr Accrued income[/b] (SOFP - current asset), [b]Cr Income[/b] (SOPL)."},
							{"text": "[b]Deferred income[/b] (income received in advance): cash received for something we haven't delivered yet - e.g. a customer pays for next year's subscription.\n[b]Dr Income[/b] (SOPL - reduce it), [b]Cr Deferred income[/b] (SOFP - current liability: we owe the service)."},
							{"text": "Memory hook - match each to its 'expense twin':\n[b]Accrued income[/b] is an ASSET (like a prepayment).\n[b]Deferred income[/b] is a LIABILITY (like an accrual)."}
						],
						"example": {"title": "Flat rented out: year-end 31 December", "table": {"cols": ["Situation", "Treatment", "$"], "rows": [
							{"c": ["Tenant owes December rent, paid 5 Jan", "Accrued income (asset)", "800"], "s": 1},
							{"c": ["Customer paid 1,200 on 1 Oct for a 12-month subscription", "9 months not yet earned: deferred income (liability)", "900"], "s": 2},
							{"c": ["Subscription income this year: 3/12 x 1,200", "Income in SOPL", "300"], "s": 2, "b": true}]},
							"steps": ["December's rent is earned this year even though the cash arrives in January: Dr Accrued income 800, Cr Rent income 800.", "Of the 1,200 received, only October to December (300) is earned this year. The other 900 is owed to the customer as future service: Dr Income 900, Cr Deferred income 900."]},
						"practice": [
							{"type": "sort", "q": "Is each item an asset or a liability at the year-end?", "buckets": ["Asset", "Liability"], "items": [["Accrued income", 0], ["Prepaid expense", 0], ["Deferred income", 1], ["Accrued expense", 1]], "ex": "Accrued income and prepayments are assets; deferred income and accruals are liabilities."},
							{"type": "input", "q": "Year-end 31 December. A customer paid 6,000 on 1 September for 12 months' maintenance. How much is deferred income at 31 December?  (number)", "accept": ["4000"], "display_answer": "4,000", "ex": "September to December is earned (4 months = 2,000). January to August (8 months = 4,000) is deferred."},
							{"type": "picklist", "q": "Commission of 700 earned in December is received in January. At 31 December: Debit {0}, Credit {1}.", "lists": [["Accrued income", "Commission income", "Deferred income"], ["Commission income", "Accrued income", "Bank"]], "a": [0, 0], "ex": "The commission is earned this year: an asset (accrued income) and income in the SOPL."},
							{"type": "choice", "q": "Cash received in advance for a service not yet provided is:", "opts": ["Deferred income - a liability", "Accrued income - an asset", "Revenue for this year", "A prepayment - an asset"], "a": 0, "ex": "We still owe the service, so it is a liability."}
						]
					},
					{
						"id": "L4", "title": "The ledger account and the effect on profit",
						"outcome": "D7(c) Illustrate the adjusting process; D7(e) Impact on profit and net assets; D7(f) Report in the financial statements",
						"apply": {"title": "Zuru's Lemonade Stand - the rent account, start to finish", "pages": [
							{"text": "Stall rent is [b]40 a month[/b]. During the year Zuru paid [b]440[/b] (eleven months - December's was late). The rent ledger account for the year, with the accrual:", "table": {"cols": ["Rent - Dr", "", "Cr", ""], "rows": [{"c": ["Cash (11 payments)", "440", "SOPL (12 months)", "480"]}, {"c": ["Accrual c/d", "40", "", ""]}, {"c": ["", "480", "", "480"], "b": true}, {"c": ["", "", "Accrual b/d", "40"]}]}},
							{"text": "The SOPL takes the full [b]480[/b] (12 x 40). The credit balance b/d of 40 is the accrual - a current liability in the SOFP. Had Zuru paid 13 months by mistake, the account would close with a [b]debit[/b] balance b/d: a prepayment, a current asset."},
							{"text": "Year-end effects, which the examiner tests from every angle:", "table": {"cols": ["Adjustment", "Profit", "Net assets"], "rows": [{"c": ["Accrued expense (rent 40)", "down 40", "down 40 (liability up)"]}, {"c": ["Prepaid expense (insurance 180)", "up 180", "up 180 (asset up)"]}, {"c": ["Accrued income (commission 50)", "up 50", "up 50 (asset up)"]}, {"c": ["Deferred income (dojo 120)", "down 120", "down 120 (liability up)"]}]}}
						]},
						"learn": [
							{"text": "Exam questions often give you the cash paid plus opening and closing balances and ask for the [b]SOPL expense[/b]. Think of the expense account:\n[b]Expense = Cash paid - Opening accrual + Closing accrual + Opening prepayment - Closing prepayment[/b]"},
							{"text": "Why: an opening accrual was last year's cost (paid this year) so take it off; a closing accrual is this year's cost not yet paid so add it. An opening prepayment is this year's cost paid last year so add it; a closing prepayment is next year's cost so take it off."},
							{"text": "Effect of each adjustment:\n[b]Accrual[/b] - expense UP, profit DOWN, liabilities UP\n[b]Prepayment[/b] - expense DOWN, profit UP, assets UP\n[b]Accrued income[/b] - income UP, profit UP, assets UP\n[b]Deferred income[/b] - income DOWN, profit DOWN, liabilities UP"},
							{"text": "Reporting: accruals and deferred income are [b]current liabilities[/b]; prepayments and accrued income are [b]current assets[/b]."}
						],
						"example": {"title": "Electricity expense account", "table": {"cols": ["Electricity", "Dr $", "Cr $"], "rows": [
							{"c": ["Cash paid in the year", "5,200", ""], "s": 1},
							{"c": ["Opening accrual reversed (last year's cost)", "", "400"], "s": 2},
							{"c": ["Closing accrual (this year, unpaid)", "600", ""], "s": 3},
							{"c": ["Expense to SOPL (balancing figure)", "", "5,400"], "s": 4, "b": true},
							{"c": ["Totals", "5,800", "5,800"], "s": 4}]},
							"steps": ["Cash paid during the year: 5,200.", "400 of that paid last year's bill - the reversed opening accrual takes it out.", "Add the 600 used this year but not paid yet.", "Expense = 5,200 - 400 + 600 = 5,400."]},
						"practice": [
							{"type": "input", "q": "Insurance paid 3,600. Opening prepayment 500; closing prepayment 800. Insurance expense = ?  (number)", "accept": ["3300"], "display_answer": "3,300", "ex": "3,600 + 500 - 800 = 3,300."},
							{"type": "input", "q": "Gas paid 2,900. Opening accrual 350; closing accrual 420. Gas expense = ?  (number)", "accept": ["2970"], "display_answer": "2,970", "ex": "2,900 - 350 + 420 = 2,970."},
							{"type": "choice", "q": "A business forgets to record a closing PREPAYMENT of 900. The effect is:", "opts": ["Profit understated by 900 and assets understated by 900", "Profit overstated by 900", "Liabilities understated by 900", "No effect on profit"], "a": 0, "ex": "The expense is 900 too high, so profit is 900 too low, and the prepayment asset is missing."},
							{"type": "multi", "q": "Which TWO adjustments INCREASE profit?", "opts": ["Recording a prepayment", "Recording accrued income", "Recording an accrual", "Recording deferred income"], "a": [0, 1], "ex": "Prepayments reduce expenses and accrued income adds income. Accruals and deferred income reduce profit."}
						]
					}
				]
			},
			{
				"id": 11, "title": "Provisions and contingencies", "monster": "The Contingency Shade",
				"beats": [
					{"type":"story","speaker":"Sensei Otter","text":"The flickering [b]Contingency Shade[/b] is never quite there. Judge what is probable, possible or remote to pin it down."},
					{"type":"story","speaker":"Sensei Otter","text":"A [b]provision[/b] needs: a present obligation (past event), a [b]probable[/b] outflow, and a reliable estimate. Contingent liability: possible -> disclose, probable -> provide. Contingent asset: probable -> disclose, virtually certain -> recognise. [b]Adjusting event[/b] = a condition that existed AT the year-end."},
					{"type":"choice","q":"A provision is recognised only when an outflow of resources is:","opts":["Possible","Probable","Remote","Certain"],"a":1,"ex":"A provision needs a present obligation, a PROBABLE outflow and a reliable estimate."},
					{"type":"choice","q":"A contingent liability that is only POSSIBLE should be:","opts":["Recognised as a provision","Disclosed by note","Ignored completely","Added to revenue"],"a":1,"ex":"A possible contingent liability is disclosed, not recognised."},
					{"type":"choice","q":"A probable contingent ASSET should be:","opts":["Recognised","Disclosed by note","Ignored","Provided for"],"a":1,"ex":"Prudence: a probable asset is only disclosed; recognised only when virtually certain."},
					{"type":"choice","q":"Which is NOT a condition for recognising a provision?","opts":["A present obligation from a past event","A probable outflow","A reliable estimate","The amount is certain"],"a":3,"ex":"A provision is a liability of UNCERTAIN amount; certainty is not required."},
					{"type":"choice","q":"A warranty provision is recognised because:","opts":["A loss is merely possible","There is a present obligation with a probable outflow and reliable estimate","The directors prefer it","It reduces tax"],"a":1,"ex":"Past sales create a present obligation; if probable and estimable, provide."},
					{"type":"choice","q":"A contingent asset that is virtually certain should be:","opts":["Recognised","Disclosed only","Ignored","Provided for"],"a":0,"ex":"A virtually certain inflow is no longer contingent - it is recognised."},
					{"type":"input","q":"A provision rises from 5,000 to 8,000 at the year-end. The charge to profit or loss = ?  (number)","accept":["3000"],"display_answer":"3,000","ex":"Only the increase is charged: 8,000 - 5,000 = 3,000."},
					{"type":"choice","q":"A contingent liability where the outflow is REMOTE should be:","opts":["Ignored - no provision and no disclosure","Disclosed by note","Provided for","Recognised as an asset"],"a":0,"ex":"Remote = neither provided for nor disclosed."},
					{"type":"choice","q":"At each reporting date, a provision should be:","opts":["Reviewed and adjusted to the current best estimate","Left unchanged until settled","Written off","Moved to equity"],"a":0,"ex":"Provisions are reviewed every reporting date and adjusted to the best current estimate."}
				],
				# Ch 11 learning objectives: D9(a)-(f). Exam: when to provide vs disclose; calculating a provision.
				"lessons": [
					{
						"id": "L1", "title": "Provisions",
						"outcome": "D9(a) Define a provision; D9(d) Calculate provisions and changes; D9(e) Journals for the movement; D9(f) Report provisions",
						"apply": {"title": "Zuru's Lemonade Stand - the spilt-lemonade claim", "pages": [
							{"text": "In November a customer slips on lemonade spilt by the cart and sends a claim. Zuru's lawyer says: she will [b]probably[/b] have to pay, and the best estimate is [b]400[/b]. Nothing has been paid by 31 December.\n\nIAS 37: a [b]provision[/b] is a liability of uncertain timing or amount. Recognise it when there is a present obligation from a past event (the spill), payment is probable, and the amount can be estimated reliably. All three hold."},
							{"text": "", "table": {"cols": ["", "Dr", "Cr"], "rows": [{"c": ["Year 1: Legal claim expense (SOPL) / Provision (SOFP)", "400", "400"]}, {"c": ["Year 2: claim settled at 350 - Provision / Cash", "350", "350"]}, {"c": ["Year 2: release the 50 not needed - Provision / Legal claim expense", "50", "50"]}]}},
							{"text": "In year 1 the SOPL shows the 400 expense and the SOFP a provision of 400 (current, as it is expected within 12 months). In year 2 only the [b]movement[/b] hits profit: the 50 over-provided comes back as a credit. Had the settlement been 450, the extra 50 would be an expense in year 2. A provision is never adjusted by rewriting last year's accounts - the estimate was the best available at the time."}
						]},
						"learn": [
							{"text": "A [b]provision[/b] is a [b]liability of uncertain timing or amount[/b] (IAS 37). Examples: warranty repairs, legal claims the business expects to lose, restructuring, cleaning up environmental damage."},
							{"text": "A provision is recognised ONLY if all three are met:\n1. A [b]present obligation[/b] (legal or constructive) as a result of a [b]past event[/b]\n2. An outflow of resources is [b]probable[/b] (more likely than not)\n3. A [b]reliable estimate[/b] can be made"},
							{"text": "It is measured at the [b]best estimate[/b] of what will be paid. For many similar items (like warranties) use an [b]expected value[/b]: each possible cost x its probability, added up."},
							{"text": "Only the [b]movement[/b] goes through profit or loss each year:\nIncrease: [b]Dr Expense[/b] (SOPL), [b]Cr Provision[/b] (SOFP)\nDecrease: [b]Dr Provision[/b], [b]Cr Expense[/b]\nThe provision is a liability in the SOFP, explained in a disclosure note."}
						],
						"example": {"title": "Warranty provision", "table": {"cols": ["Outcome", "Probability", "Cost if it happens", "Expected cost"], "rows": [
							{"c": ["No defects", "75%", "0", "0"], "s": 1},
							{"c": ["Minor defects", "20%", "100,000", "20,000"], "s": 1},
							{"c": ["Major defects", "5%", "400,000", "20,000"], "s": 1},
							{"c": ["Provision needed", "", "", "40,000"], "s": 2, "b": true},
							{"c": ["Less: provision brought forward", "", "", "(32,000)"], "s": 3},
							{"c": ["Increase - charged to profit or loss", "", "", "8,000"], "s": 3, "b": true}]},
							"steps": ["Multiply each possible cost by its probability.", "Add them up: the provision at the year-end is 40,000.", "Only the 8,000 increase on last year's 32,000 is charged: Dr Warranty expense 8,000, Cr Provision 8,000."]},
						"practice": [
							{"type": "input", "q": "A business expects warranty claims: 70% chance of none, 25% chance costing 40,000, 5% chance costing 200,000. Provision = ?  (number)", "accept": ["20000"], "display_answer": "20,000", "ex": "25% x 40,000 + 5% x 200,000 = 10,000 + 10,000 = 20,000."},
							{"type": "input", "q": "A provision falls from 15,000 to 11,000. By how much is the expense REDUCED in profit or loss?  (number)", "accept": ["4000"], "display_answer": "4,000", "ex": "Only the movement goes through profit or loss: Dr Provision 4,000, Cr Expense 4,000."},
							{"type": "multi", "q": "Which TWO are conditions for recognising a provision?", "opts": ["A present obligation from a past event", "A probable outflow of resources", "The exact amount is known", "The cash has already been paid"], "a": [0, 1], "ex": "Present obligation, probable outflow and a reliable ESTIMATE - the exact amount doesn't need to be known."},
							{"type": "choice", "q": "A provision is best described as:", "opts": ["A liability of uncertain timing or amount", "An asset of uncertain value", "A reserve set aside from profits", "An expense paid in advance"], "a": 0, "ex": "That's the IAS 37 definition."}
						]
					},
					{
						"id": "L2", "title": "Contingent liabilities and contingent assets",
						"outcome": "D9(a) Define contingent liabilities and assets; D9(b) Classify items; D9(c) Methods of accounting for each",
						"apply": {"title": "Zuru's Lemonade Stand - three more disputes", "pages": [
							{"text": "Same year-end, three more loose ends:\n1. The dojo says Zuru's heater scorched its gate and wants 600. The lawyer thinks a payout is [b]possible but not probable[/b].\n2. A passer-by claims the lemonade was too hot. The lawyer calls it [b]remote[/b].\n3. Zuru is suing the bottler for a spoiled batch; winning 900 is [b]probable[/b] but not certain."},
							{"text": "", "table": {"cols": ["Item", "Likelihood", "Treatment"], "rows": [{"c": ["Provision (spilt-lemonade claim, last lesson)", "Probable outflow", "Recognise a liability"]}, {"c": ["Contingent liability (scorched gate)", "Possible outflow", "Disclose in a note only"]}, {"c": ["Contingent liability (too-hot claim)", "Remote", "Nothing - not even a note"]}, {"c": ["Contingent asset (bottler case)", "Probable inflow", "Disclose in a note only"]}, {"c": ["Contingent asset", "Virtually certain", "Recognise the asset"]}]}},
							{"text": "The asymmetry is [b]prudence[/b] at work: a probable loss goes in the accounts, a probable gain only gets a note. Zuru's accounts for the year therefore show one provision (400), one note about the gate, one note about the bottler, and silence about the too-hot claim."}
						]},
						"learn": [
							{"text": "A [b]contingent liability[/b] is either:\n- a POSSIBLE obligation that will only be confirmed by uncertain future events outside the entity's control, or\n- a present obligation that isn't recognised because the outflow isn't probable or can't be measured reliably.\nIt is NOT recognised - it is [b]disclosed in a note[/b] (unless remote)."},
							{"text": "A [b]contingent asset[/b] is a POSSIBLE asset from past events, confirmed only by uncertain future events outside the entity's control - e.g. a legal claim the business is making against someone else. Prudence applies: it is NOT recognised."},
							{"text": "The decision table:\n[b]Outflow (liability):[/b] probable -> provide; possible -> disclose; remote -> ignore.\n[b]Inflow (asset):[/b] virtually certain -> recognise (it's no longer contingent); probable -> disclose; possible or remote -> ignore."},
							{"text": "Notice the asymmetry: a liability is provided for once it's [b]probable[/b], but an asset needs to be [b]virtually certain[/b]. That's prudence - losses are recognised sooner than gains."}
						],
						"example": {"title": "Four legal cases at the year-end", "table": {"cols": ["Case", "Likelihood", "Treatment"], "rows": [
							{"c": ["Customer suing us for 50,000", "Probable we lose", "Provision 50,000"], "s": 1},
							{"c": ["Supplier suing us for 20,000", "Possible we lose", "Disclose in a note"], "s": 2},
							{"c": ["Ex-employee suing us for 5,000", "Remote", "Ignore"], "s": 2},
							{"c": ["We are suing a competitor for 80,000", "Probable we win", "Disclose in a note"], "s": 3},
							{"c": ["Insurer has agreed to pay us 10,000", "Virtually certain", "Recognise the asset"], "s": 3}]},
							"steps": ["Probable loss: recognise a provision.", "Possible loss: disclose only. Remote: no mention at all.", "Gains: disclose if probable, but recognise only when virtually certain."]},
						"practice": [
							{"type": "sort", "q": "How should each item be treated?", "buckets": ["Provide / recognise", "Disclose only", "Ignore"], "items": [["Probable loss on a court case", 0], ["Possible loss on a court case", 1], ["Remote chance of a claim", 2], ["Probable gain from a claim we are making", 1], ["Virtually certain insurance receipt", 0]], "ex": "Liabilities: probable = provide, possible = disclose, remote = ignore. Assets: virtually certain = recognise, probable = disclose."},
							{"type": "choice", "q": "A contingent asset that is PROBABLE should be:", "opts": ["Disclosed in a note", "Recognised in the SOFP", "Ignored", "Provided for"], "a": 0, "ex": "Probable contingent assets are disclosed; they are recognised only when virtually certain."},
							{"type": "choice", "q": "A contingent liability where the outflow is only POSSIBLE should be:", "opts": ["Disclosed in a note", "Recognised as a provision", "Ignored", "Recognised as an asset"], "a": 0, "ex": "Possible outflows are disclosed, not provided for."},
							{"type": "picklist", "q": "A liability is provided for when the outflow is {0}, but an asset is recognised only when the inflow is {1}.", "lists": [["probable", "possible", "remote"], ["virtually certain", "probable", "possible"]], "a": [0, 0], "ex": "This asymmetry reflects prudence."}
						]
					}
				]
			},
			{
				"id": 12, "title": "Irrecoverable debts and allowances", "monster": "The Debt Specter",
				"beats": [
					{"type":"story","speaker":"Sensei Otter","text":"The [b]Debt Specter[/b] drifts between the ledgers, dropping amounts no one will pay. Control the accounts and allow for the doubtful ones."},
					{"type":"story","speaker":"Sensei Otter","text":"The receivables control is the total owed by customers (a debit balance). Write off a bad debt: [b]Dr Irrecoverable debts expense, Cr Receivables[/b]. An [b]allowance[/b] is netted off receivables; only its [b]movement[/b] hits the SOPL."},
					{"type":"choice","q":"To write off an irrecoverable debt, the entry is:","opts":["Dr Receivables, Cr Cash","Dr Irrecoverable debts expense, Cr Receivables","Dr Sales, Cr Receivables","Dr Allowance, Cr Cash"],"a":1,"ex":"Writing off charges the expense and removes the receivable."},
					{"type":"input","q":"The allowance for receivables rises from 2,000 to 3,200. The charge to the SOPL = ?  (number)","accept":["1200"],"display_answer":"1,200","ex":"Only the movement hits the SOPL: 3,200 - 2,000 = 1,200."},
					{"type":"input","q":"Receivables 80,000. Specific allowance 3,000, plus 2% general on the rest. Total allowance = ?  (number)","accept":["4540"],"display_answer":"4,540","ex":"3,000 + 2% x (80,000 - 3,000) = 3,000 + 1,540 = 4,540."},
					{"type":"choice","q":"The allowance falls from 5,000 to 3,500. The effect on the SOPL is:","opts":["An expense of 1,500","A reduction of the expense of 1,500","An expense of 3,500","No effect"],"a":1,"ex":"A decrease of 1,500 reduces the irrecoverable debts expense."},
					{"type":"choice","q":"A debt previously written off is unexpectedly paid. On receipt:","opts":["Dr Receivables, Cr Cash","Dr Cash, Cr Irrecoverable debts (expense/income)","Dr Allowance, Cr Cash","Dr Sales, Cr Cash"],"a":1,"ex":"Cash recovered is Dr Cash and credited back against the irrecoverable debts expense."}
				],
				# Ch 12 learning objectives: D8(a)-(k). Exam: write-offs, cash later received, allowance movements; SOPL and SOFP figures; can be Section B.
				# (Contras and supplier statements are taught in Ch 14.)
				"lessons": [
					{
						"id": "L1", "title": "Selling on credit",
						"outcome": "D8(a) Examples of receivables and payables; D8(b) Benefits and costs of credit; D8(c) Aged receivables analysis; D8(d) Credit limits",
						"apply": {"title": "Zuru's Lemonade Stand - who owes what, and for how long", "pages": [
							{"text": "By the autumn Zuru sells on credit to the [b]cafe[/b], the [b]dojo[/b] and a [b]gym[/b]. Credit brings bigger customers and bigger orders - the cafe wouldn't pay cash for 200 bottles a month. It also brings costs: she funds the lemons weeks before the cash arrives, chases invoices, and sometimes doesn't get paid at all.\n\nAt the end of November the app prints an [b]aged receivables analysis[/b]:"},
							{"text": "", "table": {"cols": ["Customer", "Total", "0-30 days", "31-60", "61-90", "90+"], "rows": [{"c": ["Cafe", "480", "240", "240", "-", "-"]}, {"c": ["Dojo", "120", "120", "-", "-", "-"]}, {"c": ["Gym", "300", "-", "-", "150", "150"]}, {"c": ["Student tab", "10", "-", "-", "-", "10"]}, {"c": ["Total", "910", "360", "240", "150", "160"], "b": true}]}},
							{"text": "The table tells her where to look. The gym has 300 outstanding, half of it over 90 days - time to stop deliveries and chase hard. The student's 10 is probably gone (next lesson). So she sets [b]credit limits[/b]: cafe 600 (pays like clockwork), gym 150 until it clears its account, and the dojo 200. Payables work the same way from the other side: Kenji's ageing of Zuru's account decides how much credit HE gives HER."}
						]},
						"learn": [
							{"text": "[b]Trade receivables[/b] are amounts customers owe for goods or services bought on credit. [b]Trade payables[/b] are amounts the business owes its suppliers. Other examples: prepayments and accrued income (receivables), accruals (payables)."},
							{"text": "Offering credit has [b]benefits[/b]: more sales, competing with rivals who offer credit, building customer loyalty.\nAnd [b]costs[/b]: some customers never pay (irrecoverable debts), cash arrives later (so the business may need an overdraft), plus admin and chasing costs."},
							{"text": "Two tools manage the risk:\n[b]Credit limits[/b] - the maximum a customer may owe at any time, set from their credit history and references.\n[b]Aged receivables analysis[/b] - lists each customer's balance by how long it has been owed (e.g. 0-30, 31-60, 61-90, 90+ days), so overdue debts can be chased and doubtful ones spotted."}
						],
						"practice": [
							{"type": "multi", "q": "Which TWO are COSTS of offering credit to customers?", "opts": ["Some debts may never be paid", "Cash is received later than the sale", "Sales may increase", "Customers may be more loyal"], "a": [0, 1], "ex": "Irrecoverable debts and delayed cash are costs; extra sales and loyalty are benefits."},
							{"type": "choice", "q": "The MAIN purpose of an aged receivables analysis is to:", "opts": ["Show how long each customer's balance has been outstanding", "Calculate sales tax", "Set the selling price of goods", "Record cash sales"], "a": 0, "ex": "It groups balances by age so overdue and doubtful debts can be chased or allowed for."},
							{"type": "choice", "q": "A customer credit limit is:", "opts": ["The maximum amount a customer is allowed to owe", "The discount offered for early payment", "The number of days allowed to pay", "The amount written off as irrecoverable"], "a": 0, "ex": "The credit limit caps the risk on each customer."}
						]
					},
					{
						"id": "L2", "title": "Irrecoverable debts: write-offs and recoveries",
						"outcome": "D8(e) Write off an irrecoverable debt; D8(f) Debt later recovered; D8(g) Impact on SOPL and SOFP",
						"apply": {"title": "Zuru's Lemonade Stand - the vanished student", "pages": [
							{"text": "The student who ran up a [b]10[/b] tab has left the dojo and isn't answering messages. At the year-end Zuru accepts the money is not coming: the debt is [b]irrecoverable[/b] and is written off.\n\n[b]Dr Irrecoverable debts expense 10, Cr Receivables 10[/b]\n\nReceivables drop by 10 (the SOFP no longer claims an asset that isn't there) and profit drops by 10. Prudence: don't count money you won't get."},
							{"text": "In March the student reappears with the 10. The debt had already been removed, so it can't be credited to receivables - it comes back as income:\n[b]Dr Cash 10, Cr Irrecoverable debts expense 10[/b] (a 'recovered' debt, netted against this year's write-offs).", "table": {"cols": ["Irrecoverable debts expense - Dr", "", "Cr", ""], "rows": [{"c": ["Receivables (written off)", "10", "Cash (recovered)", "10"]}, {"c": ["Receivables (gym, written off)", "150", "SOPL", "150"]}, {"c": ["", "160", "", "160"], "b": true}]}},
							{"text": "The gym's 150 that was over 90 days also goes - the owner has shut up shop. Written off in the same account: expense 160, less 10 recovered, so the SOPL charge is 150. Both write-offs reduce receivables in the SOFP; the recovery just reduces the expense. Note the difference from the next lesson: a write-off is a debt you KNOW is lost; an allowance is for debts you FEAR may be."}
						]},
						"learn": [
							{"text": "An [b]irrecoverable debt[/b] is one the business believes the customer will [b]never pay[/b] - e.g. the customer has gone bankrupt. Keeping it in receivables would overstate assets, so it is written off."},
							{"text": "The write-off: [b]Dr Irrecoverable debts expense[/b] (SOPL), [b]Cr Receivables[/b] (SOFP).\nEffect: profit DOWN, receivables (assets) DOWN."},
							{"text": "If a debt already written off is unexpectedly paid later, the expense is reversed:\n[b]Dr Bank, Cr Irrecoverable debts expense[/b].\n(Receivables aren't touched - the debt was already removed from them.)"},
							{"text": "Order of work at the year-end: write off the irrecoverable debts FIRST, then work out the allowance (next lesson) on the receivables that are left."}
						],
						"practice": [
							{"type": "picklist", "q": "To write off an irrecoverable debt of 750: Debit {0}, Credit {1}.", "lists": [["Irrecoverable debts expense", "Receivables", "Bank"], ["Receivables", "Irrecoverable debts expense", "Allowance for receivables"]], "a": [0, 0], "ex": "The expense goes up and the receivable is removed."},
							{"type": "choice", "q": "A debt of 400 written off last year is received in full this year. The entry is:", "opts": ["Dr Bank, Cr Irrecoverable debts expense", "Dr Receivables, Cr Bank", "Dr Bank, Cr Receivables", "Dr Irrecoverable debts expense, Cr Bank"], "a": 0, "ex": "The cash is recorded and the expense is reduced. Receivables were cleared when the debt was written off."},
							{"type": "input", "q": "Receivables are 46,000 before a debt of 1,300 is written off. What figure remains for receivables before any allowance?  (number)", "accept": ["44700"], "display_answer": "44,700", "ex": "46,000 - 1,300 = 44,700."}
						]
					},
					{
						"id": "L3", "title": "The allowance for receivables",
						"outcome": "D8(h) Create and adjust an allowance; D8(i) Allowance in the SOPL and SOFP; D8(g) Impact on the statements",
						"apply": {"title": "Zuru's Lemonade Stand - allowing for doubt", "pages": [
							{"text": "After the write-offs, receivables at 31 December are [b]750[/b]. Zuru isn't sure about all of it: the cafe's oldest invoice of [b]50[/b] is disputed (they say two cases were short), and experience says about [b]5%[/b] of the rest will drift into trouble.\n\nThe debts are still owed, so nothing is written off - instead she creates an [b]allowance for receivables[/b]:\n- specific: 50\n- general: 5% x (750 - 50) = 35\n- allowance needed: [b]85[/b]"},
							{"text": "", "table": {"cols": ["", "Dr", "Cr"], "rows": [{"c": ["Year 1: create - Irrecoverable debts expense / Allowance for receivables", "85", "85"]}, {"c": ["SOFP: Receivables 750 less allowance (85) = 665", "", ""], "b": true}, {"c": ["Year 2: allowance needed falls to 60 - Allowance / Irrecoverable debts expense", "25", "25"]}, {"c": ["Year 2: or rises to 110 - Irrecoverable debts expense / Allowance", "25", "25"]}]}},
							{"text": "Only the [b]movement[/b] in the allowance goes through profit each year; the full allowance sits in the SOFP netted against receivables (a credit balance - that's why it was a credit in the Chapter 6 trial balance). Year 1: profit down 85, net receivables 665. Year 2 (allowance down to 60): profit UP 25, net receivables = that year's receivables less 60. The exam question nearly always combines a write-off, a recovery and an allowance movement in one go - do them in that order."}
						]},
						"learn": [
							{"text": "Some debts aren't certainly bad, but [b]might[/b] not be paid. As a prudent precaution, the business makes an [b]allowance for receivables[/b] (allowance for irrecoverable debts): for specific doubtful customers and/or a % of the rest."},
							{"text": "The debts are NOT written off - the allowance is a separate credit balance that reduces receivables in the SOFP:\n[b]Receivables - Allowance = Net receivables[/b] shown as a current asset."},
							{"text": "Creating or increasing it: [b]Dr Irrecoverable debts expense, Cr Allowance[/b].\nDecreasing it: [b]Dr Allowance, Cr Irrecoverable debts expense[/b].\nOnly the [b]movement[/b] in the allowance hits profit or loss each year."},
							{"text": "Total SOPL charge = write-offs + increase in allowance (or - decrease) - any debts recovered."}
						],
						"example": {"title": "Year-end receivables", "table": {"cols": ["", "$"], "rows": [
							{"c": ["Receivables before write-off", "52,000"], "s": 1}, {"c": ["Irrecoverable debt written off", "(2,000)"], "s": 1}, {"c": ["Receivables after write-off", "50,000"], "s": 1, "b": true},
							{"c": ["Allowance needed: 5% x 50,000", "2,500"], "s": 2}, {"c": ["Allowance brought forward", "(1,800)"], "s": 2}, {"c": ["Increase in allowance", "700"], "s": 2, "b": true},
							{"c": ["SOPL irrecoverable debts expense: 2,000 + 700", "2,700"], "s": 3, "b": true},
							{"c": ["SOFP net receivables: 50,000 - 2,500", "47,500"], "s": 3, "b": true}]},
							"steps": ["Write off the bad debt first: 50,000 remain.", "The allowance should be 2,500. Last year's was 1,800, so increase it by 700: Dr Expense 700, Cr Allowance 700.", "SOPL expense = the write-off plus the increase. SOFP shows receivables net of the full allowance."]},
						"practice": [
							{"type": "input", "q": "The allowance for receivables rises from 2,000 to 3,200. The charge to profit or loss = ?  (number)", "accept": ["1200"], "display_answer": "1,200", "ex": "Only the movement is charged: 3,200 - 2,000 = 1,200."},
							{"type": "input", "q": "Receivables 60,000 after write-offs. A specific allowance of 1,500 is needed for one customer, plus 3% on the rest. Total allowance = ?  (number)", "accept": ["3255"], "display_answer": "3,255", "ex": "1,500 + 3% x (60,000 - 1,500) = 1,500 + 1,755 = 3,255."},
							{"type": "input", "q": "Write-offs in the year 900. Allowance fell from 2,600 to 2,100. A debt of 150 written off last year was recovered. Total irrecoverable debts expense in the SOPL = ?  (number)", "accept": ["250"], "display_answer": "250", "ex": "900 - 500 decrease in allowance - 150 recovered = 250."},
							{"type": "choice", "q": "In the SOFP, the allowance for receivables is shown:", "opts": ["As a deduction from trade receivables", "As a current liability", "As an expense", "As a non-current asset"], "a": 0, "ex": "Receivables are shown net of the allowance."},
							{"type": "picklist", "q": "To DECREASE the allowance for receivables: Debit {0}, Credit {1}.", "lists": [["Allowance for receivables", "Irrecoverable debts expense", "Receivables"], ["Irrecoverable debts expense", "Allowance for receivables", "Bank"]], "a": [0, 0], "ex": "A decrease reduces the allowance (debit) and reduces the expense (credit)."}
						]
					}
				]
			},
			{
				"id": 13, "title": "Sales tax", "monster": "The Tax-Collector Tengu",
				"beats": [
					{"type":"story","speaker":"Sensei Otter","text":"The [b]Tax-Collector Tengu[/b] demands its due on every sale. Net output against input and pay only the difference."},
					{"type":"story","speaker":"Sensei Otter","text":"[b]Output tax[/b] on sales (owed); [b]input tax[/b] on purchases (reclaimed). Net payable = output - input. Sales and purchases are shown [b]net[/b]; receivables and payables [b]gross[/b]. At 20%, gross to tax = x 20/120."},
					{"type":"taccount","speaker":"Sensei Otter","text":"The control account nets the two and shows what you owe the authority:","name":"Sales tax control account","dr":["Input tax on purchases 6,500","Balance c/d 2,500"],"cr":["Output tax on sales 9,000"],"dr_total":"9,000","cr_total":"9,000"},
					{"type":"choice","q":"Tax charged on sales is called:","opts":["Input tax","Output tax","Net tax","Deferred tax"],"a":1,"ex":"Output tax is charged on sales; input tax is suffered on purchases."},
					{"type":"input","q":"A sale is made for 600 plus sales tax at 20%. The output tax = ?  (number)","accept":["120"],"display_answer":"120","ex":"20% x 600 = 120."},
					{"type":"input","q":"A purchase invoice is 540 gross, including sales tax at 20%. The recoverable input tax = ?  (number)","accept":["90"],"display_answer":"90","ex":"Gross to tax = 540 x 20/120 = 90."},
					{"type":"input","q":"Output tax 9,000 and input tax 6,500. Amount owed to the tax authority = ?  (number)","accept":["2500"],"display_answer":"2,500","ex":"Net payable = 9,000 - 6,500 = 2,500."},
					{"type":"input","q":"Goods are sold for 960 including sales tax at 20%. The net sales figure = ?  (number)","accept":["800"],"display_answer":"800","ex":"Net = 960 x 100/120 = 800."},
					{"type":"choice","q":"In the financial statements, receivables are shown:","opts":["Net of sales tax","Gross (including sales tax)","At cost","At NRV"],"a":1,"ex":"Receivables include the tax the customer must pay, so they are shown gross."},
					{"type":"choice","q":"Irrecoverable input tax (e.g. on entertaining) is:","opts":["Reclaimed as normal","Included in the related expense or asset cost","Added to output tax","Ignored"],"a":1,"ex":"If input tax cannot be reclaimed, it forms part of the related expense or cost."},
					{"type":"input","q":"Goods are bought on credit for 2,000 plus sales tax at 20%. The amount credited to payables = ?  (number)","accept":["2400"],"display_answer":"2,400","ex":"Payables are gross: 2,000 + 400 tax = 2,400."},
					{"type":"input","q":"Sales 48,000 INCLUDING tax at 20%; purchases 30,000 EXCLUDING tax at 20%. Net sales tax payable = ?  (number)","accept":["2000"],"display_answer":"2,000","ex":"Output 48,000 x 20/120 = 8,000. Input 30,000 x 20% = 6,000. Payable 2,000."},
					{"type":"choice","q":"A business NOT registered for sales tax records its purchases:","opts":["Gross, including the tax it paid","Net of tax","At nil","In the sales tax control account"],"a":0,"ex":"It cannot reclaim input tax, so the tax is part of the cost."},
					{"type":"choice","q":"A credit balance on the sales tax control account is:","opts":["A current liability owed to the tax authority","A current asset","Revenue","An expense"],"a":0,"ex":"Output tax exceeds input tax, so the business owes the difference - a liability."}
				],
				# Ch 13 learning objectives: D1(c), D1(d). Exam: journals for sales/purchases incl. sales tax; sales tax in the cost of non-current assets.
				"lessons": [
					{
						"id": "L1", "title": "How sales tax works",
						"outcome": "D1(c) Principles of the operation of a sales tax",
						"apply": {"title": "Zuru Lemonade Ltd - the tax that isn't hers", "pages": [
							{"text": "Once bottled YUZURU takes off, Zuru Lemonade Ltd's sales pass the threshold and it registers for [b]sales tax at 20%[/b]. A cup that was 2 is now [b]2.40[/b]: 2 for Zuru, 0.40 collected for the tax authority. When she buys lemons for 120, Kenji charges [b]144[/b]: 24 of tax she can claim back.\n\nThe company is a [b]collector[/b], not a taxpayer: it passes on the difference and keeps none of it."},
							{"text": "", "table": {"cols": ["One month", "Net", "Tax 20%", "Gross"], "rows": [{"c": ["Sales (output tax collected)", "2,000", "400", "2,400"]}, {"c": ["Purchases (input tax paid)", "900", "180", "1,080"]}, {"c": ["Owed to the tax authority", "", "220", ""], "b": true}]}},
							{"text": "Revenue in the SOPL is [b]2,000[/b], not 2,400; purchases are 900, not 1,080. The 220 is a current liability until it is paid over. A [b]customer[/b] who isn't registered (the dojo) can't reclaim the 0.40, so for them the tax is simply part of the price - which is why, if a question gives a figure 'inclusive of tax at 20%', net = gross x 100/120 and the tax = gross x 20/120."}
						]},
						"learn": [
							{"text": "[b]Sales tax[/b] (e.g. VAT) is an [b]indirect tax[/b] on goods and services. The final consumer bears it; registered businesses just [b]collect[/b] it for the tax authority. The rate is set by each country - in the exam it will be given."},
							{"text": "[b]Output tax[/b] is charged on the business's SALES - collected from customers and owed to the tax authority.\n[b]Input tax[/b] is paid on the business's PURCHASES - reclaimed from the tax authority."},
							{"text": "The business pays the difference:\n[b]Output tax - Input tax = amount payable[/b]\n(If input tax is bigger, the authority repays the business.)"},
							{"text": "Two formulas, say at 20%:\nFrom a NET amount: tax = net x 20%\nFrom a GROSS amount (tax included): tax = gross x 20/120\nGross = Net + Tax."}
						],
						"example": {"title": "One month at 20%", "table": {"cols": ["", "Net", "Tax", "Gross"], "rows": [
							{"c": ["Sales", "10,000", "2,000", "12,000"], "s": 1},
							{"c": ["Purchases", "6,000", "1,200", "7,200"], "s": 2},
							{"c": ["Paid to the tax authority", "", "800", ""], "s": 3, "b": true}]},
							"steps": ["Output tax on sales: 10,000 x 20% = 2,000, collected from customers.", "Input tax on purchases: 6,000 x 20% = 1,200, reclaimable.", "Pay the difference: 2,000 - 1,200 = 800."]},
						"practice": [
							{"type": "input", "q": "Goods are sold for 840 INCLUDING sales tax at 20%. How much is output tax?  (number)", "accept": ["140"], "display_answer": "140", "ex": "840 x 20/120 = 140."},
							{"type": "input", "q": "Output tax for the quarter 18,400; input tax 11,900. Amount payable to the tax authority = ?  (number)", "accept": ["6500"], "display_answer": "6,500", "ex": "18,400 - 11,900 = 6,500."},
							{"type": "choice", "q": "Input tax is:", "opts": ["Sales tax paid on purchases, which a registered business can reclaim", "Sales tax charged on sales", "The tax rate set by the authority", "Tax on the business's profits"], "a": 0, "ex": "Input tax is on purchases; output tax is on sales."},
							{"type": "input", "q": "A purchase costs 2,500 before sales tax at 20%. What is the gross amount payable to the supplier?  (number)", "accept": ["3000"], "display_answer": "3,000", "ex": "2,500 + 20% x 2,500 = 3,000."}
						]
					},
					{
						"id": "L2", "title": "Recording sales tax",
						"outcome": "D1(d) Calculate sales tax and record it in the sales tax ledger account",
						"apply": {"title": "Zuru Lemonade Ltd - the sales tax account", "pages": [
							{"text": "The cafe orders 250 bottles at 2 each: net [b]500[/b], tax [b]100[/b], invoice [b]600[/b]. Kenji delivers lemons: net [b]300[/b], tax [b]60[/b], invoice [b]360[/b].", "table": {"cols": ["", "Dr", "Cr"], "rows": [{"c": ["Receivables (cafe)", "600", ""]}, {"c": ["   Sales", "", "500"]}, {"c": ["   Sales tax (output)", "", "100"]}, {"c": ["Purchases", "300", ""]}, {"c": ["Sales tax (input)", "60", ""]}, {"c": ["   Payables (Kenji)", "", "360"]}]}},
							{"text": "Receivables and payables carry the [b]gross[/b] amounts (that is what will actually be paid); sales and purchases carry the [b]net[/b]. The tax lands in one account:", "table": {"cols": ["Sales tax - Dr", "", "Cr", ""], "rows": [{"c": ["Input tax (purchases)", "60", "Output tax (sales)", "100"]}, {"c": ["Balance c/d (owed)", "40", "", ""]}, {"c": ["", "100", "", "100"], "b": true}]}},
							{"text": "A [b]credit[/b] balance on the sales tax account = money owed to the authority (a current liability, 40 here). A debit balance would mean the authority owes the company a refund (a current asset) - it happens when input tax exceeds output tax, for example the month the company bought the kiosk. Cash paid to the authority is Dr Sales tax, Cr Cash, clearing the balance."}
						]},
						"learn": [
							{"text": "Sales and purchases are recorded [b]NET[/b] of sales tax; receivables and payables are recorded [b]GROSS[/b] - the customer owes the tax too. The tax itself goes to a [b]sales tax account[/b]."},
							{"text": "Credit sale, 1,000 + 20%:\n[b]Dr Receivables 1,200[/b] (gross)\n[b]Cr Sales 1,000[/b] (net)\n[b]Cr Sales tax 200[/b] (output tax - owed to the authority)"},
							{"text": "Credit purchase, 600 + 20%:\n[b]Dr Purchases 600[/b] (net)\n[b]Dr Sales tax 120[/b] (input tax - reclaimable)\n[b]Cr Payables 720[/b] (gross)\nPaying the authority: Dr Sales tax, Cr Bank."},
							{"text": "[b]Irrecoverable sales tax[/b] - when the business can't reclaim input tax (it isn't registered, or the item is non-claimable, such as some cars or entertaining) - is [b]added to the cost[/b] of the expense or asset."},
							{"text": "Watch this in [b]non-current asset[/b] questions: a registered business capitalises the NET price; an unregistered business capitalises the GROSS price."}
						],
						"example": {"title": "Sales tax account for the month", "table": {"cols": ["Sales tax account", "Dr $", "Cr $"], "rows": [
							{"c": ["Input tax on purchases", "1,200", ""], "s": 1},
							{"c": ["Output tax on sales", "", "2,000"], "s": 1},
							{"c": ["Balance c/d - owed to the authority", "800", ""], "s": 2},
							{"c": ["Totals", "2,000", "2,000"], "s": 2, "b": true},
							{"c": ["Paid to the authority: Dr Sales tax, Cr Bank", "800", ""], "s": 3}]},
							"steps": ["Input tax is debited (reclaimable); output tax is credited (owed).", "A credit balance of 800 is a current liability - the amount owed.", "When paid, the debit clears the balance to nil."]},
						"practice": [
							{"type": "picklist", "q": "A credit sale of 500 plus sales tax of 100: Debit {0} 600, Credit Sales 500, Credit {1} 100.", "lists": [["Receivables", "Sales", "Sales tax"], ["Sales tax", "Receivables", "Purchases"]], "a": [0, 0], "ex": "Receivables are gross; sales are net; the tax is credited to the sales tax account."},
							{"type": "input", "q": "A sales tax-registered business buys a machine for 30,000 plus sales tax at 20%. At what cost is the machine capitalised?  (number)", "accept": ["30000"], "display_answer": "30,000", "ex": "The input tax of 6,000 is reclaimable, so the asset is recorded net."},
							{"type": "input", "q": "A business that is NOT registered for sales tax buys a machine for 30,000 plus sales tax at 20%. Capitalised cost = ?  (number)", "accept": ["36000"], "display_answer": "36,000", "ex": "It can't reclaim the tax, so the 6,000 is part of the cost: 36,000."},
							{"type": "choice", "q": "In the financial statements, trade payables are shown:", "opts": ["Including sales tax (gross)", "Excluding sales tax (net)", "At cost less tax", "In the sales tax account only"], "a": 0, "ex": "We owe the supplier the full gross amount."},
							{"type": "choice", "q": "Input tax on business entertaining cannot be reclaimed. It is:", "opts": ["Added to the entertaining expense", "Debited to the sales tax account", "Credited to sales", "Ignored"], "a": 0, "ex": "Irrecoverable sales tax becomes part of the cost of the related expense."}
						]
					}
				]
			},
			{
				"id": 14, "title": "Trade receivables and trade payables", "monster": "The Control-Account Kappa",
				"beats": [
					{"type":"taccount","speaker":"Sensei Otter","text":"Reconstruct the control account to find the closing balance owed by customers:","name":"Receivables control account","dr":["Balance b/d 10,000","Credit sales 55,000"],"cr":["Cash received 48,000","Returns inwards 2,000","Irrecoverable debts 1,000","Balance c/d 14,000"],"dr_total":"65,000","cr_total":"65,000"},
					{"type":"choice","q":"The payables control account balance represents:","opts":["Amounts owed by customers","Amounts owed to suppliers","Cash in hand","Inventory held"],"a":1,"ex":"The payables control shows the total owed to suppliers - a current liability."},
					{"type":"choice","q":"The receivables control account is reconciled to:","opts":["The bank statement","The total of the memorandum receivables ledger","The payables control","The trial balance total"],"a":1,"ex":"The control balance is agreed to the sum of the individual customer accounts."},
					{"type":"input","q":"Receivables b/d 12,000; credit sales 90,000; cash received 85,000; irrecoverable debts 1,500. Closing receivables = ?  (number)","accept":["15500"],"display_answer":"15,500","ex":"12,000 + 90,000 - 85,000 - 1,500 = 15,500."},
					{"type":"input","q":"Payables b/d 8,000; credit purchases 50,000; payments 46,000; discounts received 1,000. Closing payables = ?  (number)","accept":["11000"],"display_answer":"11,000","ex":"8,000 + 50,000 - 46,000 - 1,000 = 11,000."},
					{"type":"choice","q":"A contra between a customer who is also a supplier is entered as:","opts":["Dr Payables control, Cr Receivables control","Dr Receivables control, Cr Payables control","Dr Cash, Cr Receivables","Dr Suspense, Cr Payables"],"a":0,"ex":"The contra reduces both balances: debit payables, credit receivables."},
					{"type":"choice","q":"A discount received from a supplier for paying early is:","opts":["Dr Payables, Cr Discounts received (income)","Dr Discounts received, Cr Payables","Dr Cash, Cr Payables","Dr Purchases, Cr Payables"],"a":0,"ex":"The amount owed falls and the discount is income in profit or loss."}
				],
				# Ch 14 learning objectives: E2(a)-(e), D1(b), D1(e), D1(f), D8(j), D8(k).
				# Exam: returns, contras, discounts; reconciling supplier statements. Discount treatment per ACCA's 'Discounts' technical article (IFRS 15).
				"lessons": [
					{
						"id": "L1", "title": "Control accounts and the personal ledgers",
						"outcome": "E2(a) Purpose of the payables ledger account; D8(a) Receivables and payables in the ledger",
						"apply": {"title": "Zuru's Lemonade Stand - one total, many customers", "pages": [
							{"text": "Zuru now has a dozen credit customers and four suppliers. The general ledger keeps [b]one[/b] receivables account and [b]one[/b] payables account - the [b]control accounts[/b], posted in totals from the day books. Beside them, the [b]memorandum ledgers[/b] keep a page per customer and per supplier, posted invoice by invoice.\n\nThe two should always agree: the control account total = the sum of the individual balances."},
							{"text": "", "table": {"cols": ["Receivables control - Dr", "", "Cr", ""], "rows": [{"c": ["Balance b/d", "640", "Cash received", "1,180"]}, {"c": ["Credit sales (SDB)", "1,450", "Sales returns (SRDB)", "24"]}, {"c": ["", "", "Irrecoverable debt written off", "10"]}, {"c": ["", "", "Balance c/d", "876"]}, {"c": ["", "2,090", "", "2,090"], "b": true}]}},
							{"text": "The 876 should equal cafe 480 + dojo 120 + gym 150 + the rest from the receivables ledger. If it doesn't, something was posted to one and not the other - a casting error in the day book, an invoice keyed to the wrong customer, a credit note missed. The [b]payables control account[/b] does the same job for Kenji and the other suppliers, with purchases on the credit side and payments and purchase returns on the debit side. Control accounts are the first thing an auditor - or Hana - checks."}
						]},
						"learn": [
							{"text": "In the [b]general ledger[/b] there is ONE account for all credit customers - [b]trade receivables[/b] (the receivables control account) - and ONE for all credit suppliers - [b]trade payables[/b] (the payables control account). They hold the TOTALS and are part of the double entry."},
							{"text": "Outside the general ledger, the [b]receivables ledger[/b] and [b]payables ledger[/b] keep a separate account for EACH customer and supplier, so the business knows who owes what. These are memorandum records - [b]not[/b] part of the double entry."},
							{"text": "The total of all the individual balances should equal the control account. Comparing them (a [b]control account reconciliation[/b]) finds errors, and gives a quick total for the trial balance."},
							{"text": "What goes through the payables control account:\nDebits: payments to suppliers, purchase returns, discounts received, contras\nCredits: credit purchases (gross, incl. sales tax)\nClosing CREDIT balance = owed to suppliers."}
						],
						"example": {"title": "Payables control account", "table": {"cols": ["Payables control", "Dr $", "Cr $"], "rows": [
							{"c": ["Balance b/d", "", "8,000"], "s": 1}, {"c": ["Credit purchases", "", "50,000"], "s": 1},
							{"c": ["Paid to suppliers", "46,000", ""], "s": 2}, {"c": ["Purchase returns", "1,200", ""], "s": 2}, {"c": ["Discounts received", "800", ""], "s": 2},
							{"c": ["Balance c/d (balancing figure)", "10,000", ""], "s": 3, "b": true},
							{"c": ["Totals", "58,000", "58,000"], "s": 3}]},
							"steps": ["What we owe goes up with the opening balance and new credit purchases.", "It comes down with payments, returns and discounts received.", "The balancing figure, 10,000, is owed to suppliers at the year-end - and should equal the total of the payables ledger."]},
						"practice": [
							{"type": "input", "q": "Receivables control: balance b/d 12,000; credit sales 90,000; cash received 85,000; sales returns 2,500; irrecoverable debts 1,500. Closing balance = ?  (number)", "accept": ["13000"], "display_answer": "13,000", "ex": "12,000 + 90,000 - 85,000 - 2,500 - 1,500 = 13,000."},
							{"type": "choice", "q": "The individual supplier accounts in the payables ledger are:", "opts": ["Memorandum records outside the double entry", "Part of the general ledger double entry", "Shown separately in the trial balance", "Only used for cash purchases"], "a": 0, "ex": "The payables control account is in the double entry; the individual accounts are memorandum records."},
							{"type": "multi", "q": "Which TWO items are DEBITED to the payables control account?", "opts": ["Payments to suppliers", "Discounts received", "Credit purchases", "Cash sales"], "a": [0, 1], "ex": "Payments and discounts received reduce what we owe (debit). Credit purchases are credited."}
						]
					},
					{
						"id": "L2", "title": "Returns, refunds, overpayments and contras",
						"outcome": "D1(b) Sales and purchase returns; D8(j) Contras between receivables and payables",
						"apply": {"title": "Zuru's Lemonade Stand - the messy month", "pages": [
							{"text": "One December, four untidy things happen to the cafe's account:\n1. Two cases of bottles arrive cracked - Zuru issues a [b]credit note for 24[/b].\n2. The cafe pays an invoice [b]twice[/b], overpaying by 30.\n3. Kenji, the lemon supplier, also BUYS lemonade from Zuru for his shop - so he is a customer AND a supplier.\n4. The cafe asks for the 30 back in cash."},
							{"text": "", "table": {"cols": ["", "Dr", "Cr"], "rows": [{"c": ["1. Sales returns / Receivables (cafe)", "24", "24"]}, {"c": ["2. Cash / Receivables - the overpayment leaves the cafe with a CREDIT balance of 30", "", ""]}, {"c": ["3. Contra: Payables (Kenji) / Receivables (Kenji) - settle 20 he owes against 80 she owes", "20", "20"]}, {"c": ["4. Refund: Receivables (cafe) / Cash", "30", "30"]}]}},
							{"text": "A customer with a [b]credit balance[/b] is odd but real: it means Zuru owes THEM. Strictly it should be shown as a payable, not netted off receivables. The [b]contra[/b] with Kenji needs an entry in both control accounts (and both personal ledgers) - it reduces what she owes him to 60 and what he owes her to nil. Purchase returns work like sales returns in reverse: Dr Payables, Cr Purchase returns when she sends back a mouldy crate."}
						]},
						"learn": [
							{"text": "A return [b]cancels[/b] part of the original sale or purchase, recorded with a credit note:\nSales return: [b]Dr Sales returns, Cr Receivables[/b]\nPurchase return: [b]Dr Payables, Cr Purchase returns[/b]"},
							{"text": "If the goods were [b]already paid for[/b], the return leaves the account the 'wrong' way round: a customer's account shows a CREDIT (we owe them) and a supplier's shows a DEBIT (they owe us). The same happens if someone [b]overpays[/b]."},
							{"text": "A [b]refund[/b] clears it: refunding a customer is Dr Receivables, Cr Bank - the balance goes back to zero."},
							{"text": "A [b]contra[/b]: when a business both sells to AND buys from the same company, the two balances can be set off and only the net amount paid. The entry is always [b]Dr Payables, Cr Receivables[/b], for the SMALLER of the two balances - it reduces both."}
						],
						"example": {"title": "Contra with Riverside Ltd", "table": {"cols": ["", "$"], "rows": [
							{"c": ["Riverside owes us (receivable)", "3,000"], "s": 1}, {"c": ["We owe Riverside (payable)", "1,800"], "s": 1},
							{"c": ["Contra: Dr Payables 1,800, Cr Receivables 1,800", "1,800"], "s": 2, "b": true},
							{"c": ["Riverside still owes us", "1,200"], "s": 3}, {"c": ["We owe Riverside", "0"], "s": 3}]},
							"steps": ["Riverside is both a customer and a supplier.", "Set off the smaller balance: debit payables, credit receivables, 1,800.", "Riverside now pays us just the net 1,200."]},
						"practice": [
							{"type": "input", "q": "A company owes a supplier 2,600 and the same company owes it 4,100. After a contra, how much is still owed TO the business?  (number)", "accept": ["1500"], "display_answer": "1,500", "ex": "Contra the smaller amount, 2,600: 4,100 - 2,600 = 1,500 still receivable."},
							{"type": "picklist", "q": "A contra between receivables and payables is recorded: Debit {0}, Credit {1}.", "lists": [["Payables", "Receivables", "Bank"], ["Receivables", "Payables", "Bank"]], "a": [0, 0], "ex": "It reduces both balances: debit payables, credit receivables."},
							{"type": "choice", "q": "A customer returns goods they have ALREADY paid for. Their account in the receivables ledger will now show:", "opts": ["A credit balance - the business owes them", "A debit balance - they owe more", "A zero balance", "A balance in the payables ledger"], "a": 0, "ex": "The credit note leaves a credit balance until the customer is refunded or buys more."}
						]
					},
					{
						"id": "L3", "title": "Trade and settlement discounts",
						"outcome": "D1(e) Discounts received; D1(f) Trade and settlement discounts allowed (IFRS 15)",
						"apply": {"title": "Zuru's Lemonade Stand - two kinds of discount", "pages": [
							{"text": "The cafe orders 500 bottles. List price 2 each = 1,000, but Zuru gives a [b]10% trade discount[/b] for bulk, and offers a further [b]2% settlement discount[/b] if the invoice is paid within 7 days.\n\n[b]Trade discount[/b] is simple: it is never recorded. The sale is 900, full stop.\n\n[b]Settlement discount[/b] depends on what Zuru EXPECTS the cafe to do (IFRS 15)."},
							{"text": "", "table": {"cols": ["Case", "Invoice recorded", "Then"], "rows": [{"c": ["Cafe usually pays early - discount expected", "Sales 882 (900 less 2%)", "If they pay late after all: extra 18 of revenue when the 900 arrives"]}, {"c": ["Cafe usually pays late - discount NOT expected", "Sales 900", "If they pay early after all: revenue reduced by 18 when the 882 arrives"]}]}},
							{"text": "From the other side, when Zuru pays Kenji early and takes HIS 2% settlement discount, the 6 she saves is [b]discount received[/b] - income, Cr Discounts received, with Dr Payables for the full invoice and Cr Cash for the smaller amount. Trade discounts from Kenji, like hers, simply never appear: his invoice is already net."}
						]},
						"learn": [
							{"text": "[b]Trade discount[/b] - a reduction in list price given at the time of sale (e.g. to a regular or bulk buyer). It is always taken up, so the sale or purchase is simply recorded at the price AFTER the discount. It never appears separately."},
							{"text": "[b]Settlement (early payment) discount[/b] - offered to encourage paying quickly. Not every customer takes it, so it's uncertain at the time of sale."},
							{"text": "[b]Discounts RECEIVED[/b] (from our suppliers) are recorded when we take them: [b]Dr Payables, Cr Discounts received[/b] (income in the SOPL)."},
							{"text": "[b]Discounts ALLOWED[/b] to customers (IFRS 15): at the time of sale, judge whether the customer is expected to take it.\n[b]Expected to take it[/b]: record revenue NET of the discount.\n[b]Not expected[/b]: record revenue at the full price.\nIf it turns out differently, [b]adjust revenue[/b] when the customer pays."}
						],
						"example": {"title": "3% discount for payment within 14 days", "table": {"cols": ["", "Expected to take it (2,000 sale)", "Not expected (8,000 sale)"], "rows": [
							{"c": ["At sale: Dr Receivables, Cr Revenue", "1,940", "8,000"], "s": 1},
							{"c": ["Pays as expected: Dr Cash, Cr Receivables", "1,940", "8,000"], "s": 2},
							{"c": ["Expectation WRONG - extra revenue / revenue reduced", "Pays 2,000 late: Cr Revenue 60", "Pays 7,760 early: Dr Revenue 240"], "s": 3}]},
							"steps": ["If the customer is expected to take the 3%, revenue is 2,000 - 60 = 1,940. If not, the full 8,000.", "When they pay as expected, receivables clear.", "If they don't: the late payer pays the full 2,000, so 60 more revenue; the early payer takes 240 off, so revenue is reduced by 240."]},
						"practice": [
							{"type": "input", "q": "Goods with a list price of 5,000 are sold with a 10% trade discount. What revenue is recorded?  (number)", "accept": ["4500"], "display_answer": "4,500", "ex": "Trade discount is always taken: 5,000 x 90% = 4,500."},
							{"type": "input", "q": "A sale of 3,000 offers a 2% settlement discount, and the customer is expected to take it. What revenue is recorded at the time of sale?  (number)", "accept": ["2940"], "display_answer": "2,940", "ex": "Expected to take it, so revenue is net: 3,000 x 98% = 2,940."},
							{"type": "picklist", "q": "A customer NOT expected to take a 5% discount on a 4,000 sale pays early and takes it. On payment: Debit Cash 3,800, Debit {0} 200, Credit {1} 4,000.", "lists": [["Revenue", "Discounts received", "Receivables"], ["Receivables", "Revenue", "Bank"]], "a": [0, 0], "ex": "Revenue was recorded at 4,000; the 200 discount taken reduces revenue and the receivable is cleared."},
							{"type": "picklist", "q": "We pay a supplier early and take a 150 discount: Debit {0} 150, Credit {1} 150.", "lists": [["Payables", "Discounts received", "Purchases"], ["Discounts received", "Payables", "Bank"]], "a": [0, 0], "ex": "What we owe falls by 150, and discounts received is income."}
						]
					},
					{
						"id": "L4", "title": "Supplier statement reconciliations",
						"outcome": "E2(b) Why payables are reconciled; E2(c) Reconcile to supplier statements; E2(d) Errors found; E2(e) Payables balance to report; D8(k) Supplier statements",
						"apply": {"title": "Zuru's Lemonade Stand - Kenji's statement", "pages": [
							{"text": "At the month-end Kenji sends a [b]supplier statement[/b] saying Zuru owes him [b]230[/b]. Her payables ledger says [b]150[/b]. Before she pays anything, she reconciles the two - the statement is Kenji's record of the same relationship, so differences mean one side has something the other hasn't.\n\nShe finds:\n- Kenji's invoice for 60, dated the 30th, arrived after she closed the books (timing).\n- Her payment of 20 on the 31st isn't on his statement yet (timing).\n- A credit note for the mouldy crate, 10, is on his statement but she forgot to post it (her error).\n- Kenji has charged 30 for a crate that was delivered to someone else (his error)."},
							{"text": "", "table": {"cols": ["Reconciliation", ""], "rows": [{"c": ["Balance per Zuru's ledger", "150"]}, {"c": ["Add: invoice not yet recorded", "60"]}, {"c": ["Less: credit note not yet recorded", "(10)"]}, {"c": ["Corrected ledger balance", "200"], "b": true}, {"c": ["Balance per Kenji's statement", "230"]}, {"c": ["Less: payment in transit", "(20)"]}, {"c": ["Less: Kenji's error (wrong delivery)", "(30)"]}, {"c": ["Adjusted statement balance", "180"], "b": true}]}},
							{"text": "The two still differ by 20 - and that is correct: it is the payment in transit, which will appear on next month's statement. Zuru posts the invoice and the credit note (her side), asks Kenji to remove the 30 (his side), and reports payables to Kenji of [b]200[/b] in her accounts. The exam gives you a list like this and asks for the corrected ledger balance - only Zuru's own errors and omissions change HER figure; Kenji's errors and timing differences don't."}
						]},
						"learn": [
							{"text": "Each month a supplier sends a [b]supplier statement[/b] listing what THEY think we owe. Comparing it with our [b]payables ledger[/b] account for that supplier checks our records against an independent document - and stops us paying the wrong amount."},
							{"text": "The balances often differ. Sort each difference into:\n[b]Timing differences[/b] - e.g. a payment we sent that hasn't reached them yet, goods returned that they haven't processed. Adjust the STATEMENT side.\n[b]Errors or omissions in OUR records[/b] - e.g. an invoice we forgot to post. Correct OUR LEDGER."},
							{"text": "After adjustments both sides should agree. The supplier statement and the payables ledger are not part of the double entry - but any correction to our ledger also needs correcting in the payables control account.\nThe amount reported in the financial statements is the [b]corrected ledger balance[/b]."}
						],
						"example": {"title": "Reconciling with Bloom Supplies", "table": {"cols": ["", "$"], "rows": [
							{"c": ["Our payables ledger balance", "4,320"], "s": 1}, {"c": ["Add: invoice we forgot to post (our error)", "600"], "s": 2}, {"c": ["Corrected ledger balance", "4,920"], "s": 2, "b": true},
							{"c": ["Supplier statement balance", "5,870"], "s": 3}, {"c": ["Less: payment sent 30 Dec, not yet on their statement", "(950)"], "s": 3}, {"c": ["Adjusted statement balance", "4,920"], "s": 3, "b": true}]},
							"steps": ["Start with what our ledger says we owe.", "We missed an invoice - that's OUR error, so correct the ledger.", "The payment in transit is just timing - adjust the statement. Both now agree at 4,920, the figure to report."]},
						"practice": [
							{"type": "sort", "q": "Should each difference be corrected in our ledger, or is it a timing difference on the supplier's statement?", "buckets": ["Correct our ledger", "Timing - adjust statement"], "items": [["An invoice we forgot to record", 0], ["A payment we sent that the supplier hasn't received yet", 1], ["An invoice posted to the wrong supplier's account", 0], ["Goods we returned that the supplier hasn't credited yet", 1]], "ex": "Our own mistakes are corrected in the ledger; items in transit are timing differences."},
							{"type": "input", "q": "Our ledger shows 7,400 owed to a supplier. Their statement shows 9,150. A payment of 1,750 was sent on 31 December and is not on the statement. No other differences. What is the adjusted statement balance?  (number)", "accept": ["7400"], "display_answer": "7,400", "ex": "9,150 - 1,750 in transit = 7,400, agreeing with our ledger."},
							{"type": "choice", "q": "Which balance is reported as payables in the financial statements?", "opts": ["Our corrected payables ledger / control account balance", "The supplier statement balance", "The average of the two", "The balance before reconciliation"], "a": 0, "ex": "The corrected ledger balance is reported."}
						]
					}
				]
			},
			{
				"id": 15, "title": "Bank reconciliations", "monster": "The Statement Serpent",
				"beats": [
					{"type":"story","speaker":"Sensei Otter","text":"The [b]Statement Serpent[/b] coils between your cash book and the bank. Agree the two and it cannot hide a slithering error."},
					{"type":"story","speaker":"Sensei Otter","text":"Step 1 - [b]correct the cash book[/b] for bank charges, interest, standing orders, direct debits, dishonoured cheques and errors. Step 2 - reconcile the bank statement using [b]timing differences[/b]: unpresented cheques and outstanding lodgements. The corrected cash book goes to the SOFP."},
					{"type":"story","speaker":"Sensei Otter","text":"Reconciliation proforma:\nBalance per bank statement 3,900\n[b]add[/b] outstanding lodgements 900\n[b]less[/b] unpresented cheques (600)\n= Balance per corrected cash book [b]4,200[/b]."},
					{"type":"choice","q":"Bank charges not yet recorded should be:","opts":["Adjusted in the cash book","Left as a timing difference","Added to the bank statement","Ignored"],"a":0,"ex":"Bank charges are something the business had not recorded - correct the cash book."},
					{"type":"choice","q":"An unpresented cheque is:","opts":["A cash book adjustment","A timing difference between corrected cash book and bank statement","An error","A direct debit"],"a":1,"ex":"A cheque written but not yet cleared is a timing difference."},
					{"type":"input","q":"The cash book shows 2,000 (debit). Bank charges of 150 (not recorded). Corrected balance = ?  (number)","accept":["1850"],"display_answer":"1,850","ex":"2,000 - 150 = 1,850 corrected cash book."},
					{"type":"input","q":"Corrected cash book 5,000 (Dr); unpresented cheques 800; outstanding lodgements 500. Bank statement balance = ?  (number)","accept":["5300"],"display_answer":"5,300","ex":"5,000 + unpresented 800 - lodgements 500 = 5,300."},
					{"type":"choice","q":"The balance that goes into the SOFP is:","opts":["The bank statement balance","The corrected cash book balance","The original cash book balance","The overdraft limit"],"a":1,"ex":"The corrected cash book balance is reported in the SOFP."},
					{"type":"choice","q":"In the business own books, a bank overdraft is a:","opts":["Debit balance (asset)","Credit balance (liability)","Suspense balance","Not recorded"],"a":1,"ex":"An overdraft is money owed to the bank - a credit balance."},
					{"type":"choice","q":"A dishonoured (bounced) customer cheque should be:","opts":["Added to the cash book","Credited (removed) in the cash book","Treated as a timing difference","Ignored"],"a":1,"ex":"The cash was never really received, so credit (reduce) the cash book."},
					{"type":"input","q":"The bank statement shows an OVERDRAFT of 1,200. Outstanding lodgements 2,000; unpresented cheques 700. Corrected cash book balance (debit) = ?  (number)","accept":["100"],"display_answer":"100 debit","ex":"-1,200 + 2,000 - 700 = +100, a debit (positive) balance in the cash book."},
					{"type":"choice","q":"A standing order paid by the bank but not yet in the cash book should be:","opts":["Credited in the cash book","Debited in the cash book","Shown as a timing difference","Ignored"],"a":0,"ex":"Money has left the account, so credit (reduce) the cash book."},
					{"type":"choice","q":"Bank interest RECEIVED, shown only on the bank statement, should be:","opts":["Debited in the cash book","Credited in the cash book","Shown as a timing difference","Ignored"],"a":0,"ex":"Money has come in, so debit (increase) the cash book."},
					{"type":"choice","q":"An outstanding lodgement is:","opts":["Money banked and in the cash book but not yet on the bank statement","A cheque written but not yet cleared","A bank charge","A dishonoured cheque"],"a":0,"ex":"Deposits recorded in the cash book that the bank has not yet processed - a timing difference."}
				],
				# Ch 15 learning objectives: E1(a)-(f). Exam: adjust in the ledger (cash book) or in the reconciliation? Derive the bank statement or ledger balance.
				"lessons": [
					{
						"id": "L1", "title": "Why the bank and the cash book differ",
						"outcome": "E1(a) Purpose of bank reconciliations; E1(b) Reasons for differences",
						"apply": {"title": "Zuru's Lemonade Stand - the bank says something else", "pages": [
							{"text": "31 December. Zuru's cash book says the bank balance is [b]1,240[/b]. The bank statement says [b]1,141[/b]. Neither is lying - they are two records of the same account kept by two different people, and each knows things the other doesn't yet.\n\nShe lists why they differ:"},
							{"text": "", "table": {"cols": ["Difference", "Who knows", "Type"], "rows": [{"c": ["Cheque to Kenji for 80, written 30 Dec, not yet cashed", "Cash book only", "Unpresented cheque (timing)"]}, {"c": ["Cafe's 150 paid in on 31 Dec, not yet on the statement", "Cash book only", "Outstanding lodgement (timing)"]}, {"c": ["Bank charges 12", "Bank only", "Cash book needs updating"]}, {"c": ["Insurance direct debit 20", "Bank only", "Cash book needs updating"]}, {"c": ["Interest received 3", "Bank only", "Cash book needs updating"]}]}},
							{"text": "The [b]bank reconciliation[/b] proves the two can be matched - and in doing so catches the bank's errors, Zuru's own errors (a receipt keyed as 540 instead of 450), and anything the bank did that she hasn't recorded (charges, direct debits, interest, a bounced cheque). Timing differences will sort themselves out next month; the rest need action. Next lesson: fix the cash book first, then reconcile what's left."}
						]},
						"learn": [
							{"text": "The business keeps its own record of the bank - the [b]cash book[/b] (bank ledger account). The bank sends its own record - the [b]bank statement[/b]. At any date they rarely agree. A [b]bank reconciliation[/b] explains every difference, checks both records, and finds the correct balance to report."},
							{"text": "Watch the sides: in OUR cash book, money in the bank is a [b]debit[/b] (an asset). On the BANK's statement, money in our account is a [b]credit[/b] - to the bank it's a liability (they owe it to us). An overdraft is a debit on the bank statement."},
							{"text": "Differences fall into three groups:\n[b]1. Timing differences[/b] - recorded by us, not yet by the bank:\n- [b]unpresented cheques[/b]: cheques we've paid out that haven't cleared\n- [b]outstanding lodgements[/b]: money we've paid in that the bank hasn't credited yet"},
							{"text": "[b]2. Items on the statement we haven't recorded[/b] - bank charges, interest, standing orders, direct debits, direct credits (BACS receipts), dishonoured (bounced) cheques.\n[b]3. Errors[/b] in the cash book - omissions, transposed figures (e.g. 540 written as 450), adding-up (casting) errors."},
							{"text": "The rule:\nGroups 2 and 3 -> [b]correct the cash book[/b] (we were wrong or incomplete).\nGroup 1 -> goes in the [b]reconciliation statement[/b] (nobody is wrong - the bank just hasn't caught up)."}
						],
						"practice": [
							{"type": "sort", "q": "Adjust the cash book, or show it in the reconciliation?", "buckets": ["Adjust cash book", "Reconciliation (timing)"], "items": [["Bank charges not yet recorded", 0], ["Cheque paid to a supplier, not yet cleared", 1], ["Standing order paid by the bank", 0], ["Takings banked on the last day of the year", 1], ["A customer's cheque was dishonoured", 0], ["A customer paid us by direct credit", 0]], "ex": "Items only the bank knew about, and our own errors, correct the cash book. Unpresented cheques and outstanding lodgements are timing differences."},
							{"type": "choice", "q": "A CREDIT balance on a bank statement means:", "opts": ["The business has money in the bank", "The business is overdrawn", "There is an error", "The cash book must be credited"], "a": 0, "ex": "From the bank's view, money it holds for us is owed to us - a credit."},
							{"type": "choice", "q": "The MAIN purpose of a bank reconciliation is to:", "opts": ["Explain the differences between the cash book and the bank statement", "Calculate the bank charges", "Record cash sales", "Replace the cash book"], "a": 0, "ex": "It explains every difference and confirms the correct bank balance."}
						]
					},
					{
						"id": "L2", "title": "Correcting the cash book, then reconciling",
						"outcome": "E1(c) Correct errors and omissions in the cash book; E1(d) Prepare the reconciliation",
						"apply": {"title": "Zuru's Lemonade Stand - two steps, always in this order", "pages": [
							{"text": "[b]Step 1 - update the cash book[/b] with everything the bank knew and Zuru didn't. These are real transactions, so they change her books.", "table": {"cols": ["Cash book", "Dr", "Cr"], "rows": [{"c": ["Balance b/d", "1,240", ""]}, {"c": ["Interest received", "3", ""]}, {"c": ["Bank charges", "", "12"]}, {"c": ["Insurance direct debit", "", "20"]}, {"c": ["Corrected balance c/d", "", "1,211"]}, {"c": ["", "1,243", "1,243"], "b": true}]}},
							{"text": "[b]Step 2 - reconcile[/b] the bank statement to the corrected cash book using only the [b]timing[/b] differences. Nothing is posted here; it is a proof.", "table": {"cols": ["Bank reconciliation at 31 December", ""], "rows": [{"c": ["Balance per bank statement", "1,141"]}, {"c": ["Add: outstanding lodgement (cafe)", "150"]}, {"c": ["Less: unpresented cheque (Kenji)", "(80)"]}, {"c": ["Balance per corrected cash book", "1,211"], "b": true}]}},
							{"text": "It agrees, so the [b]1,211[/b] is the cash figure for the SOFP - never the bank statement's 1,141, and never the uncorrected 1,240. Exam tip: a lodgement not yet credited is ADDED to the statement balance; a cheque not yet presented is DEDUCTED. If you start from the cash book instead, the signs flip."}
						]},
						"learn": [
							{"text": "[b]Step 1 - correct the cash book.[/b] Start with the cash book balance and add or subtract every item from groups 2 and 3:\nAdd: direct credits, interest received, errors that understated receipts.\nSubtract: bank charges, standing orders, direct debits, dishonoured cheques, errors that understated payments."},
							{"text": "[b]Step 2 - the reconciliation statement[/b], from the bank statement:\n[b]Balance per bank statement[/b]\n+ outstanding lodgements (the bank will add them soon)\n- unpresented cheques (the bank will take them off soon)\n[b]= Balance per corrected cash book[/b]"},
							{"text": "If the two agree, both records are explained. A transposition error tip: if the difference divides exactly by 9 (e.g. 540 vs 450 = 90), two digits may have been swapped."}
						],
						"example": {"title": "Ana's Shoes at 31 December", "table": {"cols": ["", "$"], "rows": [
							{"c": ["Cash book balance (debit)", "3,450"], "s": 1},
							{"c": ["Less: bank charges", "(85)"], "s": 1}, {"c": ["Less: standing order not recorded", "(400)"], "s": 1}, {"c": ["Add: direct credit from a customer", "1,200"], "s": 1}, {"c": ["Less: dishonoured cheque", "(300)"], "s": 1},
							{"c": ["Corrected cash book", "3,865"], "s": 2, "b": true},
							{"c": ["Balance per bank statement (credit)", "3,405"], "s": 3}, {"c": ["Add: outstanding lodgements", "2,100"], "s": 3}, {"c": ["Less: unpresented cheques", "(1,640)"], "s": 3},
							{"c": ["Balance per corrected cash book", "3,865"], "s": 4, "b": true}]},
							"steps": ["Step 1: bring the cash book up to date with items only the bank knew about.", "The corrected cash book is 3,865 - this is the figure for the SOFP.", "Step 2: start from the bank statement and adjust for timing differences.", "3,405 + 2,100 - 1,640 = 3,865. It agrees - the reconciliation is complete."]},
						"practice": [
							{"type": "input", "q": "Cash book balance 1,920 (debit). Not yet recorded: bank interest charged 45, a direct debit of 310 and a customer's BACS receipt of 600. Corrected cash book balance = ?  (number)", "accept": ["2165"], "display_answer": "2,165", "ex": "1,920 - 45 - 310 + 600 = 2,165."},
							{"type": "input", "q": "Corrected cash book 2,165 (debit). Unpresented cheques 870; outstanding lodgements 1,100. What balance does the bank statement show?  (number)", "accept": ["1935"], "display_answer": "1,935", "ex": "Bank statement = 2,165 + 870 unpresented - 1,100 not yet credited = 1,935."},
							{"type": "choice", "q": "A cheque payment of 540 was entered in the cash book as 450. The cash book must be:", "opts": ["Reduced by 90", "Increased by 90", "Reduced by 540", "Left alone - it is a timing difference"], "a": 0, "ex": "Only 450 was taken off instead of 540, so the cash book is 90 too high - reduce it by 90."},
							{"type": "picklist", "q": "In the reconciliation, starting from the bank statement balance: {0} outstanding lodgements and {1} unpresented cheques.", "lists": [["add", "subtract"], ["subtract", "add"]], "a": [0, 0], "ex": "The bank hasn't yet added our lodgements or taken off our cheques - so we do it to reach the cash book figure."}
						]
					},
					{
						"id": "L3", "title": "Deriving balances and overdrafts",
						"outcome": "E1(e) Derive bank statement and cash book balances; E1(f) Bank balance to report",
						"apply": {"title": "Zuru's Lemonade Stand - the January overdraft", "pages": [
							{"text": "January is quiet and the new heater was paid for. The bank statement shows an [b]overdraft of 120[/b] at 31 January. Zuru knows that a cheque for [b]50[/b] to the gas company is unpresented and that [b]200[/b] from the cafe was paid in on the 31st but isn't on the statement yet. What does her cash book say?\n\nWork backwards from the statement: an overdraft is a negative balance."},
							{"text": "", "table": {"cols": ["", ""], "rows": [{"c": ["Balance per bank statement (overdrawn)", "(120)"]}, {"c": ["Add: outstanding lodgement", "200"]}, {"c": ["Less: unpresented cheque", "(50)"]}, {"c": ["Balance per cash book", "30"], "b": true}]}},
							{"text": "The cash book shows [b]30 in hand[/b] - so the SOFP shows cash of 30, a current asset, even though the bank's screen says overdrawn. Had the answer come out negative, the SOFP would show a [b]bank overdraft[/b] under current liabilities (and the cash book would have a credit balance). The reportable figure is always the corrected cash book, because it includes every transaction Zuru has actually made."}
						]},
						"learn": [
							{"text": "Exam questions often give you one balance and the timing differences, and ask for the other. Use the reconciliation in either direction:\n[b]Cash book = Bank statement + lodgements - unpresented cheques[/b]\n[b]Bank statement = Cash book - lodgements + unpresented cheques[/b]"},
							{"text": "With an [b]overdraft[/b], treat the balance as a negative number. E.g. a statement overdraft of 2,500 is -2,500. Work through, and if the answer is negative the business is overdrawn in its own books too (a credit balance in the cash book)."},
							{"text": "The figure reported in the statement of financial position is ALWAYS the [b]corrected cash book balance[/b] - a current asset if positive, a [b]current liability[/b] if overdrawn."}
						],
						"example": {"title": "Overdrawn at the year-end", "table": {"cols": ["", "$"], "rows": [
							{"c": ["Bank statement: overdrawn", "(2,500)"], "s": 1},
							{"c": ["Add: outstanding lodgements", "1,300"], "s": 2}, {"c": ["Less: unpresented cheques", "(900)"], "s": 2},
							{"c": ["Corrected cash book: overdrawn", "(2,100)"], "s": 3, "b": true}]},
							"steps": ["The statement shows an overdraft, so start at -2,500.", "Lodgements will reduce the overdraft; unpresented cheques will increase it.", "Cash book = -2,100: overdrawn by 2,100, shown as a current liability."]},
						"practice": [
							{"type": "input", "q": "The bank statement shows an overdraft of 1,200. Outstanding lodgements 2,000; unpresented cheques 700. What is the corrected cash book balance? (Enter a positive number for money in the bank.)  (number)", "accept": ["100"], "display_answer": "100 (debit)", "ex": "-1,200 + 2,000 - 700 = +100: money in the bank in the cash book."},
							{"type": "input", "q": "The bank statement shows an overdraft of 3,000. Unpresented cheques 1,500; outstanding lodgements 800. By how much is the business overdrawn in its corrected cash book?  (number)", "accept": ["3700"], "display_answer": "3,700", "ex": "-3,000 + 800 - 1,500 = -3,700: overdrawn by 3,700."},
							{"type": "choice", "q": "Which bank balance is reported in the statement of financial position?", "opts": ["The corrected cash book balance", "The bank statement balance", "The original cash book balance", "The overdraft limit"], "a": 0, "ex": "The corrected cash book balance is reported."},
							{"type": "choice", "q": "A corrected cash book shows a credit balance of 2,100. In the SOFP this is:", "opts": ["A current liability (bank overdraft)", "A current asset", "A non-current liability", "Ignored"], "a": 0, "ex": "A credit balance in the cash book means overdrawn - a current liability."}
						]
					}
				]
			},
			{
				"id": 16, "title": "Correction of errors", "monster": "The Suspense Spectre",
				"beats": [
					{"type":"story","speaker":"Sensei Otter","text":"The [b]Suspense Spectre[/b] holds the gap when your books refuse to balance. Find the error and it fades to nothing."},
					{"type":"story","speaker":"Sensei Otter","text":"Errors that keep the TB balanced: [b]Omission, Commission, Principle, Compensating, Original entry, Reversal[/b]. Errors that break it go through a [b]suspense account[/b], cleared before the statements."},
					{"type":"taccount","speaker":"Sensei Otter","text":"Rent of 90 was paid but debited as only 9 - the debits are 81 short, so suspense holds the gap until the journal clears it:","name":"Suspense account","dr":["Trial balance difference 81"],"cr":["Rent expense (correction) 81"],"dr_total":"81","cr_total":"81"},
					{"type":"choice","q":"An error of principle is:","opts":["Right side, wrong TYPE of account","A missing transaction","A one-sided entry","Two errors cancelling out"],"a":0,"ex":"An error of principle posts to the wrong type of account; the TB still balances."},
					{"type":"choice","q":"A suspense account is needed when:","opts":["The TB does not balance","There are no errors","Preparing a bank reconciliation","The TB balances"],"a":0,"ex":"A suspense account temporarily holds the difference when debits do not equal credits."},
					{"type":"input","q":"Rent was debited to the rent account as 560 instead of 650. The amount held in suspense = ?  (number)","accept":["90"],"display_answer":"90","ex":"650 - 560 = 90 short, so 90 sits in suspense."},
					{"type":"choice","q":"Which error would make the trial balance disagree?","opts":["An error of commission","A one-sided entry","An error of principle","Compensating errors"],"a":1,"ex":"A one-sided entry makes debits not equal credits."},
					{"type":"choice","q":"A sale of 250 was completely left out of the books. This is an error of:","opts":["Omission","Commission","Principle","Original entry"],"a":0,"ex":"A transaction left out entirely is an error of omission."},
					{"type":"choice","q":"Recording the purchase of a van (an asset) as motor expenses is an error of:","opts":["Principle","Omission","Commission","Original entry"],"a":0,"ex":"Wrong TYPE of account (asset vs expense) is an error of principle."},
					{"type":"choice","q":"A suspense account must be:","opts":["Carried forward indefinitely","Cleared before the financial statements","Shown as revenue","Added to capital"],"a":1,"ex":"The suspense balance is temporary and must be cleared via correcting journals."},
					{"type":"choice","q":"Posting a payment to the wrong supplier's account is an error of:","opts":["Commission","Principle","Omission","Reversal"],"a":0,"ex":"Right type of account, wrong account - an error of commission. The TB still balances."},
					{"type":"choice","q":"A cash sale of 500 was recorded as Dr Sales 500, Cr Cash 500. This is an error of:","opts":["Reversal","Original entry","Omission","Principle"],"a":0,"ex":"Correct accounts and amount, but debit and credit swapped - an error of reversal."},
					{"type":"input","q":"A credit purchase of 1,000 was posted Dr Purchases 1,000 and Dr Payables 1,000. The balance on suspense = ?  (number)","accept":["2000"],"display_answer":"2,000 (credit)","ex":"Debits are 2,000 more than credits, so suspense holds a 2,000 credit until corrected."},
					{"type":"choice","q":"A credit sale of 250 was omitted entirely. The correcting journal is:","opts":["Dr Receivables 250, Cr Sales 250","Dr Suspense 250, Cr Sales 250","Dr Sales 250, Cr Receivables 250","Dr Receivables 250, Cr Suspense 250"],"a":0,"ex":"An omission does not affect the TB balance, so no suspense - just post the missing entry."}
				],
				# Ch 16 learning objectives: C2(d), F2(a)-(d), F3(a)-(d). Exam: which errors explain a difference; correcting journals; effect on profit.
				"lessons": [
					{
						"id": "L1", "title": "Types of error",
						"outcome": "F2(a) Types of error; F2(b) Errors a trial balance does and does not reveal",
						"apply": {"title": "Zuru's Lemonade Stand - Yuki's week on the books", "pages": [
							{"text": "Zuru lets Yuki do the bookkeeping for a week. Six things go wrong - one of each kind:", "table": {"cols": ["What Yuki did", "Error type", "Does the TB still balance?"], "rows": [{"c": ["Forgot to enter the cafe's invoice at all", "Omission", "Yes"]}, {"c": ["Posted the dojo's invoice to the gym's account", "Commission", "Yes"]}, {"c": ["Debited the 15 sugar to Cart", "Principle", "Yes"]}, {"c": ["Keyed a 54 receipt as 45 on both sides", "Original entry", "Yes"]}, {"c": ["Debited receivables and credited cash for a receipt", "Reversal", "Yes"]}, {"c": ["Overcast sales by 100 AND overcast purchases by 100", "Compensating", "Yes"]}]}},
							{"text": "Every one of them leaves debits equal to credits, so the trial balance sails through. The TB only trips on [b]one-sided[/b] mistakes: Yuki debiting rent 40 and forgetting the credit; adding up the cash column wrongly; posting 40 on one side and 400 on the other; or entering a balance on the wrong side of the TB itself.\n\nWhen that happens the difference goes to a [b]suspense account[/b] (next lesson). The six above are found only by looking - control account reconciliations, bank reconciliations, supplier statements and Hana reading the numbers."}
						]},
						"learn": [
							{"text": "Errors that do NOT stop the trial balance balancing (debits still equal credits):\n[b]Omission[/b] - a transaction left out completely.\n[b]Commission[/b] - right type of account, wrong account (e.g. the wrong customer).\n[b]Principle[/b] - wrong TYPE of account (e.g. a van posted to motor expenses)."},
							{"text": "Also not revealed:\n[b]Original entry[/b] - the wrong amount used for BOTH sides (e.g. an invoice of 590 entered as 950 everywhere).\n[b]Reversal[/b] - right accounts and amount, debit and credit swapped.\n[b]Compensating[/b] - two errors that cancel each other out."},
							{"text": "Errors that DO make the trial balance disagree:\n[b]Single-sided entry[/b] - only one side posted.\n[b]Unequal entry[/b] - different amounts on each side, e.g. a [b]transposition[/b] in one account only (450 vs 540).\n[b]Casting (adding-up) error[/b] in one account.\n[b]Two debits or two credits[/b] instead of one of each."},
							{"text": "Tip: if the difference is exactly divisible by 9, look for a transposition (540 - 450 = 90)."}
						],
						"practice": [
							{"type": "sort", "q": "Would each error be revealed by the trial balance?", "buckets": ["Revealed (TB disagrees)", "Not revealed (TB balances)"], "items": [["Rent of 500 debited to rent but no credit entry made", 0], ["A sale omitted from the books entirely", 1], ["Repairs posted to the motor vehicles account", 1], ["The sales account added up 100 too high", 0], ["An invoice of 270 entered as 720 on both sides", 1], ["Payment of 300 posted Dr Payables and Dr Bank", 0]], "ex": "Single-sided entries, casting errors and two debits break the TB. Omission, principle and original entry errors don't."},
							{"type": "choice", "q": "Recording the purchase of a delivery van as motor expenses is an error of:", "opts": ["Principle", "Commission", "Omission", "Original entry"], "a": 0, "ex": "An asset was posted as an expense - the wrong TYPE of account."},
							{"type": "choice", "q": "A payment to J Smith was posted to J Smyth's account in the payables ledger. This is an error of:", "opts": ["Commission", "Principle", "Reversal", "Compensating error"], "a": 0, "ex": "Right type of account, wrong account."},
							{"type": "multi", "q": "Which TWO errors would cause the trial balance totals to disagree?", "opts": ["A transposition error in one account only", "A casting error in the sales day book total posted to one account", "An error of reversal", "An error of original entry"], "a": [0, 1], "ex": "One-sided amount errors break the TB. Reversal and original entry errors keep debits equal to credits."}
						]
					},
					{
						"id": "L2", "title": "Suspense accounts",
						"outcome": "F3(a) Purpose of a suspense account; F3(b) Errors creating one; F3(c) Record entries; F3(d) Journals to clear it",
						"apply": {"title": "Zuru's Lemonade Stand - the TB won't balance", "pages": [
							{"text": "Month-end: debits [b]2,480[/b], credits [b]2,420[/b]. Zuru can't hold up the statements while she hunts, so she opens a [b]suspense account[/b] for the 60 on the smaller side - a [b]credit[/b] of 60 - and the TB balances. Suspense is a parking space, never a real balance: it must be nil before the statements are finished."},
							{"text": "Two days later she finds both causes:\n- Rent of 40 was debited to Rent but never credited to Cash (one-sided entry).\n- A 20 receipt from the dojo was credited to Receivables but the Cash debit was entered as 40 (posted twice).", "table": {"cols": ["Correcting journals", "Dr", "Cr"], "rows": [{"c": ["Suspense / Cash (the missing credit)", "40", "40"]}, {"c": ["Suspense / Cash (the extra 20 debit)", "20", "20"]}]}},
							{"text": "", "table": {"cols": ["Suspense - Dr", "", "Cr", ""], "rows": [{"c": ["Cash (rent)", "40", "TB difference", "60"]}, {"c": ["Cash (dojo receipt)", "20", "", ""]}, {"c": ["", "60", "", "60"], "b": true}]}}
						]},
						"learn": [
							{"text": "A [b]suspense account[/b] is a [b]temporary[/b] account. It's opened when the trial balance doesn't balance - the difference goes into suspense so work can continue - or when a bookkeeper is unsure where an entry belongs."},
							{"text": "Side: put the difference on whichever side is SHORT. If debits are lower than credits, suspense has a [b]debit[/b] balance (and vice versa)."},
							{"text": "To clear it, for each error:\n1. What was actually posted?\n2. What should have been posted?\n3. Journal the difference - with suspense as one side when only ONE side was wrong."},
							{"text": "Only errors that made the TB disagree go through suspense. When all are corrected, the suspense balance is nil. It must never appear in the final financial statements."}
						],
						"example": {"title": "Clearing a suspense account", "table": {"cols": ["Suspense account", "Dr $", "Cr $"], "rows": [
							{"c": ["TB difference: debits 98,600, credits 99,050", "450", ""], "s": 1},
							{"c": ["(a) Supplier payment of 300 posted to bank only: Dr Payables 300, Cr Suspense", "", "300"], "s": 2},
							{"c": ["(b) Wages of 1,250 posted to wages as 1,100: Dr Wages 150, Cr Suspense", "", "150"], "s": 3},
							{"c": ["Balance", "0", "0"], "s": 4, "b": true}]},
							"steps": ["Debits are 450 short, so suspense opens with a 450 debit.", "(a) Bank was credited but payables never debited: debit payables 300, credit suspense.", "(b) Wages were debited 150 too little: debit wages 150, credit suspense.", "Suspense is cleared to nil."]},
						"practice": [
							{"type": "input", "q": "A trial balance has debits of 76,400 and credits of 75,900. What is the suspense account balance?  (number)", "accept": ["500"], "display_answer": "500 (credit)", "ex": "Credits are 500 short, so suspense has a 500 credit balance."},
							{"type": "picklist", "q": "Discount received of 200 was correctly debited to payables but not posted anywhere else. To correct it: Debit {0} 200, Credit {1} 200.", "lists": [["Suspense", "Discounts received", "Payables"], ["Discounts received", "Suspense", "Payables"]], "a": [0, 0], "ex": "The missing credit goes to discounts received; suspense takes the debit, clearing the gap."},
							{"type": "choice", "q": "Which error would NOT be corrected through the suspense account?", "opts": ["A sale of 400 completely omitted", "A cheque payment posted to the bank only", "Wages under-posted in the wages account only", "A debit balance listed in the TB as a credit"], "a": 0, "ex": "An omission doesn't make the TB disagree, so its correction has no suspense entry."},
							{"type": "choice", "q": "The balance on a suspense account must be:", "opts": ["Cleared before the financial statements are prepared", "Shown as a current asset", "Shown as an expense", "Carried forward to next year"], "a": 0, "ex": "Suspense is temporary and must be cleared."}
						]
					},
					{
						"id": "L3", "title": "Correcting journals and the effect on profit",
						"outcome": "C2(d) Correct journals from a narrative; F2(c) Journals to correct errors; F2(d) Impact of errors on profit and position",
						"apply": {"title": "Zuru's Lemonade Stand - fixing Yuki's week, and what it does to profit", "pages": [
							{"text": "Draft profit for the month is [b]410[/b]. Then the corrections for Yuki's errors go through. Each journal has two sides; the question is which of them touch the SOPL.", "table": {"cols": ["Correction", "Dr", "Cr", "Profit"], "rows": [{"c": ["Sugar wrongly in Cart: Purchases / Cart", "15", "15", "-15"]}, {"c": ["Cafe invoice omitted: Receivables / Sales", "60", "60", "+60"]}, {"c": ["Discount received 8 posted as discount allowed: Suspense / Discount allowed 8 and Discount received 8", "16", "16", "+16"]}, {"c": ["Receipt reversed: Cash / Receivables (x2 to undo and redo)", "40", "40", "0"]}]}},
							{"text": "Corrected profit: 410 - 15 + 60 + 16 = [b]471[/b]. The reversal fix moves 40 between two SOFP accounts, so profit is untouched - but net assets were already right; only the mix was wrong. The sugar correction cuts profit by 15 AND cuts non-current assets by 15. The cafe invoice adds 60 to profit and 60 to receivables.\n\nThe exam asks it both ways: 'what is the corrected profit?' and 'what is the effect on net assets?'. Tag every journal line as SOPL or SOFP and the answer falls out."}
						]},
						"learn": [
							{"text": "For errors that DON'T involve suspense, the correcting journal moves the amount from the wrong account to the right one. E.g. a van of 12,000 posted to motor expenses: [b]Dr Motor vehicles 12,000, Cr Motor expenses 12,000[/b]."},
							{"text": "Effect on profit - ask: does the correction touch a [b]SOPL[/b] account (income or expense)?\nIf YES, profit changes. Moving 12,000 OUT of expenses increases profit by 12,000 (and it may also need depreciation).\nIf the correction only moves amounts between SOFP accounts (e.g. one supplier to another), profit is unchanged."},
							{"text": "Exam questions often give a [b]draft profit[/b] and a list of errors, and ask for the corrected profit. Work through each item: + if it reduces an expense or adds income, - if it adds an expense or reduces income, 0 if SOFP only."}
						],
						"example": {"title": "Correcting the draft profit", "table": {"cols": ["", "$"], "rows": [
							{"c": ["Draft profit", "45,000"], "s": 1},
							{"c": ["Van wrongly expensed - capitalise it", "12,000"], "s": 2}, {"c": ["Depreciation on the van (20%)", "(2,400)"], "s": 2},
							{"c": ["Electricity accrual missed", "(800)"], "s": 3}, {"c": ["Insurance prepayment missed", "500"], "s": 3},
							{"c": ["Payment posted to the wrong supplier - SOFP only", "0"], "s": 4},
							{"c": ["Corrected profit", "54,300"], "s": 4, "b": true}]},
							"steps": ["Start from the draft profit.", "Taking the van out of expenses adds 12,000, but it now needs a year's depreciation.", "A missed accrual adds an expense; a missed prepayment reduces one.", "Moving a payment between supplier accounts doesn't touch profit. Corrected profit: 54,300."]},
						"practice": [
							{"type": "input", "q": "Draft profit 30,000. Errors: a sale of 1,200 was omitted; repairs of 900 were capitalised as machinery (no depreciation charged on them). Corrected profit = ?  (number)", "accept": ["30300"], "display_answer": "30,300", "ex": "30,000 + 1,200 sale - 900 repairs expensed = 30,300."},
							{"type": "picklist", "q": "Repairs of 900 were debited to the machinery account. Correction: Debit {0} 900, Credit {1} 900.", "lists": [["Repairs expense", "Machinery", "Suspense"], ["Machinery", "Repairs expense", "Suspense"]], "a": [0, 0], "ex": "Move the cost out of the asset (credit machinery) into the expense (debit repairs). Profit falls by 900."},
							{"type": "choice", "q": "A payment to one supplier was posted to another supplier's account. Correcting it will:", "opts": ["Not affect profit", "Increase profit", "Decrease profit", "Create a suspense account"], "a": 0, "ex": "Both accounts are payables - SOFP only - so profit is unchanged."},
							{"type": "choice", "q": "The owner took 500 cash for personal use, recorded as wages. The correcting journal is:", "opts": ["Dr Drawings 500, Cr Wages 500", "Dr Wages 500, Cr Drawings 500", "Dr Drawings 500, Cr Bank 500", "Dr Capital 500, Cr Wages 500"], "a": 0, "ex": "Move it from wages (credit) to drawings (debit). Profit increases by 500."}
						]
					}
				]
			},
			{
				"id": 17, "title": "Incomplete records", "monster": "The Fragment Fiend",
				"beats": [
					{"type":"story","speaker":"Sensei Otter","text":"The [b]Fragment Fiend[/b] has torn the records to pieces. Rebuild the missing figures and it cannot deceive you."},
					{"type":"story","speaker":"Sensei Otter","text":"[b]Mark-up[/b] = gross profit as a % of COST. [b]Margin[/b] = gross profit as a % of SALES. [b]Profit[/b] = closing net assets - opening net assets + drawings - capital introduced. Reconstruct control accounts for missing sales or purchases."},
					{"type":"input","q":"Cost of sales 40,000 with a mark-up of 25%. Sales = ?  (number)","accept":["50000"],"display_answer":"50,000","ex":"Mark-up is on cost: 40,000 x 1.25 = 50,000."},
					{"type":"input","q":"Sales 80,000 at a gross margin of 30%. Cost of sales = ?  (number)","accept":["56000"],"display_answer":"56,000","ex":"Gross profit 30% x 80,000 = 24,000, so cost of sales = 56,000."},
					{"type":"input","q":"Opening net assets 50,000, closing 62,000, drawings 15,000, no new capital. Profit = ?  (number)","accept":["27000"],"display_answer":"27,000","ex":"Profit = (62,000 - 50,000) + 15,000 = 27,000."},
					{"type":"choice","q":"Mark-up is gross profit as a % of:","opts":["Cost","Sales","Net assets","Capital"],"a":0,"ex":"Mark-up is on cost; margin is on sales."},
					{"type":"input","q":"A 25% mark-up on cost equals a margin on sales of what %?  (number)","accept":["20","20%"],"display_answer":"20%","ex":"Cost 100, mark-up 25, sales 125; margin = 25/125 = 20%."},
					{"type":"input","q":"Opening capital 40,000, closing 55,000, drawings 20,000, capital introduced 5,000. Profit = ?  (number)","accept":["30000"],"display_answer":"30,000","ex":"Profit = (55,000 - 40,000) + 20,000 - 5,000 = 30,000."},
					{"type":"choice","q":"To find missing credit sales, reconstruct the:","opts":["Bank reconciliation","Receivables control account","Depreciation schedule","Suspense account"],"a":1,"ex":"The receivables control (opening + sales - receipts = closing) reveals missing sales."},
					{"type":"input","q":"Sales 60,000 at a gross margin of 25%. Gross profit = ?  (number)","accept":["15000"],"display_answer":"15,000","ex":"Margin is on sales: 25% x 60,000 = 15,000."},
					{"type":"input","q":"Inventory was destroyed in a fire. Opening inventory 6,000, purchases 44,000, cost of sales 45,000. Inventory lost = ?  (number)","accept":["5000"],"display_answer":"5,000","ex":"Closing inventory = 6,000 + 44,000 - 45,000 = 5,000 lost."},
					{"type":"input","q":"Cash from credit customers 70,000. Opening receivables 5,000; closing 8,000. Credit sales = ?  (number)","accept":["73000"],"display_answer":"73,000","ex":"Sales = 70,000 + 8,000 - 5,000 = 73,000."},
					{"type":"choice","q":"Cash stolen from the till is usually found as:","opts":["The balancing figure in the reconstructed cash account","The opening capital","Part of drawings automatically","The suspense balance"],"a":0,"ex":"Reconstruct the cash account; the unexplained shortfall is the missing (stolen) cash."}
				],
				# Ch 17 learning objectives: G6(a). Exam: find missing figures - sales, closing inventory, drawings.
				"lessons": [
					{
						"id": "L1", "title": "Margins and mark-ups",
						"outcome": "G6(a)(iv) Use of profit percentages to calculate missing figures",
						"apply": {"title": "Zuru's Lemonade Stand - the snow got the shoebox", "pages": [
							{"text": "The shoebox from Zuru's first three months was left on the cart in a blizzard. The receipts are pulp. What survives: the bank statements, Kenji's statements, the price list, and one fact - Zuru always sold lemonade at a [b]mark-up of 100% on cost[/b] (cost 1 a cup, price 2).\n\nThat one percentage rebuilds cost of sales from sales, or sales from cost."},
							{"text": "", "table": {"cols": ["", "Mark-up 100% on cost", "Margin 40% on sales"], "rows": [{"c": ["Cost of sales", "100", "60"]}, {"c": ["Profit", "100", "40"]}, {"c": ["Sales", "200", "100"]}, {"c": ["Known: sales 900 -> cost of sales", "450 (900 x 100/200)", "540 (900 x 60/100)"]}, {"c": ["Known: cost 450 -> sales", "900 (450 x 200/100)", "750 (450 x 100/60)"]}]}},
							{"text": "[b]Mark-up[/b] is a percentage of cost; [b]margin[/b] is a percentage of sales. Same lemonade, different base - mark-up 100% is the same thing as margin 50%. Once cost of sales is known, the cost-of-sales equation gives whatever else is missing: opening inventory 20 + purchases ? - closing inventory 45 = 450 -> purchases = [b]475[/b]. The lost figure, found."}
						]},
						"learn": [
							{"text": "Small businesses often don't keep full records. We rebuild the missing figures from what we DO know. A common clue is the business's profit percentage."},
							{"text": "[b]Margin[/b] = gross profit as a % of [b]SALES[/b].\n[b]Mark-up[/b] = gross profit as a % of [b]COST OF SALES[/b].\nThe trick: write the cost-structure line, putting 100 on whichever figure the % is based on."},
							{"text": "Mark-up 25% (on cost): Cost 100, GP 25, Sales 125.\nMargin 20% (on sales): Sales 100, GP 20, Cost 80.\nSo a 25% mark-up IS a 20% margin - same business, different base."},
							{"text": "Use the line to move between figures: e.g. Sales 125,000 at a 25% mark-up -> cost of sales = 125,000 x 100/125 = 100,000. Then [b]Cost of sales = Opening inventory + Purchases - Closing inventory[/b] gives any one missing figure."}
						],
						"example": {"title": "Inventory lost in a flood", "table": {"cols": ["", "$"], "rows": [
							{"c": ["Sales for the year", "120,000"], "s": 1}, {"c": ["Gross margin 25%: cost of sales = 75% x 120,000", "90,000"], "s": 1},
							{"c": ["Opening inventory", "10,000"], "s": 2}, {"c": ["Purchases", "92,000"], "s": 2}, {"c": ["Closing inventory should be: 10,000 + 92,000 - 90,000", "12,000"], "s": 2, "b": true},
							{"c": ["Inventory actually saved after the flood", "(7,000)"], "s": 3}, {"c": ["Inventory lost", "5,000"], "s": 3, "b": true}]},
							"steps": ["From the margin, cost of sales is 75% of sales: 90,000.", "Rearranging the cost of sales formula gives what closing inventory should have been: 12,000.", "Only 7,000 was saved, so 5,000 was lost (e.g. for an insurance claim)."]},
						"practice": [
							{"type": "input", "q": "Cost of sales is 64,000 and the mark-up is 25%. Sales = ?  (number)", "accept": ["80000"], "display_answer": "80,000", "ex": "Cost 100 : Sales 125. 64,000 x 125/100 = 80,000."},
							{"type": "input", "q": "Sales are 90,000 at a gross margin of 40%. Cost of sales = ?  (number)", "accept": ["54000"], "display_answer": "54,000", "ex": "Sales 100 : GP 40 : Cost 60. 60% x 90,000 = 54,000."},
							{"type": "input", "q": "A mark-up of 50% on cost is equal to what gross margin %?  (number)", "accept": ["33.33", "33.3", "33", "33.33%", "33%"], "display_answer": "33.33%", "ex": "Cost 100, GP 50, Sales 150. Margin = 50/150 = 33.33%."},
							{"type": "input", "q": "Sales 60,000 at a 20% margin. Opening inventory 5,000; purchases 50,000. Closing inventory = ?  (number)", "accept": ["7000"], "display_answer": "7,000", "ex": "Cost of sales = 80% x 60,000 = 48,000. Closing = 5,000 + 50,000 - 48,000 = 7,000."}
						]
					},
					{
						"id": "L2", "title": "Missing sales and purchases",
						"outcome": "G6(a)(ii) Use of ledger accounts to find missing figures; G6(a)(iii) Cash and bank summaries",
						"apply": {"title": "Zuru's Lemonade Stand - rebuilding sales and purchases", "pages": [
							{"text": "The bank statements show [b]820[/b] received from credit customers and [b]300[/b] paid to Kenji over the three months. Zuru remembers customers owed her [b]100[/b] at the start and [b]140[/b] at the end; she owed Kenji [b]80[/b] at the start and [b]110[/b] at the end. A ledger account with one missing number finds the sales and purchases:", "table": {"cols": ["Receivables - Dr", "", "Cr", ""], "rows": [{"c": ["Opening balance", "100", "Cash received", "820"]}, {"c": ["Credit sales (balancing figure)", "860", "Closing balance", "140"]}, {"c": ["", "960", "", "960"], "b": true}]}},
							{"text": "", "table": {"cols": ["Payables - Dr", "", "Cr", ""], "rows": [{"c": ["Cash paid", "300", "Opening balance", "80"]}, {"c": ["Closing balance", "110", "Credit purchases (balancing figure)", "330"]}, {"c": ["", "410", "", "410"], "b": true}]}},
							{"text": "The [b]cash summary[/b] does the same trick for cash: bank at start 460 + takings banked ? - payments 1,050 = bank at end 610 -> takings banked [b]1,200[/b]. And if the till had 30 at the start and 20 at the end, with 1,200 banked and 60 of expenses paid from it, cash sales must have been 1,250. Whatever Zuru took for herself from the till is the last balancing figure: her [b]drawings[/b]."}
						]},
						"learn": [
							{"text": "If credit sales aren't recorded, rebuild the [b]receivables account[/b]: everything that increases receivables on one side, everything that reduces them on the other. The missing figure is the balancing figure.\n[b]Credit sales = Closing receivables + Cash received from customers + Irrecoverable debts + Discounts - Opening receivables[/b]"},
							{"text": "Same idea for purchases with the [b]payables account[/b]:\n[b]Credit purchases = Closing payables + Payments to suppliers + Discounts received - Opening payables[/b]"},
							{"text": "Remember: CASH sales and purchases don't go through receivables or payables - add them separately to get TOTAL sales or purchases."},
							{"text": "A [b]cash or bank summary[/b] works the same way: opening balance + money in - money out = closing balance. The missing figure is often [b]drawings[/b] or cash stolen."}
						],
						"example": {"title": "Finding total sales and drawings", "table": {"cols": ["", "$"], "rows": [
							{"c": ["Closing receivables", "6,500"], "s": 1}, {"c": ["Cash received from credit customers", "58,000"], "s": 1}, {"c": ["Less: opening receivables", "(4,000)"], "s": 1}, {"c": ["Credit sales", "60,500"], "s": 1, "b": true},
							{"c": ["Cash sales (till takings)", "9,500"], "s": 2}, {"c": ["Total sales", "70,000"], "s": 2, "b": true},
							{"c": ["Cash summary: opening cash 300 + takings 9,500 - wages paid 2,000 - banked 6,000 - closing cash 400", ""], "s": 3},
							{"c": ["Missing figure: drawings from the till", "1,400"], "s": 3, "b": true}]},
							"steps": ["The receivables account balances when credit sales are 60,500.", "Add the cash sales, which never went through receivables: total sales 70,000.", "In the till, everything is explained except 1,400 - the owner's drawings."]},
						"practice": [
							{"type": "input", "q": "Opening receivables 8,000; closing receivables 11,000; cash received from customers 74,000; irrecoverable debts written off 1,000. Credit sales = ?  (number)", "accept": ["78000"], "display_answer": "78,000", "ex": "11,000 + 74,000 + 1,000 - 8,000 = 78,000."},
							{"type": "input", "q": "Opening payables 6,000; closing payables 7,500; paid to suppliers 41,000; discounts received 500. Credit purchases = ?  (number)", "accept": ["43000"], "display_answer": "43,000", "ex": "7,500 + 41,000 + 500 - 6,000 = 43,000."},
							{"type": "input", "q": "Cash in the till: opening 200, takings 15,000, expenses paid from the till 1,800, banked 11,500, closing 300. Drawings taken from the till = ?  (number)", "accept": ["1600"], "display_answer": "1,600", "ex": "200 + 15,000 - 1,800 - 11,500 - 300 = 1,600."},
							{"type": "choice", "q": "When reconstructing the receivables account to find sales, cash sales are:", "opts": ["Excluded, then added separately", "Included as a debit", "Included as a credit", "Ignored completely"], "a": 0, "ex": "Cash sales never pass through receivables, so add them on after finding credit sales."}
						]
					},
					{
						"id": "L3", "title": "Drawings of goods and the accounting equation",
						"outcome": "G6(a)(i) Use of the accounting equation; G6(a) Drawings and inventory",
						"apply": {"title": "Zuru's Lemonade Stand - profit from two snapshots", "pages": [
							{"text": "Even without a single sales figure, Zuru can find the quarter's profit from what she OWNED at the start and the end. Net assets at the start: [b]600[/b]. Net assets at the end (cart, inventory, receivables, cash, less Kenji): [b]790[/b]. She put in no new capital and took [b]60[/b] of cash out for herself.\n\n[b]Closing net assets = Opening net assets + Capital introduced + Profit - Drawings[/b]"},
							{"text": "", "table": {"cols": ["", ""], "rows": [{"c": ["Closing net assets", "790"]}, {"c": ["Less: opening net assets", "(600)"]}, {"c": ["Increase", "190"]}, {"c": ["Add back: drawings", "60"]}, {"c": ["Less: capital introduced", "(0)"]}, {"c": ["Profit for the quarter", "250"], "b": true}]}},
							{"text": "The 60 of cash wasn't her only drawing - she also took lemonade home for a party. [b]Goods taken by the owner[/b] are drawings at [b]cost[/b]: Dr Drawings, Cr Purchases, so they drop out of cost of sales (she didn't SELL them). If those party lemons cost 15, drawings are really 75 and profit 265. Watch for it in the exam: 'the owner took goods costing X' always means Dr Drawings, Cr Purchases - never sales, never inventory."}
						]},
						"learn": [
							{"text": "When the owner takes [b]goods[/b] for personal use, they are recorded at [b]cost[/b]: Dr Drawings, Cr Purchases (cost of sales). Watch for this in incomplete-records questions - goods taken reduce purchases."},
							{"text": "If almost nothing is recorded, use the [b]accounting equation[/b] (Chapter 6):\nNet assets = Capital, so the CHANGE in net assets over the year = capital introduced + profit - drawings.\n[b]Profit = Closing net assets - Opening net assets + Drawings - Capital introduced[/b]"},
							{"text": "Work it in order: list assets and liabilities at the start and end, find net assets for each, then use the equation to find the missing profit (or drawings)."}
						],
						"example": {"title": "Profit from net assets", "table": {"cols": ["", "Start $", "End $"], "rows": [
							{"c": ["Total assets", "48,000", "61,000"], "s": 1}, {"c": ["Total liabilities", "(13,000)", "(16,000)"], "s": 1}, {"c": ["Net assets (= capital)", "35,000", "45,000"], "s": 1, "b": true},
							{"c": ["Increase in net assets", "", "10,000"], "s": 2},
							{"c": ["Add drawings / less capital introduced: + 12,000 - 3,000", "", "9,000"], "s": 3},
							{"c": ["Profit for the year", "", "19,000"], "s": 3, "b": true}]},
							"steps": ["Net assets went from 35,000 to 45,000.", "That's a 10,000 increase.", "Profit made the business bigger even though the owner took 12,000 out (add it back) and put 3,000 in (take it off): profit 19,000."]},
						"practice": [
							{"type": "input", "q": "Net assets: start 22,000, end 30,500. Drawings 9,000; no capital introduced. Profit = ?  (number)", "accept": ["17500"], "display_answer": "17,500", "ex": "30,500 - 22,000 + 9,000 = 17,500."},
							{"type": "input", "q": "Profit 25,000. Net assets rose from 40,000 to 52,000. The owner introduced no capital. Drawings = ?  (number)", "accept": ["13000"], "display_answer": "13,000", "ex": "Increase 12,000 = profit 25,000 - drawings. Drawings = 13,000."},
							{"type": "picklist", "q": "The owner takes goods costing 400 for personal use: Debit {0} 400, Credit {1} 400.", "lists": [["Drawings", "Purchases", "Sales"], ["Purchases", "Drawings", "Sales"]], "a": [0, 0], "ex": "Goods taken are drawings at cost, and they reduce purchases."}
						]
					}
				]
			},
			{
				"id": 18, "title": "Preparation of financial statements", "monster": "The Sole-Trader Sphinx",
				"beats": [
					{"type":"story","speaker":"Sensei Otter","text":"The [b]Sole-Trader Sphinx[/b] asks you to pull the whole year together into one set of accounts. Answer true and it lets you pass."},
					{"type":"story","speaker":"Sensei Otter","text":"[b]Closing capital = opening capital + capital introduced + profit - drawings[/b]. Drawings reduce capital, never an expense. Adjustments flow to BOTH statements, e.g. depreciation."},
					{"type":"input","q":"Opening capital 30,000, profit 22,000, drawings 14,000, no new capital. Closing capital = ?  (number)","accept":["38000"],"display_answer":"38,000","ex":"30,000 + 22,000 - 14,000 = 38,000."},
					{"type":"input","q":"Opening capital 25,000, loss for the year 4,000, drawings 6,000. Closing capital = ?  (number)","accept":["15000"],"display_answer":"15,000","ex":"25,000 - 4,000 - 6,000 = 15,000."},
					{"type":"choice","q":"Drawings are:","opts":["An expense in the SOPL","A reduction of capital in the SOFP","Revenue","A liability"],"a":1,"ex":"Drawings are the owner taking profit out - they reduce capital, not profit."},
					{"type":"choice","q":"Goods taken by the owner for personal use should be:","opts":["Added to sales","Deducted from purchases and added to drawings","Ignored","Added to expenses"],"a":1,"ex":"Goods for own use reduce purchases and increase drawings."},
					{"type":"choice","q":"An irrecoverable debt written off during the year appears in the SOPL as:","opts":["Revenue","An expense","A liability","Capital"],"a":1,"ex":"Writing off a bad debt is an expense in the SOPL."},
					{"type":"choice","q":"Depreciation for the year affects:","opts":["Only the SOPL","Only the SOFP","Both the SOPL and the SOFP","Neither"],"a":2,"ex":"Depreciation is an expense in the SOPL and reduces the asset carrying amount in the SOFP."},
					{"type":"choice","q":"In the SOFP, which total must equal total assets?","opts":["Revenue + expenses","Capital + total liabilities","Gross profit + drawings","Non-current assets only"],"a":1,"ex":"Total assets = Capital + total liabilities - the SOFP always balances."},
					{"type":"choice","q":"The owner pays the business rent from a PERSONAL bank account. The entry is:","opts":["Dr Rent expense, Cr Capital","Dr Capital, Cr Rent expense","Dr Rent expense, Cr Cash","Dr Drawings, Cr Rent expense"],"a":0,"ex":"It is a business expense, funded by the owner - treat it as capital introduced."},
					{"type":"input","q":"Gross profit 40,000; expenses 25,000; drawings 9,000. Profit for the year = ?  (number)","accept":["15000"],"display_answer":"15,000","ex":"40,000 - 25,000 = 15,000. Drawings are NOT an expense."},
					{"type":"choice","q":"A sole trader's personal income tax paid from the business bank is:","opts":["Drawings","A business expense","A liability of the business","Cost of sales"],"a":0,"ex":"A sole trader is taxed personally, so it is drawings, not a business expense."},
					{"type":"choice","q":"The owner pays 10,000 of personal savings into the business bank. The entry is:","opts":["Dr Bank, Cr Capital","Dr Capital, Cr Bank","Dr Bank, Cr Sales","Dr Bank, Cr Drawings"],"a":0,"ex":"Capital introduced: cash rises (debit) and capital rises (credit)."}
				],
				# Ch 18 learning objectives: F1(c), F2(c), F3(c), F3(d), G1(b), G2(b). Section B accounts-preparation practice:
				# the key adjustments (closing inventory, drawings, depreciation, irrecoverable debts, accruals/prepayments, receivables/payables).
				"lessons": [
					{
						"id": "L1", "title": "The technique: TB + adjustments -> statements",
						"outcome": "G1(b) Prepare a SOFP or extracts; G2(b) Prepare a SOPL or extracts; F1(c) Opening TB extracts",
						"apply": {"title": "Zuru's Lemonade Stand - the year-end checklist", "pages": [
							{"text": "31 December, end of Zuru's first year. The app prints the trial balance; Hana hands over the year-end notes. Every Section B question is this situation: a TB plus a list of adjustments the TB doesn't know about. Zuru works through the same [b]six[/b] every time:"},
							{"text": "", "table": {"cols": ["Adjustment", "Zuru's note", "SOPL", "SOFP"], "rows": [{"c": ["1. Closing inventory", "45 counted", "Reduces cost of sales", "Current asset 45"]}, {"c": ["2. Depreciation", "Cart 120", "Expense 120", "Acc dep -> carrying amount 580"]}, {"c": ["3. Accruals", "Rent 40, gas 90", "Expense +130", "Current liability 130"]}, {"c": ["4. Prepayments", "Insurance 180", "Expense -180", "Current asset 180"]}, {"c": ["5. Irrecoverable debts / allowance", "Allowance 85", "Expense 85", "Receivables net 665"]}, {"c": ["6. Drawings of goods", "None this year", "-", "-"]}]}},
							{"text": "Order matters: do the adjustments first, mark each TB line as 'SOPL' or 'SOFP', then build the two statements. Each adjustment touches [b]both[/b] statements once - that is the double entry. If a figure only landed in one statement, something is missing and the SOFP won't balance. Next lesson does the whole thing with Zuru's real numbers."}
						]},
						"learn": [
							{"text": "A Section B accounts-preparation question gives you a [b]trial balance[/b] plus a list of [b]year-end adjustments[/b] (notes), and asks for the statement of profit or loss and/or the statement of financial position. Fifteen marks, part marks for each figure."},
							{"text": "The technique, every time:\n1. Read the notes BEFORE the TB.\n2. Deal with each note as a [b]double entry[/b] - most notes hit one SOPL line AND one SOFP line.\n3. Then build the SOPL top to bottom, and the SOFP.\n4. Check: the SOFP balances."},
							{"text": "The six adjustments the exam loves:\n[b]Closing inventory[/b] - reduces cost of sales / current asset.\n[b]Depreciation[/b] - expense / reduces the asset's carrying amount.\n[b]Irrecoverable debts and the allowance[/b] - expense / reduces receivables."},
							{"text": "[b]Accruals[/b] - add to the expense / current liability.\n[b]Prepayments[/b] - take off the expense / current asset.\n[b]Drawings[/b] (cash OR goods) - never an expense; reduce capital (goods also reduce purchases).\n\nA note you have already done in the TB (e.g. 'the TB already includes the accrual') is a trap - don't do it twice."},
							{"text": "Marks tip: lay out the statement first with the figures you can take straight from the TB, then slot the adjusted ones in. Even if one figure is wrong, every other correct line still scores."}
						],
						"practice": [
							{"type": "sort", "q": "Which statement does each adjustment affect? (Most affect both - pick the one that also moves PROFIT.)", "buckets": ["SOPL and SOFP", "SOFP only"], "items": [["Depreciation for the year", 0], ["Closing inventory", 0], ["Cash drawings", 1], ["An accrued expense", 0], ["Capital introduced by the owner", 1], ["Writing off an irrecoverable debt", 0]], "ex": "Drawings and capital introduced only move capital in the SOFP. The others change an expense or cost of sales, so they change profit too."},
							{"type": "choice", "q": "The TB shows electricity of 4,100. The notes say 'electricity of 700 is owed at the year-end'. In the SOPL, electricity is:", "opts": ["4,800", "4,100", "3,400", "700"], "a": 0, "ex": "Add the accrual: 4,100 + 700 = 4,800. The 700 is also a current liability."},
							{"type": "choice", "q": "The notes say 'the owner took goods costing 600 for personal use; no entries have been made'. The correct treatment is:", "opts": ["Reduce purchases by 600 and increase drawings by 600", "Add 600 to sales", "Add 600 to expenses", "Ignore it - drawings are not in the SOPL"], "a": 0, "ex": "Goods taken are drawings at cost: Dr Drawings, Cr Purchases."},
							{"type": "input", "q": "TB: receivables 14,000; allowance for receivables b/f 500. Notes: write off 1,000; the allowance should be 3% of remaining receivables. What figure for NET receivables goes in the SOFP?  (number)", "accept": ["12610"], "display_answer": "12,610", "ex": "14,000 - 1,000 = 13,000; allowance 3% = 390; net 13,000 - 390 = 12,610."}
						]
					},
					{
						"id": "L2", "title": "Worked Section B: Leo's Bike Shop",
						"outcome": "G2(b) Prepare a SOPL; G1(b) Prepare a SOFP - full worked example with all six adjustments",
						"apply": {"title": "Zuru's Lemonade Stand - year 1, the whole thing", "pages": [
							{"text": "Zuru's trial balance at 31 December, year 1 (no opening inventory - she started this year):", "table": {"cols": ["Trial balance", "Dr", "Cr"], "rows": [{"c": ["Sales", "", "9,600"]}, {"c": ["Purchases", "4,200", ""]}, {"c": ["Rent (11 months)", "440", ""]}, {"c": ["Wages (Yuki)", "1,200", ""]}, {"c": ["Heater gas", "270", ""]}, {"c": ["Insurance (12 months from 1 Oct)", "240", ""]}, {"c": ["Irrecoverable debts written off", "160", ""]}, {"c": ["Cart - cost", "700", ""]}, {"c": ["Receivables", "750", ""]}, {"c": ["Bank", "2,240", ""]}, {"c": ["Drawings", "400", ""]}, {"c": ["Payables", "", "200"]}, {"c": ["Loan from Hana", "", "300"]}, {"c": ["Capital", "", "500"]}, {"c": ["", "10,600", "10,600"], "b": true}]}},
							{"text": "Notes: closing inventory 45; depreciate the cart 120; accrue rent 40 and gas 90; insurance prepaid 180; allowance for receivables 85.", "table": {"cols": ["Statement of profit or loss - year 1", "", ""], "rows": [{"c": ["Sales", "", "9,600"]}, {"c": ["Purchases 4,200 less closing inventory 45", "", "(4,155)"]}, {"c": ["Gross profit", "", "5,445"], "b": true}, {"c": ["Rent 440 + 40", "480", ""]}, {"c": ["Wages", "1,200", ""]}, {"c": ["Gas 270 + 90", "360", ""]}, {"c": ["Insurance 240 - 180", "60", ""]}, {"c": ["Depreciation", "120", ""]}, {"c": ["Irrecoverable debts 160 + allowance 85", "245", ""]}, {"c": ["Total expenses", "", "(2,465)"]}, {"c": ["Profit for the year", "", "2,980"], "b": true}]}},
							{"text": "", "table": {"cols": ["Statement of financial position at 31 December", "", ""], "rows": [{"c": ["Cart 700 - 120", "", "580"]}, {"c": ["Inventory", "45", ""]}, {"c": ["Receivables 750 - 85", "665", ""]}, {"c": ["Prepayment", "180", ""]}, {"c": ["Bank", "2,240", ""]}, {"c": ["Current assets", "", "3,130"]}, {"c": ["Total assets", "", "3,710"], "b": true}, {"c": ["Capital 500 + profit 2,980 - drawings 400", "", "3,080"]}, {"c": ["Loan from Hana (non-current)", "", "300"]}, {"c": ["Payables 200 + accruals 130", "", "330"]}, {"c": ["Capital + liabilities", "", "3,710"], "b": true}]}}
						]},
						"learn": [
							{"text": "Leo's trial balance at 31 December 20X7 (all in $):\nSales 210,000 Cr; Purchases 118,000; Inventory 1 Jan 15,000; Wages 36,000; Rent 18,000; Insurance 3,600; Sundry expenses 4,900; Fittings cost 48,000; Fittings acc. dep'n 1 Jan 19,200 Cr; Receivables 16,000; Allowance 1 Jan 400 Cr; Bank 7,300; Payables 9,800 Cr; Drawings 21,000; Capital 1 Jan 48,400 Cr.\nTotals: 287,800 both sides."},
							{"text": "Notes:\n1. Closing inventory 17,500.\n2. Depreciate fittings at 20% straight line on cost.\n3. Rent of 1,500 for December is unpaid.\n4. Insurance of 3,600 covers the year to 31 March 20X8.\n5. Write off a debt of 600; allowance to be 2% of the remaining receivables.\n6. Leo took goods costing 800 for his own use - not yet recorded."},
							{"text": "Workings first:\nW1 Depreciation: 20% x 48,000 = [b]9,600[/b]. Carrying amount 48,000 - 19,200 - 9,600 = [b]19,200[/b].\nW2 Rent: 18,000 + 1,500 accrual = [b]19,500[/b].\nW3 Insurance: Jan-Mar 20X8 prepaid = 3/12 x 3,600 = 900. Expense [b]2,700[/b]; prepayment 900."},
							{"text": "W4 Receivables: 16,000 - 600 = 15,400. Allowance 2% = 308. Movement 308 - 400 = [b]92 decrease[/b]. Expense = 600 - 92 = [b]508[/b]. Net receivables 15,400 - 308 = [b]15,092[/b].\nW5 Purchases: 118,000 - 800 goods taken = [b]117,200[/b]. Drawings 21,000 + 800 = [b]21,800[/b]."}
						],
						"example": {"title": "Leo's statements", "table": {"cols": ["", "$"], "rows": [
							{"c": ["SOPL: Revenue", "210,000"], "s": 1}, {"c": ["Cost of sales: 15,000 + 117,200 - 17,500", "(114,700)"], "s": 1}, {"c": ["Gross profit", "95,300"], "s": 1, "b": true},
							{"c": ["Wages 36,000 + Rent 19,500 + Insurance 2,700 + Sundry 4,900 + Dep'n 9,600 + Irrecoverable debts 508", "(73,208)"], "s": 2}, {"c": ["Profit for the year", "22,092"], "s": 2, "b": true},
							{"c": ["SOFP: Fittings (carrying amount)", "19,200"], "s": 3}, {"c": ["Inventory 17,500 + Receivables 15,092 + Prepayment 900 + Bank 7,300", "40,792"], "s": 3}, {"c": ["Total assets", "59,992"], "s": 3, "b": true},
							{"c": ["Capital 48,400 + Profit 22,092 - Drawings 21,800", "48,692"], "s": 4}, {"c": ["Payables 9,800 + Accrual 1,500", "11,300"], "s": 4}, {"c": ["Capital + liabilities", "59,992"], "s": 4, "b": true}]},
							"steps": ["SOPL top: revenue from the TB; cost of sales uses the ADJUSTED purchases and the closing inventory note.", "Expenses use the workings: adjusted rent, insurance, depreciation and the irrecoverable debts charge. Profit 22,092.", "SOFP assets: fittings at carrying amount, closing inventory, net receivables, the prepayment, bank.", "Capital moves by profit and the full drawings; liabilities include the rent accrual. 59,992 both sides - it balances."]},
						"practice": [
							{"type": "input", "q": "Using Leo's figures, what is cost of sales?  (number)", "accept": ["114700"], "display_answer": "114,700", "ex": "15,000 + (118,000 - 800) - 17,500 = 114,700."},
							{"type": "input", "q": "Using Leo's figures, what is the irrecoverable debts expense in the SOPL?  (number)", "accept": ["508"], "display_answer": "508", "ex": "Write-off 600 less the 92 fall in the allowance (400 to 308) = 508."},
							{"type": "input", "q": "Using Leo's figures, what is closing capital?  (number)", "accept": ["48692"], "display_answer": "48,692", "ex": "48,400 + 22,092 - 21,800 = 48,692."},
							{"type": "input", "q": "If Leo had forgotten note 4 (the prepayment), by how much would profit be UNDERSTATED?  (number)", "accept": ["900"], "display_answer": "900", "ex": "Insurance would be 3,600 instead of 2,700 - 900 too much expense, so profit 900 too low."}
						]
					},
					{
						"id": "L3", "title": "Suspense and corrections inside a Section B question",
						"outcome": "F2(c) Journals to correct errors; F3(c) Entries in a suspense account; F3(d) Journals to clear it",
						"apply": {"title": "Zuru's Lemonade Stand - a suspense balance in the year-end TB", "pages": [
							{"text": "Suppose Zuru's year-end TB had one more line: [b]Suspense 20 Cr[/b]. Hana's notes explain it: discount received of 10 from Kenji was posted to the DEBIT of discounts allowed instead of the credit of discounts received. One debit of 10 where a credit of 10 belonged - debits 20 too high, hence the 20 credit in suspense.\n\nIn a Section B question this is a seventh adjustment, done before the statements."},
							{"text": "", "table": {"cols": ["Correcting journal", "Dr", "Cr"], "rows": [{"c": ["Suspense", "20", ""]}, {"c": ["   Discounts allowed (remove the wrong debit)", "", "10"]}, {"c": ["   Discounts received (put in the missing credit)", "", "10"]}]}},
							{"text": "Suspense is cleared to nil and disappears from the SOFP. Profit goes UP by 20: expenses fall by 10 and income rises by 10. Everything else in the statements from the last lesson stays the same, so profit would be 3,000 and capital 3,100. The rule for any suspense question: find the one-sided or wrong-sided entry, write the journal that makes it right, and the other side of that journal is always suspense."}
						]},
						"learn": [
							{"text": "A Section B trial balance sometimes doesn't balance, and the question gives you a [b]suspense[/b] balance plus some errors. Clear the suspense account FIRST (Chapter 16), then do the normal year-end adjustments."},
							{"text": "For each error ask: does the correction change an [b]SOPL[/b] line (profit changes) or only [b]SOFP[/b] lines? And does it involve suspense (only if the original entry was one-sided or unequal)?"},
							{"text": "Common ones:\n- A sale omitted: Dr Receivables, Cr Sales (profit UP, no suspense).\n- Cash paid to a supplier recorded in bank only: Dr Payables, Cr Suspense.\n- A non-current asset purchase posted to repairs: Dr Asset, Cr Repairs (profit UP, then depreciate it)."}
						],
						"practice": [
							{"type": "picklist", "q": "A payment of 2,000 for a new computer was debited to repairs. The correction is Debit {0} 2,000, Credit {1} 2,000 - and profit {2}.", "lists": [["Computer equipment", "Repairs", "Suspense"], ["Repairs", "Computer equipment", "Bank"], ["increases by 2,000 (before depreciation)", "decreases by 2,000", "is unchanged"]], "a": [0, 0, 0], "ex": "Move the cost out of repairs into the asset; profit rises by 2,000, then depreciation on the computer reduces it a little."},
							{"type": "input", "q": "Draft profit 31,500. Corrections: a sale of 2,400 omitted; discounts received of 300 debited to discounts allowed in error (one-sided, suspense involved); closing inventory overstated by 1,000. Corrected profit = ?  (number)", "accept": ["33500"], "display_answer": "33,500", "ex": "31,500 + 2,400 + 600 (remove 300 from discounts allowed AND add 300 to discounts received) - 1,000 = 33,500."},
							{"type": "choice", "q": "Which error would require a SUSPENSE account entry to correct?", "opts": ["A receipt from a customer was credited to receivables but not debited to the bank", "A sale was completely omitted", "A van was posted to motor expenses", "Rent was posted to the wrong month's rent account"], "a": 0, "ex": "Only a one-sided entry breaks the TB and needs suspense. The others keep debits equal to credits."}
						]
					}
				],
				# Section B 15-mark MTQ (sole trader, all six adjustment types).
				"mtq": {
					"title": "Section B: Priya's Print Studio", "monster": "The Sole-Trader Sphinx", "marks": 15,
					"scenario": [
						{"text": "Priya runs a print studio as a sole trader. Her trial balance at [b]31 December 20X8[/b] is below."},
						{"table": {"cols": ["Trial balance at 31 Dec 20X8", "Dr $", "Cr $"], "rows": [
							{"c": ["Revenue", "", "164,000"]}, {"c": ["Purchases", "71,000", ""]}, {"c": ["Inventory at 1 Jan 20X8", "9,000", ""]},
							{"c": ["Wages", "38,000", ""]}, {"c": ["Rent", "15,000", ""]}, {"c": ["Insurance", "3,000", ""]}, {"c": ["Sundry expenses", "6,200", ""]},
							{"c": ["Equipment - cost", "60,000", ""]}, {"c": ["Equipment - accumulated depreciation at 1 Jan 20X8", "", "21,600"]},
							{"c": ["Trade receivables", "12,500", ""]}, {"c": ["Allowance for receivables at 1 Jan 20X8", "", "700"]}, {"c": ["Bank", "4,900", ""]}, {"c": ["Trade payables", "", "7,300"]},
							{"c": ["Drawings", "19,000", ""]}, {"c": ["Capital at 1 Jan 20X8", "", "45,000"]}, {"c": ["Total", "238,600", "238,600"], "b": true}]}},
						{"text": "[b]Notes[/b]\n1. Closing inventory at 31 December 20X8 was 11,200.\n2. Equipment is depreciated at 20% a year on the reducing-balance basis.\n3. Rent of 1,250 for December 20X8 is unpaid.\n4. The insurance of 3,000 was paid on 1 October 20X8 for the year to 30 September 20X9.\n5. A debt of 500 is irrecoverable. The allowance for receivables should be 5% of the remaining receivables.\n6. Priya took goods costing 1,000 for personal use; nothing has been recorded."}
					],
					"tasks": [
						{"title": "Task 1: Statement of profit or loss for the year to 31 December 20X8", "intro": "Enter the missing figures as positive numbers.", "rows": [
							{"c": ["Revenue", "164,000"]}, {"c": ["Cost of sales", "#cos"]}, {"c": ["Wages", "38,000"]}, {"c": ["Rent", "#rent"]}, {"c": ["Insurance", "#ins"]},
							{"c": ["Sundry expenses", "6,200"]}, {"c": ["Depreciation", "#dep"]}, {"c": ["Irrecoverable debts expense", "#bad"]}, {"c": ["Profit for the year", "#profit"], "b": true}],
							"blanks": {
								"cos": {"accept": ["67800"], "show": "67,800", "marks": 2, "ex": "9,000 + (71,000 - 1,000 goods taken) - 11,200 = 67,800."},
								"rent": {"accept": ["16250"], "show": "16,250", "marks": 1, "ex": "15,000 + 1,250 accrued = 16,250."},
								"ins": {"accept": ["750"], "show": "750", "marks": 2, "ex": "Only October-December 20X8 belongs to this year: 3/12 x 3,000 = 750. The other 2,250 is prepaid."},
								"dep": {"accept": ["7680"], "show": "7,680", "marks": 2, "ex": "20% x (60,000 - 21,600) = 7,680."},
								"bad": {"accept": ["400"], "show": "400", "marks": 2, "ex": "Write-off 500. Allowance needed 5% x 12,000 = 600; it was 700, so it FALLS by 100. Expense = 500 - 100 = 400."},
								"profit": {"accept": ["26920"], "show": "26,920", "marks": 1, "ex": "Gross profit 96,200 less expenses (38,000 + 16,250 + 750 + 6,200 + 7,680 + 400 = 69,280) = 26,920."}
							}},
						{"title": "Task 2: Statement of financial position at 31 December 20X8", "intro": "Enter the missing figures.", "rows": [
							{"c": ["Equipment (carrying amount)", "#eq"]}, {"c": ["Inventory", "11,200"]}, {"c": ["Trade receivables (net of allowance)", "#rec"]}, {"c": ["Prepayment", "#pre"]}, {"c": ["Bank", "4,900"]},
							{"c": ["Capital at 1 Jan 20X8", "45,000"]}, {"c": ["Profit for the year", "(from Task 1)"]}, {"c": ["Drawings", "#drw"]}, {"c": ["Closing capital", "#cap"], "b": true},
							{"c": ["Current liabilities (payables + accrual)", "8,550"]}],
							"blanks": {
								"eq": {"accept": ["30720"], "show": "30,720", "marks": 1, "ex": "60,000 - 21,600 - 7,680 = 30,720."},
								"rec": {"accept": ["11400"], "show": "11,400", "marks": 1, "ex": "12,500 - 500 written off = 12,000, less allowance 600 = 11,400."},
								"pre": {"accept": ["2250"], "show": "2,250", "marks": 1, "ex": "Insurance for January-September 20X9 paid in advance: 9/12 x 3,000 = 2,250."},
								"drw": {"accept": ["20000"], "show": "20,000", "marks": 1, "ex": "19,000 cash + 1,000 goods taken = 20,000."},
								"cap": {"accept": ["51920"], "show": "51,920", "marks": 1, "ex": "45,000 + 26,920 - 20,000 = 51,920. Check: assets 30,720 + 11,200 + 11,400 + 2,250 + 4,900 = 60,470 = 51,920 + 8,550."}
							}}
					]
				}
			},
			{
				"id": 19, "title": "Introduction to company accounting", "monster": "The Corporate Colossus",
				"beats": [
					{"type":"story","speaker":"Sensei Otter","text":"The towering [b]Corporate Colossus[/b] is built of shares, reserves and loans. Know its parts and it cannot crush you."},
					{"type":"story","speaker":"Sensei Otter","text":"Shares are recorded at [b]nominal value[/b]; the excess goes to [b]share premium[/b] (non-distributable). Ordinary = vote; preference = fixed dividend first. [b]Dividends[/b] are an appropriation (not an expense); proposed after the year-end -> disclose only. Bonus = free shares; rights = raises cash."},
					{"type":"input","q":"50,000 shares of 0.50 each are issued at 0.90. Share capital increases by ?  (number)","accept":["25000"],"display_answer":"25,000","ex":"Share capital = nominal = 50,000 x 0.50 = 25,000 (premium 20,000)."},
					{"type":"input","q":"100,000 shares of 1.00 each are issued at 1.30. The share premium = ?  (number)","accept":["30000"],"display_answer":"30,000","ex":"Premium = (1.30 - 1.00) x 100,000 = 30,000."},
					{"type":"choice","q":"Preference shares typically carry:","opts":["Voting rights and a variable dividend","A fixed dividend paid first, usually no vote","Guaranteed capital growth","Control of the company"],"a":1,"ex":"Preference shares get a fixed dividend in priority, usually with no vote."},
					{"type":"choice","q":"A bonus issue of shares:","opts":["Raises new cash","Issues free shares from reserves and raises no cash","Is always at market value","Reduces shares in issue"],"a":1,"ex":"A bonus issue capitalises reserves into free shares; no cash is raised."},
					{"type":"input","q":"A 1 for 4 rights issue at 1.50 is made on 200,000 existing shares. Cash raised = ?  (number)","accept":["75000"],"display_answer":"75,000","ex":"200,000 / 4 = 50,000 new shares x 1.50 = 75,000."},
					{"type":"choice","q":"A bonus issue is recorded as:","opts":["Dr Share premium (or retained earnings), Cr Share capital","Dr Cash, Cr Share capital","Dr Share capital, Cr Cash","Dr Retained earnings, Cr Cash"],"a":0,"ex":"Reserves are capitalised into share capital; no cash moves."},
					{"type":"choice","q":"The revaluation surplus is shown in:","opts":["Equity","Non-current liabilities","Revenue","Current assets"],"a":0,"ex":"It is an unrealised reserve within equity."}
				],
				# Ch 19 learning objectives: D10(a)-(k), A1(c), A1(d). Exam: share capital movements (new issues, bonus, rights), dividends, finance costs + journals; sole trader vs company.
				"lessons": [
					{
						"id": "L1", "title": "Companies: capital structure and equity",
						"outcome": "D10(a) Capital structure: ordinary shares, preference shares, borrowings; D10(b) Nature of equity; A1(c)(d) Sole trader vs company",
						"apply": {"title": "Zuru Lemonade Ltd - who put the money in, and what they get", "pages": [
							{"text": "Year 2: Zuru Lemonade Ltd is formed to open the station kiosk. The money comes from three places:\n- [b]5,000 ordinary shares of 1[/b]: Zuru 3,000, Hana 1,000, Taro 1,000. They own the company and get whatever is left.\n- [b]1,000 8% preference shares of 1[/b] bought by Taro's wife Mei: a fixed 80 a year dividend, paid before the ordinary shareholders see anything.\n- A [b]3,000 bank loan[/b] at 6%, repayable in five years."},
							{"text": "", "table": {"cols": ["Source", "In the SOFP", "What it costs the company", "In the SOPL?"], "rows": [{"c": ["Ordinary shares 5,000", "Equity", "Dividends, if declared", "No - from retained earnings"]}, {"c": ["Preference shares 1,000 (non-redeemable)", "Equity", "Fixed dividend 80", "No - from retained earnings"]}, {"c": ["Bank loan 3,000", "Non-current liability", "Interest 180 a year", "Yes - finance cost"]}]}},
							{"text": "[b]Equity[/b] is the owners' residual claim - assets less liabilities. The loan is a liability: the bank must be paid whatever happens, and its interest is an expense. Dividends are not an expense; they are the owners taking some of their profit out, like Zuru's drawings used to be. (Redeemable preference shares that must be bought back are the exception - they behave like a loan and are shown as a liability.) Compared with the sole-trader days: the company now files accounts, pays corporation tax on its own profit, and Zuru's liability stops at her 3,000."}
						]},
						"learn": [
							{"text": "A [b]limited company[/b] is a separate legal person owned by [b]shareholders[/b] and run by [b]directors[/b]. Compared with a sole trader: more regulation (company law, published accounts), but [b]limited liability[/b], easier finance and the company carries on when owners change. It pays its OWN tax on profits - unlike a sole trader, who is taxed personally."},
							{"text": "A company raises long-term finance in three ways:\n[b]Ordinary (equity) shares[/b] - carry votes; dividends vary with profits; paid last if the company fails.\n[b]Preference shares[/b] - fixed dividend, paid before ordinary dividends; usually no vote.\n[b]Borrowings[/b] - loan notes / debentures and bank loans; interest is a cost whether or not there are profits."},
							{"text": "Preference shares come in two kinds:\n[b]Irredeemable[/b] - never repaid: part of [b]equity[/b]; their dividend is an appropriation of profit.\n[b]Redeemable[/b] - repaid on a fixed date: in substance a [b]loan[/b], so a [b]liability[/b]; their 'dividend' is a [b]finance cost[/b] in profit or loss."},
							{"text": "[b]Equity[/b] = what belongs to the owners = [b]share capital + share premium + other reserves + retained earnings[/b].\n[b]Retained earnings[/b] = profits kept in the business (less dividends paid). A sole trader has one capital account; a company splits it into these parts."}
						],
						"example": {"title": "Where each source of finance sits", "table": {"cols": ["Source", "SOFP heading", "Cost to the company"], "rows": [
							{"c": ["Ordinary shares", "Equity", "Dividend (appropriation)"], "s": 1},
							{"c": ["Irredeemable preference shares", "Equity", "Dividend (appropriation)"], "s": 2},
							{"c": ["Redeemable preference shares", "Non-current liability", "Finance cost"], "s": 2},
							{"c": ["Loan notes", "Non-current liability", "Finance cost (interest)"], "s": 3}]},
							"steps": ["Ordinary shares are the core of equity.", "Preference shares split: irredeemable = equity, redeemable = a liability in substance.", "Borrowings are liabilities and their interest is an expense."]},
						"practice": [
							{"type": "sort", "q": "Classify each item in a company's statement of financial position.", "buckets": ["Equity", "Liability"], "items": [["Ordinary share capital", 0], ["Share premium", 0], ["Redeemable preference shares", 1], ["Irredeemable preference shares", 0], ["Loan notes", 1], ["Retained earnings", 0]], "ex": "Redeemable preference shares and loan notes are liabilities; everything else listed is equity."},
							{"type": "choice", "q": "The dividend on REDEEMABLE preference shares is shown as:", "opts": ["A finance cost in profit or loss", "An appropriation in the statement of changes in equity", "Part of share premium", "A current asset"], "a": 0, "ex": "Redeemable preference shares are a liability, so their dividend is a finance cost like interest."},
							{"type": "multi", "q": "Which TWO statements about a limited company are correct?", "opts": ["Shareholders' liability is limited to the amount they invested", "The company pays tax on its own profits", "The owners run the business personally", "Its accounts are private"], "a": [0, 1], "ex": "Limited liability and corporation tax are features of companies. Directors run it, and company accounts are published."},
							{"type": "choice", "q": "Which holders are paid LAST if a company is wound up?", "opts": ["Ordinary shareholders", "Loan note holders", "Preference shareholders", "Trade payables"], "a": 0, "ex": "Ordinary shareholders take the residual - they rank after creditors and preference shareholders."}
						]
					},
					{
						"id": "L2", "title": "Issuing shares: at a premium, rights and bonus issues",
						"outcome": "D10(d) Share capital and share premium; D10(e)(g) Bonus issues; D10(f)(h) Rights issues",
						"apply": {"title": "Zuru Lemonade Ltd - more shares, two ways", "pages": [
							{"text": "A second kiosk needs cash. The company makes a [b]rights issue of 1 for 5 at 1.50[/b]: existing holders may buy one new share for every five they hold, at 1.50 a share. All 1,000 are taken up.\n\nThe nominal value is 1, so each 1.50 splits: 1 to share capital, 0.50 to [b]share premium[/b].", "table": {"cols": ["Rights issue", "Dr", "Cr"], "rows": [{"c": ["Cash (1,000 x 1.50)", "1,500", ""]}, {"c": ["   Share capital (1,000 x 1)", "", "1,000"]}, {"c": ["   Share premium (1,000 x 0.50)", "", "500"]}]}},
							{"text": "A year later the directors want more shares in circulation without asking for money: a [b]bonus issue of 1 for 6[/b] - 1,000 free shares to existing holders, paid for out of reserves. No cash moves; the company is worth exactly the same, just split into more pieces.", "table": {"cols": ["Bonus issue", "Dr", "Cr"], "rows": [{"c": ["Share premium", "1,000", ""]}, {"c": ["   Share capital", "", "1,000"]}]}},
							{"text": "Share premium is used first for a bonus issue because it can't be paid out as a dividend anyway; if it isn't enough, retained earnings make up the rest. Here the bonus needs 1,000 but the premium account only holds 500 - so the journal is Dr Share premium 500, Dr Retained earnings 500, Cr Share capital 1,000. After both issues: share capital [b]7,000[/b], share premium [b]nil[/b], retained earnings down 500. Exam check: rights issue = cash in, premium up; bonus issue = no cash, reserves down, capital up, total equity unchanged."}
						]},
						"learn": [
							{"text": "Shares have a [b]nominal (par) value[/b], e.g. $1. Share capital is ALWAYS recorded at nominal value. If shares are issued for more, the excess is credited to the [b]share premium[/b] account.\nIssue at a premium: [b]Dr Cash (full price), Cr Share capital (nominal), Cr Share premium (excess)[/b]."},
							{"text": "A [b]rights issue[/b] offers new shares to EXISTING shareholders, in proportion to their holding (e.g. '1 for 4'), usually below market price. It [b]raises cash[/b]: same entries as an issue at a premium.\nPros: cheap way to raise finance; shareholders keep their % if they take it up. Cons: bad press if not taken up; more shares to pay dividends on."},
							{"text": "A [b]bonus (capitalisation) issue[/b] gives existing shareholders FREE shares, e.g. '1 for 5'. [b]No cash[/b] is raised: reserves are converted into share capital.\n[b]Dr Share premium (first, if available) or retained earnings, Cr Share capital[/b] - at nominal value.\nPros: uses the share premium; lower share price makes shares more marketable. Con: shareholders may not understand it."},
							{"text": "Quick checks:\nNumber of new shares = existing shares x (new / old) from the ratio.\nRights: cash = new shares x issue price.\nBonus: amount = new shares x nominal value; comes OUT of reserves."}
						],
						"example": {"title": "Nova Ltd: three issues in one year ($1 shares)", "table": {"cols": ["", "Share capital", "Share premium", "Retained earnings", "Cash"], "rows": [
							{"c": ["Balances at 1 Jan: 100,000 shares", "100,000", "0", "60,000", ""], "s": 1},
							{"c": ["Issue 20,000 shares at $1.50", "+20,000", "+10,000", "", "+30,000"], "s": 2},
							{"c": ["Rights issue 1 for 4 at $1.20 (30,000 shares)", "+30,000", "+6,000", "", "+36,000"], "s": 3},
							{"c": ["Bonus issue 1 for 5 (30,000 shares)", "+30,000", "-16,000", "-14,000", "0"], "s": 4},
							{"c": ["Balances at 31 Dec", "180,000", "0", "46,000", "+66,000"], "s": 5, "b": true}]},
							"steps": ["Start: 100,000 $1 shares, no premium.", "Issue at $1.50: cash 30,000; capital 20,000 (nominal); premium 10,000.", "Rights 1 for 4 on 120,000 shares = 30,000 new shares x $1.20 = 36,000 cash; capital 30,000, premium 6,000.", "Bonus 1 for 5 on 150,000 shares = 30,000 free $1 shares = 30,000. Use the premium first (16,000) then retained earnings (14,000). No cash.", "Closing: 180,000 shares; premium used up; total cash raised 66,000."]},
						"practice": [
							{"type": "input", "q": "A company issues 40,000 shares of 50c each at 80c. How much is credited to SHARE PREMIUM?  (number)", "accept": ["12000"], "display_answer": "12,000", "ex": "(0.80 - 0.50) x 40,000 = 12,000. Share capital gets 20,000 (nominal)."},
							{"type": "input", "q": "A company with 300,000 $1 shares makes a 1 for 3 rights issue at $1.40. Cash raised = ?  (number)", "accept": ["140000"], "display_answer": "140,000", "ex": "300,000 / 3 = 100,000 new shares x $1.40 = 140,000."},
							{"type": "input", "q": "A company with 400,000 25c shares and share premium of 30,000 makes a 1 for 4 bonus issue. How much is taken from RETAINED EARNINGS?  (number)", "accept": ["0"], "display_answer": "0", "ex": "100,000 new shares x 25c = 25,000, which the 30,000 share premium covers in full. Nothing from retained earnings."},
							{"type": "picklist", "q": "A bonus issue is recorded: Debit {0}, Credit {1}, and the company's cash {2}.", "lists": [["Share premium / retained earnings", "Cash", "Share capital"], ["Share capital", "Share premium", "Bank"], ["does not change", "increases", "decreases"]], "a": [0, 0, 0], "ex": "Reserves are capitalised into share capital; no cash moves."},
							{"type": "choice", "q": "Which is an advantage of a RIGHTS issue over a bonus issue?", "opts": ["It raises cash for the company", "It is always taken up in full", "It reduces the number of shares", "It needs no shareholder approval"], "a": 0, "ex": "A rights issue brings in cash; a bonus issue doesn't."}
						]
					},
					{
						"id": "L3", "title": "Dividends, finance costs and income tax",
						"outcome": "D10(i) Dividends; D10(j) Interest expense; G2(c) Income tax including under/over-provision",
						"apply": {"title": "Zuru Lemonade Ltd - paying the people who funded it", "pages": [
							{"text": "Year 2's results are in: profit before interest and tax [b]4,000[/b]. Three claims on it, each treated differently:\n- The bank's [b]interest[/b]: 6% x 3,000 = 180. Only 90 has been paid; the rest is accrued. An [b]expense[/b] in the SOPL.\n- Mei's [b]preference dividend[/b] 80 and an [b]ordinary dividend[/b] of 0.05 a share on 6,000 shares = 300, both paid in the year. [b]Not expenses[/b] - deducted from retained earnings via the SOCE.\n- [b]Income tax[/b] on the profit."},
							{"text": "Tax is an estimate when the accounts are prepared. Last year the company estimated [b]500[/b]; the bill actually came to [b]520[/b] - an [b]under-provision of 20[/b]. This year's estimate is [b]600[/b].", "table": {"cols": ["Income tax", "", ""], "rows": [{"c": ["Current year estimate", "600", "-> liability in the SOFP"]}, {"c": ["Under-provision for last year", "20", ""]}, {"c": ["Tax charge in the SOPL", "620", ""], "b": true}, {"c": ["Journals: Income tax expense / Tax payable 600; Income tax expense / Tax payable 20 (clearing last year's shortfall)", "", ""]}]}},
							{"text": "", "table": {"cols": ["SOPL (bottom half) - year 2", ""], "rows": [{"c": ["Operating profit", "4,000"]}, {"c": ["Finance costs (interest)", "(180)"]}, {"c": ["Profit before tax", "3,820"]}, {"c": ["Income tax expense", "(620)"]}, {"c": ["Profit for the year", "3,200"], "b": true}, {"c": ["Dividends 380 - NOT here; in the SOCE", ""]}]}}
						]},
						"learn": [
							{"text": "[b]Ordinary dividends[/b] (and irredeemable preference dividends) are NOT an expense - they are an [b]appropriation[/b] of profit: [b]Dr Retained earnings, Cr Bank[/b], shown in the statement of changes in equity.\nA dividend [b]proposed after[/b] the year-end is not a liability - disclose it in a note only."},
							{"text": "[b]Finance costs[/b] - interest on loan notes and bank loans, and dividends on redeemable preference shares - ARE expenses in profit or loss: Dr Finance cost, Cr Bank (or Cr Accruals if unpaid at the year-end)."},
							{"text": "[b]Income tax[/b]: the company estimates the tax on this year's profit. The estimate is a [b]current liability[/b] in the SOFP and a charge in profit or loss.\nLast year's estimate is rarely exactly right. When the actual bill is settled, the difference is adjusted in THIS year's charge:\n[b]Charge = this year's estimate + under-provision (or - over-provision) from last year[/b]."}
						],
						"example": {"title": "Tax for the year", "table": {"cols": ["", "$"], "rows": [
							{"c": ["Tax liability at 1 Jan (last year's estimate)", "8,000"], "s": 1}, {"c": ["Actually paid in the year to settle it", "8,500"], "s": 1}, {"c": ["Under-provision last year", "500"], "s": 1, "b": true},
							{"c": ["Estimate of tax on this year's profit", "12,000"], "s": 2},
							{"c": ["Income tax charge in profit or loss (12,000 + 500)", "12,500"], "s": 3, "b": true}, {"c": ["Tax liability in the SOFP at 31 Dec", "12,000"], "s": 3, "b": true}]},
							"steps": ["Last year 8,000 was estimated but 8,500 was paid: 500 under-provided.", "This year's profit attracts an estimated 12,000.", "The SOPL charge includes the catch-up: 12,500. The SOFP shows only the current estimate still owed: 12,000."]},
						"practice": [
							{"type": "input", "q": "Tax liability brought forward 10,000; paid in the year 9,400; estimate for this year 15,000. Income tax charge in profit or loss = ?  (number)", "accept": ["14400"], "display_answer": "14,400", "ex": "Over-provision last year 600 (10,000 - 9,400). Charge = 15,000 - 600 = 14,400."},
							{"type": "input", "q": "Using the same figures (estimate 15,000), what tax liability is shown in the SOFP at the year-end?  (number)", "accept": ["15000"], "display_answer": "15,000", "ex": "Only the current year's estimate remains owed."},
							{"type": "choice", "q": "A final ordinary dividend is PROPOSED by the directors after the year-end but before the accounts are approved. It is:", "opts": ["Disclosed in a note - not a liability", "Recognised as a current liability", "Charged as an expense", "Deducted from share premium"], "a": 0, "ex": "There is no obligation at the year-end, so it is disclosed only."},
							{"type": "picklist", "q": "Interest of 4,000 on loan notes is unpaid at the year-end: Debit {0} 4,000, Credit {1} 4,000.", "lists": [["Finance costs", "Retained earnings", "Loan notes"], ["Accruals", "Bank", "Share premium"]], "a": [0, 0], "ex": "Interest is an expense; unpaid interest is accrued as a liability."},
							{"type": "choice", "q": "An ordinary dividend PAID during the year is recorded as:", "opts": ["Dr Retained earnings, Cr Bank", "Dr Finance costs, Cr Bank", "Dr Share capital, Cr Bank", "Dr Bank, Cr Retained earnings"], "a": 0, "ex": "Dividends are an appropriation of retained earnings, shown in the SOCE, not an expense."}
						]
					},
					{
						"id": "L4", "title": "Reserves and the statement of changes in equity",
						"outcome": "D10(b)(c) Reserves and other components of equity; D10(k) Components of the statement of changes in equity",
						"apply": {"title": "Zuru Lemonade Ltd - the statement of changes in equity", "pages": [
							{"text": "Equity is more than one number. By the end of year 2 the company has share capital, share premium (from the rights issue), a revaluation surplus (the kiosk, Chapter 8) and retained earnings. The [b]statement of changes in equity[/b] shows every column moving from the start of the year to the end - the bridge between the SOPL and the SOFP."},
							{"text": "", "table": {"cols": ["SOCE - year 2", "Share capital", "Share premium", "Revaluation surplus", "Retained earnings", "Total"], "rows": [{"c": ["At 1 January", "5,000", "-", "-", "900", "5,900"]}, {"c": ["Profit for the year", "", "", "", "3,200", "3,200"]}, {"c": ["Revaluation of kiosk (OCI)", "", "", "7,000", "", "7,000"]}, {"c": ["Rights issue", "1,000", "500", "", "", "1,500"]}, {"c": ["Dividends paid", "", "", "", "(380)", "(380)"]}, {"c": ["At 31 December", "6,000", "500", "7,000", "3,720", "17,220"], "b": true}]}},
							{"text": "[b]Retained earnings[/b] is the only reserve that can be paid out as dividends - profits kept in the business. [b]Share premium[/b] and the [b]revaluation surplus[/b] are capital reserves: they can fund a bonus issue or be transferred (excess depreciation), but never distributed. The 17,220 total is exactly the equity line on the SOFP, and the 3,200 is exactly the profit on the SOPL - if either doesn't tie, the question has a trap in it."}
						]},
						"learn": [
							{"text": "Equity has several [b]reserves[/b]:\n[b]Share premium[/b] - excess over nominal on share issues (not distributable).\n[b]Revaluation surplus[/b] - unrealised gains on revalued assets (not distributable).\n[b]Retained earnings[/b] - accumulated profits less dividends (distributable - dividends come from here).\nOthers, e.g. a general reserve, are transfers out of retained earnings."},
							{"text": "The [b]statement of changes in equity (SOCE)[/b] shows how each part of equity moved during the year. One column per component plus a total; one row per movement:\n- Balance at the start\n- Profit for the year (to retained earnings)\n- Other comprehensive income (revaluation gain to the surplus)\n- Dividends (from retained earnings)\n- Share issues (capital + premium)\n- Bonus issue (between reserves and capital)\n- Transfers (e.g. excess depreciation from the surplus to retained earnings)\n- Balance at the end"},
							{"text": "Check: the closing total equity in the SOCE must equal total equity in the SOFP."}
						],
						"example": {"title": "SOCE for Nova Ltd ($000)", "table": {"cols": ["", "Share capital", "Share premium", "Revaluation surplus", "Retained earnings", "Total"], "rows": [
							{"c": ["Balance at 1 Jan", "100", "0", "0", "60", "160"], "s": 1},
							{"c": ["Profit for the year", "", "", "", "35", "35"], "s": 2}, {"c": ["Revaluation gain (OCI)", "", "", "25", "", "25"], "s": 2},
							{"c": ["Dividends paid", "", "", "", "(12)", "(12)"], "s": 3},
							{"c": ["Share issue", "20", "10", "", "", "30"], "s": 4}, {"c": ["Rights issue", "30", "6", "", "", "36"], "s": 4}, {"c": ["Bonus issue", "30", "(16)", "", "(14)", "0"], "s": 4},
							{"c": ["Balance at 31 Dec", "180", "0", "25", "69", "274"], "s": 5, "b": true}]},
							"steps": ["Opening balances from last year's SOFP.", "Profit goes to retained earnings; the revaluation gain goes to the revaluation surplus (through OCI).", "Dividends reduce retained earnings only.", "Share issues add capital and premium; the bonus issue moves 30 into capital out of reserves - total unchanged.", "Closing total equity 274 - this must match the SOFP."]},
						"practice": [
							{"type": "input", "q": "Retained earnings at 1 Jan 48,000; profit for the year 26,000; dividends paid 9,000; bonus issue of 5,000 funded from retained earnings. Retained earnings at 31 Dec = ?  (number)", "accept": ["60000"], "display_answer": "60,000", "ex": "48,000 + 26,000 - 9,000 - 5,000 = 60,000."},
							{"type": "sort", "q": "Which column of the SOCE does each item affect?", "buckets": ["Retained earnings", "Revaluation surplus", "Share capital / premium"], "items": [["Profit for the year", 0], ["Dividends paid", 0], ["Gain on revaluing a building", 1], ["New shares issued for cash", 2], ["Transfer of excess depreciation", 0]], "ex": "Profit, dividends and the excess depreciation transfer land in retained earnings; revaluation gains in the surplus; share issues in capital and premium."},
							{"type": "multi", "q": "Which TWO reserves are NOT distributable as dividends?", "opts": ["Share premium", "Revaluation surplus", "Retained earnings", "General reserve"], "a": [0, 1], "ex": "Share premium and the revaluation surplus are capital reserves - they cannot be paid out as dividends."},
							{"type": "choice", "q": "Total equity in the statement of changes in equity at the year-end should equal:", "opts": ["Total equity in the statement of financial position", "Profit for the year", "Net current assets", "Total assets"], "a": 0, "ex": "The SOCE explains the movement to the equity figure shown in the SOFP."}
						]
					}
				]
			},
			{
				"id": 20, "title": "Preparation of financial statements for companies", "monster": "The Boardroom Behemoth",
				"beats": [
					{"type":"choice","q":"A final dividend proposed AFTER the year-end is:","opts":["Recognised as a liability","Not recognised, only disclosed by note","Charged as a P&L expense","Added to revenue"],"a":1,"ex":"A dividend proposed after the reporting date is disclosed by note only."},
					{"type":"choice","q":"Interest on loan notes is:","opts":["An appropriation of profit","An expense (finance cost) in the SOPL","Credited to share premium","A dividend"],"a":1,"ex":"Loan note interest is a finance cost in the SOPL."},
					{"type":"input","q":"A dividend of 0.10 per share is paid on 200,000 shares. The amount = ?  (number)","accept":["20000"],"display_answer":"20,000","ex":"200,000 x 0.10 = 20,000, an appropriation of profit."},
					{"type":"input","q":"Last year's tax liability of 5,000 was settled for 5,600. This year's estimate is 9,000. Tax charge in profit or loss = ?  (number)","accept":["9600"],"display_answer":"9,600","ex":"9,000 current estimate + 600 under-provision from last year = 9,600."}
				],
				# Ch 20 learning objectives: G1(b), G2(a)-(e), G3(a), G3(b)(i)-(iv), D10(k), D4(i), D5(e) + IFRS 15 revenue.
				# SOPL layout follows IFRS 18 (examinable from Sept 2025): operating / investing / financing / income tax categories.
				"lessons": [
					{
						"id": "L1", "title": "The company statement of profit or loss (IFRS 18 layout)",
						"outcome": "G2(a) Calculate revenue, cost of sales, gross profit, operating profit, profit before financing and income taxes, profit before tax, profit, total comprehensive income; G2(b) Prepare the SOPL and OCI; G2(d) Separate disclosure; G2(e) Links to the SOFP",
						"apply": {"title": "Zuru Lemonade Ltd - year 3 in the IFRS 18 layout", "pages": [
							{"text": "Year 3: two kiosks, bottled YUZURU in six cafes. The company's statement of profit or loss now follows IFRS 18's categories: [b]operating[/b] (the lemonade business), [b]investing[/b] (returns on money parked elsewhere), [b]financing[/b] (the cost of borrowing), then [b]income tax[/b] - with the two mandatory subtotals.", "table": {"cols": ["Statement of profit or loss - year 3", ""], "rows": [{"c": ["Revenue", "24,000"]}, {"c": ["Cost of sales", "(10,000)"]}, {"c": ["Gross profit", "14,000"], "b": true}, {"c": ["Distribution costs (vans, Yuki's deliveries)", "(3,000)"]}, {"c": ["Administrative expenses (kiosk rent, Hana's admin, depreciation)", "(4,500)"]}, {"c": ["Operating profit", "6,500"], "b": true}, {"c": ["Interest income on the deposit account (investing)", "100"]}, {"c": ["Profit before financing and income taxes", "6,600"], "b": true}, {"c": ["Finance costs (bank loan interest)", "(180)"]}, {"c": ["Profit before tax", "6,420"]}, {"c": ["Income tax expense", "(1,300)"]}, {"c": ["Profit for the year", "5,120"], "b": true}]}},
							{"text": "Below profit comes [b]other comprehensive income[/b] - gains that are real but not realised, like the revaluation of the second kiosk this year, [b]1,000[/b]:", "table": {"cols": ["", ""], "rows": [{"c": ["Profit for the year", "5,120"]}, {"c": ["Other comprehensive income: revaluation surplus", "1,000"]}, {"c": ["Total comprehensive income", "6,120"], "b": true}]}},
							{"text": "The links to the SOFP: the 5,120 goes to retained earnings (via the SOCE), the 1,000 to the revaluation surplus, and the 1,300 tax becomes a current liability until it is paid. [b]Separate disclosure[/b]: anything unusual and material - a big write-off of a kiosk, a one-off legal cost - gets its own line or note so Taro can see it isn't normal trading. Dividends still appear nowhere on this statement."}
						]},
						"learn": [
							{"text": "A company's statement of profit or loss groups income and expenses into [b]categories[/b] (IFRS 18):\n[b]Operating[/b] - the main business: revenue, cost of sales, distribution costs, administrative expenses.\n[b]Investing[/b] - returns on investments, e.g. dividends and interest received, rental income.\n[b]Financing[/b] - the cost of borrowing: interest on loans and loan notes.\n[b]Income taxes[/b]."},
							{"text": "Three subtotals MUST be shown:\n[b]Operating profit[/b]\n[b]Profit before financing and income taxes[/b]\n[b]Profit (for the year)[/b]\nMost companies also show gross profit and profit before tax. Discontinued operations are NOT examinable in FA/FFA."},
							{"text": "Expenses are shown by [b]function[/b]:\n[b]Cost of sales[/b] - opening inventory + purchases - closing inventory, plus production costs and depreciation of plant.\n[b]Distribution costs[/b] - delivery, sales staff, advertising, warehouse.\n[b]Administrative expenses[/b] - office costs, management salaries, office depreciation, irrecoverable debts (unless the question says otherwise)."},
							{"text": "Below profit for the year comes [b]other comprehensive income (OCI)[/b] - unrealised gains such as a [b]revaluation surplus[/b] on property. Profit + OCI = [b]total comprehensive income[/b].\n\nLink to the SOFP: profit for the year is added to [b]retained earnings[/b]; the revaluation gain goes to the [b]revaluation surplus[/b]; the tax charge creates the [b]tax payable[/b] liability."}
						],
						"example": {"title": "Comet Co - SOPL and OCI for the year", "table": {"cols": ["", "$"], "rows": [
							{"c": ["Revenue", "500,000"], "s": 1}, {"c": ["Cost of sales", "(300,000)"], "s": 1}, {"c": ["Gross profit", "200,000"], "s": 1, "b": true},
							{"c": ["Distribution costs", "(40,000)"], "s": 2}, {"c": ["Administrative expenses", "(60,000)"], "s": 2}, {"c": ["Operating profit", "100,000"], "s": 2, "b": true},
							{"c": ["Investment income (investing category)", "5,000"], "s": 3}, {"c": ["Profit before financing and income taxes", "105,000"], "s": 3, "b": true},
							{"c": ["Finance costs (financing category)", "(15,000)"], "s": 4}, {"c": ["Profit before tax", "90,000"], "s": 4}, {"c": ["Income tax expense", "(22,000)"], "s": 4}, {"c": ["Profit for the year", "68,000"], "s": 4, "b": true},
							{"c": ["Other comprehensive income: gain on revaluation of property", "30,000"], "s": 5}, {"c": ["Total comprehensive income for the year", "98,000"], "s": 5, "b": true}]},
							"steps": ["Operating category starts with revenue less cost of sales = gross profit.", "Distribution and administrative expenses bring it down to OPERATING PROFIT (mandatory subtotal).", "Investing category: investment income is added to give PROFIT BEFORE FINANCING AND INCOME TAXES (mandatory).", "Financing: finance costs, then tax, give PROFIT FOR THE YEAR (mandatory).", "OCI: the revaluation gain. Total comprehensive income = 68,000 + 30,000 = 98,000."]},
						"practice": [
							{"type": "input", "q": "Revenue 640,000; cost of sales 390,000; distribution costs 55,000; administrative expenses 82,000. Operating profit = ?  (number)", "accept": ["113000"], "display_answer": "113,000", "ex": "640,000 - 390,000 - 55,000 - 82,000 = 113,000."},
							{"type": "input", "q": "Operating profit 113,000; rental income from an investment property 8,000; interest on loan notes 12,000; income tax 24,000. Profit for the year = ?  (number)", "accept": ["85000"], "display_answer": "85,000", "ex": "113,000 + 8,000 = 121,000 before financing and tax; less 12,000 and 24,000 = 85,000."},
							{"type": "sort", "q": "Which category of the statement of profit or loss does each item belong to?", "buckets": ["Operating", "Investing", "Financing"], "items": [["Revenue", 0], ["Depreciation of delivery vans", 0], ["Dividends received on shares held", 1], ["Interest on a bank loan", 2], ["Administrative salaries", 0], ["Interest on loan notes", 2]], "ex": "Day-to-day trading items are operating; returns on investments are investing; the cost of borrowing is financing."},
							{"type": "multi", "q": "Which TWO subtotals MUST be presented in the statement of profit or loss?", "opts": ["Operating profit", "Profit before financing and income taxes", "Gross profit", "Profit before distribution costs"], "a": [0, 1], "ex": "Operating profit, profit before financing and income taxes, and profit for the year are mandatory. Gross profit is common but optional."},
							{"type": "choice", "q": "A gain on revaluing a company's head office is shown:", "opts": ["In other comprehensive income, below profit for the year", "In operating profit", "In the investing category", "In finance costs"], "a": 0, "ex": "Revaluation gains are unrealised, so they go to OCI (and the revaluation surplus in equity)."}
						]
					},
					{
						"id": "L2", "title": "The company statement of financial position",
						"outcome": "G1(b) Prepare a company SOFP or extracts; D10(k) The SOCE ties to equity; D5(e) Revalued assets in the statements",
						"apply": {"title": "Zuru Lemonade Ltd - the company balance sheet", "pages": [
							{"text": "The company SOFP at the end of year 3 has the same shape Zuru learned as a sole trader, with three differences: the equity section is split into its reserves, there is a [b]tax payable[/b] line, and the loan sits in non-current liabilities.", "table": {"cols": ["Statement of financial position - 31 December, year 3", "", ""], "rows": [{"c": ["Property, plant and equipment (kiosks at valuation, carts at cost less depreciation)", "", "30,500"]}, {"c": ["Intangible assets (trademark, development)", "", "800"]}, {"c": ["Inventories", "1,400", ""]}, {"c": ["Trade receivables (net of allowance)", "2,600", ""]}, {"c": ["Prepayments", "180", ""]}, {"c": ["Cash", "1,920", ""]}, {"c": ["Current assets", "", "6,100"]}, {"c": ["Total assets", "", "37,400"], "b": true}]}},
							{"text": "", "table": {"cols": ["Equity and liabilities", "", ""], "rows": [{"c": ["Share capital", "6,000", ""]}, {"c": ["Share premium", "500", ""]}, {"c": ["Revaluation surplus", "8,000", ""]}, {"c": ["Retained earnings", "8,460", ""]}, {"c": ["Total equity (= SOCE closing total)", "", "22,960"], "b": true}, {"c": ["Bank loan (non-current)", "", "2,400"]}, {"c": ["Trade payables", "7,800", ""]}, {"c": ["Accruals", "600", ""]}, {"c": ["Tax payable", "1,300", ""]}, {"c": ["Deferred income (dojo open day)", "120", ""]}, {"c": ["Current liabilities", "", "9,820"]}, {"c": ["Sales tax payable (within payables)", "", ""]}, {"c": ["Total equity and liabilities", "", "37,400"], "b": true}]}},
							{"text": "Three things to check in any company SOFP question:\n- [b]Equity total = SOCE closing total[/b] - here 22,960, with retained earnings carrying this year's 5,120 profit less dividends.\n- [b]Revalued assets[/b] are shown at the revalued amount less depreciation since the revaluation; the surplus sits in equity, not in profit.\n- The [b]current-year tax[/b] estimate is a current liability; the loan instalment due within 12 months (600) would be shown as current, the rest (2,400) non-current."}
						]},
						"learn": [
							{"text": "The company SOFP has the same assets as a sole trader's, but the bottom half is different:\n[b]Equity[/b]: share capital, share premium, revaluation surplus, retained earnings.\n[b]Non-current liabilities[/b]: loan notes, bank loans due after one year, redeemable preference shares.\n[b]Current liabilities[/b]: trade payables, accruals (incl. accrued interest), [b]income tax payable[/b], bank overdraft."},
							{"text": "Retained earnings at the year-end = opening retained earnings + profit for the year - dividends paid. (Dividends paid come straight out of retained earnings - never through the SOPL.)"},
							{"text": "Property shown at a [b]revalued amount[/b] appears at that valuation less depreciation since the revaluation; the gain sits in the revaluation surplus. Loan notes are shown at the amount borrowed; the year's interest is a finance cost, with any unpaid part [b]accrued[/b].\n\nCheck: Total assets = Equity + Non-current liabilities + Current liabilities."}
						],
						"example": {"title": "Comet Co - SOFP extracts at the year-end", "table": {"cols": ["", "$"], "rows": [
							{"c": ["Property at valuation (after revaluation)", "330,000"], "s": 1}, {"c": ["Plant (carrying amount)", "95,000"], "s": 1}, {"c": ["Current assets", "140,000"], "s": 1}, {"c": ["Total assets", "565,000"], "s": 1, "b": true},
							{"c": ["Share capital ($1 shares)", "200,000"], "s": 2}, {"c": ["Share premium", "40,000"], "s": 2}, {"c": ["Revaluation surplus", "30,000"], "s": 2}, {"c": ["Retained earnings (80,000 + 68,000 - 25,000 dividends)", "123,000"], "s": 2}, {"c": ["Total equity", "393,000"], "s": 2, "b": true},
							{"c": ["6% loan notes", "100,000"], "s": 3}, {"c": ["Trade payables and accruals", "50,000"], "s": 3}, {"c": ["Income tax payable", "22,000"], "s": 3}, {"c": ["Total equity and liabilities", "565,000"], "s": 3, "b": true}]},
							"steps": ["Assets as usual: the revalued property, plant at carrying amount, current assets.", "Equity: capital and premium from share issues; the 30,000 OCI gain in the surplus; retained earnings rolled forward with this year's 68,000 profit less dividends paid.", "Liabilities: the loan notes (non-current) and current liabilities including the 22,000 tax charge still unpaid. 565,000 both sides."]},
						"practice": [
							{"type": "input", "q": "Retained earnings at 1 January 142,000; profit for the year 57,000; dividends paid 18,000; a bonus issue of 10,000 was made from retained earnings. Retained earnings at 31 December = ?  (number)", "accept": ["171000"], "display_answer": "171,000", "ex": "142,000 + 57,000 - 18,000 - 10,000 = 171,000."},
							{"type": "sort", "q": "Where does each item appear in a company's SOFP?", "buckets": ["Equity", "Non-current liabilities", "Current liabilities"], "items": [["Revaluation surplus", 0], ["8% loan notes repayable in 5 years", 1], ["Income tax payable", 2], ["Accrued loan note interest", 2], ["Share premium", 0], ["Redeemable preference shares (redeemable in 3 years)", 1]], "ex": "Reserves are equity; long-term borrowings (including redeemable preference shares) are non-current liabilities; tax and accrued interest are due within a year."},
							{"type": "input", "q": "A company has 10% loan notes of 200,000. During the year it paid 15,000 of interest. What accrued interest is shown in current liabilities at the year-end?  (number)", "accept": ["5000"], "display_answer": "5,000", "ex": "Interest for the year = 10% x 200,000 = 20,000; 15,000 paid, so 5,000 is accrued. The finance cost in the SOPL is the full 20,000."},
							{"type": "choice", "q": "Dividends PAID during the year are:", "opts": ["Deducted from retained earnings in the SOFP (via the SOCE)", "An expense in the statement of profit or loss", "A current liability", "Added to share premium"], "a": 0, "ex": "Dividends are an appropriation of retained earnings, not an expense."}
						]
					},
					{
						"id": "L3", "title": "Revenue: IFRS 15",
						"outcome": "G2(a) Revenue under IFRS 15 - recognise when control transfers; D1(f) Settlement discounts under IFRS 15",
						"apply": {"title": "Zuru Lemonade Ltd - when is a sale a sale?", "pages": [
							{"text": "Three deals in December, and the question for each is the same: when does [b]control[/b] of the lemonade pass to the customer?\n1. The gym pays [b]1,200 up front[/b] for 12 monthly deliveries of bottles, January to December next year.\n2. A gift shop takes 100 bottles on [b]sale or return[/b] - it pays only for what it sells and sends the rest back.\n3. The cafe orders 500 bottles; they are delivered on 29 December, invoiced on 3 January, paid in February."},
							{"text": "", "table": {"cols": ["Deal", "Revenue this year", "Why"], "rows": [{"c": ["Gym's 1,200 for next year", "0 - it is deferred income (liability); 100 a month next year", "Control passes delivery by delivery"]}, {"c": ["Gift shop, sale or return (20 sold by 31 Dec)", "20 bottles' worth", "The other 80 are still Zuru's inventory - control hasn't passed"]}, {"c": ["Cafe's 500 bottles delivered 29 Dec", "The full 1,000", "Delivered = control passed; invoice date and cash date don't matter"]}]}},
							{"text": "IFRS 15 in five steps, as Zuru uses it: identify the [b]contract[/b], identify the [b]performance obligations[/b] (each delivery), set the [b]price[/b] (net of trade discount, and of a settlement discount the customer is expected to take), [b]allocate[/b] it, and recognise revenue [b]when each obligation is satisfied[/b]. The settlement-discount rule from Chapter 14 is just step 3 - the price is what she expects to receive."}
						]},
						"learn": [
							{"text": "Under [b]IFRS 15[/b] a company recognises revenue to show the [b]transfer of goods or services[/b] to customers, at the amount it expects to be entitled to. Revenue is recognised when (or as) [b]control passes[/b] to the customer - not when cash is received or an invoice is raised."},
							{"text": "The five steps:\n1. Identify the [b]contract[/b].\n2. Identify the separate [b]performance obligations[/b] (promises).\n3. Determine the [b]transaction price[/b].\n4. [b]Allocate[/b] the price to the obligations.\n5. Recognise revenue when (or as) each obligation is [b]satisfied[/b]."},
							{"text": "[b]Point in time[/b]: goods - revenue when delivered (control passes), even if invoiced or paid later.\n[b]Over time[/b]: services such as a 12-month maintenance contract - revenue spread over the period.\nCash received BEFORE the service is provided is a [b]contract liability[/b] (deferred income), not revenue yet."}
						],
						"example": {"title": "Three sales at a 31 December year-end", "table": {"cols": ["Transaction", "Revenue this year", "Why"], "rows": [
							{"c": ["Goods delivered 28 Dec, invoiced 5 Jan, 9,000", "9,000", "Control passed in December"], "s": 1},
							{"c": ["12-month maintenance contract, 2,400 received 1 Oct", "600", "3 of 12 months done; 1,800 is a contract liability"], "s": 2},
							{"c": ["Deposit of 1,000 received for goods to be delivered in February", "0", "Nothing transferred yet - contract liability"], "s": 3}]},
							"steps": ["Delivery is what counts: the goods were delivered this year, so the revenue belongs here.", "The service is provided over time: October-December = 3/12 x 2,400 = 600; the rest is deferred.", "A deposit before delivery is a liability to deliver, not revenue."]},
						"practice": [
							{"type": "input", "q": "A customer pays 3,600 on 1 November for a 12-month support contract. Year-end 31 December. Revenue recognised this year = ?  (number)", "accept": ["600"], "display_answer": "600", "ex": "2/12 x 3,600 = 600. The remaining 3,000 is a contract liability."},
							{"type": "choice", "q": "Under IFRS 15, revenue from the sale of goods is recognised when:", "opts": ["Control of the goods passes to the customer", "The invoice is raised", "The cash is received", "The order is placed"], "a": 0, "ex": "Revenue depicts the transfer of control, whatever the invoice or cash timing."},
							{"type": "picklist", "q": "A deposit received from a customer before goods are delivered is shown as a {0} and recognised as revenue {1}.", "lists": [["contract liability", "contract asset", "receivable"], ["when the goods are delivered", "when the deposit is received", "never"]], "a": [0, 0], "ex": "Until delivery the company owes the customer goods - a liability. Revenue follows control."},
							{"type": "choice", "q": "Which is the FIRST step of the IFRS 15 five-step model?", "opts": ["Identify the contract with the customer", "Determine the transaction price", "Recognise revenue", "Allocate the price to performance obligations"], "a": 0, "ex": "Contract, obligations, price, allocate, recognise."}
						]
					},
					{
						"id": "L4", "title": "Notes to the financial statements",
						"outcome": "G3(a) Purpose of disclosure notes; G3(b) Draft notes: non-current assets, provisions, events after the reporting period, inventories; D4(i) PPE movements",
						"apply": {"title": "Zuru Lemonade Ltd - the small print Taro reads", "pages": [
							{"text": "Taro, 300 miles away, reads the notes more carefully than the statements. A single SOFP line - 'Property, plant and equipment 30,500' - tells him little. The [b]notes[/b] explain the policies behind the numbers and break the big ones down.", "table": {"cols": ["Property, plant and equipment", "Kiosks", "Carts and equipment", "Total"], "rows": [{"c": ["Cost or valuation at 1 Jan", "26,000", "2,900", "28,900"]}, {"c": ["Additions", "-", "2,000", "2,000"]}, {"c": ["Revaluation", "1,000", "-", "1,000"]}, {"c": ["Disposals", "-", "(700)", "(700)"]}, {"c": ["At 31 Dec", "27,000", "4,200", "31,200"]}, {"c": ["Depreciation at 1 Jan", "-", "860", "860"]}, {"c": ["Charge for the year", "833", "607", "1,440"]}, {"c": ["Disposals", "-", "(600)", "(600)"]}, {"c": ["At 31 Dec", "833", "867", "1,700"]}, {"c": ["Carrying amount 31 Dec", "26,167", "3,333", "29,500"], "b": true}]}},
							{"text": "Three more notes the FA exam asks you to draft:\n- [b]Inventories[/b]: 'valued at the lower of cost (FIFO) and net realisable value' - plus the amount by category (ingredients 400, bottles 1,000).\n- [b]Provisions[/b]: opening 400, used (350), released (50), new provisions 0, closing 0 - and what it was for.\n- [b]Events after the reporting period[/b]: the cart fire in February (next chapter), with its financial effect, because it is non-adjusting but material."},
							{"text": "Notes are where the [b]qualitative characteristics[/b] from Chapter 3 get delivered: comparability (same policies each year, stated), understandability (plain words), faithful representation (nothing hidden). A number in the statements that doesn't tie to its note is the first thing an auditor - or an examiner - will pick on."}
						]},
						"learn": [
							{"text": "The [b]notes[/b] explain and expand the figures on the face of the statements: the accounting policies used, breakdowns of totals, movements during the year, and information that has no number (e.g. a contingent liability). Users need them to understand and compare the statements."},
							{"text": "Examinable notes:\n[b]Property, plant and equipment[/b] - a table per class: cost (opening, additions, disposals, revaluation, closing), accumulated depreciation (opening, charge, disposals, closing), carrying amounts.\n[b]Intangible assets[/b] - same layout with amortisation."},
							{"text": "[b]Inventories[/b] - the policy (lower of cost and NRV; FIFO or AVCO) and a split into raw materials, work in progress and finished goods.\n[b]Provisions[/b] - a movement table: opening balance, amounts added, amounts used, amounts released, closing; plus a description of the obligation and expected timing."},
							{"text": "[b]Events after the reporting period[/b] - for a material NON-adjusting event: the nature of the event and an estimate of its financial effect (or a statement that it can't be estimated).\n[b]Contingent liabilities[/b] - nature, estimate of the effect, uncertainties."}
						],
						"example": {"title": "Provision note - warranty provision", "table": {"cols": ["", "$"], "rows": [
							{"c": ["Balance at 1 January", "32,000"], "s": 1}, {"c": ["Charged to profit or loss during the year", "14,000"], "s": 2}, {"c": ["Used during the year (repairs carried out)", "(9,000)"], "s": 2}, {"c": ["Released (unused amounts reversed)", "(2,000)"], "s": 2},
							{"c": ["Balance at 31 December", "35,000"], "s": 3, "b": true}]},
							"steps": ["Start with last year's closing provision.", "Show what was added (an expense), what was actually spent against it, and anything released because it was no longer needed.", "The closing balance appears as a liability in the SOFP: 32,000 + 14,000 - 9,000 - 2,000 = 35,000."]},
						"practice": [
							{"type": "input", "q": "Provision at 1 Jan 20,000; charged in the year 11,000; used 7,500; released 1,500. Provision at 31 Dec = ?  (number)", "accept": ["22000"], "display_answer": "22,000", "ex": "20,000 + 11,000 - 7,500 - 1,500 = 22,000."},
							{"type": "sort", "q": "Which note would each item appear in?", "buckets": ["PPE note", "Inventories note", "Events after the reporting period note"], "items": [["Depreciation charge for the year by class of asset", 0], ["Split between raw materials, WIP and finished goods", 1], ["A major fire at a warehouse two weeks after the year-end", 2], ["Additions and disposals during the year", 0], ["The valuation policy: lower of cost and NRV", 1]], "ex": "Movements and charges go in the PPE note; categories and policy in the inventories note; material non-adjusting events in the events note."},
							{"type": "multi", "q": "Which TWO are purposes of the notes to the financial statements?", "opts": ["To explain the accounting policies used", "To give breakdowns and movements behind the figures on the face of the statements", "To replace the statement of financial position", "To show the directors' bonuses only"], "a": [0, 1], "ex": "Notes explain policies and give the detail behind the headline figures."},
							{"type": "choice", "q": "For a material NON-adjusting event after the reporting period, the note should give:", "opts": ["The nature of the event and an estimate of its financial effect", "A revised statement of financial position", "Nothing - non-adjusting events are ignored", "Only the date of the event"], "a": 0, "ex": "Non-adjusting events are disclosed with their nature and estimated effect, but the statements are not changed."}
						]
					}
				],
				# Section B 15-mark MTQ (company: IFRS 18 SOPL with revaluation, accrued interest, tax under/over-provision; SOFP equity and liabilities).
				"mtq": {
					"title": "Section B: Kestrel Co", "monster": "The Boardroom Behemoth", "marks": 15,
					"scenario": [
						{"text": "Kestrel Co's trial balance at [b]31 December 20X9[/b] is below."},
						{"table": {"cols": ["Trial balance at 31 Dec 20X9", "Dr $", "Cr $"], "rows": [
							{"c": ["Revenue", "", "820,000"]}, {"c": ["Cost of sales", "490,000", ""]}, {"c": ["Distribution costs", "74,000", ""]}, {"c": ["Administrative expenses", "96,000", ""]},
							{"c": ["Loan note interest paid", "6,000", ""]}, {"c": ["Investment income", "", "4,000"]},
							{"c": ["Land and buildings - cost (land 100,000)", "400,000", ""]}, {"c": ["Buildings - accumulated depreciation at 1 Jan 20X9", "", "60,000"]},
							{"c": ["Plant - cost", "150,000", ""]}, {"c": ["Plant - accumulated depreciation at 1 Jan 20X9", "", "54,000"]},
							{"c": ["Inventory at 31 Dec 20X9", "62,000", ""]}, {"c": ["Trade receivables", "88,000", ""]}, {"c": ["Bank", "197,000", ""]}, {"c": ["Trade payables", "", "57,000"]},
							{"c": ["Income tax liability at 1 Jan 20X9", "", "32,000"]}, {"c": ["Income tax paid during the year", "30,000", ""]},
							{"c": ["8% loan notes (repayable 20Y5)", "", "150,000"]}, {"c": ["Ordinary share capital ($1 shares)", "", "300,000"]}, {"c": ["Share premium", "", "40,000"]},
							{"c": ["Retained earnings at 1 Jan 20X9", "", "96,000"]}, {"c": ["Dividends paid", "20,000", ""]}, {"c": ["Total", "1,613,000", "1,613,000"], "b": true}]}},
						{"text": "[b]Notes[/b]\n1. Cost of sales already includes the inventory adjustments.\n2. Buildings are depreciated at 2% a year straight line on cost (charge to administrative expenses). Land is not depreciated. Plant is depreciated at 20% a year reducing balance (charge to cost of sales).\n3. After charging this year's depreciation, land and buildings were revalued to 450,000 at 31 December 20X9.\n4. The loan notes were in issue all year; only half the year's interest has been paid.\n5. The income tax charge for the year is estimated at 48,000.\n6. The 30,000 paid settled last year's liability in full."}
					],
					"tasks": [
						{"title": "Task 1: Statement of profit or loss and other comprehensive income", "intro": "Enter the missing figures as positive numbers.", "rows": [
							{"c": ["Revenue", "820,000"]}, {"c": ["Cost of sales", "#cos"]}, {"c": ["Distribution costs", "74,000"]}, {"c": ["Administrative expenses", "#admin"]},
							{"c": ["Operating profit", "#op"], "b": true}, {"c": ["Investment income", "4,000"]}, {"c": ["Profit before financing and income taxes", "#pbfit"], "b": true},
							{"c": ["Finance costs", "#fin"]}, {"c": ["Income tax expense", "#tax"]}, {"c": ["Profit for the year", "#profit"], "b": true},
							{"c": ["Other comprehensive income: revaluation gain", "#oci"]}, {"c": ["Total comprehensive income", "#tci"], "b": true}],
							"blanks": {
								"cos": {"accept": ["509200"], "show": "509,200", "marks": 2, "ex": "490,000 + plant depreciation 20% x (150,000 - 54,000) = 490,000 + 19,200 = 509,200."},
								"admin": {"accept": ["102000"], "show": "102,000", "marks": 1, "ex": "96,000 + buildings depreciation 2% x 300,000 = 96,000 + 6,000 = 102,000."},
								"op": {"accept": ["134800"], "show": "134,800", "marks": 1, "ex": "820,000 - 509,200 - 74,000 - 102,000 = 134,800."},
								"pbfit": {"accept": ["138800"], "show": "138,800", "marks": 1, "ex": "134,800 + 4,000 investment income = 138,800."},
								"fin": {"accept": ["12000"], "show": "12,000", "marks": 2, "ex": "8% x 150,000 = 12,000 for the full year; 6,000 paid, 6,000 accrued."},
								"tax": {"accept": ["46000"], "show": "46,000", "marks": 2, "ex": "Last year 32,000 was provided but only 30,000 was needed: over-provision 2,000. Charge = 48,000 - 2,000 = 46,000."},
								"profit": {"accept": ["80800"], "show": "80,800", "marks": 1, "ex": "138,800 - 12,000 - 46,000 = 80,800."},
								"oci": {"accept": ["116000"], "show": "116,000", "marks": 1, "ex": "Carrying amount after this year's depreciation = 400,000 - 60,000 - 6,000 = 334,000. Revalued to 450,000: gain 116,000."},
								"tci": {"accept": ["196800"], "show": "196,800", "marks": 1, "ex": "80,800 + 116,000 = 196,800."}
							}},
						{"title": "Task 2: Statement of financial position extracts", "intro": "Enter the missing figures.", "rows": [
							{"c": ["Retained earnings at 31 Dec 20X9", "#re"]}, {"c": ["Total equity", "#eq"], "b": true}, {"c": ["Non-current liabilities: 8% loan notes", "150,000"]}, {"c": ["Current liabilities (payables + accrued interest + tax payable)", "#cl"]}],
							"blanks": {
								"re": {"accept": ["156800"], "show": "156,800", "marks": 1, "ex": "96,000 + 80,800 - 20,000 dividends = 156,800."},
								"eq": {"accept": ["612800"], "show": "612,800", "marks": 1, "ex": "300,000 + 40,000 + revaluation surplus 116,000 + 156,800 = 612,800."},
								"cl": {"accept": ["111000"], "show": "111,000", "marks": 1, "ex": "57,000 + 6,000 accrued interest + 48,000 tax = 111,000. Check: assets 450,000 + 76,800 + 62,000 + 88,000 + 197,000 = 873,800 = 612,800 + 150,000 + 111,000."}
							}}
					]
				}
			},
			{
				"id": 21, "title": "Events after the reporting period", "monster": "The Aftermath Yurei",
				"beats": [
					{"type":"choice","q":"After the year-end, a customer who owed money at year-end goes bankrupt. This is:","opts":["A non-adjusting event (disclose)","An adjusting event - write the debt off","Ignored","A new provision"],"a":1,"ex":"The weakness existed at the year-end, so it is adjusting; write the receivable off."},
					{"type":"choice","q":"A fire destroys a warehouse two weeks after the year-end. This is:","opts":["An adjusting event","A non-adjusting event - disclose if material","Recognised as a loss this year","A provision"],"a":1,"ex":"A new condition after the year-end is non-adjusting; disclose if material."},
					{"type":"choice","q":"After the year-end, a fraud is discovered showing the financial statements are wrong. This is:","opts":["An adjusting event","A non-adjusting event","Ignored","A contingent asset"],"a":0,"ex":"Discovering fraud or errors that show the statements were incorrect is an adjusting event."}
				],
				# Ch 21 learning objectives: G4(a)-(c). Exam: pick adjusting vs non-adjusting events from a list, and the treatment.
				"lessons": [
					{
						"id": "L1", "title": "Adjusting or non-adjusting?",
						"outcome": "G4(a) Define events after the reporting period; G4(b) Classify as adjusting or non-adjusting; G4(c) How each is reported",
						"apply": {"title": "Zuru Lemonade Ltd - what happened between year-end and sign-off", "pages": [
							{"text": "Year-end 31 December; the directors approve the accounts on 31 March. Four things happen in between:\n1. 10 Jan: the spilt-lemonade claim is settled at [b]350[/b] (provision was 400).\n2. 5 Feb: the cafe goes into liquidation owing [b]480[/b] - it had been struggling since November.\n3. 20 Feb: a fire destroys a cart (carrying amount [b]1,500[/b]).\n4. 15 Mar: the directors declare a dividend of [b]0.10[/b] a share."},
							{"text": "", "table": {"cols": ["Event", "Adjusting or non-adjusting?", "Treatment in the year-3 accounts"], "rows": [{"c": ["Claim settled at 350", "Adjusting - evidence of a condition at year-end", "Reduce the provision to 350"]}, {"c": ["Cafe goes bust", "Adjusting - it was already in trouble at year-end", "Write off the 480 receivable"]}, {"c": ["Cart fire", "Non-adjusting - the cart was fine at year-end", "No change; disclose in a note if material"]}, {"c": ["Dividend declared in March", "Non-adjusting - no obligation existed at year-end", "Note only; it is next year's SOCE entry"]}]}},
							{"text": "The test is always: does the event tell you something about [b]conditions that existed at 31 December[/b]? If yes, adjust the numbers. If it's a new condition, leave the numbers alone but tell the reader if it matters. One exception overrides everything: if an event after the year-end shows the company is [b]no longer a going concern[/b], the whole basis of the accounts changes, whatever the date."}
						]},
						"learn": [
							{"text": "An [b]event after the reporting period[/b] (IAS 10) is something - favourable or unfavourable - that happens between the [b]end of the reporting period[/b] and the date the financial statements are [b]authorised for issue[/b]. The question is always: does it tell us about conditions at the year-end, or about something new?"},
							{"text": "[b]Adjusting events[/b] give evidence of conditions that [b]existed at the year-end[/b]. The financial statements ARE changed. Examples:\n- a court case settled, confirming a year-end obligation\n- a customer who owed money at the year-end goes bankrupt\n- inventory sold after the year-end for less than cost (evidence of NRV)\n- discovery of fraud or errors showing the statements were wrong"},
							{"text": "[b]Non-adjusting events[/b] relate to conditions that [b]arose after[/b] the year-end. The statements are NOT changed - if material, [b]disclose[/b] the nature of the event and an estimate of its financial effect. Examples:\n- a fire or flood destroying an asset after the year-end\n- a major share issue or acquisition after the year-end\n- announcing the closure of part of the business\n- dividends proposed or declared after the year-end"},
							{"text": "Two traps:\n[b]Dividends[/b] declared after the year-end are NOT a liability at the year-end - disclose only.\n[b]Going concern[/b]: if an event after the year-end shows the business is no longer a going concern, that DOES change the statements (a different basis of preparation), even though it arose later."}
						],
						"example": {"title": "Year-end 31 December; accounts approved 20 March", "table": {"cols": ["Event", "Type", "Treatment"], "rows": [
							{"c": ["15 Jan: customer who owed 9,000 at 31 Dec declared bankrupt", "Adjusting", "Write off the 9,000"], "s": 1},
							{"c": ["2 Feb: court case from October settled for 25,000 (provision was 20,000)", "Adjusting", "Increase the provision to 25,000"], "s": 1},
							{"c": ["10 Feb: warehouse destroyed by fire", "Non-adjusting", "Disclose nature and effect"], "s": 2},
							{"c": ["1 Mar: directors declare a final dividend", "Non-adjusting", "Disclose only"], "s": 2},
							{"c": ["5 Apr: new product launched", "Not an event after the reporting period", "After approval - ignore"], "s": 3}]},
							"steps": ["Both January/February items confirm conditions that existed at the year-end: adjust the figures.", "The fire and the dividend are new conditions: leave the figures, disclose if material.", "Anything after the approval date is outside the window entirely."]},
						"practice": [
							{"type": "sort", "q": "Year-end 30 June; accounts approved 30 September. Adjusting or non-adjusting?", "buckets": ["Adjusting", "Non-adjusting"], "items": [["15 July: a major customer with a year-end balance goes into liquidation", 0], ["20 August: flood damages the factory", 1], ["10 July: inventory on hand at 30 June is sold below cost", 0], ["5 September: directors propose a dividend", 1], ["1 August: an error is found in the year-end inventory count", 0], ["25 August: the company announces a rights issue", 1]], "ex": "Evidence about year-end conditions (customer, inventory NRV, the count error) adjusts. The flood, dividend and rights issue are new conditions - disclose."},
							{"type": "choice", "q": "A material NON-adjusting event should be:", "opts": ["Disclosed in a note, with the nature of the event and an estimate of its financial effect", "Adjusted in the financial statements", "Ignored completely", "Recognised as a provision"], "a": 0, "ex": "Non-adjusting events are disclosed, not adjusted."},
							{"type": "choice", "q": "After the year-end a court case is settled, confirming that a liability existed at the year-end but for more than was provided. The company should:", "opts": ["Increase the provision in the financial statements", "Disclose the settlement in a note only", "Record the extra amount next year", "Treat it as a contingent asset"], "a": 0, "ex": "It gives evidence of a condition at the year-end - an adjusting event, so the figures change."},
							{"type": "picklist", "q": "A dividend declared after the reporting period is {0} at the year-end and is {1}.", "lists": [["not a liability", "a current liability", "a provision"], ["disclosed in a note", "deducted from retained earnings this year", "ignored"]], "a": [0, 0], "ex": "No obligation existed at the year-end, so it is disclosed only."}
						]
					}
				]
			},
			{
				"id": 22, "title": "Statement of cash flows", "monster": "The Cashflow Leviathan",
				"beats": [
					{"type":"story","speaker":"Sensei Otter","text":"The deep-dwelling [b]Cashflow Leviathan[/b] cares nothing for profit, only for real cash. Trace the cash and it surfaces."},
					{"type":"story","speaker":"Sensei Otter","text":"Three sections: [b]Operating, Investing, Financing[/b]. Indirect method: start with profit, [b]add back depreciation[/b], adjust working capital. [b]Asset up = cash outflow; liability up = cash inflow.[/b]"},
					{"type":"choice","q":"The three sections of a statement of cash flows are:","opts":["Operating, investing and financing","Current, non-current and equity","Fixed, variable and semi-variable","Revenue, capital and reserves"],"a":0,"ex":"Cash flows are classified as operating, investing and financing activities."},
					{"type":"input","q":"Operating profit 50,000; depreciation 8,000; receivables rose 3,000; payables rose 2,000. Cash generated from operations = ?  (number)","accept":["57000"],"display_answer":"57,000","ex":"50,000 + 8,000 - 3,000 + 2,000 = 57,000."},
					{"type":"choice","q":"In the indirect method, depreciation is:","opts":["Added back to profit","Deducted from profit","Ignored","Shown as financing"],"a":0,"ex":"Depreciation is a non-cash expense, so it is added back."},
					{"type":"choice","q":"An increase in inventory is a cash:","opts":["Outflow","Inflow","Financing item","Investing item"],"a":0,"ex":"Tying up more cash in inventory is a cash outflow."},
					{"type":"choice","q":"Proceeds from issuing new shares appear under:","opts":["Operating activities","Investing activities","Financing activities","Cost of sales"],"a":2,"ex":"Raising finance from shares is a financing activity."},
					{"type":"choice","q":"The purchase of new machinery for cash is shown under:","opts":["Operating activities","Investing activities","Financing activities","Equity"],"a":1,"ex":"Buying non-current assets is an investing activity."},
					{"type":"choice","q":"A decrease in trade payables is a cash:","opts":["Inflow","Outflow","Financing item","Investing item"],"a":1,"ex":"Paying down payables uses cash - an outflow."},
					{"type":"input","q":"PPE carrying amount: opening 100,000, closing 120,000. Depreciation 15,000, no disposals. PPE purchased = ?  (number)","accept":["35000"],"display_answer":"35,000","ex":"120,000 - 100,000 + 15,000 = 35,000 cash spent on PPE."},
					{"type":"input","q":"Tax liability opening 8,000; tax charge 12,000; closing liability 9,000. Tax paid = ?  (number)","accept":["11000"],"display_answer":"11,000","ex":"8,000 + 12,000 - 9,000 = 11,000 paid."},
					{"type":"choice","q":"In the indirect method, a PROFIT on disposal of PPE is:","opts":["Deducted from profit (proceeds go in investing)","Added back to profit","Shown in financing","Ignored"],"a":0,"ex":"The profit is non-cash; the actual cash (proceeds) is shown under investing activities."},
					{"type":"choice","q":"Dividends paid are shown under:","opts":["Financing activities","Investing activities","Cost of sales","Revenue"],"a":0,"ex":"Dividends paid to shareholders are a financing cash flow."}
				],
				# Ch 22 learning objectives: G5(a)-(g). IAS 7 as amended by IFRS 18 (examinable from Sept 2025): indirect method starts from OPERATING PROFIT;
				# interest paid = financing; interest and dividends received = investing; dividends paid = financing; tax paid = operating.
				"lessons": [
					{
						"id": "L1", "title": "Profit is not cash",
						"outcome": "G5(a) Profit vs cash flow; G5(b) Why management controls cash; G5(c) Benefits and drawbacks of the statement of cash flows",
						"apply": {"title": "Zuru Lemonade Ltd - record profit, empty account", "pages": [
							{"text": "Year 3 profit: [b]5,120[/b], the best ever. Yet in January the bank calls: the account is nearly empty. Hana asks how both can be true.\n\nProfit is measured on the [b]accruals[/b] basis; the bank only sees [b]cash[/b]. During the year the company:\n- bought a new cart for 2,000 - all cash, but only 400 of depreciation in profit\n- let receivables grow by 600 (six cafes on 60-day terms)\n- stocked up 400 more bottles\n- repaid 600 of the loan and paid 380 of dividends - neither is an expense"},
							{"text": "", "table": {"cols": ["Why profit and cash differ", "Profit", "Cash"], "rows": [{"c": ["Depreciation", "Expense", "No cash leaves"]}, {"c": ["Buying a cart", "Not an expense (asset)", "Cash leaves"]}, {"c": ["Credit sales not yet collected", "Revenue", "No cash yet"]}, {"c": ["Loan repayment, dividends", "Not expenses", "Cash leaves"]}, {"c": ["Loan received, shares issued", "Not income", "Cash arrives"]}]}},
							{"text": "That is why the [b]statement of cash flows[/b] exists: it shows where cash came from and went, in a way profit can't hide - a company can be profitable and still run out of cash (overtrading), and cash is harder to manipulate than profit. Its limits: it is historical, it says nothing about profitability on its own, and a healthy cash balance can come from selling the kiosk rather than selling lemonade. Zuru now watches both numbers."}
						]},
						"learn": [
							{"text": "A profitable business can still run out of cash. Profit is measured on the [b]accruals[/b] basis: sales on credit count before the cash arrives, depreciation reduces profit without any cash leaving, and buying a machine uses cash without touching profit."},
							{"text": "That's why management must [b]control cash[/b]: wages, suppliers and loan repayments are paid in cash, not profit. Running out of cash - even briefly - can sink a profitable company."},
							{"text": "The [b]statement of cash flows[/b] (IAS 7) shows where cash came from and went during the year, under three headings: [b]operating, investing and financing[/b] activities. It reconciles the opening and closing [b]cash and cash equivalents[/b] (cash, demand deposits and short-term highly liquid investments, less bank overdrafts)."},
							{"text": "[b]Benefits[/b]: hard to manipulate (cash is cash), easy to understand, shows liquidity and how growth was financed, comparable between companies.\n[b]Drawbacks[/b]: historical, says nothing about profitability on its own, cash balances can be dressed up at the year-end (e.g. delaying payments)."}
						],
						"practice": [
							{"type": "multi", "q": "Which TWO explain why a profitable company might have LESS cash at the end of the year than the start?", "opts": ["It bought new machinery for cash", "Customers are taking longer to pay", "It charged depreciation", "It made a bonus issue of shares"], "a": [0, 1], "ex": "Buying assets and rising receivables use cash without reducing profit. Depreciation and bonus issues don't move cash at all."},
							{"type": "choice", "q": "Which is a BENEFIT of the statement of cash flows to users?", "opts": ["Cash flows are difficult to manipulate, so the figures are objective", "It shows the profit for the year", "It predicts next year's cash flows exactly", "It values the company's assets"], "a": 0, "ex": "Cash is a fact, which makes the statement objective and comparable."},
							{"type": "choice", "q": "Cash equivalents are:", "opts": ["Short-term, highly liquid investments readily convertible to known amounts of cash", "Trade receivables", "Inventory that sells quickly", "Shares held in other companies"], "a": 0, "ex": "Cash equivalents are near-cash: short-term and highly liquid, e.g. a 30-day deposit."}
						]
					},
					{
						"id": "L2", "title": "The three headings - where does each cash flow go?",
						"outcome": "G5(d) Classify the effect of transactions on cash flows; G5(g) Treatment of given transactions in the statement of cash flows",
						"apply": {"title": "Zuru Lemonade Ltd - three buckets", "pages": [
							{"text": "IAS 7 sorts every cash movement into three headings. Zuru's year, sorted:", "table": {"cols": ["Transaction", "Heading", "Direction"], "rows": [{"c": ["Cash from selling lemonade, paying Kenji, wages, rent", "Operating", "in / out"]}, {"c": ["Income tax paid 1,250", "Operating", "out"]}, {"c": ["New cart bought 2,000", "Investing", "out"]}, {"c": ["Old cart sold 150", "Investing", "in"]}, {"c": ["Interest received on the deposit 100", "Investing", "in"]}, {"c": ["Rights issue 1,500", "Financing", "in"]}, {"c": ["Loan repaid 600", "Financing", "out"]}, {"c": ["Interest paid 180", "Financing", "out"]}, {"c": ["Dividends paid 380", "Financing", "out"]}]}},
							{"text": "Under the amended IAS 7 that FA now examines: [b]interest paid[/b] is a [b]financing[/b] flow (it is the cost of the loan), [b]interest and dividends received[/b] are [b]investing[/b] flows (returns on money placed elsewhere), and [b]dividends paid[/b] are financing. Tax paid stays in operating."},
							{"text": "Two traps:\n- The [b]bonus issue[/b] and the [b]revaluation[/b] involve no cash at all - they never appear.\n- [b]Depreciation[/b] and the [b]profit on disposal[/b] are not cash flows either; they are only adjustments inside the indirect-method working (next lesson). The cash from the disposal is the 150 proceeds, not the 30 profit."}
						]},
						"learn": [
							{"text": "[b]Operating activities[/b] - cash from the main trading: cash generated from operations, less [b]income tax paid[/b].\n[b]Investing activities[/b] - buying and selling non-current assets, and the RETURNS on investments: [b]interest received[/b] and [b]dividends received[/b].\n[b]Financing activities[/b] - raising and repaying long-term finance: share issues, loans raised or repaid, [b]interest paid[/b], [b]dividends paid[/b]."},
							{"text": "The 2025 update (IFRS 18 amended IAS 7): the indirect method now starts from [b]operating profit[/b], [b]interest paid[/b] goes ONLY in financing, and [b]interest received[/b] goes ONLY in investing. Older textbooks may show choices - the exam uses these."},
							{"text": "Things that are NOT cash flows and never appear: depreciation and amortisation, a bonus issue of shares, a revaluation gain, writing off a debt, an asset bought on credit (until it is paid for)."}
						],
						"example": {"title": "Classifying Orion Co's transactions", "table": {"cols": ["Transaction", "Heading", "Inflow / outflow"], "rows": [
							{"c": ["Paid income tax 24,000", "Operating", "Outflow"], "s": 1},
							{"c": ["Bought plant for cash 80,000", "Investing", "Outflow"], "s": 2}, {"c": ["Sold old plant for 14,000", "Investing", "Inflow"], "s": 2}, {"c": ["Received interest 2,000", "Investing", "Inflow"], "s": 2},
							{"c": ["Issued shares for 30,000", "Financing", "Inflow"], "s": 3}, {"c": ["Repaid loan 25,000", "Financing", "Outflow"], "s": 3}, {"c": ["Paid interest 8,000", "Financing", "Outflow"], "s": 3}, {"c": ["Paid dividends 15,000", "Financing", "Outflow"], "s": 3},
							{"c": ["Depreciation 35,000", "Not a cash flow", "-"], "s": 4}]},
							"steps": ["Tax paid sits in operating activities.", "Buying and selling non-current assets, and interest received, are investing.", "Shares, loans, interest paid and dividends paid are financing.", "Depreciation never appears as a cash flow (it is only an adjustment inside the operating working)."]},
						"practice": [
							{"type": "sort", "q": "Classify each cash flow.", "buckets": ["Operating", "Investing", "Financing"], "items": [["Income tax paid", 0], ["Purchase of a delivery van for cash", 1], ["Interest received on a bank deposit", 1], ["Interest paid on loan notes", 2], ["Proceeds of a rights issue", 2], ["Dividends paid to shareholders", 2]], "ex": "Tax paid is operating; buying assets and interest received are investing; share issues, interest paid and dividends paid are financing."},
							{"type": "multi", "q": "Which TWO items do NOT appear anywhere in a statement of cash flows?", "opts": ["A bonus issue of shares", "Depreciation (other than as an adjustment to operating profit)", "Dividends paid", "Proceeds from selling a machine"], "a": [0, 1], "ex": "No cash moves in a bonus issue or depreciation. Dividends paid and disposal proceeds are real cash flows."},
							{"type": "choice", "q": "Under IAS 7 as amended, interest PAID by a trading company is shown under:", "opts": ["Financing activities", "Operating activities", "Investing activities", "It is not a cash flow"], "a": 0, "ex": "Interest paid is the cost of financing, so it goes in financing activities."}
						]
					},
					{
						"id": "L3", "title": "Cash generated from operations",
						"outcome": "G5(e)(i) Cash flows from operating activities - indirect and direct methods",
						"apply": {"title": "Zuru Lemonade Ltd - from operating profit to cash", "pages": [
							{"text": "The [b]indirect method[/b] starts from [b]operating profit[/b] (6,500 - the IFRS 18 subtotal) and undoes everything in it that wasn't cash:", "table": {"cols": ["Cash flows from operating activities", ""], "rows": [{"c": ["Operating profit", "6,500"]}, {"c": ["Add: depreciation and amortisation (no cash)", "1,440"]}, {"c": ["Less: profit on disposal of cart (cash is in investing)", "(30)"]}, {"c": ["Less: increase in inventories", "(400)"]}, {"c": ["Less: increase in receivables", "(600)"]}, {"c": ["Add: increase in payables", "300"]}, {"c": ["Cash generated from operations", "7,210"], "b": true}, {"c": ["Income tax paid", "(1,250)"]}, {"c": ["Net cash from operating activities", "5,960"], "b": true}]}},
							{"text": "The working-capital signs: more inventory or receivables means cash is tied up (deduct); more payables means Zuru is holding suppliers' cash (add). Decreases do the opposite. The [b]tax paid[/b] figure is usually a working: opening tax payable 1,100 + this year's charge 1,300 - closing payable 1,150 = [b]1,250[/b] paid."},
							{"text": "The [b]direct method[/b] reaches the same 7,210 the plain way - cash received from customers 23,400 less cash paid to suppliers and employees 16,190 - built from the receivables, payables and expense accounts. IAS 7 allows either; the exam mostly tests the indirect one, because it is where the understanding is. Interest paid and received are NOT in this section any more."}
						]},
						"learn": [
							{"text": "The [b]indirect method[/b] starts with [b]operating profit[/b] and undoes the non-cash items and timing differences:\n+ depreciation and amortisation\n+ loss on disposal (or - profit on disposal)\n- increase in inventory (+ decrease)\n- increase in receivables (+ decrease)\n+ increase in payables (- decrease)\n= [b]Cash generated from operations[/b]\n- income tax paid = [b]Net cash from operating activities[/b]"},
							{"text": "Why: depreciation and a loss on disposal reduced operating profit without using cash, so add them back; a profit on disposal is taken out because the real cash (the proceeds) is shown in investing. More inventory or receivables means cash tied up; more payables means cash kept."},
							{"text": "The [b]direct method[/b] gets the same cash generated from operations by listing the actual cash: cash received from customers - cash paid to suppliers - cash paid to employees - other cash expenses. Then tax paid as before."},
							{"text": "[b]Tax paid[/b] working: opening tax liability + this year's charge - closing liability = cash paid."}
						],
						"example": {"title": "Orion Co - operating activities", "table": {"cols": ["", "$"], "rows": [
							{"c": ["Operating profit", "120,000"], "s": 1},
							{"c": ["Add: depreciation", "35,000"], "s": 2}, {"c": ["Less: profit on disposal of plant", "(4,000)"], "s": 2},
							{"c": ["Increase in inventory", "(6,000)"], "s": 3}, {"c": ["Decrease in receivables", "3,000"], "s": 3}, {"c": ["Increase in payables", "5,000"], "s": 3},
							{"c": ["Cash generated from operations", "153,000"], "s": 4, "b": true},
							{"c": ["Income tax paid (20,000 + 28,000 - 24,000)", "(24,000)"], "s": 5}, {"c": ["Net cash from operating activities", "129,000"], "s": 5, "b": true}]},
							"steps": ["Start with operating profit - not profit before tax.", "Add back the non-cash depreciation; take out the disposal profit (its cash is in investing).", "Working capital: inventory up uses cash; receivables down releases cash; payables up keeps cash.", "Cash generated from operations: 153,000.", "Tax paid from the working: opening 20,000 + charge 28,000 - closing 24,000 = 24,000. Net operating cash 129,000."]},
						"practice": [
							{"type": "input", "q": "Operating profit 84,000; depreciation 12,000; loss on disposal 1,500; inventory up 4,000; receivables up 7,000; payables down 2,500. Cash generated from operations = ?  (number)", "accept": ["84000"], "display_answer": "84,000", "ex": "84,000 + 12,000 + 1,500 - 4,000 - 7,000 - 2,500 = 84,000."},
							{"type": "input", "q": "Tax liability at the start 18,000; income tax charge for the year 26,000; liability at the end 21,000. Tax paid = ?  (number)", "accept": ["23000"], "display_answer": "23,000", "ex": "18,000 + 26,000 - 21,000 = 23,000."},
							{"type": "picklist", "q": "In the indirect method, an INCREASE in receivables is {0} operating profit, and a loss on disposal is {1}.", "lists": [["deducted from", "added to"], ["added back", "deducted"]], "a": [0, 0], "ex": "Sales not yet collected reduce cash; the loss on disposal is a non-cash charge, so add it back."},
							{"type": "choice", "q": "The indirect method under IAS 7 (as amended) starts from:", "opts": ["Operating profit", "Profit before tax", "Gross profit", "Profit for the year"], "a": 0, "ex": "The reconciliation now begins at operating profit."}
						]
					},
					{
						"id": "L4", "title": "Investing, financing and the full statement",
						"outcome": "G5(e)(ii)(iii) Investing and financing cash flows; G5(f) Prepare a statement of cash flows or extracts",
						"apply": {"title": "Zuru Lemonade Ltd - the whole statement, and the empty account explained", "pages": [
							{"text": "", "table": {"cols": ["Statement of cash flows - year 3", "", ""], "rows": [{"c": ["Net cash from operating activities", "", "5,960"]}, {"c": ["Purchase of cart", "(2,000)", ""]}, {"c": ["Proceeds from sale of old cart", "150", ""]}, {"c": ["Interest received", "100", ""]}, {"c": ["Net cash used in investing activities", "", "(1,750)"]}, {"c": ["Proceeds from rights issue", "1,500", ""]}, {"c": ["Repayment of loan", "(600)", ""]}, {"c": ["Interest paid", "(180)", ""]}, {"c": ["Dividends paid", "(380)", ""]}, {"c": ["Net cash from financing activities", "", "340"]}, {"c": ["Net increase in cash", "", "4,550"], "b": true}, {"c": ["Cash at 1 January", "", "(2,630)"]}, {"c": ["Cash at 31 December", "", "1,920"], "b": true}]}},
							{"text": "So the 5,120 of profit became 5,960 of operating cash, of which 1,750 bought kit and 340 came in net from financing - and the company started the year [b]overdrawn by 2,630[/b] (the second kiosk's fit-out). The year-end 1,920 is real cash, but it was a long way from where Hana's intuition put it.\n\nThe [b]PPE purchase[/b] is often a working too: opening carrying amount + additions - depreciation - disposals carrying amount = closing carrying amount, solve for additions."},
							{"text": "The bank reads this statement before lending for kiosk three: operating cash 5,960 comfortably covers the 600 loan repayment, the 180 interest and the 380 dividend. Profit told them the lemonade sells; the cash flow statement tells them the cash actually arrives. Both, together, are what the FA exam calls 'the financial statements'."}
						]},
						"learn": [
							{"text": "[b]Investing[/b] workings. Cash paid for PPE is usually a missing figure:\n[b]Opening carrying amount + Additions - Depreciation - Carrying amount of disposals = Closing carrying amount[/b]\n(If assets were revalued, add the revaluation gain on the left too.) Proceeds of disposals and interest/dividends received come from the question."},
							{"text": "[b]Financing[/b] workings:\nShare issue proceeds = increase in share capital + increase in share premium (ignore bonus issues - no cash).\nLoans: compare opening and closing balances.\nInterest paid = charge + opening accrual - closing accrual.\nDividends paid = from the SOCE (or opening retained earnings + profit - closing retained earnings)."},
							{"text": "Finish: net cash from operating + investing + financing = [b]net increase (decrease) in cash[/b]. Add the opening cash and cash equivalents; the result must equal the closing figure in the SOFP."}
						],
						"example": {"title": "Orion Co - statement of cash flows", "table": {"cols": ["", "$"], "rows": [
							{"c": ["Net cash from operating activities", "129,000"], "s": 1, "b": true},
							{"c": ["Purchase of plant (300,000 + X - 35,000 - 10,000 = 335,000)", "(80,000)"], "s": 2}, {"c": ["Proceeds from sale of plant", "14,000"], "s": 2}, {"c": ["Interest received", "2,000"], "s": 2}, {"c": ["Net cash used in investing activities", "(64,000)"], "s": 2, "b": true},
							{"c": ["Proceeds of share issue (capital +20,000, premium +10,000)", "30,000"], "s": 3}, {"c": ["Repayment of loan", "(25,000)"], "s": 3}, {"c": ["Interest paid", "(8,000)"], "s": 3}, {"c": ["Dividends paid", "(15,000)"], "s": 3}, {"c": ["Net cash used in financing activities", "(18,000)"], "s": 3, "b": true},
							{"c": ["Net increase in cash and cash equivalents", "47,000"], "s": 4}, {"c": ["Cash and cash equivalents at the start", "12,000"], "s": 4}, {"c": ["Cash and cash equivalents at the end", "59,000"], "s": 4, "b": true}]},
							"steps": ["Operating cash from Lesson 3.", "Investing: the PPE working gives additions of 80,000; add the disposal proceeds and interest received.", "Financing: cash from the share issue, less the loan repayment, interest paid and dividends paid.", "129,000 - 64,000 - 18,000 = 47,000 more cash; 12,000 at the start becomes 59,000 - check it against the SOFP."]},
						"practice": [
							{"type": "input", "q": "PPE carrying amount: start 210,000, end 262,000. Depreciation for the year 31,000. A machine with a carrying amount of 9,000 was sold. Cash paid for new PPE = ?  (number)", "accept": ["92000"], "display_answer": "92,000", "ex": "210,000 + X - 31,000 - 9,000 = 262,000, so X = 92,000."},
							{"type": "input", "q": "Share capital rose from 200,000 to 260,000 and share premium from 50,000 to 74,000. Of the share capital increase, 20,000 was a bonus issue. Cash raised from shares = ?  (number)", "accept": ["64000"], "display_answer": "64,000", "ex": "(60,000 - 20,000 bonus) + 24,000 premium = 64,000. The bonus issue raised no cash."},
							{"type": "input", "q": "Interest charge for the year 9,000; accrued interest at the start 1,500 and at the end 2,500. Interest paid = ?  (number)", "accept": ["8000"], "display_answer": "8,000", "ex": "9,000 + 1,500 - 2,500 = 8,000."},
							{"type": "input", "q": "Net cash from operating activities 48,000; net cash used in investing (31,000); net cash from financing 5,000; cash at the start 6,000. Cash at the end = ?  (number)", "accept": ["28000"], "display_answer": "28,000", "ex": "48,000 - 31,000 + 5,000 = 22,000 increase; 6,000 + 22,000 = 28,000."}
						]
					}
				]
			},
			{
				"id": 23, "title": "Introduction to consolidated financial statements", "monster": "The Twin-Headed Hydra",
				"beats": [
					{"type":"story","speaker":"Sensei Otter","text":"The final beast: the [b]Consolidation Hydra[/b], many heads acting as one. Present the group as a single entity and cut it down."},
					{"type":"story","speaker":"Sensei Otter","text":"A parent [b]controls[/b] a subsidiary (usually >50% of votes) and consolidates [b]100%[/b] of its assets and liabilities. [b]Goodwill = consideration + NCI - net assets at acquisition[/b]. NCI (the part not owned) sits in equity. Intra-group balances cancel."},
					{"type":"choice","q":"Control of a subsidiary normally means owning more than:","opts":["50% of voting shares","25% of voting shares","75% of voting shares","Any shares"],"a":0,"ex":"Control is usually more than 50% of the voting rights."},
					{"type":"choice","q":"Consolidated financial statements present the parent and subsidiary as:","opts":["Two separate entities","A single economic entity (the group)","Only the parent","Only the subsidiary"],"a":1,"ex":"Consolidation shows the group as one economic entity."},
					{"type":"choice","q":"An associate (significant influence, usually 20-50%) is accounted for using:","opts":["The equity method","Full consolidation","Proportionate consolidation","Cost only, never adjusted"],"a":0,"ex":"Associates use the equity method: one line in the SOFP and the share of profit in profit or loss."}
				],
				# Ch 23 learning objectives: H1(a), H1(b), H2(a)-(c). Exam: subsidiary vs associate vs trade investment; how each is treated in the group accounts.
				"lessons": [
					{
						"id": "L1", "title": "Parents, subsidiaries and control",
						"outcome": "H1(a) Group terms: parent, subsidiary, control, consolidated statements, NCI, trade investment; H1(b) Identify subsidiaries in a group structure",
						"apply": {"title": "Zuru Lemonade Ltd - buying the rival", "pages": [
							{"text": "Year 4: Zuru Lemonade Ltd buys [b]80%[/b] of the shares in [b]Cold Press Co[/b], the juice kiosk across the square, for 10,000. It also buys [b]30%[/b] of Riverside Cafe, and [b]5%[/b] of the bottler it uses.\n\nThree stakes, three relationships:"},
							{"text": "", "table": {"cols": ["Stake", "Relationship", "What it means", "In the group accounts"], "rows": [{"c": ["80% of Cold Press Co", "Subsidiary - Zuru has CONTROL", "She appoints the board, sets prices", "Consolidated line by line; the other 20% = non-controlling interest"]}, {"c": ["30% of Riverside Cafe", "Associate - SIGNIFICANT INFLUENCE", "A seat on the board, a say but not the say", "Equity method (next lesson)"]}, {"c": ["5% of the bottler", "Trade investment", "Just a shareholding", "An investment at cost"]}]}},
							{"text": "The group is [b]Zuru Lemonade Ltd (the parent) + Cold Press Co (the subsidiary)[/b]. Each company still keeps its own books and files its own accounts; on top, the parent prepares [b]consolidated[/b] statements showing the group as one economic unit, as if Zuru simply owned another kiosk. Control is the test, not the percentage: 51% normally gives it, but so would 45% plus the right to appoint most of the directors. The 20% of Cold Press Zuru does NOT own belongs to the [b]non-controlling interest[/b] - the other shareholders - and is shown as such, not hidden."}
						]},
						"learn": [
							{"text": "When one company buys shares in another, the accounting depends on how much [b]influence[/b] it gets. Three levels:\n[b]Control[/b] -> a subsidiary\n[b]Significant influence[/b] -> an associate (Lesson 2)\n[b]Neither[/b] -> a simple trade investment"},
							{"text": "A [b]parent[/b] is a company that [b]controls[/b] another - the [b]subsidiary[/b]. Control normally means owning [b]more than 50%[/b] of the voting shares (IFRS 10: power over the investee, exposure to its returns, and the ability to use that power to affect the returns)."},
							{"text": "A parent must prepare [b]consolidated (group) financial statements[/b] that present the parent and its subsidiaries as if they were a [b]single economic entity[/b]. They are prepared for the parent's shareholders, in addition to the parent's own statements."},
							{"text": "If the parent owns less than 100% of a subsidiary, the part owned by other shareholders is the [b]non-controlling interest (NCI)[/b] - shown within equity in the group SOFP. Because the group CONTROLS the subsidiary, it still consolidates [b]100%[/b] of its assets, liabilities, income and expenses."},
							{"text": "A [b]trade (simple) investment[/b] is a small holding (usually under 20%) with no influence: shown at [b]cost[/b] as an investment; dividends received are [b]investment income[/b].\nIn the [b]parent's own[/b] statements, EVERY investment - even a subsidiary - is shown at cost, with dividends received as income."}
						],
						"example": {"title": "Spotting the subsidiaries in a group", "table": {"cols": ["Holding", "Influence", "Status"], "rows": [
							{"c": ["Alpha owns 80% of Beta", "Control", "Subsidiary (NCI 20%)"], "s": 1},
							{"c": ["Alpha owns 100% of Gamma", "Control", "Subsidiary (no NCI)"], "s": 1},
							{"c": ["Alpha owns 35% of Delta", "Significant influence", "Associate"], "s": 2},
							{"c": ["Alpha owns 10% of Epsilon", "None", "Trade investment"], "s": 3}]},
							"steps": ["More than 50% = control = subsidiary; the other shareholders are the NCI.", "20-50% usually = significant influence = associate.", "Under 20% = a trade investment at cost."]},
						"practice": [
							{"type": "sort", "q": "Classify each investment held by Pine Co.", "buckets": ["Subsidiary", "Associate", "Trade investment"], "items": [["75% of the voting shares of Oak Co", 0], ["30% of the voting shares of Elm Co", 1], ["5% of the shares of Ash Co", 2], ["100% of Birch Co", 0], ["40% of Fir Co", 1]], "ex": "Over 50% = subsidiary; 20-50% = associate; under 20% = trade investment."},
							{"type": "choice", "q": "Consolidated financial statements present a parent and its subsidiaries as:", "opts": ["A single economic entity", "Separate legal entities side by side", "The parent only", "The subsidiaries only"], "a": 0, "ex": "The group is treated as one business."},
							{"type": "choice", "q": "A parent owns 70% of a subsidiary. In the consolidated statement of financial position, the subsidiary's assets are included at:", "opts": ["100%, with a 30% non-controlling interest shown in equity", "70% only", "70%, with 30% shown as a liability", "Cost of the investment only"], "a": 0, "ex": "Control means consolidating 100%; the NCI shows the part not owned by the parent."},
							{"type": "choice", "q": "In the PARENT'S OWN statement of financial position, its investment in a subsidiary is shown:", "opts": ["At cost, as an investment", "By adding the subsidiary's assets line by line", "As goodwill", "As a non-controlling interest"], "a": 0, "ex": "Consolidation happens only in the group statements; the parent's own books show the investment at cost."}
						]
					},
					{
						"id": "L2", "title": "Associates and the equity method",
						"outcome": "H2(a) Define an associate and significant influence; H2(b) Parent-associate relationship; H2(c) The equity method",
						"apply": {"title": "Zuru Lemonade Ltd - a seat at the cafe's table", "pages": [
							{"text": "Riverside Cafe: Zuru holds [b]30%[/b] and sits on its board, so she influences the big decisions but can't make them alone. [b]Significant influence[/b] is presumed at 20% or more - an [b]associate[/b].\n\nAdding the cafe's revenue and coffee machines line by line would overstate what the group controls. Instead the [b]equity method[/b] shows one line: what Zuru's 30% is worth."},
							{"text": "She paid [b]3,000[/b] for the 30%. In the year the cafe made a profit of [b]2,000[/b] and paid dividends of [b]500[/b].", "table": {"cols": ["Investment in associate (consolidated SOFP)", ""], "rows": [{"c": ["Cost", "3,000"]}, {"c": ["Add: share of profit since acquisition (30% x 2,000)", "600"]}, {"c": ["Less: dividends received (30% x 500)", "(150)"]}, {"c": ["Carrying amount", "3,450"], "b": true}]}},
							{"text": "In the consolidated SOPL one line too: [b]'Share of profit of associate 600'[/b] - replacing the 150 dividend income the parent's own accounts show. The dividend isn't double counted: it reduces the investment because it is a return OF the profit already picked up. Compare with the subsidiary: Cold Press is consolidated 100% line by line with a non-controlling interest; the cafe is a single line that grows with its profits."}
						]},
						"learn": [
							{"text": "An [b]associate[/b] is an entity over which the investor has [b]significant influence[/b] - the power to take part in financial and operating policy decisions, without controlling it. A holding of [b]20% to 50%[/b] of the votes is presumed to give significant influence; so can a seat on the board or material transactions between the companies."},
							{"text": "An associate is NOT consolidated line by line. It is accounted for using the [b]equity method[/b]:\nIn the group SOFP, ONE line - [b]Investment in associate = cost + group share of the associate's post-acquisition profits (less any impairment)[/b].\nIn the group SOPL, ONE line - [b]share of profit of associate[/b] = group % x the associate's profit for the year."},
							{"text": "Dividends received from the associate reduce the investment (they are cash out of the associate's post-acquisition profits) - they are NOT shown as income in the group statements."}
						],
						"example": {"title": "Alpha's 35% associate, Delta", "table": {"cols": ["", "$"], "rows": [
							{"c": ["Cost of the 35% holding (bought 3 years ago)", "140,000"], "s": 1},
							{"c": ["Delta's profits since acquisition", "200,000"], "s": 2}, {"c": ["Group share: 35% x 200,000", "70,000"], "s": 2},
							{"c": ["Investment in associate in the group SOFP", "210,000"], "s": 3, "b": true},
							{"c": ["Delta's profit THIS year 60,000: share of profit of associate in the group SOPL (35%)", "21,000"], "s": 4, "b": true}]},
							"steps": ["Start with what was paid.", "Add the group's share of all profits made since acquisition.", "One line in the SOFP: 210,000.", "One line in the SOPL for this year: 35% of 60,000 = 21,000."]},
						"practice": [
							{"type": "input", "q": "A company paid 90,000 for 25% of an associate four years ago. The associate has made total profits of 120,000 since then. Investment in associate in the group SOFP = ?  (number)", "accept": ["120000"], "display_answer": "120,000", "ex": "90,000 + 25% x 120,000 = 120,000."},
							{"type": "input", "q": "The group owns 40% of an associate whose profit for the year is 85,000. Share of profit of associate in the group SOPL = ?  (number)", "accept": ["34000"], "display_answer": "34,000", "ex": "40% x 85,000 = 34,000."},
							{"type": "choice", "q": "Significant influence is normally presumed when the investor holds:", "opts": ["20% to 50% of the voting shares", "More than 50% of the voting shares", "Less than 20% of the voting shares", "Any preference shares"], "a": 0, "ex": "20-50% is the presumption for an associate; over 50% is control."},
							{"type": "picklist", "q": "Under the equity method, the group SOFP shows the associate as {0}, and the group SOPL shows {1}.", "lists": [["a single investment line", "100% of its assets and liabilities", "goodwill only"], ["the group's share of the associate's profit", "the associate's full revenue and costs", "dividends received only"]], "a": [0, 0], "ex": "One line in each statement - that's the equity method."}
						]
					},
					{
						"id": "L3", "title": "How consolidation works - the big picture",
						"outcome": "H1(a) Consolidated financial statements and NCI - the mechanics in outline (detail in Chapters 24 and 25)",
						"apply": {"title": "Zuru Lemonade Ltd - two kiosks, one set of accounts", "pages": [
							{"text": "The simplest view of consolidation: take the parent's SOFP, add [b]100%[/b] of the subsidiary's assets and liabilities (Zuru controls all of them, not 80%), and then sort out two things that would otherwise be counted twice or left hanging.", "table": {"cols": ["", "Zuru Lemonade Ltd", "Cold Press Co", "Consolidated"], "rows": [{"c": ["Kiosks, carts, cash, inventory, receivables", "37,400 (incl. investment 10,000)", "11,000", "add line by line"]}, {"c": ["Investment in Cold Press", "10,000", "-", "REPLACED by goodwill"]}, {"c": ["Share capital + reserves", "22,960", "8,000 at acquisition", "parent's only, plus group share of post-acquisition profits"]}, {"c": ["Non-controlling interest", "-", "-", "the 20% the group doesn't own"]}]}},
							{"text": "Thing one: the [b]investment[/b] of 10,000 in the parent's books and the [b]share capital and reserves[/b] of Cold Press are the same thing seen from two sides - cancel them. What Zuru paid above the fair value of Cold Press's net assets is [b]goodwill[/b], an intangible asset.\n\nThing two: 100% of the assets are in, but 20% of them belong to the other shareholders - show that as the [b]non-controlling interest[/b] within equity."},
							{"text": "The consolidated SOPL works the same way: 100% of Cold Press's revenue and costs are added to Zuru's, and the profit for the year is then split: so much [b]attributable to the owners of the parent[/b], so much to the [b]non-controlling interest[/b]. Chapters 24 and 25 do the arithmetic - goodwill, post-acquisition profits, intra-group sales - but every step is one of these two ideas: don't double count, and show who owns what."}
						]},
						"learn": [
							{"text": "The group SOFP is built by [b]adding the parent and 100% of each subsidiary line by line[/b] - assets and liabilities - as if one company. Then four things are sorted out:"},
							{"text": "1. [b]Cancel the investment.[/b] The parent's 'investment in subsidiary' is replaced by the subsidiary's net assets it bought. The difference is [b]goodwill[/b] (Chapter 24).\n2. [b]Share capital and share premium[/b] in the group SOFP are the [b]PARENT'S only[/b] - the subsidiary's were cancelled against the investment."},
							{"text": "3. [b]Group reserves[/b] = parent's reserves + the group's share of the subsidiary's [b]post-acquisition[/b] reserves (profits made since it was bought). Pre-acquisition reserves were part of what was purchased.\n4. [b]NCI[/b] in equity = the other shareholders' share of the subsidiary's net assets (plus their share of goodwill if NCI is at fair value)."},
							{"text": "Cancel anything the group did with itself: [b]intra-group balances[/b] (what S owes P), [b]intra-group sales[/b], and [b]unrealised profit[/b] on goods sold within the group that are still in inventory."}
						],
						"practice": [
							{"type": "choice", "q": "In a consolidated statement of financial position, share capital is:", "opts": ["The parent's share capital only", "Parent plus subsidiary share capital", "Parent plus the group share of subsidiary share capital", "Subsidiary share capital only"], "a": 0, "ex": "The subsidiary's share capital was cancelled against the parent's investment."},
							{"type": "input", "q": "P's retained earnings are 300,000. S (80% owned) had retained earnings of 50,000 at acquisition and 90,000 now. Group retained earnings = ?  (number)", "accept": ["332000"], "display_answer": "332,000", "ex": "300,000 + 80% x (90,000 - 50,000) = 300,000 + 32,000 = 332,000."},
							{"type": "multi", "q": "Which TWO are eliminated when preparing group accounts?", "opts": ["Amounts owed by the subsidiary to the parent", "Sales from the parent to the subsidiary", "The subsidiary's trade payables", "The parent's share capital"], "a": [0, 1], "ex": "Intra-group balances and trading cancel out; the subsidiary's payables to outsiders and the parent's share capital stay."},
							{"type": "choice", "q": "The non-controlling interest is presented:", "opts": ["Within equity in the consolidated SOFP", "As a non-current liability", "As an investment", "In the parent's own statements"], "a": 0, "ex": "NCI is part of group equity."}
						]
					}
				]
			},
			{
				"id": 24, "title": "The consolidated statement of financial position", "monster": "The Consolidation Hydra",
				"beats": [
					{"type":"choice","q":"In the consolidated SOFP, how much of a subsidiary assets are added in?","opts":["100%","Only the % owned","50%","None"],"a":0,"ex":"The group controls the subsidiary, so 100% is consolidated (with an NCI)."},
					{"type":"input","q":"P pays 600,000 for 80% of S. S net assets at acquisition 650,000; NCI valued at 130,000. Goodwill = ?  (number)","accept":["80000"],"display_answer":"80,000","ex":"Goodwill = 600,000 + 130,000 - 650,000 = 80,000."},
					{"type":"input","q":"P pays 500,000 for 100% of S, whose net assets at acquisition are 420,000. Goodwill = ?  (number)","accept":["80000"],"display_answer":"80,000","ex":"With no NCI: 500,000 - 420,000 = 80,000."},
					{"type":"choice","q":"The non-controlling interest is presented:","opts":["As a liability","Within equity in the consolidated SOFP","As goodwill","In the SOPL only"],"a":1,"ex":"NCI is part of group equity."},
					{"type":"input","q":"S has net assets of 400,000 at acquisition. P owns 75%; NCI is measured at its share of net assets. NCI at acquisition = ?  (number)","accept":["100000"],"display_answer":"100,000","ex":"25% x 400,000 = 100,000."},
					{"type":"input","q":"P receivables 50,000; S receivables 30,000. S owes P 4,000 (agreed). Consolidated receivables = ?  (number)","accept":["76000"],"display_answer":"76,000","ex":"50,000 + 30,000 - 4,000 intra-group = 76,000."}
				],
				# Ch 24 learning objectives: H1(a)(v), H1(c)(i)-(v), H1(d). Section B: consolidated SOFP extracts - goodwill (NCI at fair value), FV adjustments, intra-group balances, unrealised profit, mid-year acquisition.
				"lessons": [
					{
						"id": "L1", "title": "Goodwill and the non-controlling interest at acquisition",
						"outcome": "H1(d) Calculate goodwill with NCI at fair value; H1(c)(i)(ii) Fair value adjustments and fair value of consideration",
						"apply": {"title": "Zuru Lemonade Ltd - what did the 10,000 buy?", "pages": [
							{"text": "On 1 January year 4 Zuru Lemonade Ltd paid [b]10,000[/b] for 80% of Cold Press Co. On that day Cold Press's books showed share capital 5,000 and retained earnings 3,000 - net assets of [b]8,000[/b]. But its kiosk was worth [b]1,000 more[/b] than its book value, so the [b]fair value[/b] of the net assets was 9,000. The 20% Zuru didn't buy (the non-controlling interest) was valued at [b]2,300[/b].\n\nGoodwill is what the group paid for Cold Press over and above those identifiable net assets - the customers, the location, the juice recipes."},
							{"text": "", "table": {"cols": ["Goodwill at acquisition", ""], "rows": [{"c": ["Fair value of consideration paid by the parent", "10,000"]}, {"c": ["Fair value of the non-controlling interest", "2,300"]}, {"c": ["", "12,300"]}, {"c": ["Less: fair value of Cold Press's net assets (8,000 + 1,000)", "(9,000)"]}, {"c": ["Goodwill", "3,300"], "b": true}]}},
							{"text": "Goodwill of 3,300 appears as an intangible asset in the consolidated SOFP - never in Cold Press's own accounts, which carry on as before. The [b]fair value adjustment[/b] of 1,000 is added to the group's PPE as well, so that the net assets Zuru paid for are the ones the group shows. If the consideration had included shares in Zuru Lemonade Ltd, they would go in at their market value on the day, not at nominal value. Watch the exam variant where NCI is measured at its [b]share of net assets[/b] instead: 20% x 9,000 = 1,800, and goodwill would be 2,800."}
						]},
						"learn": [
							{"text": "When a parent buys a subsidiary it usually pays MORE than the subsidiary's net assets are worth on paper - for its reputation, customers, staff. That extra is [b]goodwill[/b], an intangible asset in the group SOFP."},
							{"text": "The goodwill working (NCI at fair value):\n[b]Fair value of consideration transferred[/b]  X\n[b]+ Fair value of non-controlling interest[/b] at acquisition  X\n[b]- Fair value of net assets at acquisition[/b]  (X)\n[b]= Goodwill at acquisition[/b]  X\n(Negative goodwill - a bargain purchase - goes to profit or loss; not examined in detail.)"},
							{"text": "[b]Consideration[/b] = cash paid + the market value of any of the PARENT'S shares given to the sellers (number of shares x market price per share). Deferred and contingent consideration are not examinable."},
							{"text": "[b]Net assets at acquisition[/b] = the subsidiary's share capital + share premium + retained earnings AT THE ACQUISITION DATE, plus any [b]fair value adjustment[/b] - e.g. land in the subsidiary's books at 60,000 that is worth 100,000 adds 40,000 to net assets (and to group PPE). Depreciation on fair value adjustments is not examinable."}
						],
						"example": {"title": "P buys 80% of S on 1 January 20X8", "table": {"cols": ["", "$"], "rows": [
							{"c": ["Cash paid", "150,000"], "s": 1}, {"c": ["50,000 P shares issued, market value $2.50", "125,000"], "s": 1}, {"c": ["Fair value of consideration", "275,000"], "s": 1, "b": true},
							{"c": ["Fair value of NCI (20%) at acquisition", "60,000"], "s": 2},
							{"c": ["S share capital 100,000 + retained earnings at acquisition 120,000 + FV adjustment on land 30,000", "(250,000)"], "s": 3},
							{"c": ["Goodwill", "85,000"], "s": 4, "b": true}]},
							"steps": ["Consideration: the cash plus the market value of the shares given - 275,000.", "Add the fair value of the 20% NCI.", "Deduct the fair value of what was bought: S's net assets including the land uplift.", "Goodwill = 275,000 + 60,000 - 250,000 = 85,000 - an intangible asset in the group SOFP."]},
						"practice": [
							{"type": "input", "q": "P pays 400,000 cash for 70% of S. The fair value of the NCI is 150,000. S's net assets at acquisition have a fair value of 460,000. Goodwill = ?  (number)", "accept": ["90000"], "display_answer": "90,000", "ex": "400,000 + 150,000 - 460,000 = 90,000."},
							{"type": "input", "q": "P acquires S by issuing 100,000 of its own $1 shares (market value $3.20) plus 80,000 cash. Fair value of consideration = ?  (number)", "accept": ["400000"], "display_answer": "400,000", "ex": "100,000 x 3.20 = 320,000 + 80,000 = 400,000. Nominal value is irrelevant."},
							{"type": "input", "q": "At acquisition S had share capital 200,000 and retained earnings 90,000. Its property, carried at 150,000, had a fair value of 210,000. Fair value of net assets at acquisition = ?  (number)", "accept": ["350000"], "display_answer": "350,000", "ex": "200,000 + 90,000 + (210,000 - 150,000) = 350,000."},
							{"type": "choice", "q": "Goodwill arising on consolidation is shown in the consolidated SOFP as:", "opts": ["An intangible non-current asset", "Part of share premium", "A deduction from retained earnings", "A current asset"], "a": 0, "ex": "Positive goodwill is capitalised as an intangible non-current asset."}
						]
					},
					{
						"id": "L2", "title": "Group reserves and NCI at the year-end",
						"outcome": "H1(a)(v) Non-controlling interests; H1(c) Group retained earnings and NCI in the consolidated SOFP",
						"apply": {"title": "Zuru Lemonade Ltd - a year later", "pages": [
							{"text": "31 December year 4. Cold Press's retained earnings have grown from 3,000 to [b]5,000[/b]: it made [b]2,000[/b] of profit since Zuru bought it. Zuru Lemonade Ltd's own retained earnings are [b]12,000[/b].\n\nOnly the [b]post-acquisition[/b] profit belongs to the group - the 3,000 earned before 1 January was paid for in the 10,000 and is already inside goodwill. And of that 2,000, Zuru's shareholders own 80%; the other 20% belongs to the NCI."},
							{"text": "", "table": {"cols": ["Group retained earnings", ""], "rows": [{"c": ["Parent's retained earnings", "12,000"]}, {"c": ["Group share of subsidiary's post-acquisition profit (80% x 2,000)", "1,600"]}, {"c": ["Group retained earnings", "13,600"], "b": true}, {"c": ["Non-controlling interest", ""], "b": true}, {"c": ["NCI at acquisition (fair value)", "2,300"]}, {"c": ["NCI share of post-acquisition profit (20% x 2,000)", "400"]}, {"c": ["NCI at 31 December", "2,700"], "b": true}]}},
							{"text": "In the consolidated SOFP the equity section reads: share capital and share premium (the [b]parent's only[/b] - Cold Press's 5,000 was cancelled against the investment), revaluation surplus, group retained earnings 13,600, then [b]non-controlling interest 2,700[/b] as a separate line within total equity. The NCI is not a liability: those shareholders are owners of part of the group, just not of the parent."}
						]},
						"learn": [
							{"text": "Only profits the subsidiary makes AFTER acquisition belong to the group. Profits before acquisition were bought - they are inside the goodwill working.\n[b]Post-acquisition retained earnings of S = S's retained earnings now - S's retained earnings at acquisition[/b]"},
							{"text": "[b]Group retained earnings[/b] = P's retained earnings + P's share of S's post-acquisition retained earnings (- any unrealised profit adjustment, Lesson 3).\n[b]NCI at the reporting date[/b] = NCI at acquisition (fair value) + NCI's share of S's post-acquisition retained earnings."},
							{"text": "Group [b]share capital and share premium[/b] are always the parent's only. Other reserves (e.g. a revaluation surplus) work like retained earnings: parent's plus the group share of the subsidiary's post-acquisition movement."}
						],
						"example": {"title": "P and S at 31 December 20X9 (S acquired 1 Jan 20X8, 80%)", "table": {"cols": ["", "$"], "rows": [
							{"c": ["S retained earnings now", "180,000"], "s": 1}, {"c": ["S retained earnings at acquisition", "(120,000)"], "s": 1}, {"c": ["S post-acquisition retained earnings", "60,000"], "s": 1, "b": true},
							{"c": ["P retained earnings", "400,000"], "s": 2}, {"c": ["Group share 80% x 60,000", "48,000"], "s": 2}, {"c": ["Group retained earnings", "448,000"], "s": 2, "b": true},
							{"c": ["NCI at acquisition (fair value)", "60,000"], "s": 3}, {"c": ["NCI share 20% x 60,000", "12,000"], "s": 3}, {"c": ["NCI at 31 December 20X9", "72,000"], "s": 3, "b": true}]},
							"steps": ["S has earned 60,000 since it was bought.", "The group gets 80% of that on top of P's own retained earnings.", "The NCI gets its 20% on top of its fair value at acquisition."]},
						"practice": [
							{"type": "input", "q": "P's retained earnings 250,000. S (60% owned) had retained earnings of 40,000 at acquisition and 110,000 at the year-end. Group retained earnings = ?  (number)", "accept": ["292000"], "display_answer": "292,000", "ex": "250,000 + 60% x (110,000 - 40,000) = 250,000 + 42,000 = 292,000."},
							{"type": "input", "q": "NCI was valued at 80,000 at acquisition (40% holding). S's post-acquisition retained earnings are 70,000. NCI at the year-end = ?  (number)", "accept": ["108000"], "display_answer": "108,000", "ex": "80,000 + 40% x 70,000 = 108,000."},
							{"type": "choice", "q": "In the consolidated SOFP, the subsidiary's share premium is:", "opts": ["Not included - only the parent's share premium is shown", "Added to the parent's share premium", "Added to group retained earnings", "Shown within NCI"], "a": 0, "ex": "The subsidiary's share capital and premium were cancelled against the investment in the goodwill working."}
						]
					},
					{
						"id": "L3", "title": "Intra-group items and mid-year acquisitions",
						"outcome": "H1(c)(iii) Eliminate intra-group balances; H1(c)(iv) Remove unrealised profit; H1(c)(v) Acquisition part way through the year",
						"apply": {"title": "Zuru Lemonade Ltd - selling to yourself", "pages": [
							{"text": "During the year the two kiosks traded with each other:\n- Zuru Lemonade Ltd sold bottles to Cold Press for [b]600[/b]; they had cost Zuru [b]400[/b]. At the year-end [b]half[/b] are still on Cold Press's shelf.\n- Cold Press still [b]owes Zuru 500[/b] for them.\n\nFrom the group's point of view nothing has happened: the bottles moved from one shelf to another and the group can't owe itself money."},
							{"text": "", "table": {"cols": ["Adjustment", "Effect in the consolidated SOFP"], "rows": [{"c": ["Intra-group balance 500", "Remove 500 from receivables AND 500 from payables"]}, {"c": ["Unrealised profit: profit on the sale 200, half still unsold = 100", "Reduce inventory by 100; reduce group retained earnings by 100 (Zuru was the seller)"]}, {"c": ["Had Cold Press been the seller", "Reduce inventory by 100; split the 100 between group RE (80) and NCI (20)"]}]}},
							{"text": "[b]Mid-year acquisition[/b]: suppose Zuru had bought Cold Press on [b]1 July[/b] instead. Cold Press's profit for the year is still 2,000, but only [b]6/12 = 1,000[/b] of it is post-acquisition. Retained earnings at acquisition would be 3,000 + 1,000 = 4,000 (used in the goodwill working), and the group's share of post-acquisition profit becomes 80% x 1,000 = 800, the NCI's 200. Time-apportion unless told the profit arose unevenly."}
						]},
						"learn": [
							{"text": "The group can't owe money to itself. If S owes P 12,000 at the year-end: remove 12,000 from group [b]receivables[/b] AND from group [b]payables[/b]. (Goods or cash in transit are not examinable.)"},
							{"text": "[b]Unrealised profit (PURP)[/b]: if P sells goods to S at a profit and S still holds some at the year-end, the group hasn't really made that profit yet.\nUnrealised profit = profit on the intra-group sale x the fraction still in inventory.\nAdjustment: [b]reduce group inventory[/b] and [b]reduce the SELLER'S retained earnings[/b] (P's retained earnings if P sold; S's post-acquisition profits - and so the NCI share - if S sold)."},
							{"text": "Watch the base: 'cost plus 25%' (mark-up) means profit = price x 25/125; 'a margin of 20%' means profit = price x 20%."},
							{"text": "[b]Mid-year acquisition[/b]: S's retained earnings at the acquisition date are usually not given - estimate them by [b]pro-rating[/b] the year's profit:\nRetained earnings at acquisition = retained earnings at the start of the year + profit for the year x months before acquisition / 12. Only post-acquisition profits go to group reserves and NCI."}
						],
						"example": {"title": "Two adjustments", "table": {"cols": ["", "$"], "rows": [
							{"c": ["P sold goods to S for 40,000 at cost plus 25%; a quarter is unsold", ""], "s": 1}, {"c": ["Profit on the sale: 40,000 x 25/125", "8,000"], "s": 1}, {"c": ["Unrealised: 8,000 x 1/4 - reduce inventory and P's retained earnings", "2,000"], "s": 1, "b": true},
							{"c": ["S acquired on 1 April; S retained earnings at 1 January 100,000; profit for the year 60,000", ""], "s": 2}, {"c": ["Retained earnings at acquisition: 100,000 + 60,000 x 3/12", "115,000"], "s": 2, "b": true}]},
							"steps": ["Only the profit on the UNSOLD quarter is unrealised: 2,000 comes off group inventory and off P's retained earnings (P was the seller).", "For a 1 April acquisition, three months of the year's profit were earned before the group owned S."]},
						"practice": [
							{"type": "input", "q": "S sold goods to P for 60,000 at a margin of 30%. Half remain in P's inventory at the year-end. Unrealised profit = ?  (number)", "accept": ["9000"], "display_answer": "9,000", "ex": "Profit 30% x 60,000 = 18,000; half unsold = 9,000. S was the seller, so S's post-acquisition profits (and the NCI share) are reduced."},
							{"type": "input", "q": "P acquired S on 1 October. S's retained earnings at 1 January were 80,000 and its profit for the year (evenly earned) was 48,000. Retained earnings at acquisition = ?  (number)", "accept": ["116000"], "display_answer": "116,000", "ex": "80,000 + 48,000 x 9/12 = 116,000."},
							{"type": "picklist", "q": "At the year-end S owes P 5,000. In the consolidated SOFP, group receivables are {0} and group payables are {1}.", "lists": [["reduced by 5,000", "increased by 5,000", "unchanged"], ["reduced by 5,000", "increased by 5,000", "unchanged"]], "a": [0, 0], "ex": "The intra-group balance is cancelled from both sides."},
							{"type": "choice", "q": "Unrealised profit on goods sold by the PARENT to the subsidiary is deducted from:", "opts": ["Group inventory and the parent's retained earnings", "Group inventory and the NCI", "Goodwill", "The subsidiary's share capital"], "a": 0, "ex": "The seller's profit is reduced; when the parent is the seller, the NCI is not affected."}
						]
					},
					{
						"id": "L4", "title": "Putting the consolidated SOFP together",
						"outcome": "H1(c) Prepare a consolidated SOFP or extracts",
						"apply": {"title": "Zuru Lemonade Ltd - the group balance sheet", "pages": [
							{"text": "Everything from this chapter in one statement. Zuru Lemonade Ltd's own SOFP: PPE 24,000, investment in Cold Press 10,000, inventory 1,400, receivables 2,600 (including the 500 from Cold Press), cash 1,920; liabilities 13,420. Cold Press: PPE 7,000, inventory 900, receivables 1,100, cash 2,000; liabilities 1,000 (including the 500 owed to Zuru); share capital 5,000, retained earnings 5,000.", "table": {"cols": ["Consolidated SOFP - 31 December year 4", "Working", ""], "rows": [{"c": ["Goodwill", "Lesson 1", "3,300"]}, {"c": ["Property, plant and equipment", "24,000 + 7,000 + FV 1,000", "32,000"]}, {"c": ["Inventories", "1,400 + 900 - PURP 100", "2,200"]}, {"c": ["Receivables", "2,600 + 1,100 - intra-group 500", "3,200"]}, {"c": ["Cash", "1,920 + 2,000", "3,920"]}, {"c": ["Total assets", "", "44,620"], "b": true}]}},
							{"text": "", "table": {"cols": ["Equity and liabilities", "Working", ""], "rows": [{"c": ["Share capital (parent only)", "", "6,000"]}, {"c": ["Share premium (parent only)", "", "500"]}, {"c": ["Revaluation surplus (parent only)", "", "8,000"]}, {"c": ["Group retained earnings", "12,000 + 80% x 2,000 - PURP 100", "13,500"]}, {"c": ["Equity attributable to owners of the parent", "", "28,000"]}, {"c": ["Non-controlling interest", "2,300 + 20% x 2,000", "2,700"]}, {"c": ["Total equity", "", "30,700"], "b": true}, {"c": ["Liabilities", "13,420 + 1,000 - intra-group 500", "13,920"]}, {"c": ["Total equity and liabilities", "", "44,620"], "b": true}]}},
							{"text": "It balances, which is the proof that each adjustment went to both sides: the investment and Cold Press's share capital and pre-acquisition reserves cancelled into goodwill; the fair value uplift went into PPE and into the net assets acquired; the 500 came out of both receivables and payables; the PURP came out of inventory and retained earnings. In a 15-mark Section B question these four workings - goodwill, group RE, NCI, PURP - are where the marks are."}
						]},
						"learn": [
							{"text": "The order of work for a group SOFP question:\n1. Group structure: % owned, acquisition date.\n2. Net assets of S at acquisition and now (with fair value adjustments).\n3. Goodwill.\n4. NCI.\n5. Group retained earnings.\n6. Add P + 100% S line by line, with the adjustments."},
							{"text": "Line by line:\n[b]Goodwill[/b] - from the working.\n[b]PPE[/b] - P + S + fair value adjustment.\n[b]Inventory[/b] - P + S - unrealised profit.\n[b]Receivables / payables[/b] - P + S - intra-group balance.\n[b]Share capital / premium[/b] - P only.\n[b]Retained earnings[/b] - from the working. [b]NCI[/b] - from the working."},
							{"text": "Check: total assets = equity (incl. NCI) + liabilities. If it doesn't balance, the usual culprits are the fair value adjustment (must be in BOTH PPE and net assets at acquisition) or the unrealised profit (must be in BOTH inventory and retained earnings)."}
						],
						"example": {"title": "P group - consolidated SOFP at 31 December 20X9 ($000)", "table": {"cols": ["", "P", "S", "Adjust", "Group"], "rows": [
							{"c": ["Goodwill", "-", "-", "+85", "85"], "s": 1},
							{"c": ["PPE (FV adj on land +30)", "600", "250", "+30", "880"], "s": 2}, {"c": ["Investment in S", "275", "-", "-275", "-"], "s": 2},
							{"c": ["Inventory (PURP 2)", "90", "40", "-2", "128"], "s": 3}, {"c": ["Receivables (S owes P 10)", "80", "35", "-10", "105"], "s": 3}, {"c": ["Bank", "25", "15", "", "40"], "s": 3}, {"c": ["Total assets", "", "", "", "1,238"], "s": 3, "b": true},
							{"c": ["Share capital (P only)", "300", "100", "-100", "300"], "s": 4}, {"c": ["Retained earnings (400 + 80% x 60 - 2)", "400", "180", "", "446"], "s": 4}, {"c": ["NCI (60 + 20% x 60)", "-", "-", "", "72"], "s": 4},
							{"c": ["Payables (S owes P 10)", "95", "60", "-10", "145"], "s": 4}, {"c": ["Total equity and liabilities", "", "", "", "1,238"], "s": 4, "b": true}]},
							"steps": ["Goodwill from Lesson 1 replaces the investment.", "PPE adds P, S and the fair value uplift; the investment line disappears.", "Inventory less the unrealised profit; receivables less the intra-group balance; total assets 1,238.", "Share capital is P's only; retained earnings and NCI from the workings (the 2 PURP reduces P's); payables less the intra-group balance. It balances at 1,238."]},
						"practice": [
							{"type": "input", "q": "P's PPE 420,000; S's PPE 180,000; at acquisition S's land had a fair value 25,000 above its carrying amount. Group PPE = ?  (number)", "accept": ["625000"], "display_answer": "625,000", "ex": "420,000 + 180,000 + 25,000 = 625,000."},
							{"type": "input", "q": "P inventory 75,000; S inventory 42,000; unrealised profit on intra-group goods 3,500. Group inventory = ?  (number)", "accept": ["113500"], "display_answer": "113,500", "ex": "75,000 + 42,000 - 3,500 = 113,500."},
							{"type": "input", "q": "Group share capital 300,000; group retained earnings 446,000; NCI 72,000; payables 145,000. Total equity and liabilities = ?  (number)", "accept": ["963000"], "display_answer": "963,000", "ex": "300,000 + 446,000 + 72,000 + 145,000 = 963,000."},
							{"type": "multi", "q": "Which TWO lines in the consolidated SOFP come from the PARENT only?", "opts": ["Share capital", "Share premium", "Retained earnings", "Trade payables"], "a": [0, 1], "ex": "Share capital and premium are the parent's; retained earnings and payables combine both companies."}
						]
					}
				],
				# Section B 15-mark MTQ: consolidated SOFP (NCI at fair value, FV adjustment, intra-group balance, unrealised profit).
				"mtq": {
					"title": "Section B: Falcon Group", "monster": "The Consolidation Hydra", "marks": 15,
					"scenario": [
						{"text": "Falcon Co bought [b]75%[/b] of the ordinary shares of Sparrow Co on [b]1 January 20X9[/b] for 330,000 in cash. The statements of financial position of both companies at [b]31 December 20X9[/b] are below."},
						{"table": {"cols": ["Statements of financial position at 31 Dec 20X9", "Falcon $", "Sparrow $"], "rows": [
							{"c": ["Property, plant and equipment", "500,000", "220,000"]}, {"c": ["Investment in Sparrow", "330,000", "-"]}, {"c": ["Inventory", "90,000", "50,000"]}, {"c": ["Trade receivables", "70,000", "30,000"]}, {"c": ["Bank", "40,000", "20,000"]},
							{"c": ["Total assets", "1,030,000", "320,000"], "b": true},
							{"c": ["Ordinary share capital", "400,000", "100,000"]}, {"c": ["Retained earnings", "480,000", "160,000"]}, {"c": ["Trade payables", "150,000", "60,000"]},
							{"c": ["Total equity and liabilities", "1,030,000", "320,000"], "b": true}]}},
						{"text": "[b]Notes[/b]\n1. At 1 January 20X9 Sparrow's retained earnings were 100,000.\n2. At acquisition the fair value of Sparrow's land was 40,000 more than its carrying amount. Land is not depreciated.\n3. The fair value of the non-controlling interest at acquisition was 95,000.\n4. During the year Falcon sold goods to Sparrow for 40,000 at cost plus 25%. A quarter of these goods were still in Sparrow's inventory at 31 December 20X9.\n5. At 31 December 20X9 Sparrow owed Falcon 12,000, included in both companies' receivables and payables."}
					],
					"tasks": [
						{"title": "Task 1: Workings", "intro": "Enter the missing figures.", "rows": [
							{"c": ["Fair value of Sparrow's net assets at acquisition", "#na"]}, {"c": ["Goodwill at acquisition", "#gw"]}, {"c": ["Non-controlling interest at 31 December 20X9", "#nci"]}, {"c": ["Group retained earnings at 31 December 20X9", "#re"]}],
							"blanks": {
								"na": {"accept": ["240000"], "show": "240,000", "marks": 2, "ex": "Share capital 100,000 + retained earnings at acquisition 100,000 + fair value adjustment 40,000 = 240,000."},
								"gw": {"accept": ["185000"], "show": "185,000", "marks": 2, "ex": "Consideration 330,000 + NCI 95,000 - net assets 240,000 = 185,000."},
								"nci": {"accept": ["110000"], "show": "110,000", "marks": 2, "ex": "95,000 + 25% x post-acquisition retained earnings (160,000 - 100,000 = 60,000) = 95,000 + 15,000 = 110,000."},
								"re": {"accept": ["523000"], "show": "523,000", "marks": 2, "ex": "480,000 + 75% x 60,000 - unrealised profit 2,000 (40,000 x 25/125 x 1/4) = 480,000 + 45,000 - 2,000 = 523,000."}
							}},
						{"title": "Task 2: Consolidated statement of financial position extracts", "intro": "Enter the missing figures.", "rows": [
							{"c": ["Goodwill", "(from Task 1)"]}, {"c": ["Property, plant and equipment", "#ppe"]}, {"c": ["Inventory", "#inv"]}, {"c": ["Trade receivables", "#rec"]}, {"c": ["Bank", "60,000"]},
							{"c": ["Total equity (including NCI)", "#eq"], "b": true}, {"c": ["Trade payables", "#pay"]}],
							"blanks": {
								"ppe": {"accept": ["760000"], "show": "760,000", "marks": 1, "ex": "500,000 + 220,000 + 40,000 fair value adjustment = 760,000."},
								"inv": {"accept": ["138000"], "show": "138,000", "marks": 2, "ex": "90,000 + 50,000 - 2,000 unrealised profit = 138,000."},
								"rec": {"accept": ["88000"], "show": "88,000", "marks": 1, "ex": "70,000 + 30,000 - 12,000 intra-group = 88,000."},
								"eq": {"accept": ["1033000"], "show": "1,033,000", "marks": 2, "ex": "Share capital 400,000 (Falcon only) + retained earnings 523,000 + NCI 110,000 = 1,033,000."},
								"pay": {"accept": ["198000"], "show": "198,000", "marks": 1, "ex": "150,000 + 60,000 - 12,000 = 198,000. Check: 185,000 + 760,000 + 138,000 + 88,000 + 60,000 = 1,231,000 = 1,033,000 + 198,000."}
							}}
					]
				}
			},
			{
				"id": 25, "title": "The consolidated statement of profit or loss", "monster": "The Profit Chimera",
				"beats": [
					{"type":"choice","q":"Sales made between the parent and its subsidiary are:","opts":["Added to group revenue","Eliminated on consolidation","Shown as NCI","Treated as goodwill"],"a":1,"ex":"The group cannot trade with itself, so intra-group sales are eliminated."},
					{"type":"input","q":"P sold goods to S for 10,000 at cost plus 25%. Half are still in S's inventory at the year-end. Unrealised profit (PURP) = ?  (number)","accept":["1000"],"display_answer":"1,000","ex":"Profit = 10,000 x 25/125 = 2,000; half unsold = 1,000."}
				],
				# Ch 25 learning objectives: H1(e)(i)-(iii). Section B: consolidated SOPL with intra-group trading, unrealised profit (adjust NCI if the subsidiary sold), mid-year acquisition.
				"lessons": [
					{
						"id": "L1", "title": "The consolidated statement of profit or loss",
						"outcome": "H1(e) Components of the consolidated SOPL; profit attributable to the parent's shareholders and to the NCI",
						"apply": {"title": "Zuru Lemonade Ltd - the group's profit", "pages": [
							{"text": "Year 4 results of the two companies on their own: Zuru Lemonade Ltd revenue 24,000, profit 5,120; Cold Press revenue 9,000, profit 2,000. The consolidated SOPL adds them [b]100% line by line[/b] - the group controls all of Cold Press's sales, not 80% of them - and only at the bottom splits the profit between the two sets of owners.", "table": {"cols": ["Consolidated SOPL - year 4 (before intra-group adjustments)", ""], "rows": [{"c": ["Revenue (24,000 + 9,000)", "33,000"]}, {"c": ["Cost of sales (10,000 + 5,000)", "(15,000)"]}, {"c": ["Gross profit", "18,000"], "b": true}, {"c": ["Other expenses, finance costs, tax (both companies)", "(10,880)"]}, {"c": ["Profit for the year", "7,120"], "b": true}, {"c": ["Attributable to: owners of the parent", "6,720"]}, {"c": ["Attributable to: non-controlling interest (20% x 2,000)", "400"]}]}},
							{"text": "The [b]non-controlling interest's share[/b] is always their percentage of the SUBSIDIARY's profit (adjusted for anything that belongs to the subsidiary alone, like a PURP where the subsidiary was the seller). The owners of the parent get everything else: 7,120 - 400 = 6,720, which is the parent's own 5,120 plus 80% of 2,000.\n\nIf Cold Press paid a dividend during the year, the parent's share is [b]cancelled[/b] - it is a transfer inside the group, not income - and the NCI's share is simply part of their 400 anyway."}
						]},
						"learn": [
							{"text": "The group SOPL shows the results of the group as a [b]single entity[/b]: add the parent and [b]100%[/b] of the subsidiary [b]line by line[/b] - revenue, cost of sales, expenses, tax - down to profit for the year."},
							{"text": "Then split the profit for the year between the two sets of owners:\n[b]Attributable to the non-controlling interest[/b] = NCI % x the subsidiary's profit for the year (after tax).\n[b]Attributable to the owners of the parent[/b] = the rest."},
							{"text": "[b]Dividends[/b] received by the parent from the subsidiary are NOT group income - the group can't earn income from itself. Take them out of investment income. (Dividends paid to the NCI are a distribution, not an expense.)"}
						],
						"example": {"title": "P (80% of S) - consolidated SOPL ($000)", "table": {"cols": ["", "P", "S", "Group"], "rows": [
							{"c": ["Revenue", "800", "300", "1,100"], "s": 1}, {"c": ["Cost of sales", "(500)", "(180)", "(680)"], "s": 1}, {"c": ["Gross profit", "300", "120", "420"], "s": 1, "b": true},
							{"c": ["Operating expenses", "(150)", "(50)", "(200)"], "s": 2}, {"c": ["Operating profit", "150", "70", "220"], "s": 2, "b": true},
							{"c": ["Income tax", "(40)", "(20)", "(60)"], "s": 3}, {"c": ["Profit for the year", "110", "50", "160"], "s": 3, "b": true},
							{"c": ["Attributable to NCI: 20% x 50", "", "", "10"], "s": 4}, {"c": ["Attributable to owners of the parent", "", "", "150"], "s": 4, "b": true}]},
							"steps": ["Add each line in full - 100% of S even though P owns 80%.", "Expenses too; operating profit 220.", "Tax and profit for the year: 160 in total.", "Split it: the NCI's 20% of S's own profit (50) is 10; the parent's owners get 150."]},
						"practice": [
							{"type": "input", "q": "P's revenue 650,000; S's revenue 240,000 (S is 70% owned, no intra-group sales). Consolidated revenue = ?  (number)", "accept": ["890000"], "display_answer": "890,000", "ex": "100% of both: 650,000 + 240,000 = 890,000."},
							{"type": "input", "q": "Group profit for the year 185,000. The subsidiary (60% owned) made a profit of 45,000. Profit attributable to the NCI = ?  (number)", "accept": ["18000"], "display_answer": "18,000", "ex": "40% x 45,000 = 18,000. The owners of the parent get 167,000."},
							{"type": "choice", "q": "A dividend received by the parent from its subsidiary is:", "opts": ["Excluded from the consolidated SOPL", "Shown as investment income", "Shown as revenue", "Deducted from the NCI"], "a": 0, "ex": "Intra-group dividends cancel - the group cannot earn income from itself."}
						]
					},
					{
						"id": "L2", "title": "Intra-group trading and unrealised profit",
						"outcome": "H1(e)(i) Eliminate intra-group trading; H1(e)(ii) Remove unrealised profit (adjust the NCI if the subsidiary was the seller)",
						"apply": {"title": "Zuru Lemonade Ltd - the bottles that went across the square", "pages": [
							{"text": "The 600 of bottles Zuru sold to Cold Press sit in BOTH companies' figures: 600 of revenue in Zuru's SOPL, 600 of purchases in Cold Press's. To the group it was a stock transfer. And of the 200 profit Zuru booked, 100 relates to bottles Cold Press hasn't sold yet - the group hasn't earned it.", "table": {"cols": ["Adjustment", "Revenue", "Cost of sales"], "rows": [{"c": ["Remove the intra-group sale", "(600)", "(600)"]}, {"c": ["Add back the unrealised profit still in inventory", "", "+100"]}, {"c": ["Consolidated figures", "33,000 - 600 = 32,400", "15,000 - 600 + 100 = 14,500"], "b": true}]}},
							{"text": "Gross profit falls by the 100 PURP (the 600 cancels on both lines); profit for the year becomes 7,120 - 100 = [b]7,020[/b]. Who bears the 100? [b]Zuru was the seller[/b], so it comes entirely off the parent's shareholders: owners of the parent 6,620, NCI still 400.\n\nHad [b]Cold Press[/b] sold the bottles to Zuru, the 100 would reduce Cold Press's profit, so the NCI would bear 20% of it: NCI 380, owners of the parent 6,640. Same total, different split - and that split is exactly what the exam asks for."},
							{"text": "The same cancellation applies to intra-group interest, management charges and dividends: remove the income from one side and the expense from the other, and the group's profit is unchanged. Only the unrealised profit in [b]unsold[/b] inventory actually changes the total - and it unwinds next year when Cold Press sells the bottles."}
						]},
						"learn": [
							{"text": "Sales between group companies are not sales to the outside world. Remove the intra-group sales from BOTH [b]group revenue[/b] and [b]group cost of sales[/b] - the same amount each - so gross profit is unchanged by the cancellation itself."},
							{"text": "If some of those goods are still in the buyer's inventory at the year-end, the profit on them is [b]unrealised[/b]. [b]Add the unrealised profit to group cost of sales[/b] (closing inventory is overstated, so cost of sales is understated). This REDUCES group profit."},
							{"text": "Who bears it? If the [b]parent[/b] sold the goods, the reduction all falls on the owners of the parent. If the [b]subsidiary[/b] sold them, the subsidiary's profit is reduced - so the [b]NCI's share[/b] is calculated on the subsidiary's profit LESS the unrealised profit."}
						],
						"example": {"title": "S (75% owned) sold goods to P for 20,000 at a margin of 20%; half still unsold", "table": {"cols": ["", "$"], "rows": [
							{"c": ["Cancel from revenue AND cost of sales", "20,000"], "s": 1},
							{"c": ["Profit on the sale 20% x 20,000 = 4,000; unrealised half", "2,000"], "s": 2}, {"c": ["Add 2,000 to group cost of sales", ""], "s": 2},
							{"c": ["S's profit for the year 60,000 - unrealised 2,000", "58,000"], "s": 3}, {"c": ["NCI share: 25% x 58,000", "14,500"], "s": 3, "b": true}]},
							"steps": ["The 20,000 sale comes out of both revenue and cost of sales.", "Half the goods are unsold, so 2,000 of profit isn't real yet - add it to cost of sales.", "S was the seller, so S's profit is reduced before the NCI's 25% is worked out."]},
						"practice": [
							{"type": "input", "q": "P revenue 500,000; S revenue 200,000; P sold goods to S for 30,000 during the year. Consolidated revenue = ?  (number)", "accept": ["670000"], "display_answer": "670,000", "ex": "500,000 + 200,000 - 30,000 = 670,000."},
							{"type": "input", "q": "P cost of sales 300,000; S cost of sales 120,000; intra-group sales 30,000; unrealised profit in closing inventory 4,000. Consolidated cost of sales = ?  (number)", "accept": ["394000"], "display_answer": "394,000", "ex": "300,000 + 120,000 - 30,000 + 4,000 = 394,000."},
							{"type": "input", "q": "S (80% owned) made a profit of 90,000. S sold goods to P and 6,000 of profit on them is unrealised at the year-end. Profit attributable to the NCI = ?  (number)", "accept": ["16800"], "display_answer": "16,800", "ex": "S was the seller: 20% x (90,000 - 6,000) = 16,800."},
							{"type": "choice", "q": "Unrealised profit on goods sold by the PARENT to the subsidiary affects the NCI share of profit:", "opts": ["Not at all", "By reducing it", "By increasing it", "Only if the goods are sold next year"], "a": 0, "ex": "The parent's profit is reduced; the subsidiary's profit - and so the NCI - is untouched."}
						]
					},
					{
						"id": "L3", "title": "Mid-year acquisitions",
						"outcome": "H1(e)(iii) Acquisition of a subsidiary part way through the year",
						"apply": {"title": "Zuru Lemonade Ltd - if the deal had closed in July", "pages": [
							{"text": "Replay the year with the acquisition on [b]1 July[/b]. Cold Press still made revenue 9,000 and profit 2,000 for the full year, but the group only controlled it for [b]six months[/b]. The consolidated SOPL includes only the post-acquisition half of every Cold Press line.", "table": {"cols": ["", "Full-year acquisition", "Acquired 1 July"], "rows": [{"c": ["Cold Press revenue consolidated", "9,000", "4,500"]}, {"c": ["Cold Press profit consolidated", "2,000", "1,000"]}, {"c": ["NCI share of profit (20%)", "400", "200"]}, {"c": ["Owners of the parent (5,120 + 80% share)", "6,720", "5,920"]}]}},
							{"text": "Time-apportion every Cold Press line - revenue, cost of sales, expenses, tax - at 6/12, unless the question says a particular item arose after the acquisition (then take all of it) or before it (then none). Intra-group sales and PURPs are only removed for trading [b]after[/b] the acquisition date; a sale in March between what were then two unrelated companies stays in."},
							{"text": "The other half of the year isn't lost: it went into the retained earnings at acquisition (3,000 + 1,000 = 4,000) and therefore into the goodwill calculation on the SOFP side. The two statements agree: the profit the SOPL shows as post-acquisition is exactly the profit the SOFP adds to group retained earnings and NCI."}
						]},
						"learn": [
							{"text": "The group only controls the subsidiary from the acquisition date, so the consolidated SOPL includes the subsidiary's results [b]only from that date[/b]. Unless told otherwise, assume income and expenses arise evenly and [b]pro-rate[/b] every line by the months owned."},
							{"text": "The NCI share is also based on the post-acquisition months only: NCI % x the subsidiary's profit for the year x months owned / 12."},
							{"text": "Intra-group trading before the acquisition date is NOT cancelled - the companies weren't a group then. Only post-acquisition intra-group sales are eliminated."}
						],
						"example": {"title": "S acquired on 1 October (3 months before the year-end), 80% owned", "table": {"cols": ["", "S full year", "Included (3/12)"], "rows": [
							{"c": ["Revenue", "240,000", "60,000"], "s": 1}, {"c": ["Cost of sales", "(150,000)", "(37,500)"], "s": 1}, {"c": ["Expenses", "(30,000)", "(7,500)"], "s": 1},
							{"c": ["Profit for the year", "60,000", "15,000"], "s": 2},
							{"c": ["NCI share: 20% x 15,000", "", "3,000"], "s": 3, "b": true}]},
							"steps": ["Each line is multiplied by 3/12.", "Only 15,000 of S's profit is post-acquisition.", "The NCI gets 20% of that: 3,000."]},
						"practice": [
							{"type": "input", "q": "P acquired 70% of S on 1 May. S's revenue for the year was 360,000, earned evenly. How much of S's revenue is consolidated?  (number)", "accept": ["240000"], "display_answer": "240,000", "ex": "8 months owned (May-December): 360,000 x 8/12 = 240,000."},
							{"type": "input", "q": "S (60% owned) was acquired on 1 July. Its profit for the year was 84,000, earned evenly. Profit attributable to the NCI = ?  (number)", "accept": ["16800"], "display_answer": "16,800", "ex": "Post-acquisition profit 84,000 x 6/12 = 42,000; NCI 40% = 16,800."},
							{"type": "choice", "q": "Sales from S to P made BEFORE P acquired S are:", "opts": ["Not eliminated - the companies were not a group at the time", "Eliminated in full", "Eliminated in proportion to the holding", "Added to goodwill"], "a": 0, "ex": "Only post-acquisition intra-group trading is cancelled."}
						]
					}
				],
				# Section B 15-mark MTQ: consolidated SOPL (intra-group sales, unrealised profit, intra-group dividend, NCI share).
				"mtq": {
					"title": "Section B: Falcon Group - profit or loss", "monster": "The Profit Chimera", "marks": 15,
					"scenario": [
						{"text": "Falcon Co has owned [b]75%[/b] of Sparrow Co since [b]1 January 20X9[/b]. Their statements of profit or loss for the year to [b]31 December 20X9[/b] are below."},
						{"table": {"cols": ["Statements of profit or loss for the year to 31 Dec 20X9", "Falcon $", "Sparrow $"], "rows": [
							{"c": ["Revenue", "900,000", "400,000"]}, {"c": ["Cost of sales", "(540,000)", "(250,000)"]}, {"c": ["Gross profit", "360,000", "150,000"], "b": true},
							{"c": ["Operating expenses", "(150,000)", "(60,000)"]}, {"c": ["Operating profit", "210,000", "90,000"], "b": true},
							{"c": ["Investment income", "12,000", "-"]}, {"c": ["Finance costs", "(10,000)", "-"]}, {"c": ["Profit before tax", "212,000", "90,000"]},
							{"c": ["Income tax expense", "(50,000)", "(20,000)"]}, {"c": ["Profit for the year", "162,000", "70,000"], "b": true}]}},
						{"text": "[b]Notes[/b]\n1. During the year Falcon sold goods to Sparrow for 40,000 at cost plus 25%. A quarter of these goods remain in Sparrow's inventory at the year-end.\n2. Sparrow paid a dividend of 12,000 during the year. Falcon's share is included in its investment income.\n3. There were no intra-group balances or unrealised profit at the start of the year."}
					],
					"tasks": [
						{"title": "Task 1: Consolidated statement of profit or loss", "intro": "Enter the missing figures as positive numbers.", "rows": [
							{"c": ["Revenue", "#rev"]}, {"c": ["Cost of sales", "#cos"]}, {"c": ["Operating expenses", "#opex"]}, {"c": ["Operating profit", "#op"], "b": true},
							{"c": ["Investment income", "#inv"]}, {"c": ["Finance costs", "10,000"]}, {"c": ["Income tax expense", "#tax"]}, {"c": ["Profit for the year", "#profit"], "b": true}],
							"blanks": {
								"rev": {"accept": ["1260000"], "show": "1,260,000", "marks": 2, "ex": "900,000 + 400,000 - 40,000 intra-group sales = 1,260,000."},
								"cos": {"accept": ["752000"], "show": "752,000", "marks": 3, "ex": "540,000 + 250,000 - 40,000 intra-group + 2,000 unrealised profit (40,000 x 25/125 x 1/4) = 752,000."},
								"opex": {"accept": ["210000"], "show": "210,000", "marks": 1, "ex": "150,000 + 60,000 = 210,000."},
								"op": {"accept": ["298000"], "show": "298,000", "marks": 1, "ex": "1,260,000 - 752,000 - 210,000 = 298,000."},
								"inv": {"accept": ["3000"], "show": "3,000", "marks": 2, "ex": "12,000 less the dividend from Sparrow (75% x 12,000 = 9,000) = 3,000."},
								"tax": {"accept": ["70000"], "show": "70,000", "marks": 1, "ex": "50,000 + 20,000 = 70,000."},
								"profit": {"accept": ["221000"], "show": "221,000", "marks": 1, "ex": "298,000 + 3,000 - 10,000 - 70,000 = 221,000."}
							}},
						{"title": "Task 2: Split of profit for the year", "intro": "Enter the missing figures.", "rows": [
							{"c": ["Profit attributable to the non-controlling interest", "#nci"]}, {"c": ["Profit attributable to the owners of Falcon", "#own"]}],
							"blanks": {
								"nci": {"accept": ["17500"], "show": "17,500", "marks": 2, "ex": "25% x Sparrow's profit 70,000 = 17,500. Falcon was the seller, so the unrealised profit does not affect the NCI."},
								"own": {"accept": ["203500"], "show": "203,500", "marks": 2, "ex": "221,000 - 17,500 = 203,500."}
							}}
					]
				}
			},
			{
				"id": 26, "title": "Interpretation of financial statements", "monster": "The Ratio Raven",
				"beats": [
				],
				# Ch 26 learning objectives: I1(a)(b), I2(a)(b), I3(a)(b). Exam: calculate ratios; explain differences between years / companies; purpose and limitations. Section A or B.
				# Ratio definitions follow the study text.
				"lessons": [
					{
						"id": "L1", "title": "Why interpret, and the profitability ratios",
						"outcome": "I1(a) How interpretation is used in business; I1(b) Purpose of ratios; I2(a)(i) Profitability ratios",
						"apply": {"title": "Zuru Lemonade Ltd - the bank's spreadsheet", "pages": [
							{"text": "Zuru asks the bank for 8,000 to open kiosk three. The manager doesn't read the statements line by line; she turns year 3 into [b]ratios[/b] and compares them with last year and with other cafe businesses. Revenue 24,000, gross profit 14,000, operating profit 6,500; equity 22,960 plus the 2,400 long-term loan = capital employed [b]25,360[/b]."},
							{"text": "", "table": {"cols": ["Profitability", "Working", "Year 3", "Year 2"], "rows": [{"c": ["Return on capital employed", "6,500 / 25,360", "25.6%", "22.1%"]}, {"c": ["Gross profit margin", "14,000 / 24,000", "58.3%", "57.0%"]}, {"c": ["Operating profit margin", "6,500 / 24,000", "27.1%", "24.8%"]}, {"c": ["Asset turnover", "24,000 / 25,360", "0.95 times", "0.90 times"]}]}},
							{"text": "Her reading: every pound of capital earned 25.6p of operating profit, up on last year, because both the margin (each sale earns more - the bottled range) AND the turnover (the capital works harder) improved. ROCE = margin x asset turnover: 27.1% x 0.95 = 25.6%. A ratio on its own says little; the [b]trend[/b] and the [b]comparison[/b] are the point. Ratios turn two pages of numbers into a conversation about whether the business is getting better."}
						]},
						"learn": [
							{"text": "The statements give absolute numbers; [b]ratios[/b] turn them into something you can [b]compare[/b] - with last year, with a competitor, or with a target. Users (lenders, investors, managers, suppliers) use them to judge performance, liquidity, efficiency and risk, and to decide whether to lend, invest or trade."},
							{"text": "Before any calculation, note the obvious: did revenue grow? Did margins fall? Any new loan or share issue? Ratios then explain the [b]why[/b]. Four families: [b]profitability, liquidity, efficiency, position[/b]."},
							{"text": "Profitability:\n[b]Gross profit margin[/b] = Gross profit / Revenue x 100% - pricing and buying.\n[b]Operating profit margin[/b] = Profit before financing and income taxes / Revenue x 100% - control of overheads too.\n[b]Return on capital employed (ROCE)[/b] = Profit before financing and income taxes / (Total equity + Non-current liabilities) x 100% - return on the long-term money invested.\n[b]Return on equity (ROE)[/b] = (Profit for the year - preference dividends) / Total equity x 100% - return to ordinary shareholders."}
						],
						"example": {"title": "Zenith Co - profitability", "table": {"cols": ["", "$000", "Ratio"], "rows": [
							{"c": ["Revenue 1,000; gross profit 400", "", "GP margin 40%"], "s": 1},
							{"c": ["Profit before financing and income taxes 150", "", "Operating margin 15%"], "s": 2},
							{"c": ["Equity 600 + non-current liabilities 200 = capital employed 800", "", "ROCE 18.75%"], "s": 3},
							{"c": ["Profit for the year 100; no preference shares", "", "ROE 16.7%"], "s": 4}]},
							"steps": ["Gross margin: 400 / 1,000 = 40%.", "Operating margin: 150 / 1,000 = 15% - so overheads ate 25% of revenue.", "ROCE: 150 / 800 = 18.75% earned on the long-term capital.", "ROE: 100 / 600 = 16.7% for the ordinary shareholders."]},
						"practice": [
							{"type": "input", "q": "Revenue 820,000; cost of sales 533,000. Gross profit margin (%) = ?  (number, to 1 decimal)", "accept": ["35", "35.0", "35%"], "display_answer": "35.0%", "ex": "(820,000 - 533,000) / 820,000 = 35.0%."},
							{"type": "input", "q": "Profit before financing and income taxes 96,000; total equity 450,000; non-current liabilities 150,000. ROCE (%) = ?  (number)", "accept": ["16", "16.0", "16%"], "display_answer": "16%", "ex": "96,000 / (450,000 + 150,000) = 16%."},
							{"type": "choice", "q": "Gross profit margin fell from 42% to 36% while revenue rose. The MOST likely explanation is:", "opts": ["Selling prices were cut or purchase costs rose", "Administrative expenses increased", "A new loan was taken out", "The tax rate increased"], "a": 0, "ex": "Gross margin is about selling price versus cost of sales. Overheads, loans and tax sit below gross profit."},
							{"type": "picklist", "q": "ROCE measures the {0} earned on {1}.", "lists": [["profit before financing and income taxes", "profit for the year", "gross profit"], ["equity plus non-current liabilities", "total assets", "revenue"]], "a": [0, 0], "ex": "ROCE = PBFIT / (equity + non-current liabilities)."}
						]
					},
					{
						"id": "L2", "title": "Liquidity and efficiency ratios",
						"outcome": "I2(a)(ii)(iii) Liquidity and efficiency ratios; I2(b) Interrelationships between ratios",
						"apply": {"title": "Zuru Lemonade Ltd - can it pay its bills?", "pages": [
							{"text": "Next the manager checks whether the company can pay what it owes in the next year. Current assets 6,100 (inventory 1,400, receivables 2,600, prepayment 180, cash 1,920); current liabilities 9,820; trade payables within that 1,800; cost of sales 10,000; purchases 10,400.", "table": {"cols": ["Liquidity and efficiency", "Working", "Result"], "rows": [{"c": ["Current ratio", "6,100 / 9,820", "0.62 : 1"]}, {"c": ["Quick (acid test) ratio", "(6,100 - 1,400) / 9,820", "0.48 : 1"]}, {"c": ["Receivable days", "2,600 / 24,000 x 365", "40 days"]}, {"c": ["Inventory days", "1,400 / 10,000 x 365", "51 days"]}, {"c": ["Payable days", "1,800 / 10,400 x 365", "63 days"]}]}},
							{"text": "A current ratio of 0.62 would alarm a textbook, but the manager looks closer: a lemonade business sells for cash or on 40-day terms, turns its inventory in 51 days and pays Kenji in 63 - cash comes in [b]before[/b] it goes out. The 9,820 also includes the tax bill and deferred income, not just suppliers. Context beats the rule of thumb (2:1).\n\nThe [b]cash operating cycle[/b] = inventory days + receivable days - payable days = 51 + 40 - 63 = [b]28 days[/b]: the company funds four weeks of trading from its own cash. Shorter is easier to finance."},
							{"text": "The ratios pull on each other. Offer the cafes 60-day terms to win more orders and receivable days rise, the cycle lengthens, cash tightens - the extra margin from the bigger orders has to pay for that. Squeeze Kenji to 90 days and the cycle shortens, but he may stop giving the trade discount, so the gross margin slips. Interpretation means saying which trade-off the numbers reveal, not just reciting them."}
						]},
						"learn": [
							{"text": "Liquidity - can the business pay its short-term debts?\n[b]Current ratio[/b] = Current assets / Current liabilities (shown as X : 1).\n[b]Quick (acid test) ratio[/b] = (Current assets - Inventories) / Current liabilities - inventory is the slowest asset to turn into cash, so leave it out."},
							{"text": "Efficiency - how fast does working capital turn over?\n[b]Inventory turnover period[/b] = Inventories / Cost of sales x 365 days.\n[b]Receivables collection period[/b] = Trade receivables / Revenue x 365 days.\n[b]Payables payment period[/b] = Trade payables / Cost of sales x 365 days."},
							{"text": "[b]Working capital cycle[/b] = Inventory days + Receivable days - Payable days: how long cash is tied up between paying suppliers and collecting from customers.\n[b]Asset turnover[/b] = Revenue / (Total assets - Current liabilities) = X times: how hard the capital employed is working.\nLink: [b]ROCE = Operating margin x Asset turnover[/b] (15% x 1.25 = 18.75%)."}
						],
						"example": {"title": "Zenith Co - liquidity and efficiency ($000)", "table": {"cols": ["", "Working", "Ratio"], "rows": [
							{"c": ["Current assets 300 (inventory 120, receivables 150, cash 30); current liabilities 150", "300 / 150", "Current 2.0 : 1"], "s": 1},
							{"c": ["Quick ratio", "(300 - 120) / 150", "1.2 : 1"], "s": 1},
							{"c": ["Inventory days (cost of sales 600)", "120 / 600 x 365", "73 days"], "s": 2},
							{"c": ["Receivable days (revenue 1,000)", "150 / 1,000 x 365", "55 days"], "s": 2},
							{"c": ["Payable days (payables 100)", "100 / 600 x 365", "61 days"], "s": 2},
							{"c": ["Working capital cycle", "73 + 55 - 61", "67 days"], "s": 3},
							{"c": ["Asset turnover (total assets 950)", "1,000 / (950 - 150)", "1.25 times"], "s": 3}]},
							"steps": ["Liquidity: 2.0 current, 1.2 quick - comfortable.", "Efficiency: inventory sits 73 days, customers take 55 days, suppliers are paid in 61.", "Cash is tied up for 67 days; each $1 of capital employed generates $1.25 of revenue."]},
						"practice": [
							{"type": "input", "q": "Current assets 420,000 (including inventory 180,000); current liabilities 240,000. Quick ratio = ? (to 2 decimals)", "accept": ["1", "1.0", "1.00"], "display_answer": "1.00 : 1", "ex": "(420,000 - 180,000) / 240,000 = 1.00."},
							{"type": "input", "q": "Trade receivables 90,000; revenue 730,000. Receivables collection period in days = ? (whole days)", "accept": ["45"], "display_answer": "45 days", "ex": "90,000 / 730,000 x 365 = 45 days."},
							{"type": "input", "q": "Inventory days 60; receivable days 48; payable days 55. Working capital cycle = ? (days)", "accept": ["53"], "display_answer": "53 days", "ex": "60 + 48 - 55 = 53 days."},
							{"type": "choice", "q": "The receivables collection period has risen from 40 to 65 days. This suggests:", "opts": ["Weaker credit control - customers are taking longer to pay", "The company is paying its suppliers faster", "Inventory is selling faster", "Gearing has fallen"], "a": 0, "ex": "Receivable days measure how long customers take to pay."},
							{"type": "choice", "q": "Which ratio EXCLUDES inventory?", "opts": ["The quick (acid test) ratio", "The current ratio", "Asset turnover", "The inventory turnover period"], "a": 0, "ex": "The quick ratio removes inventory because it is the least liquid current asset."}
						]
					},
					{
						"id": "L3", "title": "Position ratios, drawing conclusions and limitations",
						"outcome": "I2(a)(iv) Position ratios; I3(a) Interpret relationships; I3(b) Draw valid conclusions and present them to users",
						"apply": {"title": "Zuru Lemonade Ltd - the decision", "pages": [
							{"text": "Last, the bank asks how much the company already owes relative to what the owners have put in, and whether profits cover the interest.", "table": {"cols": ["Position", "Working", "Result"], "rows": [{"c": ["Gearing (debt / debt + equity)", "2,400 / (2,400 + 22,960)", "9.5%"]}, {"c": ["Gearing after the new 8,000 loan", "10,400 / 33,360", "31.2%"]}, {"c": ["Interest cover", "6,500 / 180", "36 times"]}, {"c": ["Interest cover after the new loan (interest 660)", "6,500 / 660", "9.8 times"]}]}},
							{"text": "The manager's note to credit committee, in plain words:\n- Profitability is strong and improving (ROCE 25.6%, margins up).\n- Liquidity looks thin on the headline ratio (0.62) but the 28-day cash cycle and positive operating cash flow of 5,960 explain it; no concern.\n- Gearing is low (9.5%) and would stay moderate (31%) after the loan; interest would still be covered almost ten times.\n[b]Recommend: lend the 8,000.[/b]"},
							{"text": "She adds the [b]limitations[/b] she has to live with: the SOFP is a single day (31 December, after the Christmas rush - inventory is unusually low); the revaluation of the kiosks inflates capital employed, flattering nothing but depressing ROCE against a rival that hasn't revalued; the comparison year had only one kiosk; and no ratio measures the thing that matters most - whether people still want hot yuzu lemonade next winter. Ratios start the conversation; judgement finishes it. That is the whole of Chapter 26, and the last step of Zuru's journey from a shoebox to a group."}
						]},
						"learn": [
							{"text": "Position (long-term risk):\n[b]Gearing[/b] = Non-current liabilities / (Total equity + Non-current liabilities) = X%: how much of the long-term capital is borrowed. Higher gearing = more interest to pay whatever profits do = more risk.\n[b]Interest cover[/b] = Profit before financing and income taxes / Interest expense = X times: how comfortably profits cover the interest."},
							{"text": "Drawing conclusions: compare each ratio with last year or the other company, then [b]give a reason and say what it means for the user[/b]. 'Gross margin fell from 40% to 36%' is a fact; 'probably because prices were cut to win the extra revenue, so the growth may not be profitable' is interpretation."},
							{"text": "Limitations of ratio analysis: inflation distorts comparisons over time; companies use different accounting policies; year-end figures may not be typical (seasonal trading); limited information in the statements; related-party transactions; different ratio definitions; statements can be manipulated; a new company has no comparatives."}
						],
						"example": {"title": "Zenith Co - position ($000)", "table": {"cols": ["", "Working", "Ratio"], "rows": [
							{"c": ["Non-current liabilities 200; equity 600", "200 / 800", "Gearing 25%"], "s": 1},
							{"c": ["PBFIT 150; interest 20", "150 / 20", "Interest cover 7.5 times"], "s": 2},
							{"c": ["Conclusion", "", "Low gearing and strong cover - a lender would be comfortable"], "s": 3}]},
							"steps": ["A quarter of long-term capital is borrowed.", "Profits cover the interest 7.5 times over.", "Put together for the user: low risk; room to borrow more if needed."]},
						"practice": [
							{"type": "input", "q": "Non-current liabilities 300,000; total equity 900,000. Gearing (%) = ?  (number)", "accept": ["25", "25%"], "display_answer": "25%", "ex": "300,000 / (900,000 + 300,000) = 25%."},
							{"type": "input", "q": "Profit before financing and income taxes 84,000; interest expense 12,000. Interest cover = ? (times)", "accept": ["7"], "display_answer": "7 times", "ex": "84,000 / 12,000 = 7 times."},
							{"type": "multi", "q": "Which TWO are limitations of ratio analysis?", "opts": ["Different companies may use different accounting policies", "Year-end figures may not represent the typical position", "Ratios cannot be calculated from published accounts", "Ratios are only available to the directors"], "a": [0, 1], "ex": "Policy differences and unrepresentative year-end figures distort comparisons. Ratios CAN be calculated from published statements by anyone."},
							{"type": "choice", "q": "Gearing rose from 20% to 55% in a year. A LENDER would be most concerned that:", "opts": ["The company now has more fixed interest to pay regardless of profits, increasing risk", "Gross profit margin has fallen", "Inventory days have increased", "The current ratio is above 2"], "a": 0, "ex": "High gearing means heavy fixed interest commitments - the main risk to a lender."}
						]
					}
				]
			}
		],
		# Syllabus map: every learning outcome in ACCA's FA/FFA syllabus and study guide (Sept 2026 - June 2027),
		# with our own short labels. "ch" = chapter that teaches it. "cover": "6/L1" = taught in a chapter-6
		# lesson, "ch5" = only quizzed in chapter 5's questions. Empty = gap.
		"areas": [
			{"code":"A","title":"The context and purpose of financial reporting"},
			{"code":"B","title":"Accounting principles, concepts and qualitative characteristics"},
			{"code":"C","title":"Double-entry bookkeeping and accounting systems"},
			{"code":"D","title":"Recording transactions and events"},
			{"code":"E","title":"Reconciliations"},
			{"code":"F","title":"Preparing a trial balance"},
			{"code":"G","title":"Preparing financial statements"},
			{"code":"H","title":"Preparing basic consolidated financial statements"},
			{"code":"I","title":"Interpretation of financial statements"}
		],
		"syllabus": [
			{"code":"A1a","k":"K","t":"Define financial reporting","cover":["1/L1"],"ch":[1]},
			{"code":"A1b","k":"K","t":"Types of business entity: sole trader, partnership, company","cover":["1/L2"],"ch":[1]},
			{"code":"A1c","k":"K","t":"Legal differences between the entity types","cover":["1/L2","19/L1"],"ch":[1,19]},
			{"code":"A1d","k":"K","t":"Advantages and disadvantages of each entity type","cover":["1/L2","19/L1"],"ch":[1,19]},
			{"code":"A1e","k":"K","t":"Nature, principles and scope of financial reporting","cover":["1/L1"],"ch":[1]},
			{"code":"A2a","k":"K","t":"Users of financial statements and their information needs","cover":["1/L4","ch1"],"ch":[1]},
			{"code":"A3a","k":"K","t":"Purpose of each financial statement (SOFP, SOPL & OCI, SOCE, SOCF)","cover":["1/L3","ch6"],"ch":[1,3]},
			{"code":"A3b","k":"K","t":"Define assets, liabilities, equity, income and expenses","cover":["1/L3","3/L4","ch3"],"ch":[1,3]},
			{"code":"A4a","k":"K","t":"The regulatory system: IFRS Foundation, IASB, Advisory Council, IFRIC, ISSB","cover":["2/L1","ch2"],"ch":[2]},
			{"code":"A4b","k":"K","t":"Role of IFRS Accounting Standards","cover":["2/L2"],"ch":[2]},
			{"code":"A5a","k":"K","t":"Governance in preparing financial statements","cover":["1/L5"],"ch":[1]},
			{"code":"A5b","k":"K","t":"Directors' duties for the financial statements","cover":["1/L5"],"ch":[1]},
			{"code":"B1a","k":"K","t":"Key concepts: going concern, accruals, materiality, offsetting, consistency, prudence, duality, business entity, historical cost / current value, substance over form","cover":["3/L1","3/L2","3/L4","ch3"],"ch":[3]},
			{"code":"B2a","k":"K","t":"Qualitative characteristics: relevance, faithful representation, comparability, verifiability, timeliness, understandability","cover":["3/L3","ch3"],"ch":[3]},
			{"code":"C1a","k":"K","t":"Main data sources in an accounting system","cover":["4/L1"],"ch":[4]},
			{"code":"C1b","k":"K","t":"Business documents: quotation, orders, GRN, invoices, credit / debit notes, remittance, receipt","cover":["4/L1"],"ch":[4]},
			{"code":"C1c","k":"S","t":"Explain and apply the accounting equation","cover":["6/L5","ch5"],"ch":[6]},
			{"code":"C1d","k":"K","t":"Computerised accounting systems, including the cloud","cover":["4/L3"],"ch":[4]},
			{"code":"C1e","k":"K","t":"How the accounting system gives useful information and meets policies / deadlines","cover":["4/L3"],"ch":[4]},
			{"code":"C1f","k":"K","t":"Main types of business transaction","cover":["4/L1","5/L1"],"ch":[4,5]},
			{"code":"C2a","k":"K","t":"Types of general ledger account","cover":["4/L2","5/L1","ch4"],"ch":[4,5]},
			{"code":"C2b","k":"K","t":"How financial data is first recorded (books of prime entry)","cover":["4/L2","5/L2","ch4"],"ch":[4,5]},
			{"code":"C2c","k":"S","t":"Journal entries and posting them to the general ledger","cover":["5/L3","ch5"],"ch":[5]},
			{"code":"C2d","k":"S","t":"Identify the correct journal from a narrative","cover":["5/L3","16/L3","ch5"],"ch":[16]},
			{"code":"C2e","k":"S","t":"Balance and close ledger accounts at the year-end","cover":["5/L4","ch5"],"ch":[5]},
			{"code":"D1a","k":"S","t":"Record sales and purchases","cover":["4/L2","5/L2","ch5"],"ch":[4,5]},
			{"code":"D1b","k":"S","t":"Record sales returns and purchase returns","cover":["4/L2","5/L2","14/L2","ch6"],"ch":[4,5,14]},
			{"code":"D1c","k":"K","t":"How sales tax works","cover":["13/L1","ch13"],"ch":[13]},
			{"code":"D1d","k":"S","t":"Calculate and record sales tax","cover":["13/L2","ch13"],"ch":[13]},
			{"code":"D1e","k":"S","t":"Account for discounts received","cover":["14/L3","ch14"],"ch":[14]},
			{"code":"D1f","k":"S","t":"Trade and settlement discounts allowed to customers (IFRS)","cover":["14/L3","20/L3"],"ch":[14]},
			{"code":"D2a","k":"S","t":"Record cash transactions in the bank ledger account","cover":["4/L2","5/L2","ch5"],"ch":[4,5]},
			{"code":"D2b","k":"K","t":"Why petty cash records are needed","cover":["4/L2"],"ch":[4]},
			{"code":"D3a","k":"K","t":"Why inventory is adjusted when preparing financial statements","cover":["7/L1","ch7"],"ch":[7]},
			{"code":"D3b","k":"S","t":"Record cost of sales and closing inventory","cover":["7/L1","ch7"],"ch":[7]},
			{"code":"D3c","k":"S","t":"Value inventory under IFRS (lower of cost and NRV)","cover":["7/L2","ch7"],"ch":[7]},
			{"code":"D3d","k":"S","t":"Costs included in inventory","cover":["7/L2","ch7"],"ch":[7]},
			{"code":"D3e","k":"K","t":"Continuous vs period-end inventory records","cover":["7/L1","ch7"],"ch":[7]},
			{"code":"D3f","k":"S","t":"Closing inventory by FIFO and weighted average (periodic and continuous)","cover":["7/L3","ch7"],"ch":[7]},
			{"code":"D3g","k":"S","t":"Impact of inventory valuation on profit and assets","cover":["7/L4","ch7"],"ch":[7]},
			{"code":"D4a","k":"K","t":"Define non-current assets","cover":["8/L1","ch6"],"ch":[8]},
			{"code":"D4b","k":"K","t":"Current vs non-current assets","cover":["8/L1","ch6"],"ch":[8]},
			{"code":"D4c","k":"K","t":"Capital (asset) vs revenue (expense) items","cover":["8/L1"],"ch":[8]},
			{"code":"D4d","k":"S","t":"Classify expenditure as asset or expense","cover":["8/L1"],"ch":[8]},
			{"code":"D4e","k":"S","t":"Record acquisition and disposal of non-current assets","cover":["8/L3","ch8"],"ch":[8]},
			{"code":"D4f","k":"S","t":"Gains / losses on disposal, including part exchange","cover":["8/L3","ch8"],"ch":[8]},
			{"code":"D4g","k":"S","t":"Revaluation: ledger entries and presentation","cover":["8/L4","ch8"],"ch":[8]},
			{"code":"D4h","k":"S","t":"Gain or loss on disposal of a revalued asset","cover":["8/L4"],"ch":[8]},
			{"code":"D4i","k":"S","t":"Disclosure of non-current asset balances and movements","cover":["8/L5","20/L4"],"ch":[8,20]},
			{"code":"D4j","k":"K","t":"Purpose of a non-current asset register","cover":["8/L5"],"ch":[8]},
			{"code":"D5a","k":"K","t":"Purpose of depreciation","cover":["8/L2"],"ch":[8]},
			{"code":"D5b","k":"S","t":"Straight-line and reducing-balance depreciation","cover":["8/L2","ch8"],"ch":[8]},
			{"code":"D5c","k":"K","t":"When each depreciation method is appropriate","cover":["8/L2"],"ch":[8]},
			{"code":"D5d","k":"S","t":"Record depreciation in the ledger","cover":["8/L2","ch8"],"ch":[8]},
			{"code":"D5e","k":"S","t":"Depreciation on revalued assets and excess depreciation transfer","cover":["8/L4","20/L2"],"ch":[8,20]},
			{"code":"D5f","k":"S","t":"Changes in useful life or residual value","cover":["8/L5"],"ch":[8]},
			{"code":"D5g","k":"S","t":"Depreciation in the SOPL and SOFP","cover":["8/L2","ch18"],"ch":[8]},
			{"code":"D6a","k":"K","t":"Tangible vs intangible assets","cover":["9/L1"],"ch":[9]},
			{"code":"D6b","k":"K","t":"Types of intangible asset","cover":["9/L1"],"ch":[9]},
			{"code":"D6c","k":"K","t":"Research and development costs under IFRS","cover":["9/L2","ch9"],"ch":[9]},
			{"code":"D6d","k":"S","t":"Calculate development costs to capitalise or expense","cover":["9/L2"],"ch":[9]},
			{"code":"D6e","k":"K","t":"Purpose of amortisation","cover":["9/L3","ch9"],"ch":[9]},
			{"code":"D6f","k":"S","t":"Calculate and account for amortisation","cover":["9/L3"],"ch":[9]},
			{"code":"D7a","k":"S","t":"Apply accrual accounting: accruals, prepayments, accrued and deferred income","cover":["10/L1","10/L2","10/L3","ch10"],"ch":[10]},
			{"code":"D7b","k":"S","t":"Calculate year-end adjustments for them","cover":["10/L1","10/L2","10/L3","ch10"],"ch":[10]},
			{"code":"D7c","k":"S","t":"Illustrate the adjusting process","cover":["10/L4","ch10"],"ch":[10]},
			{"code":"D7d","k":"S","t":"Journals to create and reverse them","cover":["10/L1","10/L2","10/L3","ch10"],"ch":[10]},
			{"code":"D7e","k":"S","t":"Their impact on profit and net assets","cover":["10/L4","ch10"],"ch":[10]},
			{"code":"D7f","k":"S","t":"Report them in the financial statements","cover":["10/L4","ch10"],"ch":[10]},
			{"code":"D8a","k":"K","t":"Examples of receivables and payables","cover":["12/L1","14/L1","ch14"],"ch":[12]},
			{"code":"D8b","k":"K","t":"Benefits and costs of offering credit","cover":["12/L1"],"ch":[12]},
			{"code":"D8c","k":"K","t":"Purpose of an aged receivables analysis","cover":["12/L1"],"ch":[12]},
			{"code":"D8d","k":"K","t":"Purpose of customer credit limits","cover":["12/L1"],"ch":[12]},
			{"code":"D8e","k":"S","t":"Journal to write off an irrecoverable debt","cover":["12/L2","ch12"],"ch":[12]},
			{"code":"D8f","k":"S","t":"Irrecoverable debt later recovered","cover":["12/L2","ch12"],"ch":[12]},
			{"code":"D8g","k":"S","t":"Impact of irrecoverable debts on SOPL and SOFP","cover":["12/L2","12/L3","ch12","ch18"],"ch":[12]},
			{"code":"D8h","k":"S","t":"Create and adjust an allowance for receivables","cover":["12/L3","ch12"],"ch":[12]},
			{"code":"D8i","k":"S","t":"Allowance movement in SOPL and balance in SOFP","cover":["12/L3","ch12"],"ch":[12]},
			{"code":"D8j","k":"S","t":"Contras between receivables and payables","cover":["14/L2","ch14"],"ch":[12,14]},
			{"code":"D8k","k":"S","t":"Prepare and reconcile supplier statements","cover":["14/L4"],"ch":[12,14]},
			{"code":"D9a","k":"K","t":"Define provision, contingent liability and contingent asset","cover":["11/L1","11/L2","ch11"],"ch":[11]},
			{"code":"D9b","k":"S","t":"Classify items as provisions or contingencies","cover":["11/L2","ch11"],"ch":[11]},
			{"code":"D9c","k":"K","t":"How provisions and contingencies are accounted for","cover":["11/L2","ch11"],"ch":[11]},
			{"code":"D9d","k":"S","t":"Calculate provisions and changes in provisions","cover":["11/L1","ch11"],"ch":[11]},
			{"code":"D9e","k":"S","t":"Journals for provision movements","cover":["11/L1"],"ch":[11]},
			{"code":"D9f","k":"S","t":"Report provisions in the financial statements","cover":["11/L1"],"ch":[11]},
			{"code":"D10a","k":"K","t":"Company capital structure: ordinary shares, preference shares, borrowings","cover":["19/L1","ch19"],"ch":[19]},
			{"code":"D10b","k":"K","t":"Nature of equity, including retained earnings","cover":["19/L1","19/L4"],"ch":[19]},
			{"code":"D10c","k":"S","t":"Other components of equity","cover":["19/L4","ch19"],"ch":[19]},
			{"code":"D10d","k":"S","t":"Share capital and share premium movements","cover":["19/L2","ch19"],"ch":[19]},
			{"code":"D10e","k":"K","t":"Bonus issues: definition, pros and cons","cover":["19/L2","ch19"],"ch":[19]},
			{"code":"D10f","k":"K","t":"Rights issues: definition, pros and cons","cover":["19/L2"],"ch":[19]},
			{"code":"D10g","k":"S","t":"Record a bonus issue","cover":["19/L2","ch19"],"ch":[19]},
			{"code":"D10h","k":"S","t":"Record a rights issue","cover":["19/L2","ch19"],"ch":[19]},
			{"code":"D10i","k":"S","t":"Dividends in the ledger and financial statements","cover":["19/L3","ch20"],"ch":[19]},
			{"code":"D10j","k":"S","t":"Interest expense in the ledger and financial statements","cover":["19/L3","ch20"],"ch":[19]},
			{"code":"D10k","k":"K","t":"Components of the statement of changes in equity","cover":["19/L4","20/L2"],"ch":[19,20]},
			{"code":"E1a","k":"K","t":"Purpose of bank reconciliations","cover":["15/L1"],"ch":[15]},
			{"code":"E1b","k":"K","t":"Reasons the cash book and bank statement differ","cover":["15/L1","ch15"],"ch":[15]},
			{"code":"E1c","k":"S","t":"Correct errors and omissions in the cash book","cover":["15/L2","ch15"],"ch":[15]},
			{"code":"E1d","k":"S","t":"Prepare a bank reconciliation","cover":["15/L2","ch15"],"ch":[15]},
			{"code":"E1e","k":"S","t":"Derive bank statement and cash book balances","cover":["15/L3","ch15"],"ch":[15]},
			{"code":"E1f","k":"S","t":"Bank balance to report in the financial statements","cover":["15/L3","ch15"],"ch":[15]},
			{"code":"E2a","k":"K","t":"Purpose of the payables ledger account","cover":["14/L1"],"ch":[14]},
			{"code":"E2b","k":"K","t":"Why payables are reconciled to external documents","cover":["14/L4"],"ch":[14]},
			{"code":"E2c","k":"S","t":"Reconcile payables to supplier statements","cover":["14/L4"],"ch":[14]},
			{"code":"E2d","k":"K","t":"Errors found by a payables reconciliation","cover":["14/L4"],"ch":[14]},
			{"code":"E2e","k":"S","t":"Payables balance to report","cover":["14/L4"],"ch":[14]},
			{"code":"F1a","k":"K","t":"Purpose of a trial balance","cover":["6/L1"],"ch":[6]},
			{"code":"F1b","k":"S","t":"Extract ledger balances into a trial balance","cover":["6/L2"],"ch":[6]},
			{"code":"F1c","k":"S","t":"Prepare extracts of an opening trial balance","cover":["6/L5","18/L1"],"ch":[6,18]},
			{"code":"F1d","k":"K","t":"Limitations of a trial balance","cover":["6/L1","6/L2"],"ch":[6]},
			{"code":"F2a","k":"K","t":"Types of accounting error","cover":["16/L1","ch16"],"ch":[16]},
			{"code":"F2b","k":"S","t":"Errors a trial balance does and does not reveal","cover":["6/L1","16/L1","ch16"],"ch":[16]},
			{"code":"F2c","k":"S","t":"Journals to correct errors","cover":["16/L3","18/L3","ch16"],"ch":[16,18]},
			{"code":"F2d","k":"S","t":"Impact of errors on profit and financial position","cover":["16/L3","ch7","ch10"],"ch":[16]},
			{"code":"F3a","k":"K","t":"Purpose of a suspense account","cover":["16/L2"],"ch":[16]},
			{"code":"F3b","k":"K","t":"Errors that create a suspense account","cover":["16/L2","ch16"],"ch":[16]},
			{"code":"F3c","k":"S","t":"Record entries in a suspense account","cover":["16/L2","18/L3","ch16"],"ch":[16,18]},
			{"code":"F3d","k":"S","t":"Journals to clear a suspense account","cover":["16/L2","18/L3","ch16"],"ch":[16,18]},
			{"code":"G1a","k":"K","t":"Accounting equation, IFRS and entity concept behind the SOFP","cover":["6/L4"],"ch":[null]},
			{"code":"G1b","k":"S","t":"Prepare a statement of financial position or extracts","cover":["6/L4","18/L1","18/L2","20/L2"],"ch":[20,18],"note":"Sole trader so far - limited company SOFP still to come"},
			{"code":"G2a","k":"S","t":"Calculate revenue, cost of sales, gross / operating profit, profit before tax, profit and total comprehensive income","cover":["6/L3","20/L1","20/L3"],"ch":[20],"note":"Operating profit, profit before tax and TCI still to come"},
			{"code":"G2b","k":"S","t":"Prepare a statement of profit or loss and OCI or extracts","cover":["6/L3","18/L1","18/L2","20/L1"],"ch":[20,18],"note":"Sole trader so far - company SOPL and OCI still to come"},
			{"code":"G2c","k":"S","t":"Income tax expense, including prior-year under / over-provision","cover":["19/L3","ch20"],"ch":[20]},
			{"code":"G2d","k":"K","t":"Items disclosed separately on the face of the SOPL","cover":["20/L1"],"ch":[20]},
			{"code":"G2e","k":"K","t":"How the SOFP and SOPL link together","cover":["20/L1"],"ch":[20]},
			{"code":"G3a","k":"K","t":"Purpose of disclosure notes","cover":["20/L4"],"ch":[20]},
			{"code":"G3b","k":"S","t":"Draft notes: non-current assets, provisions, events after the reporting period, inventories","cover":["8/L5","9/L3","20/L4"],"ch":[8,9,20]},
			{"code":"G4a","k":"K","t":"Define events after the reporting period","cover":["21/L1","ch21"],"ch":[21]},
			{"code":"G4b","k":"S","t":"Classify events as adjusting or non-adjusting","cover":["21/L1","ch21"],"ch":[21]},
			{"code":"G4c","k":"K","t":"How adjusting and non-adjusting events are reported","cover":["21/L1","ch21"],"ch":[21]},
			{"code":"G5a","k":"K","t":"Profit vs cash flow","cover":["22/L1"],"ch":[22]},
			{"code":"G5b","k":"K","t":"Why management controls cash flow","cover":["22/L1"],"ch":[22]},
			{"code":"G5c","k":"K","t":"Benefits and drawbacks of the statement of cash flows","cover":["22/L1"],"ch":[22]},
			{"code":"G5d","k":"S","t":"Classify the cash effect of transactions","cover":["22/L2","ch22"],"ch":[22]},
			{"code":"G5e","k":"S","t":"Operating (direct and indirect), investing and financing cash flows","cover":["22/L3","22/L4","ch22"],"ch":[22],"note":"Direct method not yet tested"},
			{"code":"G5f","k":"S","t":"Prepare a statement of cash flows or extracts","cover":["22/L4"],"ch":[22]},
			{"code":"G5g","k":"K","t":"Treatment of given transactions in the statement of cash flows","cover":["22/L2","ch22"],"ch":[22]},
			{"code":"G6a","k":"S","t":"Incomplete records: accounting equation, ledger accounts, cash summaries, margins and mark-ups","cover":["17/L1","17/L2","17/L3","ch17"],"ch":[17]},
			{"code":"H1a","k":"K","t":"Group terms: parent, subsidiary, control, consolidated statements, NCI, trade investment","cover":["23/L1","23/L3","24/L2","ch23"],"ch":[23,24]},
			{"code":"H1b","k":"K","t":"Identify subsidiaries in a group","cover":["23/L1","ch23"],"ch":[23]},
			{"code":"H1c","k":"S","t":"Consolidated SOFP: fair value adjustments, consideration, intra-group balances, unrealised profit, mid-year acquisition","cover":["24/L1","24/L2","24/L3","24/L4","ch24"],"ch":[24],"note":"Fair value adjustments, share consideration and mid-year acquisitions still to come"},
			{"code":"H1d","k":"S","t":"Goodwill with NCI at fair value","cover":["24/L1","ch24"],"ch":[24]},
			{"code":"H1e","k":"S","t":"Consolidated SOPL: intra-group trading, unrealised profit, mid-year acquisition","cover":["25/L1","25/L2","25/L3","ch25"],"ch":[25],"note":"Only intra-group sales elimination tested so far"},
			{"code":"H2a","k":"K","t":"Define an associate and significant influence","cover":["23/L2","ch23"],"ch":[23]},
			{"code":"H2b","k":"K","t":"Parent-associate relationship in a group structure","cover":["23/L2"],"ch":[23]},
			{"code":"H2c","k":"K","t":"Principle of the equity method","cover":["23/L2","ch23"],"ch":[23]},
			{"code":"I1a","k":"K","t":"How interpretation of financial statements is used in business","cover":["26/L1"],"ch":[26]},
			{"code":"I1b","k":"K","t":"Purpose of interpreting ratios","cover":["26/L1"],"ch":[26]},
			{"code":"I2a","k":"S","t":"Calculate profitability, liquidity, efficiency and position ratios","cover":["26/L1","26/L2","26/L3"],"ch":[26]},
			{"code":"I2b","k":"K","t":"Interrelationships between ratios","cover":["26/L2"],"ch":[26]},
			{"code":"I3a","k":"S","t":"Calculate and interpret relationships in the financial statements","cover":["26/L3"],"ch":[26]},
			{"code":"I3b","k":"S","t":"Draw valid conclusions and present them to users","cover":["26/L3"],"ch":[26]}
		]
	}
]

func first_exam() -> Dictionary:
	return EXAMS[0] if not EXAMS.is_empty() else {}

func get_exam(id: String) -> Dictionary:
	for e in EXAMS:
		if str(e.get("id", "")) == id:
			return e
	return {}

func get_chapter(exam_id: String, ch_id: int) -> Dictionary:
	var e := get_exam(exam_id)
	for c in e.get("chapters", []):
		if int(c.get("id", 0)) == ch_id:
			return c
	return {}

# ---------------------------------------------------------------- question pools
# Each question returned is a COPY of its beat with three extra fields:
#   _key = "FFA/2/4" (exam/chapter/beat index - stable while new beats are only
#          ever ADDED to the end of a chapter), _ch = "FFA/2", _topic = chapter title.
# kind: "" = all questions, "choice" = tap only, "input" = type-in only.

func is_question(b: Dictionary) -> bool:
	var t := str(b.get("type", ""))
	return t == "choice" or t == "input"

func tag_question(exam_id: String, c: Dictionary, i: int) -> Dictionary:
	var q: Dictionary = c["beats"][i].duplicate(true)
	q["_key"] = exam_id + "/" + str(c["id"]) + "/" + str(i)
	q["_ch"] = exam_id + "/" + str(c["id"])
	q["_topic"] = str(c.get("title", ""))
	return q

func chapter_beats(exam_id: String, ch_id: int) -> Array:
	var c := get_chapter(exam_id, ch_id)
	var out: Array = []
	var beats: Array = c.get("beats", [])
	for i in range(beats.size()):
		out.append(tag_question(exam_id, c, i) if is_question(beats[i]) else beats[i])
	return out

func questions(exam_id: String, ch_id: int = -1, kind: String = "") -> Array:
	var out: Array = []
	for c in get_exam(exam_id).get("chapters", []):
		if ch_id != -1 and int(c["id"]) != ch_id:
			continue
		var beats: Array = c.get("beats", [])
		for i in range(beats.size()):
			if not is_question(beats[i]):
				continue
			if kind != "" and str(beats[i]["type"]) != kind:
				continue
			out.append(tag_question(exam_id, c, i))
	return out

func questions_by_keys(keys: Array) -> Array:
	var out: Array = []
	for k in keys:
		var parts := str(k).split("/")
		if parts.size() != 3:
			continue
		var c := get_chapter(parts[0], int(parts[1]))
		var i := int(parts[2])
		if c.is_empty() or i >= c["beats"].size() or not is_question(c["beats"][i]):
			continue
		out.append(tag_question(parts[0], c, i))
	return out

# Random sample of n questions spread across every chapter (round-robin over
# shuffled chapters) so a mixed paper never clusters on one topic.
func mixed_paper(exam_id: String, n: int) -> Array:
	var by_ch: Array = []
	for c in get_exam(exam_id).get("chapters", []):
		var qs := questions(exam_id, int(c["id"]))
		qs.shuffle()
		if not qs.is_empty():
			by_ch.append(qs)
	by_ch.shuffle()
	var out: Array = []
	var round_i := 0
	while out.size() < n:
		var added := false
		for qs in by_ch:
			if round_i < qs.size() and out.size() < n:
				out.append(qs[round_i])
				added = true
		if not added:
			break
		round_i += 1
	out.shuffle()
	return out
