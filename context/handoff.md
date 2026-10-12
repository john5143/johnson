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
**Status:** on track — Loyalty_Members_J populated with 10 test rows; all four data extensions aligned and ready for Journey Builder test.

**Done this session**
- Bulk upsert 10 rows into Loyalty_Members_J (BDAY-0001 to BDAY-0010)
- Verified all 10 rows landed with correct BirthDate values and OptInStatus booleans
- Confirmed test cases in place: 6 October birthdays, 4 opted-in October birthdays for filtering

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
**Loyalty_Members_J** now has all 10 sample rows. It had 0 rows before the load, and when I read it back afterwards it had 10.

| SubscriberKey | EmailAddress | BirthDate | LoyaltyTier | OptInStatus |
|---|---|---|---|---|
| BDAY-0001 | ava.sample@example.com | 1990-10-14 | Gold | True |
| BDAY-0002 | liam.sample@example.com | 1985-10-22 | Silver | True |
| BDAY-0003 | mia.sample@example.com | 1998-03-05 | Bronze | True |
| BDAY-0004 | noah.sample@example.com | 1979-10-09 | Platinum | False |
| BDAY-0005 | zoe.sample@example.com | 1993-07-18 | Gold | True |
| BDAY-0006 | ethan.sample@example.com | 2001-10-30 | Silver | True |
| BDAY-0007 | isla.sample@example.com | 1988-12-01 | Bronze | True |
| BDAY-0008 | lucas.sample@example.com | 1995-10-17 | Platinum | False |
| BDAY-0009 | ruby.sample@example.com | 1982-05-26 | Gold | True |
| BDAY-0010 | owen.sample@example.com | 1999-10-03 | Silver | True |

- **Values match the plan.** BirthDate was saved as a real date, shown as midnight on each day (for example "10/14/1990 12:00:00 AM"). OptInStatus was saved as True/False values.
- **The test cases are in place.** Six members have October birthdays (BDAY-0001, 0002, 0004, 0006, 0008 and

_[summary truncated — see the session record for the full text]_
<!-- orchestrate:session-state:end -->
