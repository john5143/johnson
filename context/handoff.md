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
**Status:** on track — Platform_Interactions_J loaded & verified with 10 rows. All date fields saved correctly. Ready for journey testing.

**Done this session**
- Loaded 10 interaction rows into Platform_Interactions_J via bulk upsert
- Verified all 10 rows persisted with correct InteractionDate values as real dates
- Confirmed repeat contacts (BDAY-0001, BDAY-0006) for testing deduplication logic

**Open items**
- Run manual test in Journey Builder with 4 test contacts from John_Mike_Bio_Split_Test
- Replace sample@example.com addresses in John_Mike_JB_Test with controlled test addresses
- Publish John_Mike_JB_Test journey after routing confirmed
- Run entry source automation to test actual contact routing through journey
- Resolve testOrchestrateMap error from previous automation run
- Make Birthday_Campaign_Target_J sendable if using as journey entry source
- Make Cart_Abandonment_Target_J sendable if using as journey entry source or send audience

**Decisions**
- Master_Subscribers_J test data: 10 rows (BDAY-0001 to BDAY-0010) with mixed Status values
- Inactive_Purge_Target_J test data: 10 rows with separate PURGE- keys
- Platform_Interactions_J test data: 10 rows (INT-0001 to INT-0010) using same BDAY- keys for join alignment
- Entry source: DEAudience-John_Mike_JB_Test-20261009 from John_Mike_Bio_Split_Test, no schedule
- Bio_Check condition 1: IsNotNull; condition 2: NotEqual 'No Biography is Available here.'
- 30-day filter excludes only INT-0008 (2026-08-20); 21-day filter excludes INT-0008 and INT-0004

**Blockers**
- None

**Next**
- Run manual test in Journey Builder with 4 test contacts from John_Mike_Bio_Split_Test
- Verify journey entry and routing logic with Platform_Interactions_J join data
- Replace sample@example.com test addresses before publishing journey

**Checked live on 2026-10-12:** the Salesforce org
### Last session — 2026-10-12
| | |
|---|---|
| Type | BUILD |
| Outcome | COMPLETED |
| Branch | `orchestrate/context` |
| Session | `130de6ce-20be-4646-896c-78e5de6e72f4` |
**In its own words (excerpt):**
I loaded all 10 sample rows into **Platform_Interactions_J**. It had 0 rows before, and when I read it back it had 10.

| InteractionID | SubscriberKey | InteractionType | InteractionDate |
|---|---|---|---|
| INT-0001 | BDAY-0001 | EmailOpen | 2026-10-01 |
| INT-0002 | BDAY-0001 | EmailClick | 2026-10-02 |
| INT-0003 | BDAY-0002 | WebVisit | 2026-10-03 |
| INT-0004 | BDAY-0003 | AppLogin | 2026-09-15 |
| INT-0005 | BDAY-0005 | Purchase | 2026-10-05 |
| INT-0006 | BDAY-0006 | WebVisit | 2026-10-06 |
| INT-0007 | BDAY-0006 | AddToCart | 2026-10-06 |
| INT-0008 | BDAY-0007 | EmailOpen | 2026-08-20 |
| INT-0009 | BDAY-0009 | AppLogin | 2026-10-08 |
| INT-0010 | BDAY-0010 | EmailClick | 2026-10-09 |

- **The rows match the plan.** InteractionDate was saved as a real date, which Marketing Cloud shows as midnight on each day (for example "10/1/2026 12:00:00 AM").
- **Correction to what I said in the plan.** I said BDAY-0003 and BDAY-0007 both had dates old enough to fall outside a "last 30 days" filter. That's only true for BDAY-0007 (2026-08-20). BDAY-0003's date, 2026-09-15, was 27 days ago, so it's still inside 30 days. With today's date (2026-10-12), a 30-day filter excludes only INT

_[summary truncated — see the session record for the full text]_
<!-- orchestrate:session-state:end -->
