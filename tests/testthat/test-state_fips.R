context("test-state_fips.R")

td_n <- c(39, 40, 41, 42)
td_c <- c("OH", "OK", "OR", "PA")
td_fl <- list(TRUE, TRUE, FALSE)

test_that("statefips codes/fails correctly", {
    expect_equal(state_fips(td_n), td_c)
    expect_equal(state_fips(td_c), td_n)
    expect_error(state_fips(td_fl))
})


test_that("this can play hockey (canada/territories work)", {
    expect_equal(state_fips(81), 'AB')
    expect_equal(state_fips(66), 'GU')
    expect_equal(state_fips('GU'), 66)
    expect_equal(state_fips('YT'), 93)
})
