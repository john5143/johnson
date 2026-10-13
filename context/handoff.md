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
**Status:** on track — Welcome Email subject & preheader done; one test address replaced in John_Mike_Customers; four *.sample@example.com addresses remain

**Done this session**
- Replaced meera.sample@example.com with nagaruri.johnson@jaxconsult.com in John_Mike_Customers row JMC-0004

**Open items**
- Replace three remaining *.sample@example.com test addresses in John_Mike_Customers (JMC-0001, 0002, 0003, 0005)
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
- Welcome Email subject uses %%FirstName%% with no fallback; greeting inside has fallback 'Hi there'

**Blockers**
- Canvas visual confirmation not yet done — Random Split appearance on Opened branch unconfirmed
- Test data lacks LoyaltyTier field — emails will show fallback text 'Member' for all contacts
- Global Footer address will not render if account sender details are blank (CAN-SPAM compliance risk)
- FirstName field must exist in sending data extension or subject will show 'Welcome Aboard, !' for all subscribers

**Next**
- Replace three remaining *.sample@example.com addresses in John_Mike_Customers with controlled test addresses
- Send test of Welcome Email to verify subject, preheader, and FirstName personalization render correctly
- Send test of Global Footer to verify address renders from account sender details
- Open John_Mike_JB_Test in Journey Builder and visually confirm Random Split and variant emails on Opened branch
- Run manual test with 4 test contacts to verify routing through Bio_Check and Engagement Split

**Checked live on 2026-10-13:** the Salesforce org
### Last session — 2026-10-13
| | |
|---|---|
| Type | BUILD |
| Outcome | COMPLETED |
| Branch | `orchestrate/context` |
| Session | `130de6ce-20be-4646-896c-78e5de6e72f4` |
**In its own words (excerpt):**
Row **JMC-0004** in **John_Mike_Customers** now has the new email. I read the row back after the update to confirm it.

| Field | Before | After |
|---|---|---|
| Email | meera.sample@example.com | **nagaruri.johnson@jaxconsult.com** |
| FirstName | Updated | Updated (unchanged) |
| CreatedDate | 10/6/2026 9:48:31 AM | unchanged |
| Bio | Avid reader | unchanged |

- **Only one row changed.** The other 4 rows (JMC-0001, 0002, 0003 and 0005) weren't touched.
- **My first try failed.** Marketing Cloud rejected it with "Parameter {values} is required" because of how I formatted the request. I fixed the format and the second try worked.
- **No email was sent.** I only changed data.

**Still open:** the other four rows still use `*.sample@example.com` addresses. That includes this data extension's own test contacts, so look at them before you publish any journey that sends to this data. I can change those to addresses you control too.

Sources: engagement context (context/handoff.md) · checked live: Marketing Cloud (John_Mike_Customers fields, rows before and after the update) · not checked: whether any journey or send currently uses this data extension
<!-- orchestrate:session-state:end -->
