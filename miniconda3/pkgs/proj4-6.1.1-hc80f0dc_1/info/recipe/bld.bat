mkdir build && cd build

cmake -G "%CMAKE_GENERATOR%" ^
         -D CMAKE_BUILD_TYPE=Release ^
         -D BUILD_LIBPROJ_SHARED="ON" ^
         -D CMAKE_C_FLAGS="/WX" ^
         -D CMAKE_CXX_FLAGS="/WX" ^
         -D CMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
         %SRC_DIR%
if errorlevel 1 exit 1

cmake --build . --config Release --target install
if errorlevel 1 exit 1

:: For some reason proj now creates a proj_X_Y.lib so we have to update 
:: each recipe each time there is a version change. Copy the lib to proj.lib
FOR /F "tokens=1,2 delims=." %%a IN ("%PKG_VERSION%") DO (
  set PROJ_MAJOR_VERSION=%%a
  set PROJ_MINOR_VERSION=%%b
)
copy %LIBRARY_LIB%\proj_%PROJ_MAJOR_VERSION%_%PROJ_MINOR_VERSION%.lib %LIBRARY_LIB%\proj.lib
if errorlevel 1 exit 1

cd ..
copy /Y data\* %LIBRARY_PREFIX%\\share\\proj
if errorlevel 1 exit 1

del /F /Q %LIBRARY_PREFIX%\\share\\proj\\*.cmake
if errorlevel 1 exit 1

set ACTIVATE_DIR=%PREFIX%\etc\conda\activate.d
set DEACTIVATE_DIR=%PREFIX%\etc\conda\deactivate.d
mkdir %ACTIVATE_DIR%
if errorlevel 1 exit 1
mkdir %DEACTIVATE_DIR%
if errorlevel 1 exit 1

copy %RECIPE_DIR%\scripts\activate.bat %ACTIVATE_DIR%\proj4-activate.bat
if errorlevel 1 exit 1

copy %RECIPE_DIR%\scripts\deactivate.bat %DEACTIVATE_DIR%\proj4-deactivate.bat
if errorlevel 1 exit 1
