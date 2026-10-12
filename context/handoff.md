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
**Status:** on track — Staging_Active_Subscribers_J loaded with 10 test rows verified. OrderAmount scale decision & Journey Builder manual test remain open.

**Done this session**
- Loaded all 10 rows into Staging_Active_Subscribers_J (BDAY-0001 to BDAY-0010)
- Verified all rows persisted with correct LastInteractionDate values
- Confirmed dates match Platform_Interactions_J for 8 contacts with interactions
- Validated filtering logic: 30-day filter removes 3 rows, Active join removes 4 rows

**Open items**
- Decide: OrderAmount scale change for Purchase_History_J (Decimal(18,0) vs Decimal(18,2))
- Run manual test in Journey Builder with 4 test contacts from John_Mike_Bio_Split_Test
- Replace sample@example.com addresses in John_Mike_JB_Test with controlled test addresses
- Publish John_Mike_JB_Test journey after routing confirmed
- Resolve testOrchestrateMap error from previous automation run
- Load Cart_Abandonment_Target_J (previously cancelled — confirm if proceeding)

**Decisions**
- Raw_Transactions_J Amount field remains Text(50) — staging table design confirmed
- Staging_Active_Subscribers_J includes all 10 contacts (BDAY-0001 to BDAY-0010) including inactive ones for filtering validation
- All previous decisions from 2026-10-12 remain in effect

**Blockers**
- OrderAmount field scale (0) in Purchase_History_J cannot store decimal values — decision pending on schema change

**Next**
- Decide OrderAmount scale change for Purchase_History_J
- Run manual test in Journey Builder with John_Mike_Bio_Split_Test contacts
- Replace sample@example.com addresses in John_Mike_JB_Test
- Publish John_Mike_JB_Test journey

**Checked live on 2026-10-12:** the Salesforce org
### Last session — 2026-10-12
| | |
|---|---|
| Type | BUILD |
| Outcome | COMPLETED |
| Branch | `orchestrate/context` |
| Session | `130de6ce-20be-4646-896c-78e5de6e72f4` |
**In its own words (excerpt):**
I loaded all 10 sample rows into **Staging_Active_Subscribers_J**. It had 0 rows before, and when I read it back it had 10.

| SubscriberKey | LastInteractionDate |
|---|---|
| BDAY-0001 | 2026-10-02 |
| BDAY-0002 | 2026-10-03 |
| BDAY-0003 | 2026-09-15 |
| BDAY-0004 | 2026-06-30 |
| BDAY-0005 | 2026-10-05 |
| BDAY-0006 | 2026-10-06 |
| BDAY-0007 | 2026-08-20 |
| BDAY-0008 | 2026-05-14 |
| BDAY-0009 | 2026-10-08 |
| BDAY-0010 | 2026-10-09 |

- **All 10 rows match the plan.** LastInteractionDate was saved as a real date. Marketing Cloud shows each one as midnight on that day, for example "10/2/2026 12:00:00 AM".
- **The dates agree with Platform_Interactions_J.** For the 8 contacts that have interactions, the date here is their latest interaction date there.
- **Two filters you can test:**
  - A "last 30 days" filter (2026-09-12 onward) removes BDAY-0004, BDAY-0007 and BDAY-0008.
  - A filter that keeps only Active subscribers, by joining to Master_Subscribers_J, removes BDAY-0003, BDAY-0004, BDAY-0007 and BDAY-0008.
- **No email was sent.** I only wrote rows to this data extension.

**Test data so far:** 11 data extensions now have 10 rows each: Birthday_Campaign_Target_J, Campaign

_[summary truncated — see the session record for the full text]_
<!-- orchestrate:session-state:end -->
