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
**Status:** on track — Cart_Abandonment_J discovered & ready for load; 10 test rows planned, SubscriberKeys match existing contacts

**Done this session**
- Located Cart_Abandonment_J in Salesforce org
- Verified schema: CartID (PK), SubscriberKey, AbandonDate, CartTotal (Decimal, scale 0)
- Planned 10 test rows with whole-dollar amounts, all SubscriberKeys match Birthday_Campaign_Target_J & Campaign_Send_Log_J

**Open items**
- Bulk upsert 10 rows into Cart_Abandonment_J and verify all landed with correct dates and totals
- Run manual test in Journey Builder with 4 test contacts from John_Mike_Bio_Split_Test, verify routing matches expected paths
- Replace four *.sample@example.com test addresses in John_Mike_JB_Test with controlled addresses before publishing
- Publish John_Mike_JB_Test journey after test confirms routing
- Run entry source automation to test actual contact routing through journey
- Resolve testOrchestrateMap error from previous automation run
- Make Birthday_Campaign_Target_J sendable (link SubscriberKey to Subscriber Key) if using as journey entry source

**Decisions**
- Entry source: DEAudience-John_Mike_JB_Test-20261009 from John_Mike_Bio_Split_Test, no schedule
- Bio_Check condition 1: IsNotNull operator
- Bio_Check condition 2: NotEqual 'No Biography is Available here.'
- Test method: manual in Journey Builder UI only (no API endpoint exists)
- Test email sending: leave unticked to avoid delivery to sample addresses
- Campaign_Send_Log_J sample rows: 10 rows with SubscriberKeys BDAY-0001 through BDAY-0010
- Cart_Abandonment_J test data: 10 rows, whole-dollar amounts only (CartTotal scale is 0, no cents)

**Blockers**
- None

**Next**
- Proceed with bulk upsert of 10 Cart_Abandonment_J rows (CART-0001 through CART-0010)
- Read Cart_Abandonment_J back to verify all 10 rows landed with real Date values and whole-number totals
- Open John_Mike_JB_Test in Journey Builder and run manual test with 4 contacts from John_Mike_Bio_Split_Test

**Checked live on 2026-10-12:** the Salesforce org
### Last session — 2026-10-12
| | |
|---|---|
| Type | BUILD |
| Outcome | COMPLETED |
| Branch | `orchestrate/context` |
| Session | `130de6ce-20be-4646-896c-78e5de6e72f4` |
**In its own words (excerpt):**
I found **Cart_Abandonment_J**. It has 4 fields, all required, and currently 0 rows:

- **CartID**: Text(50), primary key
- **SubscriberKey**: Text(50)
- **AbandonDate**: Date
- **CartTotal**: Decimal, with **scale 0**

**About CartTotal:** it's set up with no decimal places, so it can't hold cents. A value like 129.99 would be rounded or rejected. I've used whole-dollar amounts below. If you need cents, the field's scale has to be changed to 2 first. That's a separate change and I'd ask you before making it.

**Planned rows.** The SubscriberKeys match the contacts already in Birthday_Campaign_Target_J and Campaign_Send_Log_J, so all three data extensions join up:

| CartID | SubscriberKey | AbandonDate | CartTotal |
|---|---|---|---|
| CART-0001 | BDAY-0001 | 2026-10-01 | 129 |
| CART-0002 | BDAY-0002 | 2026-10-02 | 45 |
| CART-0003 | BDAY-0003 | 2026-10-03 | 310 |
| CART-0004 | BDAY-0004 | 2026-10-04 | 78 |
| CART-0005 | BDAY-0005 | 2026-10-05 | 560 |
| CART-0006 | BDAY-0006 | 2026-10-06 | 22 |
| CART-0007 | BDAY-0007 | 2026-10-07 | 199 |
| CART-0008 | BDAY-0008 | 2026-10-08 | 87 |
| CART-0009 | BDAY-0009 | 2026-10-09 | 415 |
| CART-0010 | BDAY-0010 | 2026-10-10 | 64 |

**Tool ca

_[summary truncated — see the session record for the full text]_
<!-- orchestrate:session-state:end -->
