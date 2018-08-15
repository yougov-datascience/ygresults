context("test-postal_replace_fips.R")

## fixing GH issue #2, accepting FIPS codes and postal codes in CD
test_that("cd fips replacement works correctly", {
  repvars <- c("AZ08", "0408", "CA16")
  munged <- postal_replace_fips(repvars)

  expect_equal(munged, c("0408", "0408", "0616"))
})

## Accepting FIPS and postal codes in state
test_that("state fips replacement works correctly",{
    repvars <- c("AZ", "04", "DE")
    munged <- postal_replace_fips(repvars)

    expect_equal(munged, c("04", "04", "10"))
})
