context("test-raw_download.R")

test_that("correct file is pinged", {
    httptest::with_mock_api({
        d <- raw_download("te_19700101", "45666")
        expect_equal(nrow(d), 150)
        expect_named(d, names(iris))
    })
})

# test_that("compressed file is correctly unpacked", {
#     httptest::with_mock_api({
#         d <- raw_download("te_19700101", "78901")
#         expect_equal(nrow(d), 150)
#         expect_named(d, names(iris))
#     })
# })
#
# test_that("compressed json is correctly unpacked", {
#     httptest::with_mock_api({
#         d <- raw_download("te_19700101", "12121")
#         expect_is(d, 'list')
#     })
# })
