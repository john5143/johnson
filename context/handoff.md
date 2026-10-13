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
**Status:** on track — Welcome Email drafted; Basic Newsletter template & email created. Four placeholder links & test addresses still pending.

**Done this session**
- Created Basic Newsletter template (ID 34014) in MCP_Test folder with 600px layout and five editable sections
- Created Basic Newsletter - MCP_Test email (ID 34015) built on template 34014 with placeholder blocks and first-name greeting
- Confirmed both template and email saved as drafts in Content Builder

**Open items**
- Replace four *.sample@example.com test addresses with controlled addresses before publish
- Open John_Mike_JB_Test in Journey Builder canvas and visually confirm Random Split and both variant emails on Opened branch
- Define what step follows Not Opened path on Engagement Split (currently ends journey)
- Confirm Has Bio wait should be 2 days total or restore to 3 days + add 1-day wait after split
- Run manual test in Journey Builder with 4 test contacts from John_Mike_Bio_Split_Test
- Add LoyaltyTier field to John_Mike_Bio_Split_Test or confirm fallback text 'Member' is acceptable
- Change Welcome Email Get Started button link from https://www.example.com to real URL
- Replace all placeholder links in Basic Newsletter email (2 Read more + 1 Call to Action button) with real URLs

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
- Replace all placeholder links in Basic Newsletter email (2 Read more + 1 Call to Action) with real URLs
- Replace placeholder text in Basic Newsletter (newsletter name, month/year, headline, articles, call to action)
- Update Welcome Email Get Started button to real URL and verify FirstName field in sending data
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
I created the Basic Newsletter template and an email built on it, then read both back to confirm they saved. Both are drafts. Nothing has been sent.

**1. Template:** Basic Newsletter
| | |
|---|---|
| ID / Customer Key | 34014 / `cab0a678-a59f-4274-9c8c-a839d036cc5f` |
| Type | Template |
| Folder | MCP_Test (50064) |
| Layout | 600px single column with five editable sections: Header, Hero, Articles, Call to Action, Footer |

You can reuse this template for future newsletters.

**2. Email:** Basic Newsletter - MCP_Test
| | |
|---|---|
| ID / Customer Key | 34015 / `a406a1e4-05ef-4b54-939d-d2d305db410e` |
| Type | Template-Based Email, built on template 34014 |
| Folder | MCP_Test (50064) |
| Subject | Your monthly newsletter is here |
| Preheader | The latest news, updates and highlights from our team. |
| Status | Draft |

**Placeholder blocks (6, each editable on its own in the drag-and-drop editor):**
- **Header:** banner reading `[Newsletter Name] · [Month Year]`
- **Hero:** `[Headline goes here]` and an intro line that greets the subscriber by first name, or says "Hi there" if there isn't one
- **Articles:** two article blocks, each with a title, a summary and a "Read more" l

_[summary truncated — see the session record for the full text]_
<!-- orchestrate:session-state:end -->
