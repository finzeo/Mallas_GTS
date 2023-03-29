import gmsh 

gmsh.initialize()

# gmsh handles the correct file extension automatically 
gmsh.open("gts_converted.msh")
gmsh.write("gts_cgns.cgns")

gmsh.finalize()

