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
**Status:** at risk — Field access fix validated, awaiting approval to deploy. BUILD tasks paused pending blocker resolution.

**Done this session**
- Validated check-only deploy of Leave_Balance_Engine permission set with Available_Days__c read grant (validation 0AfjV0000040eJKSAY passed)
- Confirmed org and GitHub field match (formula, type, blanks); noted precision difference (18 vs 8 digits) for future decision
- Identified no users currently assigned to Leave_Balance_Engine permission set

**Open items**
- BLOCKER: Approve deploy of permission set with Available_Days__c grant, then assign to test user and re-run engine tests (19/21, 20/36 failures)
- Preview Welcome Email - MCP_Test (34013) with row JMC-0004 to confirm banner and personalization render
- Send test of Welcome Email to nagaruri.johnson@jaxconsult.com to verify subject, preheader, and image
- Replace three remaining *.sample@example.com addresses in John_Mike_Customers (JMC-0001, 0002, 0003, 0005)
- Open John_Mike_JB_Test in Journey Builder and visually confirm Random Split and variant emails on Opened branch
- Define what step follows Not Opened path on Engagement Split (currently ends journey)
- Run manual test in Journey Builder with 4 test contacts from John_Mike_Bio_Split_Test
- Replace all placeholder links and text in Basic Newsletter email

**Decisions**
- Deploy permission set from org copy (not GitHub file) to preserve all existing grants and org-only settings
- Precision difference (18 vs 8 digits) deferred; decide before deploying GitHub field file as-is
- Welcome Banner - Image Block created as reusable block (34027) in MCP_Test folder, linked not copied
- Global Footer block created in MCP_Test (not yet moved to Shared Content)
- Engagement Split added to Has Bio path; wait set to 2 days for open window
- Random Split (50/50) added to Opened path with Variant A and Variant B emails
- Welcome Email subject uses %%FirstName%% with no fallback; greeting inside has fallback 'Hi there'
- Target org: orgfarm-232477b490-dev-ed (MAX Developer Edition, ID 00DjV000003BVbRUAW)

**Blockers**
- Available_Days__c field has no field-level access—blocks engine tests (19/21 and 20/36 failures) and SOQL queries. Fix validated, awaiting approval to deploy.
- No users assigned to Leave_Balance_Engine permission set; test user assignment required after deploy
- Data Cloud tools unavailable—Revecast Orchestrate Connector package needs upgrade for missing scopes

**Next**
- Approve deploy of Leave_Balance_Engine permission set with Available_Days__c read grant
- Assign Leave_Balance_Engine permission set to test user (John Steve or designated tester)
- Re-run LeaveBalanceEngineTest (19/21, 20/36) to confirm field access resolves failures
- Resume BUILD: Preview Welcome Email, test Journey Builder splits, finalize Basic Newsletter content

**Checked live on 2026-10-14:** nothing — the status above is as recorded, not re-checked
### Last session — 2026-10-14
| | |
|---|---|
| Type | BUILD |
| Outcome | COMPLETED |
| Branch | `main` |
| Session | `9b7d39c9-0d43-41d4-b21e-f81bf48b101a` |
**In its own words (excerpt):**
The check-only validation passed and nothing has been deployed. It adds a single read-only grant on `Available_Days__c` to `Leave_Balance_Engine`. The org and the repo are both unchanged: the permission set's last-modified date is still 2026-09-29, and the field grant is still missing.

**1. Org ID.** The authenticated org `orgfarm-232477b490-dev-ed` returns `00DjV000003BVbRUAW`. Its first 15 characters are `00DjV000003BVbR`, so it matches.

**2. The field vs GitHub (`sprint2-leave-balance`)**

| | Org | GitHub | Match |
|---|---|---|---|
| Exists | Yes (`00NjV00000atiQHUAY`) | Yes | ✅ |
| Formula | `Entitled_Days__c + Carry_Forward_Days__c - Used_Days__c - Pending_Days__c` | Same | ✅ |
| Blanks treated as | Zero | Zero | ✅ |
| Type and decimals | Number, 2 decimals | Number, 2 decimals | ✅ |
| Precision (total digits) | 18 | 8 | ⚠️ Differs |

The precision difference doesn't affect access, so I left the field out of this change. If you ever deploy the GitHub field file as it is, it would cut precision to 8, so decide which value you want before then.

**3. The permission set: org vs GitHub**
- Both have read-only access to the two Leave objects, with no create, edit, delete, View 

_[summary truncated — see the session record for the full text]_
<!-- orchestrate:session-state:end -->
