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
**Status:** on track — Purchase_History_J loaded with 10 rows; OrderAmount scale (0) remains unfixed but whole-number test data persisted correctly.

**Done this session**
- Loaded 10 purchase rows into Purchase_History_J (PUR-0001 to PUR-0010)
- Verified all 10 rows persisted with correct PurchaseDate as real dates
- Confirmed date-window logic: 30-day filter excludes only PUR-0004 and PUR-0008
- Validated multi-purchase contacts: BDAY-0001 (2 purchases, total 165) and BDAY-0005 (2 purchases, total 385)

**Open items**
- Confirm whether OrderAmount scale should be changed to Decimal(18,2) before further use
- Run manual test in Journey Builder with 4 test contacts from John_Mike_Bio_Split_Test
- Replace sample@example.com addresses in John_Mike_JB_Test with controlled test addresses
- Publish John_Mike_JB_Test journey after routing confirmed
- Resolve testOrchestrateMap error from previous automation run

**Decisions**
- Master_Subscribers_J: 10 rows (BDAY-0001 to BDAY-0010) with mixed Status values
- Inactive_Purge_Target_J: 10 rows with separate PURGE- keys
- Platform_Interactions_J: 10 rows (INT-0001 to INT-0010) loaded and verified
- Purchase_History_J: 10 rows (PUR-0001 to PUR-0010) using BDAY- keys for join alignment
- Entry source: DEAudience-John_Mike_JB_Test-20261009 from John_Mike_Bio_Split_Test, no schedule
- Bio_Check condition 1: IsNotNull; condition 2: NotEqual 'No Biography is Available here.'

**Blockers**
- OrderAmount field scale (0) cannot store decimal values — decision pending on whether to change to Decimal(18,2)

**Next**
- Decide: keep OrderAmount as Decimal(18,0) for whole numbers only, or change schema to Decimal(18,2)
- Run manual journey test with 4 contacts from John_Mike_Bio_Split_Test
- Update test email addresses in John_Mike_JB_Test and publish journey

**Checked live on 2026-10-12:** the Salesforce org
### Last session — 2026-10-12
| | |
|---|---|
| Type | BUILD |
| Outcome | COMPLETED |
| Branch | `orchestrate/context` |
| Session | `130de6ce-20be-4646-896c-78e5de6e72f4` |
**In its own words (excerpt):**
**Purchase_History_J** now has all 10 sample rows. It had 0 rows before the load, and when I read it back it had 10.

| PurchaseID | SubscriberKey | PurchaseDate | OrderAmount |
|---|---|---|---|
| PUR-0001 | BDAY-0001 | 2026-09-20 | 120 |
| PUR-0002 | BDAY-0001 | 2026-10-04 | 45 |
| PUR-0003 | BDAY-0002 | 2026-10-02 | 89 |
| PUR-0004 | BDAY-0003 | 2026-08-28 | 230 |
| PUR-0005 | BDAY-0005 | 2026-10-05 | 310 |
| PUR-0006 | BDAY-0005 | 2026-10-10 | 75 |
| PUR-0007 | BDAY-0006 | 2026-10-07 | 60 |
| PUR-0008 | BDAY-0007 | 2026-07-15 | 150 |
| PUR-0009 | BDAY-0009 | 2026-10-08 | 499 |
| PUR-0010 | BDAY-0010 | 2026-10-11 | 35 |

- **Every value matches the plan.** PurchaseDate was saved as a real date, shown as midnight on each day (for example "9/20/2026 12:00:00 AM"). OrderAmount came through unchanged because the amounts are all whole numbers.
- **The date-window test works.** As of today (2026-10-12), a 30-day filter goes back to 2026-09-12. That excludes only PUR-0004 and PUR-0008. PUR-0001 (9/20) is still inside the window.
- **Contacts with more than one purchase:** BDAY-0001 has 2 purchases totalling 165, and BDAY-0005 has 2 totalling 385. Use these to test totals and latest-pur

_[summary truncated — see the session record for the full text]_
<!-- orchestrate:session-state:end -->
