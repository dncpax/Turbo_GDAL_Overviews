# Turbo_GDAL_Overviews
Building raster overviews with gdal_translate in parallel, in a portion of time taken by gdaladdo

There's a blog post explaining the whole enchilada here:
https://blog.viasig.com/

# TLDR
This script automates creating overviews with 3 parallel gdal_translate commands, instead of using gdaladdo. In limited tests it is 20% faster, and takes 30% less disk space.

Should be simple enough to port to Linux.
