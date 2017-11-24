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
                    request_pars="created_after=today", result_format="json", verbose = FALSE)
# Using wrapper function for pardot_client()
df <- pardot_prospects(created_after = "today")
```

**Prebaked dataframes**

The functions below are convenient wrappers for pardot_client(). 

```
df <- pardot_account()
df <- pardot_campaigns()
df <- pardot_lifecycle_histories()
df <- pardot_lifecycle_stages()
df <- pardot_list_memberships()
df <- pardot_lists()
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

Object is the name of a Pardot object: _account_, _campaign_, _lifecycleHistory_, _lifecycleStage_, _listMembership_, _list_, _prospect_, _tagObject_, _tag_, _user_, _visitorActivity_, _visitor_, _visit_.

Operator is either _query_ or _read_. The latter usually requires parameters identifier_field and identifier.

If result_format is _json_ the function returns a single data frame, using successive API calls with iterative url querystrings to accumulate the results. The returned data frame includes all records selected by the request_pars which should be formatted as a url query string. Iteration uses the API querystring parameter _offset_. The first call uses no offset. If _offset_ is specified as part of the request_pars querystring that value is used for the first call. Successive calls increment the offset by 200. 

Verbose = TRUE shows the successive call urls and the data structure returned by the first call.

A progress indicator shows call progress. Individual calls are marked by a dot, which corresponds to 200 records received. A number is shown after every 1000 records received.

**XML response with some configuration**

Use result_format="xml" to obtain the requested data in XML format. 

```
xml_response <- pardot_client(object, operator, identifier_field, identifier, result_format="xml")
```

