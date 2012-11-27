library(copula)
setwd("D:/Dropbox/Copulas/Matlab/test")

data3 <- as.matrix(read.csv("data/data3d.csv", header=FALSE, sep=","))
data2 <- as.matrix(read.csv("data/data2d.csv", header=FALSE, sep=","))

normal.cop.3 = normalCopula(c(0.18, 0.23, 0.74), dim=3, dispstr="un")
t.cop.3 = tCopula(c(0.37, 0.52, 0.77), df=5, dim=3, dispstr="un")
clayton.cop.3 = archmCopula("clayton", param=0.9912, dim=3)  
gumbel.cop.3 = archmCopula("gumbel", param=1.4529, dim=3)  
clayton.cop.2 = archmCopula("clayton", param=1.4557, dim=2)

to.csv <- function(data, filename) {
  write.table(data, filename, sep=',', row.names=FALSE, col.names=FALSE);
}

testCond <- function(data, cop, dim) {
  y = cCopula(data[,1:dim], cop)
  return (y)
}

# Conditional copulas
to.csv(testCond(data3, normal.cop.3, 2), "data/test_copulacnd_gaussian2d.csv")
to.csv(testCond(data3, normal.cop.3, 3), "data/test_copulacnd_gaussian3d.csv")
to.csv(testCond(data3, t.cop.3, 2), "data/test_copulacnd_t2d.csv")
to.csv(testCond(data3, t.cop.3, 3), "data/test_copulacnd_t3d.csv")
to.csv(testCond(data3, clayton.cop.3, 3), "data/test_copulacnd_clayton3d.csv")
to.csv(testCond(data3, gumbel.cop.3, 3), "data/test_copulacnd_gumbel3d.csv")
to.csv(testCond(data2, clayton.cop.2, 2), "data/test_copulacnd_clayton2d.csv")

# Copula densities
to.csv(dCopula(data3, clayton.cop.3), "data/test_archimpdf_clayton3d.csv")