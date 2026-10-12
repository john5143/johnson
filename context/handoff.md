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
**Status:** on track — Raw_Transactions_J loaded & verified: 10 rows persisted with exact amounts & real dates. OrderAmount scale decision pending.

**Done this session**
- Bulk upsert of 10 test rows into Raw_Transactions_J completed
- Verified all 10 rows persisted with exact Amount values and real TransactionDate
- Confirmed 30-day date window filtering works (excludes TXN-0004, TXN-0008)
- Validated multi-transaction customer logic (BDAY-0002, BDAY-0006 totals require CAST)

**Open items**
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
- Decide OrderAmount scale change for Purchase_History_J (Decimal(18,0) vs Decimal(18,2))
- Proceed to Journey Builder manual test with John_Mike_Bio_Split_Test contacts
- Replace sample@example.com test addresses in John_Mike_JB_Test
- Resolve testOrchestrateMap automation error

**Checked live on 2026-10-12:** the Salesforce org
### Last session — 2026-10-12
| | |
|---|---|
| Type | BUILD |
| Outcome | COMPLETED |
| Branch | `orchestrate/context` |
| Session | `130de6ce-20be-4646-896c-78e5de6e72f4` |
**In its own words (excerpt):**
**Raw_Transactions_J** now has all 10 sample rows. It had 0 rows before the load, and when I read it back it had 10.

| TransactionID | CustomerID | StoreLocation | Amount | TransactionDate |
|---|---|---|---|---|
| TXN-0001 | BDAY-0001 | Online | 49.99 | 2026-10-01 |
| TXN-0002 | BDAY-0002 | Downtown | 125.50 | 2026-09-22 |
| TXN-0003 | BDAY-0002 | Online | 18.75 | 2026-10-07 |
| TXN-0004 | BDAY-0003 | Northgate Mall | 240.00 | 2026-08-30 |
| TXN-0005 | BDAY-0005 | Airport | 12.40 | 2026-10-03 |
| TXN-0006 | BDAY-0006 | Downtown | 89.95 | 2026-10-05 |
| TXN-0007 | BDAY-0006 | Westfield | 310.20 | 2026-10-09 |
| TXN-0008 | BDAY-0007 | Northgate Mall | 64.00 | 2026-07-18 |
| TXN-0009 | BDAY-0009 | Online | 499.99 | 2026-10-10 |
| TXN-0010 | BDAY-0010 | Westfield | 35.25 | 2026-10-11 |

- **Every value matches the plan.** Amount saved exactly as written, including the trailing zeros like "125.50" and "240.00", because the field is text. TransactionDate saved as a real date, which Marketing Cloud shows as midnight on each day.
- **Testing the date window:** a "last 30 days" filter (from 2026-09-12) leaves out TXN-0004 and TXN-0008.
- **Customers with more than one transaction:** BDAY-

_[summary truncated — see the session record for the full text]_
<!-- orchestrate:session-state:end -->
