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
**Status:** on track — John_Mike_JB_Test ready for manual test; Birthday_Campaign_Target_J populated with 10 sample rows

**Done this session**
- Loaded 10 sample rows into Birthday_Campaign_Target_J data extension
- Verified all rows match planned values: SubscriberKey, EmailAddress, LoyaltyTier, CouponCode

**Open items**
- Run manual test in Journey Builder with 4 test contacts from John_Mike_Bio_Split_Test, verify routing matches expected paths
- Replace four *.sample@example.com test addresses in John_Mike_JB_Test with controlled addresses before publishing
- Publish John_Mike_JB_Test journey after test confirms routing
- Run entry source automation to test actual contact routing through journey
- Resolve testOrchestrateMap error from previous automation run
- Make Birthday_Campaign_Target_J sendable (link SubscriberKey to Subscriber Key) if using as journey entry source or send audience

**Decisions**
- Entry source: DEAudience-John_Mike_JB_Test-20261009 from John_Mike_Bio_Split_Test, no schedule
- Bio_Check condition 1: IsNotNull operator
- Bio_Check condition 2: NotEqual 'No Biography is Available here.'
- Test method: manual in Journey Builder UI only (no API endpoint exists)
- Test email sending: leave unticked to avoid delivery to sample addresses

**Blockers**
- None

**Next**
- Open John_Mike_JB_Test in Journey Builder and select Test button
- Run manual test with all 4 contacts from John_Mike_Bio_Split_Test, verify routing (JMC-0001, JMC-0002 → Has Bio; JMC-0003, JMC-0005 → Remainder)
- Replace sample@example.com addresses in John_Mike_JB_Test with controlled test addresses
- Publish journey after test confirms expected routing

**Checked live on 2026-10-12:** the Salesforce org
### Last session — 2026-10-12
| | |
|---|---|
| Type | BUILD |
| Outcome | COMPLETED |
| Branch | `orchestrate/context` |
| Session | `130de6ce-20be-4646-896c-78e5de6e72f4` |
**In its own words (excerpt):**
All 10 sample rows are now in **Birthday_Campaign_Target_J**. I read the data extension back afterwards to check: it had 0 rows before and now has 10.

| SubscriberKey | EmailAddress | LoyaltyTier | CouponCode |
|---|---|---|---|
| BDAY-0001 | ava.sample@example.com | Gold | BDAY-GOLD-7Q2K |
| BDAY-0002 | liam.sample@example.com | Silver | BDAY-SILV-3M8T |
| BDAY-0003 | mia.sample@example.com | Bronze | BDAY-BRNZ-9X4D |
| BDAY-0004 | noah.sample@example.com | Platinum | BDAY-PLAT-2H6R |
| BDAY-0005 | zoe.sample@example.com | Gold | BDAY-GOLD-5V1N |
| BDAY-0006 | ethan.sample@example.com | Silver | BDAY-SILV-8C3W |
| BDAY-0007 | isla.sample@example.com | Bronze | BDAY-BRNZ-4J7P |
| BDAY-0008 | lucas.sample@example.com | Platinum | BDAY-PLAT-6F9L |
| BDAY-0009 | ruby.sample@example.com | Gold | BDAY-GOLD-1T5B |
| BDAY-0010 | owen.sample@example.com | Silver | BDAY-SILV-0K2Z |

- **Values:** each row has exactly the values from the plan, matched to the four fields: SubscriberKey (the primary key), EmailAddress, LoyaltyTier and CouponCode.
- **Can't be sent to as it is:** the data extension isn't set up for sending, and every address uses the reserved example.com domain, which can't re

_[summary truncated — see the session record for the full text]_
<!-- orchestrate:session-state:end -->
