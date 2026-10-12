# Handoff — current state

> **Rewritten at the end of every session.** This file is *now*; [`gotchas.md`](gotchas.md) is *forever*.
> If this file and [`../CONTEXT.md`](../CONTEXT.md) disagree, this one is newer.

**Last updated:** 2026-10-05 · **By:** <session or person>

---

## Where things stand

> **Not yet filled in.** — Where is the work right now, in two or three sentences? Someone picking
> this up cold reads this first.

## In progress

| What | State | Where it lives | Blocked on |
|---|---|---|---|
| | | | |

## Next steps

<!-- Ordered. The top item should be the one to do next, not the most interesting one. -->

1.

## Waiting on someone else

| What | Who | Since | Chased? |
|---|---|---|---|
| | | | |

## Things the next session should know

<!-- Anything true right now that is not obvious from the code: a half-finished refactor, a
     deliberately disabled test, a workaround that needs removing, a deploy that is half-applied.
     If you leave something in a strange state, this is where you say so. -->

-

<!-- orchestrate:session-state:start -->
<!-- Written by Orchestrate at the end of each session. Edits inside this block are
     replaced next session; anything OUTSIDE it is yours and is never touched. -->
### Engagement state — 2026-10-12
**Status:** on track — Raw_Transactions_J discovered with 0 rows; 10-row load plan ready. Amount is Text(50); proceeding as-is for staging table.

**Done this session**
- Discovered Raw_Transactions_J schema: 5 required fields, TransactionID is primary key
- Confirmed Amount field is Text(50), not numeric — normal for staging table
- Prepared 10 test transactions with BDAY- contacts, 2 per-customer samples, 2 rows >30 days old

**Open items**
- Load 10 rows into Raw_Transactions_J via bulk upsert and verify persistence
- Confirm TransactionDate saved as real date and Amount values match exactly
- Decide: keep OrderAmount as Decimal(18,0) or change to Decimal(18,2) in Purchase_History_J
- Run manual test in Journey Builder with 4 test contacts from John_Mike_Bio_Split_Test
- Replace sample@example.com addresses in John_Mike_JB_Test with controlled test addresses
- Publish John_Mike_JB_Test journey after routing confirmed
- Resolve testOrchestrateMap error from previous automation run

**Decisions**
- Raw_Transactions_J Amount field remains Text(50) — staging table design confirmed
- All previous decisions from 2026-10-12 remain in effect

**Blockers**
- OrderAmount field scale (0) in Purchase_History_J cannot store decimal values — decision pending on schema change

**Next**
- Run bulk upsert of 10 rows into Raw_Transactions_J
- Read back and verify all 10 rows persisted with real dates and exact Amount values
- Proceed to OrderAmount scale decision for Purchase_History_J

**Checked live on 2026-10-12:** the Salesforce org
### Last session — 2026-10-12
| | |
|---|---|
| Type | BUILD |
| Outcome | COMPLETED |
| Branch | `orchestrate/context` |
| Session | `130de6ce-20be-4646-896c-78e5de6e72f4` |
**In its own words (excerpt):**
I found **Raw_Transactions_J**. It has 5 fields, all required, and 0 rows right now:

- **TransactionID**: Text(50), primary key
- **CustomerID**: Text(50). It isn't a key here, so one customer can have several transactions.
- **StoreLocation**: Text(50)
- **Amount**: **Text(50)**. It's not a number field.
- **TransactionDate**: Date

**About Amount being Text.** Because it's text, values with cents like "49.99" will save exactly as written. The downside is that Marketing Cloud treats them as text. To sort, total or compare by value (for example `Amount > 100`), a SQL query has to `CAST` the field to a number first. If you named it "Raw" because it's a staging table that a query cleans up later, that's a normal setup and you don't need to change anything. I've written every amount as a plain number with two decimal places and no currency symbol, so it converts cleanly.

**The rows I plan to load.** CustomerID uses the same BDAY- contacts as your other test data extensions, so joins on SubscriberKey still line up. BDAY-0002 and BDAY-0006 each have two transactions, which lets you test totals and "latest transaction" logic for a customer. I left out the unsubscribed contacts, BDAY-00

_[summary truncated — see the session record for the full text]_
<!-- orchestrate:session-state:end -->
