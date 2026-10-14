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
**Status:** on track — Org connected (orgfarm-232477b490-dev-ed). BUILD tasks resume; Available_Days__c review unblocked.

**Done this session**
- Confirmed Salesforce org connection: orgfarm-232477b490-dev-ed (MAX, Dev Edition, John Steve user)
- Verified org contains Leave_Entitlement__c custom object with Available_Days__c field

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
- Data Cloud tools unavailable—Revecast Orchestrate Connector package needs upgrade for missing scopes

**Next**
- Execute Preview & Test on Welcome Email - MCP_Test (34013) with row JMC-0004
- Run Available_Days__c field access review on Leave_Entitlement__c
- Continue BUILD tasks: replace sample addresses, test Journey Builder splits, finalize Basic Newsletter content

**Checked live on 2026-10-14:** nothing — the status above is as recorded, not re-checked
### Last session — 2026-10-14
| | |
|---|---|
| Type | BUILD |
| Outcome | COMPLETED |
| Branch | `main` |
| Session | `9b7d39c9-0d43-41d4-b21e-f81bf48b101a` |
**In its own words (excerpt):**
The org is connected, and I confirmed it with live queries, not just the CLI's connection status.

**Org: `orgfarm-232477b490-dev-ed`**

| | |
|---|---|
| Org name / ID | MAX · `00DjV000003BVbRUAW` |
| Edition | Developer Edition, not a sandback (instance USA1336) |
| API version | 68.0 |
| Running user | John Steve (`johnsteve112345.c028eac59faf@agentforce.com`), System Administrator, active |
| Status | Connected. This session's default org and its deploy target. |

**What's in it**
- **Unmanaged custom objects (3):** `Employee_Leave__c`, `Leave_Entitlement__c`, `Leave_Holiday__c`
- **Apex:** 12 unmanaged classes. They're mostly Trailhead-style (AccountProcessor, AnimalLocator, ParkLocator/ParkService and their tests), plus `ESA_RecordSearchAction` with its test. There are no custom triggers.
- **Flows:** 1 active.
- **Data:** 13 Accounts, 20 Contacts, 31 Opportunities.
- **Licenses:** Salesforce 2 of 4 used, Salesforce Platform 0 of 6 used, Einstein Agent 0 of 201 used.
- **Installed packages:** devedapp, ssot, cdpactvstrgptnr, and Revecast (listed twice). All are on free licenses.

**Compared with the last session's notes:** the handoff file says no org could be connected, and 

_[summary truncated — see the session record for the full text]_
<!-- orchestrate:session-state:end -->
