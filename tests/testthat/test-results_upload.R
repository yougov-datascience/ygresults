context("test-results_upload.R")

mockup <- get_fixture("expected_requests/multi_post.json")

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
            object = results_upload(tdf, election_code = "test_20180812", county_code="99999")
        )
    })
})
