% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/encryptDataDS.R
\name{encryptDataDS}
\alias{encryptDataDS}
\title{encrypt some data on the server}
\usage{
encryptDataDS(master_mode = TRUE, preserve_mode = FALSE)
}
\arguments{
\item{master_mode}{Boolean argument. It indicates the mode of encryption. By default, set to TRUE.}

\item{preserve_mode}{Boolean argument. It indicates to presever some data exchanged previously between servers. By default, set to FALSE.}
}
\description{
This server function uses some matrices operations to encrypts some data required to exchange a parameter securely between two
DataSHIELD server.
}
\details{

}
