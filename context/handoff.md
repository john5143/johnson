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
**Status:** at risk — Available_Days__c field exists but has no field-level access—blocks engine tests & queries. Fix proposed, awaiting decision.

**Done this session**
- Diagnosed root cause: field re-created 2026-09-30 without field-level security grants
- Confirmed field exists in metadata (00NjV00000atiQHUAY) but hidden from Describe, SOQL, and Apex queries
- Identified permission set mismatch: branch includes grants, org deployment did not
- Proposed safe correction: deploy field + permission sets together, assign to test user, re-run tests

**Open items**
- Preview Welcome Email - MCP_Test (34013) with row JMC-0004 to confirm banner and personalization render
- Send test of Welcome Email to nagaruri.johnson@jaxconsult.com to verify subject, preheader, and image
- Replace three remaining *.sample@example.com addresses in John_Mike_Customers (JMC-0001, 0002, 0003, 0005)
- Open John_Mike_JB_Test in Journey Builder and visually confirm Random Split and variant emails on Opened branch
- Define what step follows Not Opened path on Engagement Split (currently ends journey)
- Run manual test in Journey Builder with 4 test contacts from John_Mike_Bio_Split_Test
- Replace all placeholder links in Basic Newsletter email (2 Read more + 1 Call to Action button)
- Replace placeholder text in Basic Newsletter (newsletter name, month/year, headline, articles, call to action)

**Decisions**
- Welcome Banner - Image Block created as reusable block (34027) in MCP_Test folder
- Banner image linked (not copied) so edits to block 34027 update all emails using it
- Image scaled to 600 px wide for email display; original 700 px asset preserved
- Global Footer block created in MCP_Test (not yet moved to Shared Content)
- Engagement Split added to Has Bio path; wait set to 2 days for open window
- Random Split (50/50) added to Opened path with Variant A and Variant B emails
- Welcome Email subject uses %%FirstName%% with no fallback; greeting inside has fallback 'Hi there'
- Target org: orgfarm-232477b490-dev-ed (MAX Developer Edition)

**Blockers**
- Available_Days__c field has no field-level access—blocks engine tests (19/21 and 20/36 failures) and SOQL queries
- Data Cloud tools unavailable—Revecast Orchestrate Connector package needs upgrade for missing scopes

**Next**
- Decide whether to apply the proposed field-level access fix (validate, deploy, re-run LeaveBalanceEngineTest)
- If approved: validate the deploy with engine tests before applying to orgfarm-232477b490-dev-ed
- Resume BUILD tasks: Preview Welcome Email, test Journey Builder splits, finalize Basic Newsletter content

**Checked live on 2026-10-14:** the repository
### Last session — 2026-10-14
| | |
|---|---|
| Type | BUILD |
| Outcome | COMPLETED |
| Branch | `main` |
| Session | `9b7d39c9-0d43-41d4-b21e-f81bf48b101a` |
**In its own words (excerpt):**
The field exists in the org, but no user has field-level access to it, so describe and SOQL can't see it. Nothing in the org or the repo was changed.

**1. Authentication.** There is no org with the alias `steveorg` (the CLI returns `NamedOrgNotFoundError: No authorization information found for steveorg`). The only authenticated org is `orgfarm-232477b490-dev-ed`. A live query confirmed it's connected, and its running user is John Steve, an active System Administrator, so I reviewed that org. If `steveorg` is meant to be a different org, it needs connecting first.

**2. The four checks**

| Check | Result |
|---|---|
| Branch `sprint2-leave-balance` | Formula field: `Entitled + Carry_Forward − Used − Pending`, blanks treated as zero. The admin and engine permission sets both grant it read-only. The field file comes from commit `e4fe695`, which is `main`'s latest commit, so the branch and `main` match. |
| Metadata API / Tooling API | ✅ Field exists (`00NjV00000atiQHUAY`) with the same formula, created 2026-09-30 16:41:23. |
| sObject Describe and FieldDefinition | ❌ The field is missing. The other 8 custom fields show up. |
| SOQL | ❌ `INVALID_FIELD: No such column 'Available_Days_

_[summary truncated — see the session record for the full text]_
<!-- orchestrate:session-state:end -->
