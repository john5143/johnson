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
**Status:** on track — Global Footer block created (34016); Newsletter & Welcome Email templates ready for link/content replacement

**Done this session**
- Created Global Footer HTML block (ID 34016) in MCP_Test with Unsubscribe, Manage preferences, View in browser, address, and copyright

**Open items**
- Replace four *.sample@example.com test addresses with controlled addresses before publish
- Open John_Mike_JB_Test in Journey Builder canvas and visually confirm Random Split and both variant emails on Opened branch
- Define what step follows Not Opened path on Engagement Split (currently ends journey)
- Confirm Has Bio wait should be 2 days total or restore to 3 days + add 1-day wait after split
- Run manual test in Journey Builder with 4 test contacts from John_Mike_Bio_Split_Test
- Add LoyaltyTier field to John_Mike_Bio_Split_Test or confirm fallback text 'Member' is acceptable
- Replace all placeholder links in Basic Newsletter email (2 Read more + 1 Call to Action button) with real URLs
- Replace placeholder text in Basic Newsletter (newsletter name, month/year, headline, articles, call to action)

**Decisions**
- Global Footer block created in MCP_Test (not yet moved to Shared Content)
- Engagement Split added to Has Bio path; wait set to 2 days for open window
- Random Split (50/50) added to Opened path with Variant A and Variant B emails
- Raw_Transactions_J Amount field remains Text(50)
- Staging_Active_Subscribers_J includes all 10 contacts (BDAY-0001 to BDAY-0010)
- VIP_Upsell_Target_J 10-row load approved
- Cart_Abandonment_Target_J loaded with all 10 rows

**Blockers**
- Canvas visual confirmation not yet done — Random Split appearance on Opened branch unconfirmed
- Test data lacks LoyaltyTier field — emails will show fallback text 'Member' for all contacts
- Global Footer address will not render if account sender details are blank (CAN-SPAM compliance risk)

**Next**
- Send test of Global Footer to verify address renders from account sender details
- Replace all placeholder links in Basic Newsletter email (2 Read more + 1 Call to Action) with real URLs
- Replace placeholder text in Basic Newsletter (newsletter name, month/year, headline, articles, call to action)
- Update Welcome Email Get Started button to real URL
- Open John_Mike_JB_Test in Journey Builder and visually confirm Random Split and variant emails on Opened branch
- Replace four *.sample@example.com addresses with controlled test addresses
- Run manual test with 4 test contacts to verify routing through Bio_Check and Engagement Split

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
I created the **Global Footer** content block and read it back to confirm it saved. It's in **MCP_Test**, as you chose. That folder isn't shared, so this block is not in a shared "Global Content" folder.

| | |
|---|---|
| Name | Global Footer |
| ID / Customer Key | 34016 / `d9170f47-b631-4ead-a12e-5ab8b5d35f67` |
| Type | HTML Block (reusable content block) |
| Folder | Content Builder → MCP_Test (50064) |
| Status | Draft |

**What's in the footer:**
- A line saying why the subscriber is getting the email
- Links to **Unsubscribe**, **Manage preferences** and **View in browser**, using Marketing Cloud's built-in links
- Your business name and physical mailing address, filled in automatically from the account's sender details
- A copyright line with the current year, filled in when the email is sent
- Light grey background, 12px text. It's full width, so it fits inside the 600px layouts of your other emails.

**How to use it:** open an email in the drag-and-drop editor, go to **Content → Saved Content**, and drag in **Global Footer**. The block isn't linked to any email yet. If you add it to the Welcome Email or the Basic Newsletter, they'll show two footers until you delete the 

_[summary truncated — see the session record for the full text]_
<!-- orchestrate:session-state:end -->
