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
**Status:** on track — Journey validates; canvas & Not Opened action pending. MCP_Test search completed—found Guide & CloudPage assets, not email.

**Done this session**
- Searched Content Builder for MCP_Test assets
- Located MCP_Test_Guide (PDF) and MCP_Test_Guide_CloudPage (Web Page) in MCP CloudPage Project folder
- Confirmed neither asset is a published CloudPage with live URL

**Open items**
- Replace four *.sample@example.com test addresses with controlled addresses before publish
- Open John_Mike_JB_Test in Journey Builder canvas and visually confirm Random Split and both variant emails on Opened branch
- Define what step follows Not Opened path on Engagement Split (currently ends journey)
- Confirm Has Bio wait should be 2 days total or restore to 3 days + add 1-day wait after split
- Run manual test in Journey Builder with 4 test contacts from John_Mike_Bio_Split_Test
- Add LoyaltyTier field to John_Mike_Bio_Split_Test or confirm fallback text 'Member' is acceptable
- Publish John_Mike_JB_Test after canvas confirmed, addresses replaced, and Not Opened action decided

**Decisions**
- Engagement Split added to Has Bio path; wait set to 2 days for open window
- Random Split (50/50) added to Opened path with Variant A and Variant B emails
- Raw_Transactions_J Amount field remains Text(50)
- Staging_Active_Subscribers_J includes all 10 contacts (BDAY-0001 to BDAY-0010)
- VIP_Upsell_Target_J 10-row load approved
- Cart_Abandonment_Target_J loaded with all 10 rows

**Blockers**
- Canvas visual confirmation not yet done — Random Split appearance on Opened branch unconfirmed
- Test data lacks LoyaltyTier field — emails will show fallback text 'Member' for all contacts

**Next**
- Open John_Mike_JB_Test in Journey Builder and visually confirm Random Split and variant emails on Opened branch
- Decide whether Not Opened path should send reminder email or end journey
- Replace four *.sample@example.com addresses with controlled test addresses
- Confirm Has Bio 2-day wait is final or add 1-day wait after split for 3-day total hold
- Run manual test with 4 test contacts to verify routing through Bio_Check and Engagement Split
- Publish John_Mike_JB_Test once canvas confirmed and addresses replaced

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
No Content Builder asset is named exactly **MCP_Test**. I searched for names containing "MCP_Test" and found two assets, both in the same folder:

**Folder:** Content Builder → **MCP CloudPage Project** (folder ID 49103, directly under the root)

| Asset | Type | ID | Created |
|---|---|---|---|
| MCP_Test_Guide | Document (PDF) | 32627 | 2026-08-28 |
| MCP_Test_Guide_CloudPage | Web Page | 32628 | 2026-08-28 |

**If you can't see them in Content Builder:** both assets belong to the "Revecast Orchestrate MCP1 app user" integration user, not to you. Content Builder's default **My Content** view hides them. To find them:
1. Switch the view from **My Content** to **All Content**.
2. Clear any type filter (for example "Emails"). Neither asset is an email.
3. Open the **MCP CloudPage Project** folder.

`MCP_Test_Guide_CloudPage` is page content stored in Content Builder. It is not a published CloudPage with a live URL. To make it live, a person has to create or attach a landing page in **Web Studio → CloudPages** and publish it.

If you meant a different asset, such as an email actually called "MCP_Test" in another business unit, tell me and I'll search there.

Sources: checked live: Ma

_[summary truncated — see the session record for the full text]_
<!-- orchestrate:session-state:end -->
