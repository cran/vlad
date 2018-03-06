context("racusum_arl_sim")

df1 <- data.frame(Parsonnet=c(0L, 0L, 50L, 50L), status = c(0, 1, 0, 1))
coeff1 <- c("(Intercept)" = -3.68, "Parsonnet" = 0.077)
r <- 1
h <- 1

test_that("Input parameter of function", {
  expect_error(racusum_arl_sim(r = 0, coeff1, h, df1),
               "Number of simulation runs 'r' must be a positive integer")
  expect_error(racusum_arl_sim(r, coeff1, h = 0, df1),
               "Control limit 'h' must be a positive numeric value")
})

test_that("Different input values for df", {
  dftest1 <- list(as.matrix(df1), NULL)
  lapply(dftest1, function(x) {
    expect_error(do.call(x, racusum_arl_sim(r, coeff1, h, df = x)),
                 "Provide a dataframe for argument 'df'")})

  dftest2 <- list(data.frame(0L, 1, 1), data.frame(0L), data.frame(NA))
  lapply(dftest2, function(x) {
    expect_error(do.call(x, racusum_arl_sim(r, coeff1, h, df = x)),
                 "Provide a dataframe with two columns for argument 'df'")})

  dftest3 <- list(data.frame(0, 1), data.frame("0", 1), data.frame(NA, 1))
  lapply(dftest3, function(x) {
    expect_error(do.call(x, racusum_arl_sim(r, coeff1, h, df = x)),
                 "First column of dataframe must be of type integer")})

  dftest4 <- list(data.frame(0L, 1L), data.frame(0L, "1L"), data.frame(0L, NA))
  lapply(dftest4, function(x) {
    expect_error(do.call(x, racusum_arl_sim(r, coeff1, h, df = x)),
                 "Second column of dataframe must be of type numeric")})
})

test_that("Different input values for coeff", {
  coefftest <- list(coeff1[1], rep(1, 3), NULL, NA)
  lapply(coefftest, function(x) {
    expect_error(do.call(x, racusum_arl_sim(r, coeff = x, h, df1)),
                 "Model coefficients 'coeff' must be a numeric vector with two elements")})
})

test_that("Different input values for yemp", {
  expect_warning(racusum_arl_sim(r, coeff1, h, df1, yemp = as.character(TRUE)),
                 "Argument 'yemp' must be logical using TRUE as default value")
  expect_warning(racusum_arl_sim(r, coeff1, h, df1, yemp = as.numeric(TRUE)),
                 "Argument 'yemp' must be logical using TRUE as default value")
  expect_warning(racusum_arl_sim(r, coeff1, h, df1, yemp = NA),
                 "Argument 'yemp' must be logical using TRUE as default value")
})