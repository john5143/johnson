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
**Status:** blocked — BUILD complete; Salesforce org connection required to proceed. No org available in this session.

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
- No Salesforce org connected to this session—sf org list returns 0 orgs. steveorg, JohnDev-Org, and orgfarm-232477b490-dev-ed all failed to connect. Org must be selected when session starts; cannot be added mid-session.

**Next**
- Go to Connectors page under Salesforce orgs; verify steveorg, JohnDev-Org, or orgfarm-232477b490-dev-ed is listed and approved
- If org is waiting for approval, workspace owner or admin must approve it under Approvals
- Start new BUILD session with one of these orgs selected as target org
- Run Available_Days__c field access review in connected org session
- Execute Preview & Test on Welcome Email - MCP_Test (34013) with row JMC-0004

**Checked live on 2026-10-14:** nothing — the status above is as recorded, not re-checked
### Last session — 2026-10-14
| | |
|---|---|
| Type | BUILD |
| Outcome | COMPLETED |
| Branch | `main` |
| Session | `c6d95fa0-1cc1-41d8-8801-5bdee6cafe57` |
**In its own words (excerpt):**
I just checked again, and this session still has no Salesforce org connected.

| Check | Result |
|---|---|
| `sf org list` | **0 orgs**. The sandbox, non-scratch, scratch and Dev Hub lists are all empty. |
| Default target org | **Not set**. The setting exists but has no value. |

**What is connected in this session:**
- **GitHub:** `john5143/johnson`, which I read from earlier in this session.
- **Slack:** the Jaxconsulting workspace.

Nothing has changed since the earlier checks. The org is chosen when a session starts, so steveorg, JohnDev-Org and orgfarm-232477b490-dev-ed can't be added to this session.

**To get one connected:**
1. Go to the **Connectors** page and look under **Salesforce orgs** for the org you want. If it isn't there, connect it. If it's waiting for approval, a workspace owner or admin can approve it under **Approvals**.
2. Start a **new** session with that org selected as the target org. Then I can run the `Available_Days__c` review.

Sources: engagement context (none relied on) · checked live: Salesforce CLI (`sf org list`, `sf config get target-org`) · not checked: the Connectors page (I have no tool that can see it)
<!-- orchestrate:session-state:end -->
