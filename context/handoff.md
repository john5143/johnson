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
### Engagement state — 2026-10-13
**Status:** on track — Wait 3 Days added to Has Bio path, journey validates. Ready for test run after address swap.

**Done this session**
- Added WAIT-1 (3 Days) to Has Bio outcome in John_Mike_JB_Test
- Confirmed journey validates: 0 errors, 1 warning (long wait advice only)
- Verified saved definition matches intent: Has Bio → Wait 3 Days → end

**Open items**
- Decide OrderAmount scale for Purchase_History_J (Decimal(18,0) vs Decimal(18,2))
- Replace sample@example.com addresses in John_Mike_JB_Test with controlled test addresses
- Run manual test in Journey Builder with 4 test contacts from John_Mike_Bio_Split_Test
- Define what step follows the 3-day wait on Has Bio path (currently ends journey)
- Publish John_Mike_JB_Test journey after routing confirmed and addresses replaced
- Resolve testOrchestrateMap error from previous automation run
- Confirm schema change to Decimal(18,2) for CartTotal, TotalSpent, OrderAmount if real money values needed

**Decisions**
- Raw_Transactions_J Amount field remains Text(50) — staging table design confirmed
- Staging_Active_Subscribers_J includes all 10 contacts (BDAY-0001 to BDAY-0010) for filtering validation
- VIP_Upsell_Target_J 10-row load approved and completed
- Cart_Abandonment_Target_J loaded with all 10 rows (all contacts, not Active-only subset)
- 3-day wait added to Has Bio path; can reduce to minutes for testing if needed

**Blockers**
- OrderAmount field scale (0) in Purchase_History_J cannot store decimal values — decision pending on schema change

**Next**
- Replace four *.sample@example.com test addresses in John_Mike_JB_Test with controlled addresses
- Define next step after 3-day wait on Has Bio path (currently journey ends)
- Run manual Journey Builder test with 4 test contacts from John_Mike_Bio_Split_Test
- Decide: convert CartTotal, TotalSpent, OrderAmount to Decimal(18,2) for real money values or keep as Decimal(18,0)

**Checked live on 2026-10-13:** the Salesforce org
### Last session — 2026-10-13
| | |
|---|---|
| Type | BUILD |
| Outcome | COMPLETED |
| Branch | `orchestrate/context` |
| Session | `01fb15ac-1085-4a83-a04a-d398ce9717b9` |
**In its own words (excerpt):**
I added the 3-day Wait to the **Has Bio** path and the journey still passes validation. There are no errors and one warning, explained below. **John_Mike_JB_Test is still Draft**: it has never been published, 0 contacts have entered it, and nothing was sent. I didn't change the entry source, the email or the test data.

**The journey now runs like this** (I read the saved definition back separately to confirm it):

```
Entry source → Send Welcome Email → Bio_Check
                                      ├─ Has Bio   → Wait 3 Days → end
                                      └─ Remainder → end
```

| Item | Saved value |
|---|---|
| New activity | `WAIT-1`, named "Wait 3 Days", type `WAIT` |
| Duration | `waitDuration: 3`, `waitUnit: DAYS` (a fixed wait, not wait-until-date) |
| Has Bio outcome | Now points to `WAIT-1`. Before, it ended the journey. |
| Remainder outcome | Unchanged. It still ends the journey. |
| Bio_Check conditions | Unchanged (`IsNotNull` + `NotEqual`) |
| Send Welcome Email | Unchanged: email 10606, same subject, profiles and publication list 1115 |

**Validation:** it completed with 0 errors and 1 warning:
> `121547`: "The journey has a long wait (3 days), please

_[summary truncated — see the session record for the full text]_
<!-- orchestrate:session-state:end -->
