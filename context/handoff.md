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
**Status:** on track — Purchase_History_J schema reviewed; 10 test rows ready to load. OrderAmount scale (0) flagged for confirmation.

**Done this session**
- Reviewed Purchase_History_J schema: 4 required fields, 0 rows
- Identified OrderAmount Decimal(18,0) scale limitation — cannot store cents
- Planned 10 purchase rows aligned with existing BDAY- contacts for join testing

**Open items**
- Confirm whether OrderAmount scale should be changed to Decimal(18,2) before load
- Load 10 rows into Purchase_History_J via bulk upsert (pending schema confirmation)
- Verify all 10 rows persisted with correct PurchaseDate as real dates
- Run manual test in Journey Builder with 4 test contacts from John_Mike_Bio_Split_Test
- Replace sample@example.com addresses in John_Mike_JB_Test with controlled test addresses
- Publish John_Mike_JB_Test journey after routing confirmed
- Resolve testOrchestrateMap error from previous automation run

**Decisions**
- Master_Subscribers_J: 10 rows (BDAY-0001 to BDAY-0010) with mixed Status values
- Inactive_Purge_Target_J: 10 rows with separate PURGE- keys
- Platform_Interactions_J: 10 rows (INT-0001 to INT-0010) loaded and verified
- Purchase_History_J test data: 10 rows (PUR-0001 to PUR-0010) using same BDAY- keys for join alignment
- Entry source: DEAudience-John_Mike_JB_Test-20261009 from John_Mike_Bio_Split_Test, no schedule
- Bio_Check condition 1: IsNotNull; condition 2: NotEqual 'No Biography is Available here.'

**Blockers**
- OrderAmount field scale (0) cannot store decimal values — confirm fix before loading Purchase_History_J

**Next**
- Confirm OrderAmount schema change to Decimal(18,2) or proceed with whole-number amounts only
- Load 10 purchase rows into Purchase_History_J and verify persistence and date formatting
- Run manual journey test with 4 contacts from John_Mike_Bio_Split_Test

**Checked live on 2026-10-12:** the Salesforce org
### Last session — 2026-10-12
| | |
|---|---|
| Type | BUILD |
| Outcome | COMPLETED |
| Branch | `orchestrate/context` |
| Session | `130de6ce-20be-4646-896c-78e5de6e72f4` |
**In its own words (excerpt):**
I found **Purchase_History_J**. It has 4 fields, all required, and 0 rows right now:

- **PurchaseID**: Text(50), primary key
- **SubscriberKey**: Text(50). It isn't a key here, so one contact can have several purchases.
- **PurchaseDate**: Date
- **OrderAmount**: Decimal(18, **0**)

**Something to check before loading: OrderAmount has a scale of 0.** That means it can't store cents. A value like 49.99 would be saved as 50 or 49, or might be rejected. I've used whole-number amounts below so nothing gets changed on the way in. If this field is meant to hold real prices, it probably needs a scale of 2, for example Decimal(18,2). Tell me if you'd like that fixed first. It's a schema change that can't be automatically undone, so I'd confirm it with you separately.

**Planned rows.** These use the same BDAY- contacts as your other test data extensions, so the joins still line up. BDAY-0001 and BDAY-0005 each have two purchases, so you can test totals and "latest purchase" logic per contact. BDAY-0004 and BDAY-0008 (the unsubscribed contacts) are left out. Two purchases fall outside a 30-day window, which gives a date filter something to exclude.

| PurchaseID | SubscriberKey | PurchaseD

_[summary truncated — see the session record for the full text]_
<!-- orchestrate:session-state:end -->
