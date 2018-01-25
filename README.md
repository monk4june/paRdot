# paRdot
A simple R package for the Pardot API v3

### Install
```
devtools::install_github("demgenman/paRdot")
```

### Getting Started:

Make sure to set your Pardot credentials

```
set_credentials('your-username', 'your-password', 'your-user-key')
```
Next, make a paRdot API call.

```
# Using pardot_client()
df <- pardot_client(object = "prospect", operator = "query", 
                    request_pars="created_after=today", result_format="json", verbose = 0)
# Using wrapper function for pardot_client()
df <- pardot_prospects(created_after = "today")
```

**Wrapper functions for querying objects**

The functions below are convenient wrappers for pardot_client(). 

```
df <- pardot_account()
df <- pardot_campaigns()
df <- pardot_email()
df <- pardot_email_clicks()
df <- pardot_email_stats()
df <- pardot_email_template()
df <- pardot_forms()
df <- pardot_lifecycle_histories()
df <- pardot_lifecycle_stages()
df <- pardot_list_memberships()
df <- pardot_lists()
df <- pardot_prospect_accounts()
df <- pardot_prospects()
df <- pardot_tag_objects()
df <- pardot_tags()
df <- pardot_users()
df <- pardot_visitor_activities()
df <- pardot_visitors()
df <- pardot_visits()
```

All functions accept the Pardot API parameters as described on http://developer.pardot.com/.

```
df <- pardot_prospects(created_after = "20171101,1200", last_activity_never = TRUE)
```

**Data frame from JSON response, with Pardot API call parameters supported:**

Use result_format="json" to obtain a data frame with the requested data. Function pardot_client() uses multiple calls to the API if necessary.

```
df <- pardot_client(object, operator, identifier_field=NULL, identifier=NULL, 
                    request_pars=NULL, result_format="json", verbose=FALSE)
```

Object is the name of a Pardot object and operator is the operation performed on that object. The table below gives an overview of the allowed combinations. 

Refer to the [Pardot API documentation](http://developer.pardot.com/) for more details.

Object | Operation for querying the object | Operations for using the object
--- | --- | ---
[_account_](http://developer.pardot.com/kb/object-field-references/#account) | [read](http://developer.pardot.com/kb/api-version-3/accounts/) | -
[_campaign_](http://developer.pardot.com/kb/object-field-references/#campaign) | [query](http://developer.pardot.com/kb/api-version-3/campaigns/) | [read, update, create](http://developer.pardot.com/kb/api-version-3/campaigns/#using-campaigns)
[_customField_](http://developer.pardot.com/kb/object-field-references/#custom-field) | [query](http://developer.pardot.com/kb/api-version-3/custom-fields/) | [read, update, create, delete](http://developer.pardot.com/kb/api-version-3/custom-fields/#using-custom-fields)
[_customRedirect_](http://developer.pardot.com/kb/object-field-references/#custom-redirect) | [query](http://developer.pardot.com/kb/api-version-3/custom-redirects/) | [read](http://developer.pardot.com/kb/api-version-3/custom-redirects/#using-custom-redirects)
[_email_](http://developer.pardot.com/kb/object-field-references/#email) | [read](http://developer.pardot.com/kb/api-version-3/emails/) | [stats](http://developer.pardot.com/kb/api-version-3/emails/#querying-email-stats), [send](http://developer.pardot.com/kb/api-version-3/emails/#sending-one-to-one-emails)
[_emailClick_](http://developer.pardot.com/kb/object-field-references/#email-clicks) | [query](http://developer.pardot.com/kb/api-version-3/batch-email-clicks/) | -
_emailTemplate_ | [read](http://developer.pardot.com/kb/api-version-3/email-templates/) | [listOneToOne](http://developer.pardot.com/kb/api-version-3/email-templates/#list-one-to-one-email-templates)
[_form_](http://developer.pardot.com/kb/object-field-references/#form) | [query](http://developer.pardot.com/kb/api-version-3/forms/) | [read](http://developer.pardot.com/kb/api-version-3/forms/#using-forms)
[_lifecycleHistory_](http://developer.pardot.com/kb/object-field-references/#lifecycle-history) | [query](http://developer.pardot.com/kb/api-version-3/lifecycle-histories/) | [read](http://developer.pardot.com/kb/api-version-3/lifecycle-histories/#using-lifecycle-histories)
[_lifecycleStage_](http://developer.pardot.com/kb/object-field-references/#lifecycle-stage) | [query](http://developer.pardot.com/kb/api-version-3/lifecycle-stages/) | -
[_listMembership_](http://developer.pardot.com/kb/object-field-references/#list-membership) | [query](http://developer.pardot.com/kb/api-version-3/list-memberships/) | [read, create, update, delete](http://developer.pardot.com/kb/api-version-3/list-memberships/#using-list-memberships)
[_list_](http://developer.pardot.com/kb/object-field-references/#list) | [query](http://developer.pardot.com/kb/api-version-3/lists/) | [read, create, update, delete](http://developer.pardot.com/kb/api-version-3/lists/#using-lists)
[_opportunity_](http://developer.pardot.com/kb/object-field-references/#opportunity) | [query](http://developer.pardot.com/kb/api-version-3/opportunities/) | [read, update, delete, undelete](http://developer.pardot.com/kb/api-version-3/opportunities/#using-opportunities)
[_prospect_](http://developer.pardot.com/kb/object-field-references/#prospect) | [query](http://developer.pardot.com/kb/api-version-3/prospects/) | [assign, unassign, create, batchCreate, read, update, batchUpdate, upsert, batchUpsert, delete](http://developer.pardot.com/kb/api-version-3/prospects/#using-prospects)
[_prospectAccount_](http://developer.pardot.com/kb/object-field-references/#prospect-account) | [query](http://developer.pardot.com/kb/api-version-3/prospect-accounts/) | [create, describe, read, update, assign](http://developer.pardot.com/kb/api-version-3/prospect-accounts/#using-prospect-accounts)
[_tagObject_](http://developer.pardot.com/kb/object-field-references/#tag-object) | [query](http://developer.pardot.com/kb/api-version-3/tag-objects/) | [read](http://developer.pardot.com/kb/api-version-3/tag-objects/#using-tagobjects)
[_tag_](http://developer.pardot.com/kb/object-field-references/#tag) | [query](http://developer.pardot.com/kb/api-version-3/tags/) | [read](http://developer.pardot.com/kb/api-version-3/tags/#using-tags)
[_user_](http://developer.pardot.com/kb/object-field-references/#user) | [query](http://developer.pardot.com/kb/api-version-3/users/) | [read](http://developer.pardot.com/kb/api-version-3/users/#using-users)
[_visitorActivity_](http://developer.pardot.com/kb/object-field-references/#visitor-activity) | [query](http://developer.pardot.com/kb/api-version-3/visitor-activities/) | [read](http://developer.pardot.com/kb/api-version-3/visitor-activities/#using-visitor-activities)
[_visitor_](http://developer.pardot.com/kb/object-field-references/#visitor) | [query](http://developer.pardot.com/kb/api-version-3/visitors/) | [assign, read](http://developer.pardot.com/kb/api-version-3/visitors/#using-visitors)
[_visit_](http://developer.pardot.com/kb/object-field-references/#visit) | [query](http://developer.pardot.com/kb/api-version-3/visits/) | [read](http://developer.pardot.com/kb/api-version-3/visits/#using-visits)

Identifier_field and identifier are  required for operations for using the object, and specify the name and value of the identifier, respectively. 

If result_format is _json_ the function returns a single data frame, using successive API calls with iterative url querystrings to accumulate the results. The returned data frame includes all records selected by the request_pars which should be formatted as a url query string. Iteration uses the API querystring parameter _offset_. The first call uses no offset. If _offset_ is specified as part of the request_pars querystring that value is used for the first call. Successive calls increment the offset by 200. 

Information about call progress is available using the verbose parameter. 1 displays a progress bar. 2 additionally displays call urls and the data structure returned by the first call.

The paRdot wrapper functions are for querying an object.  

**XML response with some configuration**

Use result_format="xml" to obtain the requested data in XML format. 

```
xml_response <- pardot_client(object, operator, identifier_field, identifier, result_format="xml")
```
**Limits**

Pardot Professional edition customers have a limit of 25k API calls per day, and Ultimate edition customers have a limit of 100k API calls per day. See the Pardot knowledge base article [Using the Pardot API](http://help.pardot.com/customer/portal/articles/2128635-using-the-pardot-api)

Pardot also seems to limit the number of results it returns to 100k results at a time for a single type of API call. To retrieve more result use query search criteria parameters like created_after, created_before, id_greater_than and id_less_than in subsequent function calls.
```
# Retrieve data in two parts
df1 <- pardot_visitor_activities(created_after = "20170101", created_before = "20170102")
df2 <- pardot_visitor_activities(created_after = "20170102", created_before = "20170103")
df <- plyr::rbind.fill(df1, df2)
```
