@ECHO OFF & TITLE FloorIntSQRT.bat

SETLOCAL EnableDelayedExpansion 

CALL :FLOORINTSQRT %1
REM CALL :CHECKFLOORINTSQRT
GOTO :END

:FLOORINTSQRT
 REM ECHO %0
 SET "arg1=, init=, iter=" 
 SET /A arg1=%1
 IF %arg1% GTR 0 (
   SET /A "init=%arg1%/(11*1024)+40"
   SET /A "iter=!init!"
   FOR /L %%I in (1,1,5) DO (
     set /A "iter=(%arg1%/!iter!+!iter!)/2"
     IF %%I EQU 5 (
       SET /A isqrt=!iter!
       SET /A sqr=!isqrt!*!isqrt!
       IF !sqr! GTR %arg1% (
         SET /A isqrt-=1
         SET /A sqr=!isqrt!*!isqrt!
       )
       ECHO ISQRT(%arg1%^)=!isqrt! check SQR(!isqrt!^) = !sqr! Variable name is isqrt
     )
   )
 )
 IF %arg1% EQU 0 (ECHO Input zero no ISQRT)
 IF %arg1% LSS 0 (ECHO Input negative ISQRT irrational)
GOTO :EOF

:CHECKFLOORINTSQRT
 ECHO %0
 FOR %%C in (-2147483647, -1, 0, 1, 2, 3, 4, 9, 10, 16, 25, 35, 48, 100, 511, 512, 1000, 10000,
            65535, 65536, 100000, 131071, 131072, 262143, 262144, 393215, 393216, 1000000, 2085999,
            2086000, 5000000, 10000000, 100000000, 200000000, 1000000000, 2147395600, 2147483647
   ) DO (  
   CALL :FLOORINTSQRT %%C
 )
GOTO :EOF

:END
