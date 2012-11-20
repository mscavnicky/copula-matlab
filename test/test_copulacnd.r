library(copula)

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

write.table(testGaussianCond(2), "data/test_copulacnd_gaussian2d.csv", sep=',', row.names=FALSE, col.names=FALSE);
write.table(testGaussianCond(3), "data/test_copulacnd_gaussian3d.csv", sep=',', row.names=FALSE, col.names=FALSE);
write.table(testStudentCond(2), "data/test_copulacnd_t2d.csv", sep=',', row.names=FALSE, col.names=FALSE);
write.table(testStudentCond(3), "data/test_copulacnd_t3d.csv", sep=',', row.names=FALSE, col.names=FALSE);


