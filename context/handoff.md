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
**Status:** on track — Welcome Email created in MCP_Test folder (draft); Journey canvas & addresses still pending

**Done this session**
- Created Welcome Email - MCP_Test (ID 34013) in new MCP_Test folder with header, first-name greeting, Get Started button, footer with unsubscribe
- Fixed broken AMPscript unsubscribe link to standard Marketing Cloud unsubscribe
- Confirmed email saved as draft with open tracking enabled

**Open items**
- Replace four *.sample@example.com test addresses with controlled addresses before publish
- Open John_Mike_JB_Test in Journey Builder canvas and visually confirm Random Split and both variant emails on Opened branch
- Define what step follows Not Opened path on Engagement Split (currently ends journey)
- Confirm Has Bio wait should be 2 days total or restore to 3 days + add 1-day wait after split
- Run manual test in Journey Builder with 4 test contacts from John_Mike_Bio_Split_Test
- Add LoyaltyTier field to John_Mike_Bio_Split_Test or confirm fallback text 'Member' is acceptable
- Change Welcome Email Get Started button link from https://www.example.com to real URL
- Verify FirstName field exists in sending data extension; update greeting logic if field name differs

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
- Update Welcome Email Get Started button to real URL and verify FirstName field in sending data
- Open John_Mike_JB_Test in Journey Builder and visually confirm Random Split and variant emails on Opened branch
- Replace four *.sample@example.com addresses with controlled test addresses
- Decide whether Not Opened path should send reminder email or end journey
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
I created the email and read it back to confirm it saved correctly. It's a draft and has not been sent.

**New folder:** Content Builder → **MCP_Test** (ID 50064, at the root)

**New email:**
| | |
|---|---|
| Name | Welcome Email - MCP_Test |
| ID / Customer Key | 34013 / `d18b1271-8834-4bfb-bdfb-36e413cf15ac` |
| Type | HTML Email (HTML Paste) |
| Folder | MCP_Test |
| Subject | Welcome to the community! |
| Status | Draft |

The existing "Welcome Email" (ID 33995) was not changed.

**What's in it:** a 600px-wide layout with a header, a greeting that uses the subscriber's first name (and says "Hi there" if there isn't one), a short welcome message, a "Get Started" button, and a footer with your sender address, Unsubscribe and Manage preferences links. Open tracking is on, and the plain-text version is generated from the HTML.

**One fix after creating it:** in my first version, the Unsubscribe link pointed at an AMPscript variable that was never defined, so the link would have been broken. I replaced it with the standard Marketing Cloud unsubscribe link and checked that the saved version has it.

**Before you send it:**
- The **Get Started** button links to `https://www.example.c

_[summary truncated — see the session record for the full text]_
<!-- orchestrate:session-state:end -->
