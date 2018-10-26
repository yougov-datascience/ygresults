context("test-value_check.R")

good_pct <- data.frame(
    candidate = c("Foo", "Bar"),
    party = c("Dem", "Dem"),
    precinct = "743",
    votetype = "All",
    votes = sample(1:100, 2),
    office = c("US House - Dem", "US House - Dem"),
    state = 12,
    county = 86,
    stringsAsFactors = FALSE
)

test_that("no warnings from correct precinct", {
  expect_null({
      precinct_check(good_pct, "12086")
  })
})

bad_pct <- data.frame(
    candidate = c("Foo", "Bar"),
    party = c("Dem", "Dem"),
    precinct = "nooooooooo",
    votetype = "All",
    votes = sample(1:100, 2),
    office = c("US House - Dem", "US House - Dem"),
    state = 12,
    county = 86,
    stringsAsFactors = FALSE
)

test_that("warning on bad precinct", {
    expect_warning({
        precinct_check(bad_pct, "12086")
    })
})


good_cand <- data.frame(
    candidate = c("Cottrell", "Webster", "Gillum", "Nelson"),
    precinct = "743",
    votetype = "All",
    votes = sample(1:100, 2),
    office = c("US House", "US House", "Governor", "US Senate"),
    state = 12,
    county = 86,
    district = 11,
    stringsAsFactors = FALSE
)

test_that("no warning on good cands", {
    expect_null({
        candidate_check(good_cand, "12086")
    })
})


bad_cand <- data.frame(
    candidate = c("Cottrell", "Webster", "Gillum", "Nelson"),
    precinct = "743",
    votetype = "All",
    votes = sample(1:100, 2),
    office = rev(c("US House", "US House", "Governor", "US Senate")),
    state = 12,
    county = 86,
    district = 11,
    stringsAsFactors = FALSE
)


test_that("yes warning on bad cands", {
    expect_warning({
        candidate_check(bad_cand, "12086")
    })
})

