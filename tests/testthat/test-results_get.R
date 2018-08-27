context("test-results_get.R")

test_that("api retrieves and munges correct data", {
  httptest::with_mock_API({
      df <- results_get("test_20180824", county="04013")
      expect_equal(nrow(df), 429)
      expect_equal(sum(df$votes), 156065)
  })
})
