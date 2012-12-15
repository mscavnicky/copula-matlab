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
to.csv(rtrafo(data3, clayton.cop.3), "data/test_copula_pit_clayton3d.csv")
to.csv(rtrafo(data3, gumbel.cop.3), "data/test_copula_pit_gumbel3d.csv")

# Archimedean Copula's sampling
to.csv(rCopula(1000, archmCopula("clayton", 1.5, dim=2)), "data/test_copula_rnd_clayton2d.csv");

to.csv(rCopula(1000, archmCopula("clayton", 1.5, dim=5)), "data/test_copula_rnd_clayton.csv");
to.csv(rCopula(1000, archmCopula("gumbel", 1.5, dim=5)), "data/test_copula_rnd_gumbel.csv");
to.csv(rCopula(1000, archmCopula("frank", 1.5, dim=5)), "data/test_copula_rnd_frank.csv");
to.csv(rCopula(1000, normal.cop.3), "data/test_copula_rnd_gaussian.csv");

# Kolomogorov-Smirnov experiment
x = rCopula(1000, archmCopula("clayton", 1.5, dim=5)
y = rCopula(1000, archmCopula("clayton", 1.5, dim=5)

ks.test(x[,1], y[,1])
            
# FX Test comparation
            
price2ret <- function(prices) {
  returns = log(1 + diff(prices) / head(prices, -1))
  return (returns)
}

# GOF tests
fx.prices <- as.matrix(read.csv("../../Data/fxdata-small.txt", header=FALSE, sep=","))
fx.returns <- price2ret(fx.prices)
uniform.fx.returns <- pobs(fx.returns, ties.method="max")

normal.cop.fx = normalCopula(c(0.12422, 0.03048, 0.060702, 0.60127, 0.094, 0.09007), dim=4, dispstr="un")
t.cop.fx = tCopula(c(0.11887, 0.024424, 0.048434, 0.61431, 0.093133, 0.093032), df=16.107, dim=4, dispstr="un")
clayton.cop.fx = archmCopula("clayton", param=0.20706, dim=4)  
gumbel.cop.fx = archmCopula("gumbel", param=1.11, dim=4)  
frank.cop.fx = archmCopula("frank", param=0.92933, dim=4)  
            
gofCopula(clayton.cop.fx, uniform.fx.returns, method="SnC", estim.method="ml", N=10)
            
# HAC Test
            
hac.gumbel <- onacopula("Gumbel", C(1.25, 1, C(2, c(2,3))))
to.csv(rnacopula(1000, hac.gumbel), "data/test_hac_rnd_gumbel3d.csv")
hac.frank <- onacopula("Frank", C(1.25, 1, C(2, c(2,3))))
to.csv(rnacopula(1000, hac.frank), "data/test_hac_rnd_frank3d.csv")
hac.clayton <- onacopula("Clayton", C(1.25, 1, C(2, c(2,3))))
to.csv(rnacopula(1000, hac.clayton), "data/test_hac_rnd_frank3d.csv")            
            
          