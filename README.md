# 3DShollAnalysis
Matlab/Imaris-based 3D Sholl Analysis

This custom Matlab code is provided as supporting documentation for: 
Farrar, M.J., Kolkman, K.K., and Fetcho, J.R. "Features of the structure, development and activity of the Zebrafish Noradrenergic System explored in new CRISPR transgenic lines", Journal of Comparative Neurology, 2018.

The code assumes that Imaris software has been used to generate a 3-D traced filament data set. The function "generateFilamentData.m" takes the Imaris tracing and creates a ".mat" file containing the coordinates of points on the filament. A connectivity matrix is also added. The location of the soma is added manually, and  must be performed prior to subsequent analysis.

The code "sholl3D.m" performs a 3-D Sholl analysis on the created ".mat" file. This code has the microscope pixel conversion factor, umPerPix, hard-coded and must be edited according to the parameters of the microscope being used.

The code "drawFilaments.m" creates a redrawing of the filament data in 3D or in 2D. The 2D drawing simply omits the z-dimension in all coordinates.
