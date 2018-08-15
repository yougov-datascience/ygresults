context("test-results_upload.R")

mockup <- '{"precincts":[{"state":99,"county":999,"cd":99,"name":"FAKE BAPTIST CHURCH","office":{"US House":{"Bar":{"party":"Dem","votes":{"All":2134}},"Foo":{"party":"Rep","votes":{"All":1456}}}}},{"state":99,"county":999,"cd":99,"name":"FAKELAND","office":{"US House":{"Bar":{"party":"Dem","votes":{"All":1234}},"Foo":{"party":"Rep","votes":{"All":1010}}}}}]}'

tdf <- data.frame(
    state = 99,
    county = 999,
    district = 99,
    precinct = c("FAKELAND", "FAKELAND", "FAKE BAPTIST CHURCH", "FAKE BAPTIST CHURCH"),
    office = rep("US House", 4),
    votetype = rep("All", 4),
    candidate = c("Foo", "Bar", "Foo", "Bar"),
    party = c("Rep", "Dem", "Rep", "Dem"),
    votes = c(1010, 1234, 1456, 2134),
    stringsAsFactors = FALSE
)

test_that("creates a correctly formatted PUT request", {
    httptest::with_fake_http({
        httptest::expect_PUT(
            object = results_upload(tdf, election_code = "test_20180812"),
            url = "fakeaws.cc/dev/results/test_20180812/write",
            mockup
        )
    })
})
