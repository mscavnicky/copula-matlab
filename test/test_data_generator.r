library(copula)
setwd("D:/Dropbox/Copulas/Matlab/test")

data3 <- as.matrix(read.csv("data/data3d.csv", header=FALSE, sep=","))
data2 <- as.matrix(read.csv("data/data2d.csv", header=FALSE, sep=","))
data7 <- as.matrix(read.csv("data/data7d.csv", header=FALSE, sep=","))


normal.cop.2 = normalCopula(c(0.57), dim=2, dispstr="un")
normal.cop.3 = normalCopula(c(0.18, 0.23, 0.74), dim=3, dispstr="un")
t.cop.3 = tCopula(c(0.37, 0.52, 0.77), df=5, dim=3, dispstr="un")
clayton.cop.3 = archmCopula("clayton", param=0.9912, dim=3)  
gumbel.cop.3 = archmCopula("gumbel", param=1.4529, dim=3)
joe.cop.3 = archmCopula("joe", param=1.85, dim=3)
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

# Copula cdfs
to.csv(pCopula(data3, joe.cop.3), "data/test_archim_cdf_joe3d.csv")

# Copula densities
to.csv(dCopula(data3, clayton.cop.3), "data/test_archimpdf_clayton3d.csv")
to.csv(dCopula(data3, joe.cop.3), "data/test_archim_pdf_joe3d.csv")

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
to.csv(rCopula(1000, archmCopula("joe", 1.5, dim=5)), "data/test_copula_rnd_joe.csv");
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
            
# HAC sampling Test
            
hac.clayton <- onacopula("Clayton", C(1.25, 1, C(2, c(2,3))))
hac.gumbel <- onacopula("Gumbel", C(1.25, 1, C(2, c(2,3))))
hac.frank1 <- onacopula("Frank", C(1.25, 1, C(2, c(2,3))))            
hac.frank2 <- onacopula("Frank", C(0.5, 1, C(0.75, c(2,3))))
hac.joe <- onacopula("Joe", C(1.25, 1, C(2, c(2,3))))

to.csv(rnacopula(1000, hac.gumbel), "data/test_hac_rnd_gumbel3d.csv")
to.csv(rnacopula(1000, hac.frank1), "data/test_hac_rnd_frank3d_1.csv")
to.csv(rnacopula(1000, hac.frank2), "data/test_hac_rnd_frank3d_2.csv")
to.csv(rnacopula(1000, hac.clayton), "data/test_hac_rnd_clayton3d.csv")    
to.csv(rnacopula(1000, hac.joe), "data/test_hac_rnd_joe3d.csv")

hac.clayton7 <- onacopula("Clayton", C(1.15, c(), list(  C(1.3, c(1,2)), C(1.4, c(3,4), C(2.2, c(5,6,7))) )))
hac.gumbel7 <- onacopula("Gumbel", C(1.15, c(), list(  C(1.3, c(1,2)), C(1.4, c(3,4), C(2.2, c(5,6,7))) )))
hac.frank7.1 <- onacopula("Frank", C(1.15, c(), list(  C(1.3, c(1,2)), C(1.4, c(3,4), C(2.2, c(5,6,7))) )))
hac.frank7.2 <- onacopula("Frank", C(0.3, c(), list(  C(0.9, c(1,2)), C(0.5, c(3,4), C(0.7, c(5,6,7))) )))
hac.joe7 <- onacopula("Joe", C(1.15, c(), list(  C(1.3, c(1,2)), C(1.4, c(3,4), C(2.2, c(5,6,7))) )))

to.csv(rnacopula(1000, hac.gumbel7), "data/test_hac_rnd_gumbel7d.csv")
to.csv(rnacopula(1000, hac.frank7.1), "data/test_hac_rnd_frank7d_1.csv")
to.csv(rnacopula(1000, hac.frank7.2), "data/test_hac_rnd_frank7d_2.csv")
to.csv(rnacopula(1000, hac.clayton7), "data/test_hac_rnd_clayton7d.csv")
to.csv(rnacopula(1000, hac.joe7), "data/test_hac_rnd_joe7d.csv")

to.csv(pnacopula(hac.clayton7, data7), "data/test_hac_cdf_clayton7d.csv")
to.csv(pnacopula(hac.gumbel7, data7), "data/test_hac_cdf_gumbel7d.csv")
to.csv(pnacopula(hac.frank7, data7), "data/test_hac_cdf_frank7d.csv")
            
to.csv(dnacopula(hac.clayton7, data7), "data/test_hac_pdf_clayton7d.csv")
to.csv(dnacopula(hac.gumbel7, data7), "data/test_hac_pdf_gumbel7d.csv")
to.csv(dnacopula(hac.frank7, data7), "data/test_hac_pdf_frank7d.csv")
            
# HAC Test
h = hac.full(type=HAC_GUMBEL, c("X1", "X2", "X3", "X4", "X5", "X6", "X7", "X8"), c(1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7)) 
            
            
# GOF
U = rCopula(1000, normal.cop.2)
gofCopula(normal.cop.2, U, N=100, method="SnC", estim.method="ml")

          