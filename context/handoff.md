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
**Status:** on track — VIP_Upsell_Target_J schema confirmed; 10 test rows ready to load pending approval

**Done this session**
- Verified VIP_Upsell_Target_J structure: SubscriberKey (PK), TotalSpent Decimal(18,0), PrimaryStore Text(50)
- Prepared 10 test rows (BDAY-0001 to BDAY-0010) with VIP-level spend amounts and store names

**Open items**
- Decide: OrderAmount scale change for Purchase_History_J (Decimal(18,0) vs Decimal(18,2))
- Approve and load 10 rows into VIP_Upsell_Target_J, then verify persistence
- Run manual test in Journey Builder with 4 test contacts from John_Mike_Bio_Split_Test
- Replace sample@example.com addresses in John_Mike_JB_Test with controlled test addresses
- Publish John_Mike_JB_Test journey after routing confirmed
- Resolve testOrchestrateMap error from previous automation run
- Confirm: load Cart_Abandonment_Target_J or keep cancelled

**Decisions**
- Raw_Transactions_J Amount field remains Text(50) — staging table design confirmed
- Staging_Active_Subscribers_J includes all 10 contacts (BDAY-0001 to BDAY-0010) including inactive ones for filtering validation
- VIP_Upsell_Target_J test data uses whole numbers; TotalSpent scale decision deferred to separate change

**Blockers**
- OrderAmount field scale (0) in Purchase_History_J cannot store decimal values — decision pending on schema change

**Next**
- Approve load of 10 rows into VIP_Upsell_Target_J
- Verify all 10 rows persisted with correct TotalSpent and PrimaryStore values
- Decide OrderAmount scale change for Purchase_History_J

**Checked live on 2026-10-12:** the Salesforce org
### Last session — 2026-10-12
| | |
|---|---|
| Type | BUILD |
| Outcome | COMPLETED |
| Branch | `orchestrate/context` |
| Session | `130de6ce-20be-4646-896c-78e5de6e72f4` |
**In its own words (excerpt):**
I found **VIP_Upsell_Target_J**. It has 3 fields, all required, and no rows yet:

- **SubscriberKey**: Text(50), primary key, so each contact can appear only once
- **TotalSpent**: Decimal(18, **0**)
- **PrimaryStore**: Text(50)

**TotalSpent has a scale of 0, so it can't store cents.** OrderAmount in Purchase_History_J has the same setting. I've used whole numbers below so nothing gets rounded when it saves. If you want this field to hold real money values, I can change it to Decimal(18,2) as a separate change, after you confirm.

**The 10 rows I'd load.** The primary key means I need 10 different contacts, so I've used BDAY-0001 to BDAY-0010 to keep the joins with your other test data working. The store names match the ones in Raw_Transactions_J. The totals are made up at VIP-level amounts. They don't add up from Raw_Transactions_J, because those amounts are too small to look like VIP spend. Two contacts are under 1,000, so a spend-threshold filter has rows to drop.

| SubscriberKey | TotalSpent | PrimaryStore |
|---|---|---|
| BDAY-0001 | 1250 | Online |
| BDAY-0002 | 2480 | Downtown |
| BDAY-0003 | 980 | Northgate Mall |
| BDAY-0004 | 1520 | Downtown |
| BDAY-0005 | 3200 | Airp

_[summary truncated — see the session record for the full text]_
<!-- orchestrate:session-state:end -->
