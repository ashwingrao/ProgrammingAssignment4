install.packages("httpuv")
library(httpuv)
library(httr)
Sys.setenv(GITHUB_CONSUMER_SECRET="597e524550b6cc9dff5fb3a50fd39901b9ac67c2")

# 1. Find OAuth settings for github:
#    http://developer.github.com/v3/oauth/
oauth_endpoints("github")

## Found this on the web
##github <- oauth_endpoint(NULL, "authorize", "access_token",
##  base_url = "https://github.com/login/oauth")

# 2. Register an application at https://github.com/settings/applications;
#    Use any URL you would like for the homepage URL (http://github.com is fine)
#    and http://localhost:1410 as the callback url
#
#    Insert your client ID and secret below - if secret is omitted, it will
#    look it up in the GITHUB_CONSUMER_SECRET environmental variable.
#myapp <- oauth_app("github", key = "644a9e346d5caf938eb0", secret = "597e524550b6cc9dff5fb3a50fd39901b9ac67c2" )
myapp <- oauth_app("github", key = "644a9e346d5caf938eb0")

##
# 3. Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

# 4. Use API
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/users/jtleek/repos", gtoken)
stop_for_status(req)
content(req)

# OR:
req <- with_config(gtoken, GET("https://api.github.com/rate_limit"))
stop_for_status(req)
content(req)

json1 <- content(req, as="text")
json2 <- jsonlite::fromJSON(toJSON(json1))
jsonlite::prettify(json2)

## A better way
data3 <- jsonlite::fromJSON("https://api.github.com/users/jtleek/repos", flatten = TRUE)
cbind(data3$full_name, data3$created_at)

## OR more simply
data3[which(data3$full_name == "jtleek/datasharing"),]$created_at
