context("multivariate_change")


# prepare data ----------------------------------------


# Load our example dataset
data("pplots", package = "codyn") 

#make a dataset with no treatments
dat1 <- subset(pplots, treatment == "N1P0")

#make missing abundance
bdat <- dat1
bdat$relative_cover[1] <- NA

#repeat a species
x <- c("N1P0", 25, 1, 2002, "senecio plattensis", 0.002123142)
bdat2 <- rbind(x, dat1)

# run tests -------------------------------------------


test_that("multivariate_change function returns correct result", {
  
  #test the returned result with default setting, no treatment
  myresults1 <- multivariate_change(dat1, time.var = "year",
                           abundance.var = "relative_cover",
                           species.var = "species",
                           replicate.var = "plot")
  
  
  expect_is(myresults1, "data.frame")
  expect_equal(nrow(myresults1), 3)
  expect_equal(ncol(myresults1), 4)
  expect_equal(myresults1$composition_change[1], 0.1244439, tolerance = 0.00001)
  expect_equal(myresults1$dispersion_change[1], 0.03804344, tolerance = 0.000001)

  #test that it works with treatment
  myresults2 <- multivariate_change(pplots, abundance.var = "relative_cover",
                                    replicate.var = "plot",
                                    species.var = "species",
                                    time.var = "year",
                                    treatment.var = "treatment")
  
  expect_equal(nrow(myresults2), 9)
  expect_equal(ncol(myresults2), 5)
  
  #test that it works with treatment and reference year
  myresults3 <- multivariate_change(pplots, abundance.var = "relative_cover",
                                    replicate.var = "plot",
                                    species.var = "species",
                                    time.var = "year",
                                    treatment.var = "treatment",
                                    reference.time = 2002)
  
  expect_equal(nrow(myresults3), 9)
  expect_equal(ncol(myresults3), 5)
  
  
  #test that is doesn't work with missing abundance
  expect_error(multivariate_change(bdat, abundance.var = "relative_cover",
                               replicate.var = "plot",
                               species.var = "species",
                               time.var = "year"), "Abundance column contains missing values")
  
  #test that is doesn't work with a repeated species
  expect_error(multivariate_change(bdat2, abundance.var = "relative_cover",
                               replicate.var = "plot",
                               species.var = "species",
                               time.var = "year"), "Multiple records for one or more species found at:\n year   plot\n \"2002\" \"25\"")

  # imaginary distance generates warning
  df <- data.frame(
    t = rep(0:1, each = 6),
    r = rep(0:2, each = 2),
    s = rep(c('a', 'b'), 6),
    a = c(0, 2, 1, 2, 1, 0, 1, 2, 1, 2, 1, 2)
  )
  expect_warning(multivariate_change(df,
    time.var = 't', replicate.var = 'r', species.var = 's', abundance.var = 'a'))
})
