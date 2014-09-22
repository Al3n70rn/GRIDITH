################################################################
################################################################
#
# Read example data
#
################################################################
################################################################

mat <- readRDS( 'segfile.RData')


################################################################
################################################################
#
# Rotation and ITH
#
################################################################
################################################################

mystart = start.alphamax.f(mat, colbychrom = TRUE, 
                           dx.eq.dy = TRUE, 
                           force.diag = TRUE)
#We clicked these positions (x, y):
#Two points along a vertical line: 
#  (1.193036,  0.8479729) and (1.243445, 0.6519817)
#Two points along a horizontal line: 
#  (0.9787967, 0.9179698) and (1.1846342, 0.8619723)
#An allelic balance cluster:
#  (0.9493914, 0.9249694)
#The algorithm only needs the clicks to be approximate.
#Make sure the preliminary rotation looks good before proceeding.

plot.transformed(mat, mystart$alpha, 
                 mystart$F, xlim = NULL, ylim = NULL)

mat = setWeights(mat, mystart, weight.constant = 5000000, nmad = 3)

#You may have to adjust weights above and rerun optimization below:
#Often it also helps to add the contraint eqfun = myeqfun
#For some reason solnp() complains about the myeqfun, but the
#results seem good anyway.
mat = optimizeRotation(mat, mystart, UB = c(1, Inf, 0, 0, Inf), 
                        eqfun = NULL)
#Fix cn.cut, cn.cut0, cn.cuttop until regions outside 
#the regular pattern of the main subclone are all grey:
mat = setCutsUnscaled(mat, a.cut0 = 3, a.cuttop = 6.5, a.cut = 7,
                      xlim = c(0,10), ylim = c(0,10))

#Choose cut so that red segments (bottom two panels) seem
#safely distant from the blue segments
mat = subclonalCNdist(mat, cut = 3)

mat = setType(mat, xlim = c(0,21), legend = TRUE)


################################################################
################################################################
################################################################
################################################################