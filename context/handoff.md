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
### Engagement state — 2026-10-13
**Status:** at risk — BUILD complete: CloudPage content & DE built; emails drafted but never sent—no metrics yet. Blockers remain on preview & test execution.

**Done this session**
- Confirmed Welcome Email (33995, 34013) and Simple Welcome Email (10606) have zero send history—no open/click/bounce data available
- Identified journey John_Mike_JB_Test uses Simple Welcome Email (10606), not the MCP_Test variants
- Verified Simple Welcome Email has 6 completed send jobs with 0 targeted/sent/delivered across all

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

**Blockers**
- Banner render not yet previewed — use Preview & Test with row JMC-0004 to confirm
- Canvas visual confirmation not yet done — Random Split appearance on Opened branch unconfirmed
- Test data lacks LoyaltyTier field — emails will show fallback text 'Member' for all contacts
- Global Footer address will not render if account sender details are blank (CAN-SPAM compliance risk)
- No real send executed yet—test sends needed to generate trackable metrics

**Next**
- Execute Preview & Test on Welcome Email - MCP_Test (34013) with row JMC-0004 to confirm banner renders and personalization works
- Send test of Welcome Email to nagaruri.johnson@jaxconsult.com and check send log for delivery and tracking
- Replace three remaining *.sample@example.com test addresses in John_Mike_Customers
- Open John_Mike_JB_Test in Journey Builder and visually confirm Random Split and variant emails on Opened branch
- Run manual test with 4 test contacts from John_Mike_Bio_Split_Test to verify routing through Bio_Check and Engagement Split

**Checked live on 2026-10-13:** the Salesforce org
### Last session — 2026-10-13
| | |
|---|---|
| Type | BUILD |
| Outcome | COMPLETED |
| Branch | `orchestrate/context` |
| Name | Email Studio & Content Bilder |
| Session | `522cf0dc-16d2-4495-a2df-c89d86203b2d` |
**In its own words (excerpt):**
I couldn't get open, click or bounce rates, because neither email named "Welcome Email" has ever been sent. There is no send to report on.

**What I checked:**

| Email | Content Builder ID | Classic email ID | Send jobs found |
|---|---|---|---|
| Welcome Email | 33995 | 11022 | **None** |
| Welcome Email - MCP_Test | 34013 | 11030 | **None** |

- I searched the send log by email name and by classic email ID. Both searches came back empty.
- I also checked the journey **John_Mike_JB_Test**. Its "Send Welcome Email" step doesn't use either of these emails. It uses a different one, **Simple Welcome Email** (ID 10606). The journey is also still a draft that has never been published, and no contacts have entered it.

**Closest match: "Simple Welcome Email" (10606).** It has 6 send jobs marked Complete (IDs 126487, 126492, 126538, 127400, 127403, 127407). In every one of them, 0 emails were targeted, sent or delivered, and there were 0 opens, 0 clicks and 0 bounces. With nothing delivered, there are no rates to calculate. The send log also didn't return dates for these jobs, so I can't say which one was last.

**Not checked:** I couldn't look up triggered send definitions for these ema

_[summary truncated — see the session record for the full text]_
<!-- orchestrate:session-state:end -->
