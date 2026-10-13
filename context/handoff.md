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
**Status:** on track — Engagement Split added to Has Bio path; wait shortened to 2 days. Canvas & next steps after split paths need confirmation.

**Done this session**
- Added Engagement Split (Opened_Welcome_Check) to Has Bio path in John_Mike_JB_Test
- Confirmed journey validates with 0 errors, 0 warnings
- Verified split checks opens of Send Welcome Email within 2-day window
- Confirmed split format copied from editor-built example in tenant

**Open items**
- Decide OrderAmount scale for Purchase_History_J (Decimal(18,0) vs Decimal(18,2))
- Replace sample@example.com addresses in John_Mike_JB_Test with controlled test addresses
- Define what step follows Opened path on Engagement Split (currently ends journey)
- Define what step follows Not Opened path on Engagement Split (currently ends journey)
- Confirm Has Bio wait should be 2 days total or restore to 3 days + add 1-day wait after split
- Open John_Mike_JB_Test in Journey Builder canvas and visually confirm split on Has Bio branch
- Run manual test in Journey Builder with 4 test contacts from John_Mike_Bio_Split_Test
- Publish John_Mike_JB_Test after routing confirmed and addresses replaced

**Decisions**
- Raw_Transactions_J Amount field remains Text(50)
- Staging_Active_Subscribers_J includes all 10 contacts (BDAY-0001 to BDAY-0010)
- VIP_Upsell_Target_J 10-row load approved
- Cart_Abandonment_Target_J loaded with all 10 rows
- Engagement Split added to Has Bio path; wait set to 2 days for open window

**Blockers**
- OrderAmount field scale (0) in Purchase_History_J cannot store decimal values — decision pending

**Next**
- Confirm whether 2-day wait on Has Bio is final or if 3-day total hold is still required
- Define follow-up action for Opened path (e.g., end journey or send next email)
- Define follow-up action for Not Opened path (e.g., send reminder email or end journey)
- Open journey in Journey Builder and visually confirm Engagement Split appears on Has Bio branch
- Replace four *.sample@example.com test addresses with controlled addresses before publish

**Checked live on 2026-10-13:** the Salesforce org
### Last session — 2026-10-13
| | |
|---|---|
| Type | BUILD |
| Outcome | COMPLETED |
| Branch | `orchestrate/context` |
| Session | `01fb15ac-1085-4a83-a04a-d398ce9717b9` |
**In its own words (excerpt):**
I added the Engagement Split to the **Has Bio** path, and **John_Mike_JB_Test passes validation with 0 errors and 0 warnings.** It's still **Draft**: it has never been published, 0 contacts have entered it, and nothing was sent. I read the saved definition back separately to confirm it.

**One change you should check: the Has Bio wait is now 2 days instead of 3.** An Engagement Split checks for an open at the moment a contact reaches it, so the wait in front of it sets the window. A 2-day window on Has Bio meant shortening the 3-day wait you asked for earlier. If you still want contacts held 3 days in total, I can add a 1-day wait after the split.

**The journey now runs like this:**

```
Entry source → Send Welcome Email → Bio_Check
                                      ├─ Has Bio   → Wait 2 Days → Opened_Welcome_Check
                                      │                              ├─ Opened     → end
                                      │                              └─ Not Opened → end
                                      └─ Remainder → end
```

| Item | Saved value |
|---|---|
| New split | `ENGAGEMENTDECISION-1`, named "Opened_Welcome_Check" |
| What it checks | Opens (

_[summary truncated — see the session record for the full text]_
<!-- orchestrate:session-state:end -->
