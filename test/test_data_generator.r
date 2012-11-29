library(copula)
setwd("D:/Dropbox/Copulas/Matlab/test")

data3 <- as.matrix(read.csv("data/data3d.csv", header=FALSE, sep=","))
data2 <- as.matrix(read.csv("data/data2d.csv", header=FALSE, sep=","))

normal.cop.2 = normalCopula(c(0.57), dim=2, dispstr="un")
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

# Rosenblatt's transform
to.csv(rtrafo(data2, normal.cop.2), "data/test_copula_pit_gaussian2d.csv")
to.csv(rtrafo(data3, normal.cop.3), "data/test_copula_pit_gaussian3d.csv")

# Archimedean Copula's sampling
to.csv(rCopula(1000, archmCopula("clayton", 1.5, dim=2)), "data/test_copula_rnd_clayton2d.csv");

to.csv(rCopula(1000, archmCopula("clayton", 1.5, dim=5)), "data/test_copula_rnd_clayton.csv");
to.csv(rCopula(1000, archmCopula("gumbel", 1.5, dim=5)), "data/test_copula_rnd_gumbel.csv");
to.csv(rCopula(1000, archmCopula("frank", 1.5, dim=5)), "data/test_copula_rnd_frank.csv");
to.csv(rCopula(1000, normal.cop.3), "data/test_copula_rnd_gaussian.csv");

x = rCopula(1000, archmCopula("clayton", 1.5, dim=5)
y = rCopula(1000, archmCopula("clayton", 1.5, dim=5)

ks.test(x[,1], y[,1])
          