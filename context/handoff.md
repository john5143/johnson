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
**Status:** blocked — Preconditions failed: no org connected, wrong branch. Repo audit complete; LeaveBalanceServiceTest still missing.

**Done this session**
- Confirmed sprint2-leave-balance branch exists at 82456e3 with 5 of 6 required Apex classes
- Verified LeaveBalanceServiceTest absent from repo and all commit history
- Checked Salesforce CLI auth state: no org logged in, no default environment

**Open items**
- Write LeaveBalanceServiceTest covering snapshot read, balance key, off switch, employee-user context tests
- Connect org orgfarm-232477b490-dev-ed (00DjV000003BVbRUAW) to next session
- Set sprint2-leave-balance as working branch for next session
- Validate with: sf project deploy validate --source-dir force-app --test-level RunSpecifiedTests --tests LeaveBalanceEngineTest LeaveBalanceServiceTest
- Re-run LeaveBalanceEngineTest (19/21, 20/36 failures) once Apex classes deployed to org
- Preview Welcome Email - MCP_Test (34013) with row JMC-0004
- Send test of Welcome Email to nagaruri.johnson@jaxconsult.com
- Replace three remaining *.sample@example.com addresses in John_Mike_Customers (JMC-0001, 0002, 0003, 0005)

**Decisions**
- Deploy permission set from org copy (not GitHub file) to preserve all existing grants
- Precision difference (18 vs 8 digits) deferred; decide before deploying GitHub field file
- Welcome Banner - Image Block created as reusable block (34027), linked not copied
- Engagement Split added to Has Bio path; wait set to 2 days for open window
- Random Split (50/50) added to Opened path with Variant A and Variant B emails
- Welcome Email subject uses %%FirstName%% with no fallback; greeting inside has fallback 'Hi there'

**Blockers**
- No Salesforce org connected—session started with no default environment; validation requires 00DjV000003BVbRUAW attached
- Working branch is main, not sprint2-leave-balance—branch selection is set at session start
- LeaveBalanceServiceTest class missing from sprint2-leave-balance—cannot validate without it
- LeaveBalanceEngine Apex classes not yet deployed to org—cannot re-run tests to confirm field access resolves failures

**Next**
- Start new BUILD session with org orgfarm-232477b490-dev-ed (00DjV000003BVbRUAW) connected and sprint2-leave-balance as working branch
- Write LeaveBalanceServiceTest or confirm if it exists elsewhere in the org
- Run validation: sf project deploy validate --source-dir force-app --test-level RunSpecifiedTests --tests LeaveBalanceEngineTest LeaveBalanceServiceTest
- Once validation passes, deploy Apex classes and re-run LeaveBalanceEngineTest to confirm Available_Days__c access resolves failures

**Checked live on 2026-10-14:** the repository
### Last session — 2026-10-14
| | |
|---|---|
| Type | BUILD |
| Outcome | COMPLETED |
| Branch | `main` |
| Session | `191892a7-fb48-4a29-9cb9-e09c7d97e80e` |
**In its own words (excerpt):**
I stopped at the preconditions: both of them failed. I haven't changed, committed or deployed anything, and I didn't write any test code, because I can't validate it in this session.

## Precondition results

| Check | Expected | Actual | Result |
|---|---|---|---|
| Authenticated org | `00DjV000003BVbRUAW` | **No org logged in.** `sf org list` came back empty and `sf org display` returned `NoDefaultEnvError: No default environment found.` | ❌ Fail |
| Working branch | `sprint2-leave-balance` | **This session is pinned to `main`.** `sprint2-leave-balance` exists on the remote (`82456e3`). | ❌ Fail |

Neither can be fixed from inside this session. The org and the working branch are both set when a session starts.

## What I checked on the branch (read-only)

The branch is at `82456e3`, the same commit the last session audited. It has `EmployeeLeave_TriggerHandler`, `LeaveBalanceService`, `LeaveBalanceRollupService`, `LeaveBalanceException` and `LeaveBalanceEngineTest`. **`LeaveBalanceServiceTest` is still missing.** The `EmployeeLeaveTrigger` trigger was reported present last session; I listed only the classes folder this time, so I didn't recheck it.

## To unblock

Start a new **B

_[summary truncated — see the session record for the full text]_
<!-- orchestrate:session-state:end -->
