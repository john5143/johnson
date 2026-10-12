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
**Status:** on track — Cart_Abandonment_Target_J loaded & verified: 10 rows persisted. All 13 test tables now populated.

**Done this session**
- Loaded all 10 sample rows into Cart_Abandonment_Target_J
- Verified persistence: read-back matches plan exactly
- Confirmed CartTotal whole numbers saved without rounding
- Validated source-to-target row alignment for query testing

**Open items**
- Decide OrderAmount scale for Purchase_History_J (Decimal(18,0) vs Decimal(18,2))
- Run manual test in Journey Builder with 4 test contacts from John_Mike_Bio_Split_Test
- Replace sample@example.com addresses in John_Mike_JB_Test with controlled test addresses
- Publish John_Mike_JB_Test journey after routing confirmed
- Resolve testOrchestrateMap error from previous automation run
- Confirm schema change to Decimal(18,2) for CartTotal, TotalSpent, OrderAmount if real money values needed

**Decisions**
- Raw_Transactions_J Amount field remains Text(50) — staging table design confirmed
- Staging_Active_Subscribers_J includes all 10 contacts (BDAY-0001 to BDAY-0010) for filtering validation
- VIP_Upsell_Target_J 10-row load approved and completed
- Cart_Abandonment_Target_J loaded with all 10 rows (all contacts, not Active-only subset)

**Blockers**
- OrderAmount field scale (0) in Purchase_History_J cannot store decimal values — decision pending on schema change

**Next**
- Decide: convert CartTotal, TotalSpent, OrderAmount to Decimal(18,2) for real money values or keep as Decimal(18,0)
- Run manual Journey Builder test with 4 test contacts from John_Mike_Bio_Split_Test
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
I loaded all 10 sample rows into **Cart_Abandonment_Target_J**. It had 0 rows before, and reading it back after the load returned 10.

| SubscriberKey | AbandonDate | CartTotal |
|---|---|---|
| BDAY-0001 | 2026-10-01 | 129 |
| BDAY-0002 | 2026-10-02 | 45 |
| BDAY-0003 | 2026-10-03 | 310 |
| BDAY-0004 | 2026-10-04 | 78 |
| BDAY-0005 | 2026-10-05 | 560 |
| BDAY-0006 | 2026-10-06 | 22 |
| BDAY-0007 | 2026-10-07 | 199 |
| BDAY-0008 | 2026-10-08 | 87 |
| BDAY-0009 | 2026-10-09 | 415 |
| BDAY-0010 | 2026-10-10 | 64 |

- **Every value matches the plan.** AbandonDate saved as a real date (Marketing Cloud shows midnight on each day, e.g. "10/1/2026 12:00:00 AM"). CartTotal saved as whole numbers, so nothing was rounded.
- **It matches the source.** Each row has the same values as that contact's cart in Cart_Abandonment_J, so you can check a query's output against it directly.
- **You can test an Active-only filter on it.** A join to Master_Subscribers_J would remove BDAY-0003, BDAY-0004, BDAY-0007 and BDAY-0008.
- **No email was sent.** The load only wrote data.

**Where the test data stands:** all 13 data extensions you've asked about this session now have 10 rows each. Cart_Abandonment_T

_[summary truncated — see the session record for the full text]_
<!-- orchestrate:session-state:end -->
