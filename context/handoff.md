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
**Status:** on track — Staging_Active_Subscribers_J identified & ready to load: 10 test rows planned, includes inactive contacts for filtering validation

**Done this session**
- Located Staging_Active_Subscribers_J in Salesforce org
- Confirmed schema: SubscriberKey (Text 50, PK) + LastInteractionDate (Date), 0 rows current
- Planned 10 test rows with dates from Platform_Interactions_J or synthetic older dates

**Open items**
- Load & verify 10 rows into Staging_Active_Subscribers_J (bulk upsert pending approval)
- Decide: OrderAmount scale change for Purchase_History_J (Decimal(18,0) vs Decimal(18,2))
- Run manual test in Journey Builder with 4 test contacts from John_Mike_Bio_Split_Test
- Replace sample@example.com addresses in John_Mike_JB_Test with controlled test addresses
- Publish John_Mike_JB_Test journey after routing confirmed
- Resolve testOrchestrateMap error from previous automation run

**Decisions**
- Raw_Transactions_J Amount field remains Text(50) — staging table design confirmed
- Staging_Active_Subscribers_J will include all 10 contacts (BDAY-0001 to BDAY-0010) including inactive ones for filtering validation
- All previous decisions from 2026-10-12 remain in effect

**Blockers**
- OrderAmount field scale (0) in Purchase_History_J cannot store decimal values — decision pending on schema change

**Next**
- Approve & execute bulk upsert of 10 rows into Staging_Active_Subscribers_J
- Verify all 10 rows persisted with correct LastInteractionDate values
- Decide OrderAmount scale change for Purchase_History_J
- Proceed to Journey Builder manual test with John_Mike_Bio_Split_Test contacts

**Checked live on 2026-10-12:** the Salesforce org
### Last session — 2026-10-12
| | |
|---|---|
| Type | BUILD |
| Outcome | COMPLETED |
| Branch | `orchestrate/context` |
| Session | `130de6ce-20be-4646-896c-78e5de6e72f4` |
**In its own words (excerpt):**
I found **Staging_Active_Subscribers_J**. It has 2 fields, both required, and 0 rows right now:

- **SubscriberKey**: Text(50), primary key, so each contact can appear only once
- **LastInteractionDate**: Date

**The rows I'd load.** Because SubscriberKey is the primary key, I need 10 different contacts. I've used BDAY-0001 to BDAY-0010 so joins with your other test data extensions still work. For the 8 contacts that have rows in Platform_Interactions_J, LastInteractionDate is their latest interaction date there, so the two data extensions agree. BDAY-0004 and BDAY-0008 have no interactions, so I gave them older dates.

| SubscriberKey | LastInteractionDate | Source of date |
|---|---|---|
| BDAY-0001 | 2026-10-02 | latest in Platform_Interactions_J |
| BDAY-0002 | 2026-10-03 | latest in Platform_Interactions_J |
| BDAY-0003 | 2026-09-15 | latest in Platform_Interactions_J |
| BDAY-0004 | 2026-06-30 | made up (older) |
| BDAY-0005 | 2026-10-05 | latest in Platform_Interactions_J |
| BDAY-0006 | 2026-10-06 | latest in Platform_Interactions_J |
| BDAY-0007 | 2026-08-20 | latest in Platform_Interactions_J |
| BDAY-0008 | 2026-05-14 | made up (older) |
| BDAY-0009 | 2026-10-08 | latest

_[summary truncated — see the session record for the full text]_
<!-- orchestrate:session-state:end -->
