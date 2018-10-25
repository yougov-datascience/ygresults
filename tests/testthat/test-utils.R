context("test-utils.R")

test_that("left_pad works", {
  expect_equal(left_pad(10, 4), "0010")
    expect_equal(left_pad(c(10, 8), 2), c("10", "08"))
})

test_that("names are correctly capitalized", {
    expect_equal(capitalize_names("O'HALLERAN"), "O'Halleran")
    expect_equal(capitalize_names("murcasel-powell"), "Murcasel-Powell")
})


test_that("schema precinct names return", {
    expect_true("0008 AHWATUKEE" %in% schema_precincts("04013"))
})
