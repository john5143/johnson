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
**Status:** on track — Banner image block added to Welcome Email; draft ready for preview test. Seven open items remain.

**Done this session**
- Created Welcome Banner - Image Block (34027) with Banner_GFLEC.jpg (700×150 px)
- Added image block to Welcome Email - MCP_Test (34013) via AMPscript ContentBlockByKey
- Confirmed both assets saved in Content Builder

**Open items**
- Replace three remaining *.sample@example.com test addresses in John_Mike_Customers (JMC-0001, 0002, 0003, 0005)
- Preview Welcome Email with row JMC-0004 to confirm banner renders and personalization works
- Send test of Welcome Email to nagaruri.johnson@jaxconsult.com
- Open John_Mike_JB_Test in Journey Builder and visually confirm Random Split and variant emails on Opened branch
- Define what step follows Not Opened path on Engagement Split (currently ends journey)
- Run manual test in Journey Builder with 4 test contacts from John_Mike_Bio_Split_Test
- Replace all placeholder links in Basic Newsletter email (2 Read more + 1 Call to Action button) with real URLs
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

**Next**
- Preview Welcome Email - MCP_Test (34013) with row JMC-0004 to confirm banner and personalization render
- Send test of Welcome Email to nagaruri.johnson@jaxconsult.com to verify subject, preheader, and image
- Replace three remaining *.sample@example.com addresses in John_Mike_Customers with controlled test addresses
- Open John_Mike_JB_Test in Journey Builder and visually confirm Random Split and variant emails on Opened branch
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
I added the banner image to **Welcome Email - MCP_Test (34013)** using a new reusable Image block. I read both assets back to confirm they saved. The email is still a draft and hasn't been sent.

**1. New Image block:** Welcome Banner - Image Block
| | |
|---|---|
| ID / Customer Key | 34027 / `MCP_Test_Welcome_Banner_Block` |
| Type | Image Block |
| Folder | MCP_Test (50064) |
| Image | Banner_GFLEC.jpg (asset 18610, 700×150 px) |
| Alt text | Welcome to the community |
| Sizing | 600 px wide to fit the email, and it shrinks on smaller screens |

**2. Email change:** I added a new row just below the blue "Welcome to the community!" header. It pulls in the block with `%%=ContentBlockByKey("MCP_Test_Welcome_Banner_Block")=%%`. Nothing else changed: the subject, preheader, body, button and footer are the same as before.

**Things to know:**
- **The image is linked, not copied.** If you edit block 34027 later, for example to swap the image or change the alt text, this email and any other email that uses the block will update.
- **Don't change the block's customer key.** The email finds the block by that key, so renaming the key would make the banner disappear.
- **The image is scaled

_[summary truncated — see the session record for the full text]_
<!-- orchestrate:session-state:end -->
