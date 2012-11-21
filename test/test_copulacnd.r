library(copula)

to.csv <- function(data, filename) {
  write.table(data, filename, sep=',', row.names=FALSE, col.names=FALSE);
}

testGaussianCond <- function(dim) {
  data <- as.matrix(read.csv("data/data3d.csv", header=FALSE, sep=","))  
  cop <- normalCopula(c(0.18, 0.23, 0.74), dim = 3, dispstr="un")  
  y = cCopula(data[,1:dim], cop)
  return (y)
}

testStudentCond <- function(dim) {
  data <- as.matrix(read.csv("data/data3d.csv", header=FALSE, sep=","))  
  cop <- tCopula(c(0.37, 0.52, 0.77), df=5, dim = 3, dispstr="un")  
  y = cCopula(data[,1:dim], cop)
  return (y)
}

testArchimCond3D <- function(family, alpha, dim) {
  data <- as.matrix(read.csv("data/data3d.csv", header=FALSE, sep=","))  
  cop <- archmCopula(family, alpha, dim = 3)  
  y = cCopula(data, cop)
  return (y)
}

testArchimCond2D <- function(family, alpha, dim) {
  data <- as.matrix(read.csv("data/data2d.csv", header=FALSE, sep=","))  
  cop <- archmCopula(family, alpha, dim = 2)  
  y = cCopula(data, cop)
  return (y)
}

to.csv(testGaussianCond(2), "data/test_copulacnd_gaussian2d.csv")
to.csv(testGaussianCond(3), "data/test_copulacnd_gaussian3d.csv")
to.csv(testStudentCond(2), "data/test_copulacnd_t2d.csv")
to.csv(testStudentCond(3), "data/test_copulacnd_t3d.csv")
to.csv(testArchimCond3D("clayton", 0.9912, 3), "data/test_copulacnd_clayton3d.csv")
to.csv(testArchimCond3D("gumbel", 1.4529, 3), "data/test_copulacnd_gumbel3d.csv")
to.csv(testArchimCond2D("clayton", 1.4557, 3), "data/test_copulacnd_clayton2d.csv")

testArchimPdf <- function(family, alpha, dim) {
  data <- as.matrix(read.csv("data/data3d.csv", header=FALSE, sep=","))  
  cop <- archmCopula(family, alpha, dim = 3)  
  y = dCopula(data, cop)
  return (y)
}

to.csv(testArchimPdf('clayton', 0.9912, 3), "data/test_archimpdf_clayton3d.csv")

