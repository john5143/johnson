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
**Status:** blocked — BUILD: Email content complete; steveorg unreachable—cannot verify field access. Awaiting admin reconnection.

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
- steveorg not reachable—NamedOrgNotFoundError, no Salesforce org signed in; sf org list returns 0 orgs

**Next**
- Have Salesforce admin connect or re-authorize steveorg under Setup → Revecast Orchestrate → Connected Orgs and click Test Connection
- Start a new session with steveorg as target org to verify Leave_Entitlement__c.Available_Days__c field access
- Execute Preview & Test on Welcome Email - MCP_Test (34013) with row JMC-0004 to confirm banner renders
- Send test of Welcome Email to nagaruri.johnson@jaxconsult.com and check send log for delivery and tracking

**Checked live on 2026-10-14:** the repository
### Last session — 2026-10-14
| | |
|---|---|
| Type | BUILD |
| Outcome | COMPLETED |
| Branch | `main` |
| Session | `c6d95fa0-1cc1-41d8-8801-5bdee6cafe57` |
**In its own words (excerpt):**
I checked the steveorg connection first, and it isn't available, so I stopped there. I didn't run any of the org checks: Metadata API, sObject Describe, SOQL queryability or field-level security.

| Connection | Result |
|---|---|
| **steveorg** (Salesforce) | ❌ Not available. `sf org display --target-org steveorg` returned `NamedOrgNotFoundError: No authorization information found for steveorg.` `sf org list` returned **0 orgs**, so this session has no Salesforce org connected at all. |
| **`sprint2-leave-balance`** (GitHub, `john5143/johnson`) | ✅ Available. The branch still points to commit `82456e3`, the same as last session. |

I can't tell you the root cause of the `Available_Days__c` problem without the org. Every check you asked for compares the org against the branch, and I can only see the branch. I made no changes.

**Running this again in this session won't help.** The org is fixed when a session starts and can't be added partway through. To unblock it:
1. Have a Salesforce admin connect steveorg again, or reconnect it, from the **Connectors** page under **Salesforce orgs**. If it doesn't appear on the new-session form afterwards, a workspace owner or admin may need to 

_[summary truncated — see the session record for the full text]_
<!-- orchestrate:session-state:end -->
