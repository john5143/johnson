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
**Status:** on track — Cart_Abandonment_Target_J loaded with 10 test rows; all three data extensions now aligned. Ready for Journey Builder manual test.

**Done this session**
- Bulk upsert 10 rows into Cart_Abandonment_Target_J (BDAY-0001 to BDAY-0010)
- Verified all 10 rows landed with correct AbandonDate values and whole-number CartTotal amounts
- Confirmed Cart_Abandonment_Target_J schema matches Cart_Abandonment_J (SubscriberKey, AbandonDate, CartTotal)

**Open items**
- Run manual test in Journey Builder with 4 test contacts from John_Mike_Bio_Split_Test, verify routing matches expected paths
- Replace four *.sample@example.com test addresses in John_Mike_JB_Test with controlled addresses before publishing
- Publish John_Mike_JB_Test journey after test confirms routing
- Run entry source automation to test actual contact routing through journey
- Resolve testOrchestrateMap error from previous automation run
- Make Birthday_Campaign_Target_J sendable (link SubscriberKey to Subscriber Key) if using as journey entry source
- Make Cart_Abandonment_Target_J sendable if using as journey entry source or send audience

**Decisions**
- Entry source: DEAudience-John_Mike_JB_Test-20261009 from John_Mike_Bio_Split_Test, no schedule
- Bio_Check condition 1: IsNotNull operator
- Bio_Check condition 2: NotEqual 'No Biography is Available here.'
- Test method: manual in Journey Builder UI only (no API endpoint exists)
- Test email sending: leave unticked to avoid delivery to sample addresses
- Campaign_Send_Log_J sample rows: 10 rows with SubscriberKeys BDAY-0001 through BDAY-0010
- Cart_Abandonment_J test data: 10 rows, whole-dollar amounts only (CartTotal scale is 0, no cents)
- Cart_Abandonment_Target_J test data: same 10 rows as Cart_Abandonment_J for consistency

**Blockers**
- None

**Next**
- Open John_Mike_JB_Test in Journey Builder and run manual test with 4 contacts from John_Mike_Bio_Split_Test
- Verify routing matches expected paths based on Bio_Check conditions
- Replace sample@example.com test addresses with controlled addresses
- Publish journey after test confirms routing

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

- **SubscriberKey**: Text(50), primary key
- **AbandonDate**: Date
- **CartTotal**: Decimal, scale 0 (whole numbers only, the same as Cart_Abandonment_J)

**Planned rows.** SubscriberKey is the primary key, so each contact can only appear once. I've used the same 10 contacts (BDAY-0001 to BDAY-0010) with the same dates and totals as Cart_Abandonment_J. That makes this data extension look like the output of a targeting query over that one, which keeps your test data consistent:

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

**Tool call:** one bulk upsert of these 10 rows into Cart_Abandonment_Target_J. Afterwards I'll read the data extension back to check that all 10 rows landed with real Date values and whole-number totals. This only writes data and doesn't s

_[summary truncated — see the session record for the full text]_
<!-- orchestrate:session-state:end -->
