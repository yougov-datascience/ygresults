context("test-utils.R")

test_that("left_pad works", {
  expect_equal(left_pad(10, 4), "0010")
    expect_equal(left_pad(c(10, 8), 2), c("10", "08"))
})
