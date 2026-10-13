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
**Status:** on track — Random Split added to Opened path; journey validates. Canvas & Not Opened action still pending.

**Done this session**
- Added 50/50 Random Split (Follow-up 50-50 Test) to Opened path
- Routed Variant A (50%) to Follow-up Variant A email (11027)
- Routed Variant B (50%) to Follow-up Variant B email (11028)
- Confirmed John_Mike_JB_Test validates with 0 errors, 0 warnings
- Verified split format copied from JB_Welcome_Series Random Splits

**Open items**
- Replace four *.sample@example.com test addresses with controlled addresses before publish
- Open John_Mike_JB_Test in Journey Builder canvas and visually confirm Random Split and both variant emails on Opened branch
- Define what step follows Not Opened path on Engagement Split (currently ends journey)
- Confirm Has Bio wait should be 2 days total or restore to 3 days + add 1-day wait after split
- Run manual test in Journey Builder with 4 test contacts from John_Mike_Bio_Split_Test
- Add LoyaltyTier field to John_Mike_Bio_Split_Test or confirm fallback text 'Member' is acceptable
- Publish John_Mike_JB_Test after canvas confirmed, addresses replaced, and Not Opened action decided

**Decisions**
- Engagement Split added to Has Bio path; wait set to 2 days for open window
- Random Split (50/50) added to Opened path with Variant A and Variant B emails
- Raw_Transactions_J Amount field remains Text(50)
- Staging_Active_Subscribers_J includes all 10 contacts (BDAY-0001 to BDAY-0010)
- VIP_Upsell_Target_J 10-row load approved
- Cart_Abandonment_Target_J loaded with all 10 rows

**Blockers**
- Canvas visual confirmation not yet done — Random Split appearance on Opened branch unconfirmed
- Test data lacks LoyaltyTier field — emails will show fallback text 'Member' for all contacts

**Next**
- Open John_Mike_JB_Test in Journey Builder and visually confirm Random Split and variant emails on Opened branch
- Decide whether Not Opened path should send reminder email or end journey
- Replace four *.sample@example.com addresses with controlled test addresses
- Confirm Has Bio 2-day wait is final or add 1-day wait after split for 3-day total hold
- Run manual test with 4 test contacts to verify routing through Bio_Check and Engagement Split
- Publish John_Mike_JB_Test once canvas confirmed and addresses replaced

**Checked live on 2026-10-13:** the Salesforce org
### Last session — 2026-10-13
| | |
|---|---|
| Type | BUILD |
| Outcome | COMPLETED |
| Branch | `orchestrate/context` |
| Session | `01fb15ac-1085-4a83-a04a-d398ce9717b9` |
**In its own words (excerpt):**
I added the 50/50 Random Split to the **Opened** path, and **John_Mike_JB_Test passes validation with 0 errors and 0 warnings.** The journey is still **Draft**. It has never been published, 0 contacts have entered it, and nothing was sent. I read the saved definition back separately to confirm all of this.

**The journey now runs like this:**

```
Entry source → Send Welcome Email → Bio_Check
                                      ├─ Has Bio   → Wait 2 Days → Opened_Welcome_Check
                                      │                              ├─ Opened     → Follow-up 50-50 Test
                                      │                              │                ├─ Variant A (50%) → Follow-up Variant A → end
                                      │                              │                └─ Variant B (50%) → Follow-up Variant B → end
                                      │                              └─ Not Opened → end
                                      └─ Remainder → end
```

| Item | Saved value |
|---|---|
| New split | `RANDOMSPLIT-1`, "Follow-up 50-50 Test", with two paths at `percentage: 50` each |
| Variant A path | Goes to `EMAILV2-2` "Follow-up Variant A": e

_[summary truncated — see the session record for the full text]_
<!-- orchestrate:session-state:end -->
