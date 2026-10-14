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
**Status:** on track — Rollup fix validated (49/49 tests pass). Ready to commit, PR, and deploy.

**Done this session**
- Moved totals query into LeaveBalanceRollupService, runs WITH SYSTEM_MODE
- Added FOR UPDATE lock to balance records before totalling
- Wrote LeaveBalanceServiceTest (22 tests) covering BalanceKey, keyFor, computeTotals, getEntitlementSnapshot, user-visibility, off switch, handler guard, 200 records
- Added 5 new tests to LeaveBalanceEngineTest (year boundary, delete, edit, 200 records)
- Achieved 100% coverage on service, rollup, handler, trigger
- Check-only validation passed: 49/49 tests, validation ID 0AfjV0000041E9tSAE
- Fixed real save failure: employee with read-only balance access can now save leave

**Open items**
- Delete LeaveBalanceException or put it to use (0% coverage blocks deploy)
- Confirm business rule: leave crossing year boundary counts entirely against start year
- Commit to sprint2-leave-balance
- Open pull request
- Run Deploy session to ship to org

**Decisions**
- Totals query must run in system mode inside without-sharing rollup service
- Balance records locked before totalling to prevent concurrent-save overwrites
- computeTotals() and getEntitlementSnapshot() documented as read-only for screens only
- Undercount risk closed by design (system-mode query) rather than test reproduction
- Deploy permission set from org copy (not GitHub file) to preserve existing grants
- Precision difference (18 vs 8 digits) deferred; decide before deploying GitHub field file
- Welcome Banner - Image Block created as reusable block (34027), linked not copied
- Engagement Split added to Has Bio path; wait set to 2 days for open window

**Blockers**
- LeaveBalanceException has 0% coverage and blocks deploy—must delete or put to use

**Next**
- Delete or implement LeaveBalanceException
- Confirm year-boundary business rule with stakeholder
- Commit changes to sprint2-leave-balance
- Open pull request for review
- Merge to main after approval
- Start Deploy session to ship to org 00DjV000003BVbRUAW

**Checked live on 2026-10-14:** the repository
### Last session — 2026-10-14
| | |
|---|---|
| Type | BUILD |
| Outcome | COMPLETED |
| Branch | `sprint2-leave-balance` |
| Name | Sprint 2 - Leave Balance Engine |
| Session | `081c15c1-bec7-44fc-b80c-04d3fd222930` |
**In its own words (excerpt):**
━━ Build status (auto-checked from tool results — deploy = sf CLI exit, not runtime effect) ━━
• Code committed: no
• Pushed to GitHub: no
• Validated (sf deploy validate): yes
• Deployed to org: NO — not deployed to any org
Next: open/refresh the PR → review → merge to main → run a Deploy session to ship. This work is NOT live yet.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

The rollup fix is in and check-only validation passed: 49 of 49 tests, and validation ID `0AfjV0000041E9tSAE`. Nothing was deployed, committed, pushed or merged, and no field metadata was touched. The changes exist only in this session's local copy of the branch.

**Preconditions: both passed.** The org ID is `00DjV000003BVbRUAW`. The branch is `sprint2-leave-balance` at `82456e3`, level with `main`.

**The fix** (in `LeaveBalanceRollupService`):
- **Totals:** the rollup now totals every Approved and Pending leave row itself, in system mode. Before, it took them from `LeaveBalanceService.computeTotals()`, which only counts what the person saving can see.
- **Locking:** the balance rows are locked before totalling, so two saves at once can't overwrite each other.
- **Writing:** the balance update is now ex

_[summary truncated — see the session record for the full text]_
<!-- orchestrate:session-state:end -->
