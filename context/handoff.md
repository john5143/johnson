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
**Status:** on track — Purchases_J ready for load: 10 rows planned, schema confirmed (no OrderAmount field), awaiting approval to proceed

**Done this session**
- Identified Purchases_J data extension: 3 required fields (PurchaseID, SubscriberKey, PurchaseDate), 0 rows
- Planned 10 rows reusing PUR-0001 to PUR-0010 IDs and dates from Purchase_History_J for alignment
- Confirmed unsubscribed contacts (BDAY-0004, BDAY-0008) excluded from Purchases_J load

**Open items**
- Approve Purchases_J load plan or request different data (dates/IDs) before proceeding
- Load 10 rows into Purchases_J via bulk upsert
- Read back Purchases_J to confirm all 10 rows persisted with real dates
- Confirm whether OrderAmount scale should be changed to Decimal(18,2) in Purchase_History_J
- Run manual test in Journey Builder with 4 test contacts from John_Mike_Bio_Split_Test
- Replace sample@example.com addresses in John_Mike_JB_Test with controlled test addresses
- Publish John_Mike_JB_Test journey after routing confirmed
- Resolve testOrchestrateMap error from previous automation run

**Decisions**
- Master_Subscribers_J: 10 rows (BDAY-0001 to BDAY-0010) with mixed Status values
- Inactive_Purge_Target_J: 10 rows with separate PURGE- keys
- Platform_Interactions_J: 10 rows (INT-0001 to INT-0010) loaded and verified
- Purchase_History_J: 10 rows (PUR-0001 to PUR-0010) using BDAY- keys for join alignment
- Purchases_J: 10 rows planned, reusing same PurchaseIDs and dates as Purchase_History_J for data alignment
- Entry source: DEAudience-John_Mike_JB_Test-20261009 from John_Mike_Bio_Split_Test, no schedule
- Bio_Check condition 1: IsNotNull; condition 2: NotEqual 'No Biography is Available here.'

**Blockers**
- OrderAmount field scale (0) in Purchase_History_J cannot store decimal values — decision pending on schema change

**Next**
- Approve or modify Purchases_J load plan (10 rows with PUR-0001 to PUR-0010, BDAY keys, dates from Purchase_History_J)
- Execute bulk upsert of 10 rows into Purchases_J
- Read back Purchases_J to verify all 10 rows persisted with real dates
- Decide: keep OrderAmount as Decimal(18,0) or change to Decimal(18,2)

**Checked live on 2026-10-12:** the Salesforce org
### Last session — 2026-10-12
| | |
|---|---|
| Type | BUILD |
| Outcome | COMPLETED |
| Branch | `orchestrate/context` |
| Session | `130de6ce-20be-4646-896c-78e5de6e72f4` |
**In its own words (excerpt):**
I found **Purchases_J**. It has 3 fields, all required, and 0 rows at the moment:

- **PurchaseID**: Text(50), primary key
- **SubscriberKey**: Text(50). It isn't a key, so one contact can have several purchases.
- **PurchaseDate**: Date

It has the same layout as Purchase_History_J but no OrderAmount field, so the scale problem from that one doesn't apply here.

**Planned rows.** I've reused the same PurchaseIDs, contacts and dates you already have in Purchase_History_J. That way the two data extensions agree, and any join or comparison between them lines up. BDAY-0001 and BDAY-0005 each have 2 purchases. The unsubscribed contacts, BDAY-0004 and BDAY-0008, are left out.

| PurchaseID | SubscriberKey | PurchaseDate |
|---|---|---|
| PUR-0001 | BDAY-0001 | 2026-09-20 |
| PUR-0002 | BDAY-0001 | 2026-10-04 |
| PUR-0003 | BDAY-0002 | 2026-10-02 |
| PUR-0004 | BDAY-0003 | 2026-08-28 |
| PUR-0005 | BDAY-0005 | 2026-10-05 |
| PUR-0006 | BDAY-0005 | 2026-10-10 |
| PUR-0007 | BDAY-0006 | 2026-10-07 |
| PUR-0008 | BDAY-0007 | 2026-07-15 |
| PUR-0009 | BDAY-0009 | 2026-10-08 |
| PUR-0010 | BDAY-0010 | 2026-10-11 |

Today is 2026-10-12. A "purchased in the last 30 days" filter on these rows wo

_[summary truncated — see the session record for the full text]_
<!-- orchestrate:session-state:end -->
