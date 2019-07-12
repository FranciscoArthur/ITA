set MATLAB=D:\MatLab

cd .

if "%1"=="" ("D:\MatLab\bin\win64\gmake"  -f untitled.mk all) else ("D:\MatLab\bin\win64\gmake"  -f untitled.mk %1)
@if errorlevel 1 goto error_exit

exit /B 0

:error_exit
echo The make command returned an error of %errorlevel%
An_error_occurred_during_the_call_to_make
