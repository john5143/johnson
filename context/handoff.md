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
### Engagement state — 2026-10-14
**Status:** blocked — Preconditions still fail (no org, wrong branch). Root cause found: LeaveBalanceService user-mode query causes rollup undercount. Ready to f…

**Done this session**
- Identified rollup undercount root cause: user-mode query in with-sharing class limits totals to visible rows only
- Documented fix: move totals query to without-sharing rollup service, run WITH SYSTEM_MODE
- Confirmed LeaveBalanceServiceTest still missing from sprint2-leave-balance at 82456e3

**Open items**
- Write LeaveBalanceServiceTest covering BalanceKey, keyFor(), computeTotals(), getEntitlementSnapshot(), user-visibility undercount case, off switch, handler re-run guard, 20+ bulk records
- Move totals query from LeaveBalanceService into LeaveBalanceRollupService, run WITH SYSTEM_MODE
- Add FOR UPDATE lock to balance records before totalling to prevent concurrent-save overwrites
- Document computeTotals() as read-only for user-facing screens, not for writes
- Validate: sf project deploy validate --source-dir force-app --test-level RunSpecifiedTests --tests LeaveBalanceEngineTest LeaveBalanceServiceTest
- Check org: Employee_Leave__c sharing model and whether Total_Days__c is a formula field
- Confirm business rule: leave crossing year boundary counts entirely against start year
- Connect org orgfarm-232477b490-dev-ed (00DjV000003BVbRUAW) and set sprint2-leave-balance as working branch

**Decisions**
- Deploy permission set from org copy (not GitHub file) to preserve all existing grants
- Precision difference (18 vs 8 digits) deferred; decide before deploying GitHub field file
- Welcome Banner - Image Block created as reusable block (34027), linked not copied
- Engagement Split added to Has Bio path; wait set to 2 days for open window
- Random Split (50/50) added to Opened path with Variant A and Variant B emails
- Welcome Email subject uses %%FirstName%% with no fallback; greeting inside has fallback 'Hi there'
- Totals query must run in system mode inside without-sharing rollup service, not in with-sharing service

**Blockers**
- No Salesforce org connected—validation requires 00DjV000003BVbRUAW attached
- Working branch is main, not sprint2-leave-balance—branch selection is set at session start
- LeaveBalanceServiceTest class missing from sprint2-leave-balance—cannot validate without it

**Next**
- Start new BUILD session with org orgfarm-232477b490-dev-ed (00DjV000003BVbRUAW) connected and sprint2-leave-balance as working branch
- Move computeTotals() query into LeaveBalanceRollupService, run WITH SYSTEM_MODE
- Add FOR UPDATE lock to balance records before totalling
- Write LeaveBalanceServiceTest with all required coverage (BalanceKey, keyFor, computeTotals, getEntitlementSnapshot, user-visibility case, off switch, handler guard, 20+ bulk records)
- Run validation: sf project deploy validate --source-dir force-app --test-level RunSpecifiedTests --tests LeaveBalanceEngineTest LeaveBalanceServiceTest
- Check org for Employee_Leave__c sharing model and Total_Days__c field type

**Checked live on 2026-10-14:** the repository
### Last session — 2026-10-14
| | |
|---|---|
| Type | BUILD |
| Outcome | COMPLETED |
| Branch | `main` |
| Session | `d168f70a-68c2-492d-9a55-72095a048249` |
**In its own words (excerpt):**
I stopped at the preconditions again, because both still fail. I haven't edited, created, validated, committed or deployed anything. I did a read-only review of the branch and found the cause of the undercount.

## Precondition results

| Check | Expected | Actual | Result |
|---|---|---|---|
| Org | `00DjV000003BVbRUAW` | No org is logged in. `sf org list` is empty and `sf org display` returns `NoDefaultEnvError` | ❌ Fail |
| Working branch | `sprint2-leave-balance` | This session is pinned to `main`. `sprint2-leave-balance` exists on the remote at `82456e3` | ❌ Fail |

This is the same result as the last session. Both the org and the branch are fixed when a session starts, so I can't change either from here. Without an org, check-only validation can't run.

## Why the rollup undercounts

`LeaveBalanceRollupService` is `without sharing` and writes `Used_Days__c` and `Pending_Days__c` in system mode. But it gets its totals from `LeaveBalanceService.computeTotals()`, which is `with sharing` and runs the aggregate `WITH USER_MODE`. So the totals only include the leave rows the person saving can see, and those partial totals then overwrite the stored balance.

- **Example:** a manager

_[summary truncated — see the session record for the full text]_
<!-- orchestrate:session-state:end -->
