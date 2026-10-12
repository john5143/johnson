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
**Status:** on track — VIP_Upsell_Target_J loaded & verified: 10 rows persisted. OrderAmount scale decision still pending.

**Done this session**
- Loaded 10 test rows into VIP_Upsell_Target_J
- Verified all 10 rows persisted with correct TotalSpent (whole numbers) and PrimaryStore values
- Confirmed filter logic: TotalSpent ≥ 1000 removes BDAY-0003, BDAY-0007; Active-only join removes BDAY-0004, BDAY-0008

**Open items**
- Decide: OrderAmount scale change for Purchase_History_J (Decimal(18,0) vs Decimal(18,2))
- Run manual test in Journey Builder with 4 test contacts from John_Mike_Bio_Split_Test
- Replace sample@example.com addresses in John_Mike_JB_Test with controlled test addresses
- Publish John_Mike_JB_Test journey after routing confirmed
- Resolve testOrchestrateMap error from previous automation run
- Confirm: load Cart_Abandonment_Target_J or keep cancelled

**Decisions**
- Raw_Transactions_J Amount field remains Text(50) — staging table design confirmed
- Staging_Active_Subscribers_J includes all 10 contacts (BDAY-0001 to BDAY-0010) including inactive ones for filtering validation
- VIP_Upsell_Target_J test data uses whole numbers; TotalSpent scale decision deferred to separate change
- VIP_Upsell_Target_J 10-row load approved and completed

**Blockers**
- OrderAmount field scale (0) in Purchase_History_J cannot store decimal values — decision pending on schema change

**Next**
- Decide OrderAmount scale for Purchase_History_J (Decimal(18,0) vs Decimal(18,2))
- Run manual Journey Builder test with 4 contacts from John_Mike_Bio_Split_Test
- Replace sample@example.com in John_Mike_JB_Test with controlled test addresses

**Checked live on 2026-10-12:** the Salesforce org
### Last session — 2026-10-12
| | |
|---|---|
| Type | BUILD |
| Outcome | COMPLETED |
| Branch | `orchestrate/context` |
| Session | `130de6ce-20be-4646-896c-78e5de6e72f4` |
**In its own words (excerpt):**
**VIP_Upsell_Target_J** now has all 10 sample rows. It had 0 rows before the load, and reading it back after the load returned 10.

| SubscriberKey | TotalSpent | PrimaryStore |
|---|---|---|
| BDAY-0001 | 1250 | Online |
| BDAY-0002 | 2480 | Downtown |
| BDAY-0003 | 980 | Northgate Mall |
| BDAY-0004 | 1520 | Downtown |
| BDAY-0005 | 3200 | Airport |
| BDAY-0006 | 1875 | Westfield |
| BDAY-0007 | 640 | Northgate Mall |
| BDAY-0008 | 1100 | Online |
| BDAY-0009 | 4999 | Online |
| BDAY-0010 | 1310 | Westfield |

- **Every value matches the plan.** All the TotalSpent amounts are whole numbers, so none were rounded when saved.
- **Filters you can test:**
  - TotalSpent ≥ 1000 removes BDAY-0003 and BDAY-0007.
  - An Active-only join to Master_Subscribers_J also removes BDAY-0004 and BDAY-0008.
- **No email was sent.** This load only wrote data.

**Test data status:** 12 data extensions now have 10 rows each. VIP_Upsell_Target_J is the newest. Cart_Abandonment_Target_J is still empty because you cancelled that load.

**Still open:** TotalSpent here and OrderAmount in Purchase_History_J are both Decimal(18,0), so they can't hold cents. If you want either to store real money values, I ca

_[summary truncated — see the session record for the full text]_
<!-- orchestrate:session-state:end -->
