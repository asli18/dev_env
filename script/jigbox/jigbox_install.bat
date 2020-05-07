@echo off

echo.
echo --- Jigbox initial installation start ---
echo.

:: upgrade pip, pip: py -m pip
pip install --upgrade pip

IF %ERRORLEVEL% NEQ 0 (
    REM pip fail
    echo.
    echo --- pip upgrade fail ---
    echo.
    pause
    exit 1
)

pip install gitpython
pip install sip
pip install PyQt5
pip install numpy
pip install opencv-python
pip install jsonpickle
pip install pyserial
pip install pandas
pip install pandas matplotlib

echo.
echo.
echo --- Jigbox initial installation completed ---
echo.

pause

