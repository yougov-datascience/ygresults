context("test-get_state_data.R")

test_that("GET request goes out", {
  httptest::without_internet({
      httptest::expect_GET(get_state_data("test_20180812", state="30"),
                 "fakeaws.cc/dev/results/test_20180812/county/30001")
  })
})
