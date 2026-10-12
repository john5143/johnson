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
**Status:** on track — Cart_Abandonment_Target_J ready to load: 10 rows mapped, awaiting approval to proceed

**Done this session**
- Inspected Cart_Abandonment_Target_J schema: 3 required fields, 0 rows, CartTotal is Decimal(18,0)
- Mapped 10 source rows from Cart_Abandonment_J to target (BDAY-0001 to BDAY-0010, all whole numbers)
- Confirmed all CartTotal values are whole numbers — no rounding risk on save

**Open items**
- Approve or reject Cart_Abandonment_Target_J 10-row load (all contacts vs. Active-only)
- Decide: OrderAmount scale change for Purchase_History_J (Decimal(18,0) vs Decimal(18,2))
- Run manual test in Journey Builder with 4 test contacts from John_Mike_Bio_Split_Test
- Replace sample@example.com addresses in John_Mike_JB_Test with controlled test addresses
- Publish John_Mike_JB_Test journey after routing confirmed
- Resolve testOrchestrateMap error from previous automation run

**Decisions**
- Raw_Transactions_J Amount field remains Text(50) — staging table design confirmed
- Staging_Active_Subscribers_J includes all 10 contacts (BDAY-0001 to BDAY-0010) including inactive ones for filtering validation
- VIP_Upsell_Target_J test data uses whole numbers; TotalSpent scale decision deferred to separate change
- VIP_Upsell_Target_J 10-row load approved and completed

**Blockers**
- OrderAmount field scale (0) in Purchase_History_J cannot store decimal values — decision pending on schema change

**Next**
- Decide: load Cart_Abandonment_Target_J with all 10 rows or Active-only subset (6 rows)
- Execute approved Cart_Abandonment_Target_J load and verify persistence
- Decide OrderAmount scale for Purchase_History_J (Decimal(18,0) vs Decimal(18,2))

**Checked live on 2026-10-12:** the Salesforce org
### Last session — 2026-10-12
| | |
|---|---|
| Type | BUILD |
| Outcome | COMPLETED |
| Branch | `orchestrate/context` |
| Session | `130de6ce-20be-4646-896c-78e5de6e72f4` |
**In its own words (excerpt):**
I found **Cart_Abandonment_Target_J**. It has 3 fields, all required, and 0 rows right now:

- **SubscriberKey**: Text(50), primary key, so each contact can appear only once
- **AbandonDate**: Date
- **CartTotal**: Decimal(18, **0**), so it can't store cents (the same setting as TotalSpent and OrderAmount)

**The rows I'd load.** I read your source table, Cart_Abandonment_J, which has 10 rows: one cart for each contact from BDAY-0001 to BDAY-0010. Since each contact has exactly one cart, the target can copy those values directly. Then the source and target agree, and you can check a query's output against them.

| SubscriberKey | AbandonDate | CartTotal | Source row |
|---|---|---|---|
| BDAY-0001 | 2026-10-01 | 129 | CART-0001 |
| BDAY-0002 | 2026-10-02 | 45 | CART-0002 |
| BDAY-0003 | 2026-10-03 | 310 | CART-0003 |
| BDAY-0004 | 2026-10-04 | 78 | CART-0004 |
| BDAY-0005 | 2026-10-05 | 560 | CART-0005 |
| BDAY-0006 | 2026-10-06 | 22 | CART-0006 |
| BDAY-0007 | 2026-10-07 | 199 | CART-0007 |
| BDAY-0008 | 2026-10-08 | 87 | CART-0008 |
| BDAY-0009 | 2026-10-09 | 415 | CART-0009 |
| BDAY-0010 | 2026-10-10 | 64 | CART-0010 |

All the totals are whole numbers, so nothing gets rounded w

_[summary truncated — see the session record for the full text]_
<!-- orchestrate:session-state:end -->
