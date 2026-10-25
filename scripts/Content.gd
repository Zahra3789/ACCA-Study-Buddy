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
		"chapters": [

			# ---------------- CHAPTER 1 ----------------
			{
				"id": 1,
				"title": "Framework, Concepts & Qualities",
				"monster": "The Gatekeeper Spirit",
				"beats": [
					{"type": "story", "speaker": "Sensei Otter", "text": "At the dojo gate floats the [b]Gatekeeper Spirit[/b]. It will not let you pass until you know WHY accounts exist and what makes them useful."},
					{"type": "story", "speaker": "Sensei Otter", "text": "Its lore: statements serve [b]investors, lenders and creditors[/b]. The two [b]fundamental[/b] qualities are [b]Relevance[/b] and [b]Faithful representation[/b]; the enhancing four are Comparability, Verifiability, Timeliness, Understandability. And the [b]accruals[/b] idea: record income and expenses when earned or incurred, not when cash moves."},
					{"type": "choice", "q": "Who are the PRIMARY users of general purpose financial statements?", "opts": ["Investors, lenders and other creditors", "Competitors", "Tax inspectors only", "The general public"], "a": 0, "ex": "The Conceptual Framework names existing and potential investors, lenders and other creditors as the primary users."},
					{"type": "choice", "q": "Which is a FUNDAMENTAL qualitative characteristic?", "opts": ["Comparability", "Faithful representation", "Timeliness", "Verifiability"], "a": 1, "ex": "Relevance and faithful representation are fundamental; the other four are enhancing."},
					{"type": "choice", "q": "Recognising income and expenses when earned or incurred (not when cash moves) is the:", "opts": ["Prudence concept", "Accruals (matching) concept", "Going concern assumption", "Historical cost concept"], "a": 1, "ex": "The accruals concept matches income and expenses to the period they relate to."},
					{"type": "choice", "q": "Accounting for a business separately from its owner is the:", "opts": ["Business (separate) entity concept", "Going concern assumption", "Materiality concept", "Consistency concept"], "a": 0, "ex": "The separate entity concept keeps the owner's personal affairs out of the business accounts."},
					{"type": "choice", "q": "Which body writes IFRS Standards?", "opts": ["The IASB", "The external auditors", "The IFRS Foundation", "The directors"], "a": 0, "ex": "The IASB develops and issues IFRS Standards; the IFRS Foundation oversees it."},
					{"type": "choice", "q": "If the going concern basis does NOT apply, it is assumed the business will:", "opts": ["Keep expanding", "Cease trading in the foreseeable future", "Become tax exempt", "Convert to a company"], "a": 1, "ex": "Going concern failing means the entity may cease trading, which changes asset and liability values."},
					{"type": "choice", "q": "Exercising caution so assets and income are not overstated is:", "opts": ["Comparability", "Prudence", "Timeliness", "Understandability"], "a": 1, "ex": "Prudence is caution under uncertainty."},
					{"type": "choice", "q": "Information is material if:", "opts": ["It is a large round number", "Omitting or misstating it could influence users decisions", "It appears in the notes", "It is over 1,000"], "a": 1, "ex": "Materiality is judged by whether omitting or misstating it could influence users economic decisions."}
				]
			},

			# ---------------- CHAPTER 2 ----------------
			{
				"id": 2,
				"title": "Double Entry & the Accounting System",
				"monster": "The Double-Entry Oni",
				"beats": [
					{"type": "story", "speaker": "Sensei Otter", "text": "A shadow stirs in the first hall... the [b]Double-Entry Oni[/b]. It feeds on sloppy books. To wound it you must think in two sides: every move has a [b]debit[/b] and a [b]credit[/b]."},
					{"type": "story", "speaker": "Sensei Otter", "text": "The law of this dojo, the [b]accounting equation[/b]:\n\n[b]ASSETS = CAPITAL + LIABILITIES[/b]\n\nAnd the stance, [b]DEAD CLIC[/b]:\nDEbit = Expenses, Assets, Drawings\nCredit = Liabilities, Income, Capital."},
					{"type": "taccount", "speaker": "Sensei Otter", "text": "Watch a ledger account balance. Both sides must total the same, and that balance is the Oni's weak point:", "name": "Cash account", "dr": ["Capital 1,000", "Sales 500"], "cr": ["Purchases 300", "Rent 200", "Balance c/d 1,000"], "dr_total": "1,500", "cr_total": "1,500"},
					{"type": "choice", "q": "Complete the law:  Assets =", "opts": ["Capital + Liabilities", "Capital - Liabilities", "Liabilities - Capital", "Income + Expenses"], "a": 0, "ex": "Assets = Capital + Liabilities (Net assets = Capital)."},
					{"type": "input", "q": "Assets are 70,000 and capital is 45,000. What are the liabilities?  (number)", "accept": ["25000"], "display_answer": "25,000", "ex": "Liabilities = Assets - Capital = 70,000 - 45,000 = 25,000."},
					{"type": "choice", "q": "A cash sale is made. Which entry strikes true?", "opts": ["Dr Cash, Cr Sales", "Dr Sales, Cr Cash", "Dr Cash, Cr Capital", "Dr Purchases, Cr Cash"], "a": 0, "ex": "Cash (an asset) rises, so Dr Cash; income rises, so Cr Sales."},
					{"type": "choice", "q": "Goods for resale are bought on credit. The entry is:", "opts": ["Dr Purchases, Cr Payables", "Dr Payables, Cr Purchases", "Dr Purchases, Cr Cash", "Dr Cash, Cr Payables"], "a": 0, "ex": "Purchases rise (Dr) and a liability to the supplier is created (Cr Payables)."},
					{"type": "input", "q": "Capital was 40,000. Profit 18,000, drawings 11,000. Closing capital = ?  (number)", "accept": ["47000"], "display_answer": "47,000", "ex": "40,000 + profit 18,000 - drawings 11,000 = 47,000."},
					{"type": "choice", "q": "Under DEAD CLIC, which is a DEBIT?", "opts": ["An asset", "A liability", "Income", "Capital"], "a": 0, "ex": "Assets, expenses and drawings are debits."},
					{"type": "choice", "q": "Which is NOT a book of prime entry?", "opts": ["The nominal (general) ledger", "Sales day book", "Cash book", "The journal"], "a": 0, "ex": "The nominal ledger holds the accounts; prime-entry books feed it."},
					{"type": "input", "q": "A trial balance shows total debits of 63,500. Total credits must be?  (number)", "accept": ["63500"], "display_answer": "63,500", "ex": "A trial balance balances only when total debits equal total credits."}
				]
			},

			# ---------------- CHAPTER 3 ----------------
			{
				"id": 3,
				"title": "Trial Balance to Financial Statements",
				"monster": "The Trial-Balance Golem",
				"beats": [
					{"type": "story", "speaker": "Sensei Otter", "text": "The hulking [b]Trial-Balance Golem[/b] guards the path to the financial statements. Strike it with the formats."},
					{"type": "story", "speaker": "Sensei Otter", "text": "[b]Gross profit = Revenue - Cost of sales[/b]. Cost of sales = Opening inventory + Purchases - Closing inventory. The SOFP always balances: [b]Total assets = Capital + Total liabilities[/b]."},
					{"type": "input", "q": "Revenue 90,000, opening inventory 8,000, purchases 55,000, closing inventory 6,000. Gross profit = ?  (number)", "accept": ["33000"], "display_answer": "33,000", "ex": "COS = 8,000 + 55,000 - 6,000 = 57,000. Gross profit = 90,000 - 57,000 = 33,000."},
					{"type": "choice", "q": "Which is a NON-current asset?", "opts": ["Inventory", "Trade receivables", "Machinery", "Bank overdraft"], "a": 2, "ex": "Machinery is property, plant and equipment - a non-current asset."},
					{"type": "input", "q": "Revenue 120,000, cost of sales 70,000, expenses 30,000. Profit for the year = ?  (number)", "accept": ["20000"], "display_answer": "20,000", "ex": "Gross profit 50,000 less expenses 30,000 = 20,000."},
					{"type": "choice", "q": "Carriage inwards (delivery on goods bought) is:", "opts": ["Included in cost of sales", "An administrative expense", "Ignored", "Added to revenue"], "a": 0, "ex": "Carriage inwards is part of the cost of purchases."},
					{"type": "choice", "q": "Which appears in the statement of profit or loss?", "opts": ["Trade payables", "The depreciation charge for the year", "Bank loan", "Share capital"], "a": 1, "ex": "The depreciation charge is an expense in the SOPL."},
					{"type": "choice", "q": "A prepayment at the year-end is shown as a:", "opts": ["Non-current asset", "Current asset", "Current liability", "Reduction of capital"], "a": 1, "ex": "A prepayment is value paid in advance - a current asset."},
					{"type": "choice", "q": "A bank overdraft is shown as a:", "opts": ["Current asset", "Current liability", "Non-current liability", "Part of capital"], "a": 1, "ex": "An overdraft is repayable on demand - a current liability."},
					{"type": "choice", "q": "The statement showing performance over a period is the:", "opts": ["Statement of financial position", "Statement of profit or loss", "Trial balance", "List of balances"], "a": 1, "ex": "The SOPL shows performance over the period; the SOFP is a snapshot."}
				]
			},

			# ---------------- CHAPTER 4 ----------------
			{
				"id": 4,
				"title": "Inventory",
				"monster": "The Stockpile Slime",
				"beats": [
					{"type": "story", "speaker": "Sensei Otter", "text": "The [b]Stockpile Slime[/b] hoards goods in a quivering heap. Value its hoard correctly to make it shrink."},
					{"type": "story", "speaker": "Sensei Otter", "text": "Inventory = [b]lower of cost and NRV[/b]. NRV = selling price - costs to complete - costs to sell. [b]Cost of sales = Opening + Purchases - Closing[/b]. FIFO: oldest sold first; [b]LIFO is not allowed[/b]."},
					{"type": "choice", "q": "Inventory is valued at:", "opts": ["Cost only", "The lower of cost and net realisable value", "Selling price", "The higher of cost and NRV"], "a": 1, "ex": "Prudence requires the lower of cost and NRV."},
					{"type": "choice", "q": "Which method is NOT allowed under IFRS?", "opts": ["FIFO", "Weighted average cost", "LIFO", "Periodic weighted average"], "a": 2, "ex": "LIFO is not permitted in the financial statements."},
					{"type": "input", "q": "Opening inventory 5,000, purchases 40,000, closing inventory 7,000. Cost of sales = ?  (number)", "accept": ["38000"], "display_answer": "38,000", "ex": "COS = 5,000 + 40,000 - 7,000 = 38,000."},
					{"type": "input", "q": "Opening inventory 12,000, purchases 60,000, closing inventory 9,000. Cost of sales = ?  (number)", "accept": ["63000"], "display_answer": "63,000", "ex": "COS = 12,000 + 60,000 - 9,000 = 63,000."},
					{"type": "input", "q": "FIFO: bought 100 units at 5 then 100 at 7, sold 120. Value of closing inventory (80 units)?  (number)", "accept": ["560"], "display_answer": "560", "ex": "FIFO leaves the newest 80 units at 7 each = 560."},
					{"type": "choice", "q": "Net realisable value is:", "opts": ["Selling price minus costs to complete and sell", "Original purchase cost", "Replacement cost", "Selling price including tax"], "a": 0, "ex": "NRV = selling price - costs to complete - costs to sell."},
					{"type": "choice", "q": "Which cost is EXCLUDED from the cost of inventory?", "opts": ["Purchase price", "Import duties", "Storage of finished goods", "Conversion costs"], "a": 2, "ex": "Storage of finished goods does not bring inventory to its present condition."},
					{"type": "choice", "q": "Closing inventory was overstated. The effect on profit is:", "opts": ["Profit understated", "Profit overstated", "No effect", "Profit halved"], "a": 1, "ex": "Higher closing inventory reduces cost of sales, so profit is overstated."}
				]
			},

			# ---------------- CHAPTER 5 ----------------
			{
				"id": 5,
				"title": "Non-Current Assets & Depreciation",
				"monster": "The Depreciation Dragon",
				"beats": [
					{"type": "story", "speaker": "Sensei Otter", "text": "The ancient [b]Depreciation Dragon[/b] wears away all it touches. Spread its cost correctly and it cannot overwhelm you."},
					{"type": "story", "speaker": "Sensei Otter", "text": "[b]Carrying amount = Cost - Accumulated depreciation[/b]. Straight line = (Cost - residual) / life. Reducing balance = fixed % of carrying amount. [b]Profit/(loss) on disposal = proceeds - carrying amount[/b]."},
					{"type": "taccount", "speaker": "Sensei Otter", "text": "The disposal account gathers everything about the asset sold; the balancing figure is the profit or loss:", "name": "Disposal account", "dr": ["Asset at cost 20,000", "Profit on disposal 2,000"], "cr": ["Accumulated depreciation 14,000", "Sale proceeds 8,000"], "dr_total": "22,000", "cr_total": "22,000"},
					{"type": "input", "q": "Cost 50,000, residual value 5,000, useful life 5 years. Straight-line depreciation per year = ?  (number)", "accept": ["9000"], "display_answer": "9,000", "ex": "(50,000 - 5,000) / 5 = 9,000 per year."},
					{"type": "input", "q": "Reducing balance at 25% on a carrying amount of 16,000. The charge = ?  (number)", "accept": ["4000"], "display_answer": "4,000", "ex": "25% x 16,000 = 4,000."},
					{"type": "input", "q": "Asset cost 30,000, accumulated depreciation 18,000, sold for 10,000. The LOSS on disposal = ?  (number)", "accept": ["2000"], "display_answer": "2,000", "ex": "Carrying amount 12,000; proceeds 10,000 - 12,000 = 2,000 loss."},
					{"type": "choice", "q": "Carrying amount =", "opts": ["Cost - Accumulated depreciation", "Cost - Residual value", "Cost + depreciation", "Proceeds - cost"], "a": 0, "ex": "Carrying amount (NBV) = Cost - Accumulated depreciation."},
					{"type": "choice", "q": "Research costs are:", "opts": ["Always expensed", "Always capitalised", "Amortised", "Added to goodwill"], "a": 0, "ex": "Research is always expensed; only qualifying development may be capitalised."},
					{"type": "choice", "q": "A gain on revaluing a non-current asset upwards is reported in:", "opts": ["Profit or loss", "Other comprehensive income and a revaluation surplus", "Cost of sales", "Retained earnings as realised profit"], "a": 1, "ex": "The gain is unrealised, so it goes to OCI and a non-distributable revaluation surplus."},
					{"type": "choice", "q": "Amortisation is charged on:", "opts": ["Land", "Intangible assets with a finite life", "Inventory", "Cash"], "a": 1, "ex": "Amortisation spreads the cost of a finite-life intangible; land is not depreciated."}
				]
			},

			# ---------------- CHAPTER 6 ----------------
			{
				"id": 6,
				"title": "Accruals & Prepayments",
				"monster": "The Timing Wraith",
				"beats": [
					{"type": "story", "speaker": "Sensei Otter", "text": "The [b]Timing Wraith[/b] shifts costs between years to confuse you. Match each to its proper period and it loses its power."},
					{"type": "story", "speaker": "Sensei Otter", "text": "[b]Accrual[/b] = used but unpaid = a LIABILITY (Dr Expense, Cr Accruals). [b]Prepayment[/b] = paid ahead = an ASSET. [b]Deferred income[/b] = cash received early = a liability. [b]Accrued income[/b] = earned, awaited = an asset."},
					{"type": "choice", "q": "An accrued (unpaid) expense is shown as a:", "opts": ["Asset", "Liability", "Reduction of capital", "Revenue"], "a": 1, "ex": "An accrual is an obligation to pay for something used - a liability."},
					{"type": "choice", "q": "A prepayment is shown as a:", "opts": ["Asset", "Liability", "Expense only", "Revenue"], "a": 0, "ex": "A prepayment is value paid for but not yet used - an asset."},
					{"type": "input", "q": "Rent of 12,000 was paid for the year to 30 April. At 31 December the prepayment = ?  (number)", "accept": ["4000"], "display_answer": "4,000", "ex": "4 months (Jan-Apr) prepaid: 4/12 x 12,000 = 4,000."},
					{"type": "input", "q": "Insurance of 2,400 was paid for the year to 31 March. At 31 December the prepayment = ?  (number)", "accept": ["600"], "display_answer": "600", "ex": "3 months (Jan-Mar) prepaid: 3/12 x 2,400 = 600."},
					{"type": "choice", "q": "The entry to accrue an expense at the year-end is:", "opts": ["Dr Accruals, Cr Expense", "Dr Expense, Cr Accruals", "Dr Prepayment, Cr Expense", "Dr Cash, Cr Expense"], "a": 1, "ex": "Accruing increases the expense (Dr) and creates a liability (Cr Accruals)."},
					{"type": "choice", "q": "Cash received in advance for a service not yet provided is:", "opts": ["Accrued income (asset)", "Deferred income (liability)", "A prepayment (asset)", "Revenue now"], "a": 1, "ex": "Income received before the service is deferred income - a liability."},
					{"type": "choice", "q": "Service earned but not yet received at the year-end is:", "opts": ["Deferred income (liability)", "Accrued income (asset)", "An accrual (liability)", "Ignored"], "a": 1, "ex": "Income earned but not received is accrued income - an asset."},
					{"type": "choice", "q": "To reverse an opening accrual at the start of the next period:", "opts": ["Dr Accruals, Cr Expense", "Dr Expense, Cr Accruals", "Dr Cash, Cr Accruals", "No entry"], "a": 0, "ex": "Reversing an accrual is the opposite of creating it."}
				]
			},

			# ---------------- CHAPTER 7 ----------------
			{
				"id": 7,
				"title": "Provisions, Contingencies & Post-Reporting Events",
				"monster": "The Contingency Shade",
				"beats": [
					{"type": "story", "speaker": "Sensei Otter", "text": "The flickering [b]Contingency Shade[/b] is never quite there. Judge what is probable, possible or remote to pin it down."},
					{"type": "story", "speaker": "Sensei Otter", "text": "A [b]provision[/b] needs: a present obligation (past event), a [b]probable[/b] outflow, and a reliable estimate. Contingent liability: possible -> disclose, probable -> provide. Contingent asset: probable -> disclose, virtually certain -> recognise. [b]Adjusting event[/b] = a condition that existed AT the year-end."},
					{"type": "choice", "q": "A provision is recognised only when an outflow of resources is:", "opts": ["Possible", "Probable", "Remote", "Certain"], "a": 1, "ex": "A provision needs a present obligation, a PROBABLE outflow and a reliable estimate."},
					{"type": "choice", "q": "A contingent liability that is only POSSIBLE should be:", "opts": ["Recognised as a provision", "Disclosed by note", "Ignored completely", "Added to revenue"], "a": 1, "ex": "A possible contingent liability is disclosed, not recognised."},
					{"type": "choice", "q": "A probable contingent ASSET should be:", "opts": ["Recognised", "Disclosed by note", "Ignored", "Provided for"], "a": 1, "ex": "Prudence: a probable asset is only disclosed; recognised only when virtually certain."},
					{"type": "choice", "q": "Which is NOT a condition for recognising a provision?", "opts": ["A present obligation from a past event", "A probable outflow", "A reliable estimate", "The amount is certain"], "a": 3, "ex": "A provision is a liability of UNCERTAIN amount; certainty is not required."},
					{"type": "choice", "q": "After the year-end, a customer who owed money at year-end goes bankrupt. This is:", "opts": ["A non-adjusting event (disclose)", "An adjusting event - write the debt off", "Ignored", "A new provision"], "a": 1, "ex": "The weakness existed at the year-end, so it is adjusting; write the receivable off."},
					{"type": "choice", "q": "A fire destroys a warehouse two weeks after the year-end. This is:", "opts": ["An adjusting event", "A non-adjusting event - disclose if material", "Recognised as a loss this year", "A provision"], "a": 1, "ex": "A new condition after the year-end is non-adjusting; disclose if material."},
					{"type": "choice", "q": "A warranty provision is recognised because:", "opts": ["A loss is merely possible", "There is a present obligation with a probable outflow and reliable estimate", "The directors prefer it", "It reduces tax"], "a": 1, "ex": "Past sales create a present obligation; if probable and estimable, provide."},
					{"type": "choice", "q": "A contingent asset that is virtually certain should be:", "opts": ["Recognised", "Disclosed only", "Ignored", "Provided for"], "a": 0, "ex": "A virtually certain inflow is no longer contingent - it is recognised."}
				]
			},

			# ---------------- CHAPTER 8 ----------------
			{
				"id": 8,
				"title": "Sales Tax",
				"monster": "The Tax-Collector Tengu",
				"beats": [
					{"type": "story", "speaker": "Sensei Otter", "text": "The [b]Tax-Collector Tengu[/b] demands its due on every sale. Net output against input and pay only the difference."},
					{"type": "story", "speaker": "Sensei Otter", "text": "[b]Output tax[/b] on sales (owed); [b]input tax[/b] on purchases (reclaimed). Net payable = output - input. Sales and purchases are shown [b]net[/b]; receivables and payables [b]gross[/b]. At 20%, gross to tax = x 20/120."},
					{"type": "taccount", "speaker": "Sensei Otter", "text": "The control account nets the two and shows what you owe the authority:", "name": "Sales tax control account", "dr": ["Input tax on purchases 6,500", "Balance c/d 2,500"], "cr": ["Output tax on sales 9,000"], "dr_total": "9,000", "cr_total": "9,000"},
					{"type": "choice", "q": "Tax charged on sales is called:", "opts": ["Input tax", "Output tax", "Net tax", "Deferred tax"], "a": 1, "ex": "Output tax is charged on sales; input tax is suffered on purchases."},
					{"type": "input", "q": "A sale is made for 600 plus sales tax at 20%. The output tax = ?  (number)", "accept": ["120"], "display_answer": "120", "ex": "20% x 600 = 120."},
					{"type": "input", "q": "A purchase invoice is 540 gross, including sales tax at 20%. The recoverable input tax = ?  (number)", "accept": ["90"], "display_answer": "90", "ex": "Gross to tax = 540 x 20/120 = 90."},
					{"type": "input", "q": "Output tax 9,000 and input tax 6,500. Amount owed to the tax authority = ?  (number)", "accept": ["2500"], "display_answer": "2,500", "ex": "Net payable = 9,000 - 6,500 = 2,500."},
					{"type": "input", "q": "Goods are sold for 960 including sales tax at 20%. The net sales figure = ?  (number)", "accept": ["800"], "display_answer": "800", "ex": "Net = 960 x 100/120 = 800."},
					{"type": "choice", "q": "In the financial statements, receivables are shown:", "opts": ["Net of sales tax", "Gross (including sales tax)", "At cost", "At NRV"], "a": 1, "ex": "Receivables include the tax the customer must pay, so they are shown gross."},
					{"type": "choice", "q": "Irrecoverable input tax (e.g. on entertaining) is:", "opts": ["Reclaimed as normal", "Included in the related expense or asset cost", "Added to output tax", "Ignored"], "a": 1, "ex": "If input tax cannot be reclaimed, it forms part of the related expense or cost."}
				]
			},

			# ---------------- CHAPTER 9 ----------------
			{
				"id": 9,
				"title": "Receivables, Payables & Irrecoverable Debts",
				"monster": "The Debt Specter",
				"beats": [
					{"type": "story", "speaker": "Sensei Otter", "text": "The [b]Debt Specter[/b] drifts between the ledgers, dropping amounts no one will pay. Control the accounts and allow for the doubtful ones."},
					{"type": "story", "speaker": "Sensei Otter", "text": "The receivables control is the total owed by customers (a debit balance). Write off a bad debt: [b]Dr Irrecoverable debts expense, Cr Receivables[/b]. An [b]allowance[/b] is netted off receivables; only its [b]movement[/b] hits the SOPL."},
					{"type": "taccount", "speaker": "Sensei Otter", "text": "Reconstruct the control account to find the closing balance owed by customers:", "name": "Receivables control account", "dr": ["Balance b/d 10,000", "Credit sales 55,000"], "cr": ["Cash received 48,000", "Returns inwards 2,000", "Irrecoverable debts 1,000", "Balance c/d 14,000"], "dr_total": "65,000", "cr_total": "65,000"},
					{"type": "choice", "q": "To write off an irrecoverable debt, the entry is:", "opts": ["Dr Receivables, Cr Cash", "Dr Irrecoverable debts expense, Cr Receivables", "Dr Sales, Cr Receivables", "Dr Allowance, Cr Cash"], "a": 1, "ex": "Writing off charges the expense and removes the receivable."},
					{"type": "input", "q": "The allowance for receivables rises from 2,000 to 3,200. The charge to the SOPL = ?  (number)", "accept": ["1200"], "display_answer": "1,200", "ex": "Only the movement hits the SOPL: 3,200 - 2,000 = 1,200."},
					{"type": "input", "q": "Receivables 80,000. Specific allowance 3,000, plus 2% general on the rest. Total allowance = ?  (number)", "accept": ["4540"], "display_answer": "4,540", "ex": "3,000 + 2% x (80,000 - 3,000) = 3,000 + 1,540 = 4,540."},
					{"type": "choice", "q": "The payables control account balance represents:", "opts": ["Amounts owed by customers", "Amounts owed to suppliers", "Cash in hand", "Inventory held"], "a": 1, "ex": "The payables control shows the total owed to suppliers - a current liability."},
					{"type": "choice", "q": "The allowance falls from 5,000 to 3,500. The effect on the SOPL is:", "opts": ["An expense of 1,500", "A reduction of the expense of 1,500", "An expense of 3,500", "No effect"], "a": 1, "ex": "A decrease of 1,500 reduces the irrecoverable debts expense."},
					{"type": "choice", "q": "A debt previously written off is unexpectedly paid. On receipt:", "opts": ["Dr Receivables, Cr Cash", "Dr Cash, Cr Irrecoverable debts (expense/income)", "Dr Allowance, Cr Cash", "Dr Sales, Cr Cash"], "a": 1, "ex": "Cash recovered is Dr Cash and credited back against the irrecoverable debts expense."},
					{"type": "choice", "q": "The receivables control account is reconciled to:", "opts": ["The bank statement", "The total of the memorandum receivables ledger", "The payables control", "The trial balance total"], "a": 1, "ex": "The control balance is agreed to the sum of the individual customer accounts."}
				]
			},

			# ---------------- CHAPTER 10 ----------------
			{
				"id": 10,
				"title": "Bank Reconciliations",
				"monster": "The Statement Serpent",
				"beats": [
					{"type": "story", "speaker": "Sensei Otter", "text": "The [b]Statement Serpent[/b] coils between your cash book and the bank. Agree the two and it cannot hide a slithering error."},
					{"type": "story", "speaker": "Sensei Otter", "text": "Step 1 - [b]correct the cash book[/b] for bank charges, interest, standing orders, direct debits, dishonoured cheques and errors. Step 2 - reconcile the bank statement using [b]timing differences[/b]: unpresented cheques and outstanding lodgements. The corrected cash book goes to the SOFP."},
					{"type": "story", "speaker": "Sensei Otter", "text": "Reconciliation proforma:\nBalance per bank statement 3,900\n[b]add[/b] outstanding lodgements 900\n[b]less[/b] unpresented cheques (600)\n= Balance per corrected cash book [b]4,200[/b]."},
					{"type": "choice", "q": "Bank charges not yet recorded should be:", "opts": ["Adjusted in the cash book", "Left as a timing difference", "Added to the bank statement", "Ignored"], "a": 0, "ex": "Bank charges are something the business had not recorded - correct the cash book."},
					{"type": "choice", "q": "An unpresented cheque is:", "opts": ["A cash book adjustment", "A timing difference between corrected cash book and bank statement", "An error", "A direct debit"], "a": 1, "ex": "A cheque written but not yet cleared is a timing difference."},
					{"type": "input", "q": "The cash book shows 2,000 (debit). Bank charges of 150 (not recorded). Corrected balance = ?  (number)", "accept": ["1850"], "display_answer": "1,850", "ex": "2,000 - 150 = 1,850 corrected cash book."},
					{"type": "input", "q": "Corrected cash book 5,000 (Dr); unpresented cheques 800; outstanding lodgements 500. Bank statement balance = ?  (number)", "accept": ["5300"], "display_answer": "5,300", "ex": "5,000 + unpresented 800 - lodgements 500 = 5,300."},
					{"type": "choice", "q": "The balance that goes into the SOFP is:", "opts": ["The bank statement balance", "The corrected cash book balance", "The original cash book balance", "The overdraft limit"], "a": 1, "ex": "The corrected cash book balance is reported in the SOFP."},
					{"type": "choice", "q": "In the business own books, a bank overdraft is a:", "opts": ["Debit balance (asset)", "Credit balance (liability)", "Suspense balance", "Not recorded"], "a": 1, "ex": "An overdraft is money owed to the bank - a credit balance."},
					{"type": "choice", "q": "A dishonoured (bounced) customer cheque should be:", "opts": ["Added to the cash book", "Credited (removed) in the cash book", "Treated as a timing difference", "Ignored"], "a": 1, "ex": "The cash was never really received, so credit (reduce) the cash book."}
				]
			},

			# ---------------- CHAPTER 11 ----------------
			{
				"id": 11,
				"title": "Correction of Errors & Suspense Accounts",
				"monster": "The Suspense Spectre",
				"beats": [
					{"type": "story", "speaker": "Sensei Otter", "text": "The [b]Suspense Spectre[/b] holds the gap when your books refuse to balance. Find the error and it fades to nothing."},
					{"type": "story", "speaker": "Sensei Otter", "text": "Errors that keep the TB balanced: [b]Omission, Commission, Principle, Compensating, Original entry, Reversal[/b]. Errors that break it go through a [b]suspense account[/b], cleared before the statements."},
					{"type": "taccount", "speaker": "Sensei Otter", "text": "Rent of 90 was paid but debited as only 9 - the debits are 81 short, so suspense holds the gap until the journal clears it:", "name": "Suspense account", "dr": ["Trial balance difference 81"], "cr": ["Rent expense (correction) 81"], "dr_total": "81", "cr_total": "81"},
					{"type": "choice", "q": "An error of principle is:", "opts": ["Right side, wrong TYPE of account", "A missing transaction", "A one-sided entry", "Two errors cancelling out"], "a": 0, "ex": "An error of principle posts to the wrong type of account; the TB still balances."},
					{"type": "choice", "q": "A suspense account is needed when:", "opts": ["The TB does not balance", "There are no errors", "Preparing a bank reconciliation", "The TB balances"], "a": 0, "ex": "A suspense account temporarily holds the difference when debits do not equal credits."},
					{"type": "input", "q": "Rent was debited to the rent account as 560 instead of 650. The amount held in suspense = ?  (number)", "accept": ["90"], "display_answer": "90", "ex": "650 - 560 = 90 short, so 90 sits in suspense."},
					{"type": "choice", "q": "Which error would make the trial balance disagree?", "opts": ["An error of commission", "A one-sided entry", "An error of principle", "Compensating errors"], "a": 1, "ex": "A one-sided entry makes debits not equal credits."},
					{"type": "choice", "q": "A sale of 250 was completely left out of the books. This is an error of:", "opts": ["Omission", "Commission", "Principle", "Original entry"], "a": 0, "ex": "A transaction left out entirely is an error of omission."},
					{"type": "choice", "q": "Recording the purchase of a van (an asset) as motor expenses is an error of:", "opts": ["Principle", "Omission", "Commission", "Original entry"], "a": 0, "ex": "Wrong TYPE of account (asset vs expense) is an error of principle."},
					{"type": "choice", "q": "A suspense account must be:", "opts": ["Carried forward indefinitely", "Cleared before the financial statements", "Shown as revenue", "Added to capital"], "a": 1, "ex": "The suspense balance is temporary and must be cleared via correcting journals."}
				]
			},

			# ---------------- CHAPTER 12 ----------------
			{
				"id": 12,
				"title": "Incomplete Records",
				"monster": "The Fragment Fiend",
				"beats": [
					{"type": "story", "speaker": "Sensei Otter", "text": "The [b]Fragment Fiend[/b] has torn the records to pieces. Rebuild the missing figures and it cannot deceive you."},
					{"type": "story", "speaker": "Sensei Otter", "text": "[b]Mark-up[/b] = gross profit as a % of COST. [b]Margin[/b] = gross profit as a % of SALES. [b]Profit[/b] = closing net assets - opening net assets + drawings - capital introduced. Reconstruct control accounts for missing sales or purchases."},
					{"type": "input", "q": "Cost of sales 40,000 with a mark-up of 25%. Sales = ?  (number)", "accept": ["50000"], "display_answer": "50,000", "ex": "Mark-up is on cost: 40,000 x 1.25 = 50,000."},
					{"type": "input", "q": "Sales 80,000 at a gross margin of 30%. Cost of sales = ?  (number)", "accept": ["56000"], "display_answer": "56,000", "ex": "Gross profit 30% x 80,000 = 24,000, so cost of sales = 56,000."},
					{"type": "input", "q": "Opening net assets 50,000, closing 62,000, drawings 15,000, no new capital. Profit = ?  (number)", "accept": ["27000"], "display_answer": "27,000", "ex": "Profit = (62,000 - 50,000) + 15,000 = 27,000."},
					{"type": "choice", "q": "Mark-up is gross profit as a % of:", "opts": ["Cost", "Sales", "Net assets", "Capital"], "a": 0, "ex": "Mark-up is on cost; margin is on sales."},
					{"type": "input", "q": "A 25% mark-up on cost equals a margin on sales of what %?  (number)", "accept": ["20", "20%"], "display_answer": "20%", "ex": "Cost 100, mark-up 25, sales 125; margin = 25/125 = 20%."},
					{"type": "input", "q": "Opening capital 40,000, closing 55,000, drawings 20,000, capital introduced 5,000. Profit = ?  (number)", "accept": ["30000"], "display_answer": "30,000", "ex": "Profit = (55,000 - 40,000) + 20,000 - 5,000 = 30,000."},
					{"type": "choice", "q": "To find missing credit sales, reconstruct the:", "opts": ["Bank reconciliation", "Receivables control account", "Depreciation schedule", "Suspense account"], "a": 1, "ex": "The receivables control (opening + sales - receipts = closing) reveals missing sales."}
				]
			},

			# ---------------- CHAPTER 13 ----------------
			{
				"id": 13,
				"title": "Sole Trader Financial Statements",
				"monster": "The Sole-Trader Sphinx",
				"beats": [
					{"type": "story", "speaker": "Sensei Otter", "text": "The [b]Sole-Trader Sphinx[/b] asks you to pull the whole year together into one set of accounts. Answer true and it lets you pass."},
					{"type": "story", "speaker": "Sensei Otter", "text": "[b]Closing capital = opening capital + capital introduced + profit - drawings[/b]. Drawings reduce capital, never an expense. Adjustments flow to BOTH statements, e.g. depreciation."},
					{"type": "input", "q": "Opening capital 30,000, profit 22,000, drawings 14,000, no new capital. Closing capital = ?  (number)", "accept": ["38000"], "display_answer": "38,000", "ex": "30,000 + 22,000 - 14,000 = 38,000."},
					{"type": "input", "q": "Opening capital 25,000, loss for the year 4,000, drawings 6,000. Closing capital = ?  (number)", "accept": ["15000"], "display_answer": "15,000", "ex": "25,000 - 4,000 - 6,000 = 15,000."},
					{"type": "choice", "q": "Drawings are:", "opts": ["An expense in the SOPL", "A reduction of capital in the SOFP", "Revenue", "A liability"], "a": 1, "ex": "Drawings are the owner taking profit out - they reduce capital, not profit."},
					{"type": "choice", "q": "Goods taken by the owner for personal use should be:", "opts": ["Added to sales", "Deducted from purchases and added to drawings", "Ignored", "Added to expenses"], "a": 1, "ex": "Goods for own use reduce purchases and increase drawings."},
					{"type": "choice", "q": "An irrecoverable debt written off during the year appears in the SOPL as:", "opts": ["Revenue", "An expense", "A liability", "Capital"], "a": 1, "ex": "Writing off a bad debt is an expense in the SOPL."},
					{"type": "choice", "q": "Depreciation for the year affects:", "opts": ["Only the SOPL", "Only the SOFP", "Both the SOPL and the SOFP", "Neither"], "a": 2, "ex": "Depreciation is an expense in the SOPL and reduces the asset carrying amount in the SOFP."},
					{"type": "choice", "q": "In the SOFP, which total must equal total assets?", "opts": ["Revenue + expenses", "Capital + total liabilities", "Gross profit + drawings", "Non-current assets only"], "a": 1, "ex": "Total assets = Capital + total liabilities - the SOFP always balances."}
				]
			},

			# ---------------- CHAPTER 14 ----------------
			{
				"id": 14,
				"title": "Company Accounts & Financial Statements",
				"monster": "The Corporate Colossus",
				"beats": [
					{"type": "story", "speaker": "Sensei Otter", "text": "The towering [b]Corporate Colossus[/b] is built of shares, reserves and loans. Know its parts and it cannot crush you."},
					{"type": "story", "speaker": "Sensei Otter", "text": "Shares are recorded at [b]nominal value[/b]; the excess goes to [b]share premium[/b] (non-distributable). Ordinary = vote; preference = fixed dividend first. [b]Dividends[/b] are an appropriation (not an expense); proposed after the year-end -> disclose only. Bonus = free shares; rights = raises cash."},
					{"type": "input", "q": "50,000 shares of 0.50 each are issued at 0.90. Share capital increases by ?  (number)", "accept": ["25000"], "display_answer": "25,000", "ex": "Share capital = nominal = 50,000 x 0.50 = 25,000 (premium 20,000)."},
					{"type": "input", "q": "100,000 shares of 1.00 each are issued at 1.30. The share premium = ?  (number)", "accept": ["30000"], "display_answer": "30,000", "ex": "Premium = (1.30 - 1.00) x 100,000 = 30,000."},
					{"type": "choice", "q": "Preference shares typically carry:", "opts": ["Voting rights and a variable dividend", "A fixed dividend paid first, usually no vote", "Guaranteed capital growth", "Control of the company"], "a": 1, "ex": "Preference shares get a fixed dividend in priority, usually with no vote."},
					{"type": "choice", "q": "A bonus issue of shares:", "opts": ["Raises new cash", "Issues free shares from reserves and raises no cash", "Is always at market value", "Reduces shares in issue"], "a": 1, "ex": "A bonus issue capitalises reserves into free shares; no cash is raised."},
					{"type": "choice", "q": "A final dividend proposed AFTER the year-end is:", "opts": ["Recognised as a liability", "Not recognised, only disclosed by note", "Charged as a P&L expense", "Added to revenue"], "a": 1, "ex": "A dividend proposed after the reporting date is disclosed by note only."},
					{"type": "choice", "q": "Interest on loan notes is:", "opts": ["An appropriation of profit", "An expense (finance cost) in the SOPL", "Credited to share premium", "A dividend"], "a": 1, "ex": "Loan note interest is a finance cost in the SOPL."},
					{"type": "input", "q": "A dividend of 0.10 per share is paid on 200,000 shares. The amount = ?  (number)", "accept": ["20000"], "display_answer": "20,000", "ex": "200,000 x 0.10 = 20,000, an appropriation of profit."}
				]
			},

			# ---------------- CHAPTER 15 ----------------
			{
				"id": 15,
				"title": "Statement of Cash Flows",
				"monster": "The Cashflow Leviathan",
				"beats": [
					{"type": "story", "speaker": "Sensei Otter", "text": "The deep-dwelling [b]Cashflow Leviathan[/b] cares nothing for profit, only for real cash. Trace the cash and it surfaces."},
					{"type": "story", "speaker": "Sensei Otter", "text": "Three sections: [b]Operating, Investing, Financing[/b]. Indirect method: start with profit, [b]add back depreciation[/b], adjust working capital. [b]Asset up = cash outflow; liability up = cash inflow.[/b]"},
					{"type": "choice", "q": "The three sections of a statement of cash flows are:", "opts": ["Operating, investing and financing", "Current, non-current and equity", "Fixed, variable and semi-variable", "Revenue, capital and reserves"], "a": 0, "ex": "Cash flows are classified as operating, investing and financing activities."},
					{"type": "input", "q": "Profit before tax 50,000; depreciation 8,000; receivables rose 3,000; payables rose 2,000. Cash generated from operations = ?  (number)", "accept": ["57000"], "display_answer": "57,000", "ex": "50,000 + 8,000 - 3,000 + 2,000 = 57,000."},
					{"type": "choice", "q": "In the indirect method, depreciation is:", "opts": ["Added back to profit", "Deducted from profit", "Ignored", "Shown as financing"], "a": 0, "ex": "Depreciation is a non-cash expense, so it is added back."},
					{"type": "choice", "q": "An increase in inventory is a cash:", "opts": ["Outflow", "Inflow", "Financing item", "Investing item"], "a": 0, "ex": "Tying up more cash in inventory is a cash outflow."},
					{"type": "choice", "q": "Proceeds from issuing new shares appear under:", "opts": ["Operating activities", "Investing activities", "Financing activities", "Cost of sales"], "a": 2, "ex": "Raising finance from shares is a financing activity."},
					{"type": "choice", "q": "The purchase of new machinery for cash is shown under:", "opts": ["Operating activities", "Investing activities", "Financing activities", "Equity"], "a": 1, "ex": "Buying non-current assets is an investing activity."},
					{"type": "choice", "q": "A decrease in trade payables is a cash:", "opts": ["Inflow", "Outflow", "Financing item", "Investing item"], "a": 1, "ex": "Paying down payables uses cash - an outflow."}
				]
			},

			# ---------------- CHAPTER 16 ----------------
			{
				"id": 16,
				"title": "Consolidated Financial Statements",
				"monster": "The Consolidation Hydra",
				"beats": [
					{"type": "story", "speaker": "Sensei Otter", "text": "The final beast: the [b]Consolidation Hydra[/b], many heads acting as one. Present the group as a single entity and cut it down."},
					{"type": "story", "speaker": "Sensei Otter", "text": "A parent [b]controls[/b] a subsidiary (usually >50% of votes) and consolidates [b]100%[/b] of its assets and liabilities. [b]Goodwill = consideration + NCI - net assets at acquisition[/b]. NCI (the part not owned) sits in equity. Intra-group balances cancel."},
					{"type": "choice", "q": "Control of a subsidiary normally means owning more than:", "opts": ["50% of voting shares", "25% of voting shares", "75% of voting shares", "Any shares"], "a": 0, "ex": "Control is usually more than 50% of the voting rights."},
					{"type": "choice", "q": "In the consolidated SOFP, how much of a subsidiary assets are added in?", "opts": ["100%", "Only the % owned", "50%", "None"], "a": 0, "ex": "The group controls the subsidiary, so 100% is consolidated (with an NCI)."},
					{"type": "input", "q": "P pays 600,000 for 80% of S. S net assets at acquisition 650,000; NCI valued at 130,000. Goodwill = ?  (number)", "accept": ["80000"], "display_answer": "80,000", "ex": "Goodwill = 600,000 + 130,000 - 650,000 = 80,000."},
					{"type": "input", "q": "P pays 500,000 for 100% of S, whose net assets at acquisition are 420,000. Goodwill = ?  (number)", "accept": ["80000"], "display_answer": "80,000", "ex": "With no NCI: 500,000 - 420,000 = 80,000."},
					{"type": "choice", "q": "Sales made between the parent and its subsidiary are:", "opts": ["Added to group revenue", "Eliminated on consolidation", "Shown as NCI", "Treated as goodwill"], "a": 1, "ex": "The group cannot trade with itself, so intra-group sales are eliminated."},
					{"type": "choice", "q": "The non-controlling interest is presented:", "opts": ["As a liability", "Within equity in the consolidated SOFP", "As goodwill", "In the SOPL only"], "a": 1, "ex": "NCI is part of group equity."},
					{"type": "choice", "q": "Consolidated financial statements present the parent and subsidiary as:", "opts": ["Two separate entities", "A single economic entity (the group)", "Only the parent", "Only the subsidiary"], "a": 1, "ex": "Consolidation shows the group as one economic entity."}
				]
			}

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
