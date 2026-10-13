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
**Status:** blocked — I didn't send anything.

**Done this session**
- I didn't send anything. You chose the manual route, so here are the steps for sending the test yourself from Content Builder. I checked live that row **JMC-0004** in John_Mike_Customers has Email `nagaruri.johnson@jaxconsult.com` and First…

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
| Name | Email Studio & Content Bilder |
| Session | `522cf0dc-16d2-4495-a2df-c89d86203b2d` |
**In its own words (excerpt):**
I didn't send anything. You chose the manual route, so here are the steps for sending the test yourself from Content Builder. I checked live that row **JMC-0004** in John_Mike_Customers has Email `nagaruri.johnson@jaxconsult.com` and FirstName `Updated`, so the test should arrive with the subject **"Welcome Aboard, Updated!"**.

I've assumed you mean **Welcome Email - MCP_Test (34013)**, the one we updated. If you meant the older "Welcome Email" (33995), the steps are the same but its subject is different.

## Steps for Preview & Test

1. **Find the email:** in Content Builder, switch **My Content** to **All Content** and clear any type filter. Open the **MCP_Test** folder, then open **Welcome Email - MCP_Test**.
2. Click **Preview and Test** in the top right.
3. **Choose the data source:** in the left panel, open the **Data Extension** or **Subscriber** picker and select **John_Mike_Customers**.
4. **Choose the row:** search for or pick the row with ContactKey **JMC-0004** (Email nagaruri.johnson@jaxconsult.com). The preview should show "Hi Updated" in the greeting and "Welcome Aboard, Updated!" as the subject.
5. Click **Test Send** in the top right.
6. **Recipient:** enter `naga

_[summary truncated — see the session record for the full text]_
<!-- orchestrate:session-state:end -->
