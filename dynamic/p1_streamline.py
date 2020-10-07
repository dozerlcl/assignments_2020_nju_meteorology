# from pyvista import examples
# examples.plot_wave()
import pyvista as pv
import numpy as np
from pyvista import examples
nx = 20
ny = 15
nz = 5

origin = (-(nx - 1)*0.1/2, -(ny - 1)*0.1/2, -(nz - 1)*0.1/2)
mesh = pv.UniformGrid((nx, ny, nz), (.1, .1, .1), origin)
x = mesh.points[:, 0]
y = mesh.points[:, 1]
z = mesh.points[:, 2]
vectors = np.empty((mesh.n_points, 3))
vectors[:, 0] = np.sin(np.pi * x) * np.cos(np.pi * y) * np.cos(np.pi * z)
vectors[:, 1] = -np.cos(np.pi * x) * np.sin(np.pi * y) * np.cos(np.pi * z)
vectors[:, 2] = (np.sqrt(3.0 / 3.0) * np.cos(np.pi * x) * np.cos(np.pi * y) *
                 np.sin(np.pi * z))

mesh['vectors'] = vectors
###############################################################################
stream, src = mesh.streamlines('vectors', return_source=True,
                               terminal_speed=0.0, n_points=200,
                               source_radius=0.1)
###############################################################################
cpos = [(1.2, 1.2, 1.2), (-0.0, -0.0, -0.0), (0.0, 0.0, 1.0)]
# mesh.plot(screenshot="test1.png")
pv.plot(stream,cpos=cpos)
# plotter = pv.Plotter()    # instantiate the plotter
# plotter.add_mesh(mesh)    # add a mesh to the scene
# cpos = plotter.show()     # show the rendering window
# u=(-10.0sin(N.xpi/15000)cos(N.ypi/15000)cos(N.zpi/15000) + 10.0sqrt(3)sin(N.ypi/15000)sin(N.zpi/15000)cos(N.xpi/15000) + 15sin(sqrt(3)pi(N.z - 7500)/15000))N.i 
# v=(10.0sqrt(3)sin(N.xpi/15000)sin(N.zpi/15000)cos(N.ypi/15000) - 10.0sin(N.ypi/15000)cos(N.xpi/15000)cos(N.zpi/15000) + 15cos(sqrt(3)*pi(N.z - 7500)/15000))N.j 
# w=(20.0sin(N.zpi/15000)cos(N.xpi/15000)cos(N.ypi/15000))N.k