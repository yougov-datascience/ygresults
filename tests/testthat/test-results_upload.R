context("test-results_upload.R")

mockup <- '{ "precincts":[ { "state":99, "county":999, "cd":99, "name":"FAKELAND",
"office":{ "US House":{ "Foo":{ "party":"rep", "votes":{ "All":1010 } }, "Bar":{
"party":"dem", "votes":{ "All":1234 } } } } }, { "state":99, "county":999,
"cd":99, "name":"FAKE BAPTIST CHURCH", "office":{ "US House":{ "Foo":{
"party":"rep", "votes":{ "All":1456 } }, "Bar":{ "party":"dem", "votes":{
"All":2134 } } } } } ] }'

tdf <- data.frame(
    state = 99,
    county = 999,
    district = 99,
    precinct = c("FAKELAND", "FAKELAND", "FAKE BAPTIST CHURCH", "FAKE BAPTIST CHURCH"),
    office = rep("US House", 4),
    votetype = rep("All", 4),
    candidate = c("Foo", "Bar", "Foo", "Bar"),
    party = c("rep", "dem", "rep", "dem"),
    votes = c(1010, 1234, 1456, 2134)
)

test_that("creates a correctly formatted PUT request", {
    httptest::with_fake_http({
        httptest::expect_PUT(
            object = results_upload(tdf, election_code = "test 20180812"),
            url = "fakeaws.cc/dev/results/test_20180812/write",
            mockup
        )
    })
})
