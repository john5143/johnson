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
**Status:** blocked — BUILD complete; no Salesforce org connected. Tried steveorg, JohnDev-Org, orgfarm-232477b490-dev-ed—all failed.

**Done this session**
- None

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
- Halt diagnosis if either steveorg or GitHub connection fails

**Blockers**
- No Salesforce org connected to this session—sf org list returns 0 orgs. steveorg, JohnDev-Org, and orgfarm-232477b490-dev-ed all failed to connect.

**Next**
- On Connectors page under Salesforce orgs, verify steveorg, JohnDev-Org, and orgfarm-232477b490-dev-ed are listed and approved
- Start new session with one of these orgs selected as target org
- Run Available_Days__c field access review in connected org session
- Execute Preview & Test on Welcome Email - MCP_Test (34013) with row JMC-0004
- Send test of Welcome Email to nagaruri.johnson@jaxconsult.com and check send log

**Checked live on 2026-10-14:** nothing — the status above is as recorded, not re-checked
### Last session — 2026-10-14
| | |
|---|---|
| Type | BUILD |
| Outcome | COMPLETED |
| Branch | `main` |
| Session | `c6d95fa0-1cc1-41d8-8801-5bdee6cafe57` |
**In its own words (excerpt):**
orgfarm-232477b490-dev-ed isn't connected to this session either. I checked it under both its alias and its full My Domain name:

| Check | Result |
|---|---|
| `sf org display --target-org orgfarm-232477b490-dev-ed` | `NamedOrgNotFoundError: No authorization information found for orgfarm-232477b490-dev-ed.` |
| `sf org display --target-org orgfarm-232477b490-dev-ed.develop.my.salesforce.com` | `NamedOrgNotFoundError`, the same error |
| `sf org list` | **0 orgs** |

This is the same reason steveorg and JohnDev-Org failed. No Salesforce org was selected when this session started, and you can't attach one partway through. Trying another org name in this session will give the same result.

**To use orgfarm-232477b490-dev-ed:**
1. On the **Connectors** page under **Salesforce orgs**, check that this org is listed. If it isn't, connect it. If it's waiting for approval, a workspace owner or admin can approve it under **Approvals**.
2. Start a **new** session and select it as the target org. If you'd like, paste in the `Available_Days__c` review request from earlier and I'll run it there.

Sources: engagement context (none relied on) · checked live: Salesforce CLI (`sf org list`, `sf org

_[summary truncated — see the session record for the full text]_
<!-- orchestrate:session-state:end -->
