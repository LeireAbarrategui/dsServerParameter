source("definition_tests/def_sharing_structure.R")

context("encryptDataDS::expt::correct_parameters")
test_that("variables exists",
{
  .test_sharing_is_created()
  #.test_sharing_receiver()
})



context("encryptDataDS::expt::.define_no_rows")
test_that("define.no.rows",
{
  #numeric and odd number
  expect_equal(is.integer(.define_no_rows()),TRUE)
  expect_equal(.define_no_rows() %% 2 == 1, TRUE)

  #correct range
  no.rows <- .define_no_rows()
  expect_equal((no.rows >= 11 & no.rows <= 21),TRUE)

})

context("encryptDataDS::expt::.define_no_columns")
test_that("define.no.columns",
{
  #numeric and odd number
  expect_equal(is.integer(.define_no_columns()),TRUE)
  expect_equal(.define_no_columns() %% 2 == 1, TRUE)

  #correct range
  no.columns <- .define_no_columns()
  expect_equal((no.columns >= 13 & no.columns <= 23),TRUE)

  no.rows = 15
  #numeric and odd number
  expect_equal(is.integer(.define_no_columns(no.rows = no.rows)),TRUE)
  expect_equal(.define_no_columns(no.rows = no.rows) %% 2 == 1, TRUE)

  #correct range
  no.columns <- .define_no_columns(no.rows = no.rows)
  expect_equal((no.columns >= 13 & no.columns <= 23),TRUE)

  no.rows = "a"
  #numeric and odd number
  expect_equal(.define_no_columns(no.rows = no.rows),0)
})


context("encryptDataDS::expt::.createMatrixRUnif")
test_that(".createMatrixRUnif",
{
    #no argument
    createdMatrix <- .createMatrixRUnif()
    expect_equal(nrow(createdMatrix) == 11, TRUE)
    expect_equal(ncol(createdMatrix) == 13, TRUE)
    expect_equal(all(createdMatrix <= 1, TRUE),TRUE)

    #no row
    createdMatrix <- .createMatrixRUnif(no.rows = 10)
    expect_equal(nrow(createdMatrix) == 11, TRUE)
    expect_equal(ncol(createdMatrix) == 13, TRUE)
    expect_equal(all(createdMatrix <= 1, TRUE),TRUE)

    #no row correct
    createdMatrix <- .createMatrixRUnif(no.rows = 12)
    expect_equal(nrow(createdMatrix) == 12, TRUE)
    expect_equal(ncol(createdMatrix) == 13, TRUE)
    expect_equal(all(createdMatrix <= 1, TRUE),TRUE)

    #no column incorrect
    createdMatrix <- .createMatrixRUnif(no.rows = 13, no.columns =11)
    expect_equal(nrow(createdMatrix) == 11, TRUE)
    expect_equal(ncol(createdMatrix) == 13, TRUE)
    expect_equal(all(createdMatrix <= 1, TRUE),TRUE)

    #no row  and columns correct
    createdMatrix <- .createMatrixRUnif(no.rows = 15, no.columns = 17)
    expect_equal(nrow(createdMatrix) == 15, TRUE)
    expect_equal(ncol(createdMatrix) == 17, TRUE)
    expect_equal(all(createdMatrix <= 1, TRUE),TRUE)

    #no row  and columns, min value correct
    #createdMatrix <- .createMatrixRUnif(no.rows = 15, no.columns = 17, min.value = 12)
   # expect_equal(nrow(createdMatrix) == 15, TRUE)
    #expect_equal(ncol(createdMatrix) == 17, TRUE)
    #expect_equal(all(is.nan(createdMatrix), TRUE),TRUE)


    #no row  and columns, min value incorrect
    createdMatrix <- .createMatrixRUnif(no.rows = 15, no.columns = 17, min.value = -12)
    expect_equal(nrow(createdMatrix) == 15, TRUE)
    expect_equal(ncol(createdMatrix) == 17, TRUE)
    expect_equal(all(createdMatrix >= -12 & createdMatrix <= 1, TRUE),TRUE)

    #no row  and columns, min value, max value correct
    createdMatrix <- .createMatrixRUnif(no.rows = 15, no.columns = 17, min.value = -12, max.value = 298)
    expect_equal(nrow(createdMatrix) == 15, TRUE)
    expect_equal(ncol(createdMatrix) == 17, TRUE)
    expect_equal(all(createdMatrix >= -12 & createdMatrix <= 298, TRUE),TRUE)
})




context("encryptDataDS::expt::.is.structure.valid")
test_that(".is.structure.valid",
{
  #correct structure
  encryptDataDS()
  expect_equal(.is.structure.valid(),TRUE)

  correct.structure  <- list(data = c(1:4),
  concealing.matrix = matrix(1:2,1,1),
  masking.matrix = matrix(1:2,1,1),
  encrypted.matrix = matrix(1:2,1,1),
  index = 3)
  assign("sharing",correct.structure, pos=1)
  expect_equal(.is.structure.valid(),TRUE)

  #incorrect structure
  incorrect.structure <- list()
  assign("sharing",incorrect.structure, pos=1)
  expect_equal(.is.structure.valid(),FALSE)

  incorrect.structure <- list(master.vector = c(1,2,3),
concealing.matrix = matrix(1:2,1,1))
  assign("sharing",incorrect.structure, pos=1)
  expect_equal(.is.structure.valid(),FALSE)
})

context("encryptDataDS::expt::.create.structure.master")
test_that(".create.structure.master",
{
  expected.list <- c("concealing.matrix","masking.matrix")
  
  sharing <- .create.structure.master(4,23)
  expect_equal(is.list(sharing),TRUE)
  expect_equal(all(expected.list %in% names(sharing), TRUE), TRUE)
  expect_equal(length(sharing) == length(expected.list), TRUE)

  expect_equal(is.matrix(sharing$masking.matrix), TRUE)
  expect_equal(is.matrix(sharing$concealing.matrix), TRUE)
})


context("encryptDataDS::expt::.create.structure.receiver")
test_that("received matrix does not exist",
{
  expected.list <- c("concealing.matrix","masking.matrix","received.matrix")
  #the received matrix does not exists
  sharing <- .create.structure.receiver(4,23)
  expect_equal(is.list(sharing),TRUE)
  expect_equal(all(expected.list %in% names(sharing), FALSE), FALSE)
  expect_equal(length(sharing) == 0, TRUE)
  
  expect_equal(is.vector(sharing$master.vector), FALSE)
  expect_equal(is.matrix(sharing$encoded.matrix), FALSE)
  expect_equal(is.matrix(sharing$masking.matrix), FALSE)
  expect_equal(is.matrix(sharing$concealing.matrix), FALSE)
  
  a.list <- list(element = 3.1427)
  assign("sharing",a.list, pos=1)
  sharing <- .create.structure.receiver(4,23)
  expect_equal(is.list(sharing),TRUE)
  expect_equal(all(expected.list %in% names(sharing), FALSE), FALSE)
  expect_equal(length(sharing) == 0, TRUE)
  
  expect_equal(is.vector(sharing$master.vector), FALSE)
  expect_equal(is.matrix(sharing$encoded.matrix), FALSE)
  expect_equal(is.matrix(sharing$masking.matrix), FALSE)
  expect_equal(is.matrix(sharing$concealing.matrix), FALSE)
  
  
})

context("encryptDataDS::expt::.create.structure.receiver")
test_that("received matrix exists",
{
  expected.list <- c("concealing.matrix","masking.matrix","received.matrix")
 
  #simulate an secure exchange of date of phase I and II of the algorithm
  encryptDataDS(master_mode = TRUE)
  data <- getEncodedDataDS()
  sendEncodedDataDS(data$header, data$payload, data$property.a, data$property.b,
                    data$property.c, data$property.d)
  
  sharing <- .create.structure.receiver(4,23)
  expect_equal(is.list(sharing),TRUE)
  expect_equal(all(expected.list %in% names(sharing), TRUE), TRUE)
  expect_equal(length(sharing) >= length(expected.list), TRUE)
  expect_equal(is.matrix(sharing$received.matrix), TRUE)
  expect_equal(is.matrix(sharing$masking.matrix), TRUE)
  expect_equal(is.matrix(sharing$concealing.matrix), TRUE)
})

