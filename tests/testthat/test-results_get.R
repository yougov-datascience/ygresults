context("test-results_get.R")

test_that("api retrieves and munges correct data", {
  httptest::with_mock_API({
      df <- results_get("test_20180812", state="04")
      expect_equal(nrow(df), 429)
  })
})
