# paRdot
A simple R package for the Pardot API

### Install
```
devtools::install_github("demgenman/paRdot")
```

### Getting Started:

Make sure to set your Pardot credentials
```
set_credentials('your-username', 'your-password', 'your-user-key')
```

Next, make a **paRdot** api call.
```
df <- pardot_client(object = "prospect", operator = "query", request_pars="created_after=today", result_format="json", verbose = FALSE)
```

**Prebaked dataframes:**

```
df <- pardot_campaigns()
df <- pardot_lists()
df <- pardot_prospects()
df <- pardot_tag_objects()
df <- pardot_tags()
df <- pardot_users()
df <- pardot_visitor_activities()
df <- pardot_visitors()
```

**XML response with some configuration:**

```
xml_response <- pardot_client(object, operator, identifier_field, identifier, result_format="xml")
```

**Data frame from JSON response, with Pardot API call parameters supported:**

```
df <- pardot_client(object, operator, identifier_field=NULL, identifier=NULL, request_pars=NULL, result_format="json", verbose = FALSE)
```

Object is the name of a Pardot object, e.g. prospect, visit, visitorActivity.
Operator is either query or read. In the latter case usually identifier_field and identifier bare required.
If result_format is json the function returns a single data frame, using successive API calls with iterative url querystrings to accumulate the results. The returned data frame includes all records selected by the request_pars which should be formatted as a url query string.
Verbose = TRUE shows the successive call urls and the data structure returned by the first call.
