#  tests for pyproj-2.3.0-py36h2fd02e8_0 (this is a generated file);
print('===== testing package: pyproj-2.3.0-py36h2fd02e8_0 =====');
print('running run_test.py');
#  --- run_test.py (begin) ---
import os
import sys
import pyproj
pyproj.test()

from pyproj import Proj
Proj(init='epsg:4269')


# Test pyproj_datadir.
if not os.path.isdir(pyproj.datadir.get_data_dir()):
    sys.exit(1)
#  --- run_test.py (end) ---

print('===== pyproj-2.3.0-py36h2fd02e8_0 OK =====');
print("import: 'pyproj'")
import pyproj

