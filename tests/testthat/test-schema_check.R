context("test-schema_check.R")

prid <- data.frame(
    candidate = c("Foo", "Bar"),
    party = c("Dem", "Dem"),
    precinct = "hi mom",
    votetype = "All",
    votes = sample(1:100, 2),
    office = c("US House - Dem", "US House - Dem"),
    district = 8,
    state = 04,
    county = 019,
    stringsAsFactors = FALSE
)

test_that("results_schema accepts primary columns", {
    expect_is(
        schema_check(prid, is_primary=TRUE), "data.frame")
})
