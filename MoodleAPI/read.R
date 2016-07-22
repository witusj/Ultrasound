library(httr)
library(jsonlite)
library(XML)

user <- "user"
password <- "Eulerepii=-1"
service <- "tt"

url <- "http://ec2-52-16-98-140.eu-west-1.compute.amazonaws.com/login/token.php"
body <- list(username=user, password=password, service=service)
r <- POST(url, body = body)
token <- content(r)[[1]]

## Get courses
url1 <- "http://ec2-52-16-98-140.eu-west-1.compute.amazonaws.com/webservice/rest/server.php?wstoken=923e530808520127fb2361c7da55c2fc&wsfunction=core_course_get_courses&moodlewsrestformat=json"
courses <- fromJSON(url1)

## Get users
url2 <- "http://ec2-52-16-98-140.eu-west-1.compute.amazonaws.com/webservice/rest/server.php?wstoken=923e530808520127fb2361c7da55c2fc&wsfunction=core_enrol_get_enrolled_users&courseid=10&moodlewsrestformat=json"
users <- fromJSON(url2)

## Get grades
url3 <- "http://ec2-52-16-98-140.eu-west-1.compute.amazonaws.com/webservice/rest/server.php?wstoken=923e530808520127fb2361c7da55c2fc&wsfunction=core_grades_get_grades&courseid=10&userids[0]=154&userids[1]=99&moodlewsrestformat=json"
grades <- fromJSON(url3)
grades <- grades$items
item <- grades$grades[[1]]
