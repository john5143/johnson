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
**Status:** blocked — LeaveBalanceServiceTest missing from repo; no org connected to validate. Cannot proceed with deployment.

**Done this session**
- Audited sprint2-leave-balance branch: 5 of 6 required Apex classes present
- Identified LeaveBalanceServiceTest does not exist in repo or any commit history
- Confirmed Employee_Leave__c object and field dependencies exist only in org, not in repo
- Documented code-review findings: snapshot method untested, permission visibility gap in rollup logic, test setup runs before Test.stopTest()

**Open items**
- Write LeaveBalanceServiceTest covering snapshot read, balance key, off switch, employee-user context tests
- Connect org orgfarm-232477b490-dev-ed (00DjV000003BVbRUAW) to next session
- Set sprint2-leave-balance as working branch (session pinned to main)
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
- LeaveBalanceServiceTest class missing from sprint2-leave-balance branch—cannot validate without it
- No Salesforce org connected to this session—validation requires org 00DjV000003BVbRUAW attached
- LeaveBalanceEngine Apex classes not yet deployed to org—cannot re-run tests to confirm field access resolves failures
- Data Cloud tools unavailable—Revecast Orchestrate Connector package needs upgrade for missing scopes

**Next**
- Start new session with org orgfarm-232477b490-dev-ed connected and sprint2-leave-balance as working branch
- Write LeaveBalanceServiceTest (snapshot, balance key, off switch, employee-user tests) or confirm if it exists elsewhere
- Run validation: sf project deploy validate --source-dir force-app --test-level RunSpecifiedTests --tests LeaveBalanceEngineTest LeaveBalanceServiceTest
- Once validation passes, deploy Apex classes and re-run LeaveBalanceEngineTest to confirm Available_Days__c access resolves 19/21 and 20/36 failures

**Checked live on 2026-10-14:** the repository
### Last session — 2026-10-14
| | |
|---|---|
| Type | BUILD |
| Outcome | COMPLETED |
| Branch | `main` |
| Name | sprint2-leave-balance |
| Session | `2669e58c-d81c-4a11-8d1f-9efd169987d0` |
**In its own words (excerpt):**
I stopped before validating. Two things block it: the required test class `LeaveBalanceServiceTest` is missing from the branch, and no Salesforce org is connected to this session. No tests were run, so I have no pass/fail results or coverage numbers to report. Nothing was committed, deployed, or changed in the org, and I didn't touch the field or the permission sets.

## Why I stopped

1. **The test class isn't there.** `LeaveBalanceServiceTest` doesn't exist on `sprint2-leave-balance` (latest commit `82456e3`). It isn't in any earlier commit on any branch either, and no file in the repo refers to it. It has never been written. I didn't write it, because you asked me to stop if a test class was missing.
2. **No org is connected.** The session started with no Salesforce org attached, and the Salesforce CLI shows no logged-in orgs. A validation run needs an org to run against. To validate `00DjV000003BVbRUAW`, start a new session with that org (`orgfarm-232477b490-dev-ed`) picked on the new-session form.

## What's on the branch

| Item | Present | Notes |
|---|---|---|
| `EmployeeLeaveTrigger` (trigger) | ✅ | Only trigger on the object; contains no logic; runs after insert/update/de

_[summary truncated — see the session record for the full text]_
<!-- orchestrate:session-state:end -->
