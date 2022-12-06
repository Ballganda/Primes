@ECHO off & TITLE NoFocusEngineer

rem internate tel me i ned dis
SETLOCAL EnableDelayedExpansion

rem Record time started
SET TIMESTART=%TIME% 

SET NMAX=%1

CALL :FLOORINTSQRT %NMAX%
CALL :SIEVE
CALL :ENUMPRIMES
CALL :COUNTPRIMES
SET TIMEFINISH=%TIME%
CALL :CONVERTTIMESECONDS TIMESTART TIMESTARTSEC
CALL :CONVERTTIMESECONDS TIMEFINISH TIMEFINISHSEC
CALL :GETELAPSED
GOTO :END

:SIEVE
   ECHO %0
   SET COMPCOUNT=0
   FOR /L %%L IN (3,2,!isqrt!) DO (
      SET /P _DUMMY=%%L <NUL
      IF NOT DEFINED %%L (
         SET /A START=%%L * %%L
         SET /A STEP=%%L * 2
         FOR /L %%V IN (!START!,!STEP!,!NMAX!) DO SET %%V=~
         )
      )
   ECHO.
   GOTO :EOF

:COUNTPRIMES
   SET COMPCOUNT=0
   FOR /F "TOKENS=*" %%A IN ('SET ^| FIND "=~" ^| FIND /V /C ""') DO SET COMPCOUNT=%%A
   SET /A PRIMECOUNT=((NMAX + 1) / 2) - COMPCOUNT
   ECHO PRIMECOUNT=!PRIMECOUNT!
   GOTO :EOF

:ENUMPRIMES
   ECHO %0
   SET /P _DUMMY=2 <NUL
   FOR /L %%L IN (3,2,!NMAX!) DO (
      IF NOT DEFINED %%L SET /P _DUMMY=%%L <NUL
      )
   ECHO.
   GOTO :EOF
   
:FLOORINTSQRT
 ECHO %0
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
       ECHO FLOORISQRT(%arg1%^)=!isqrt!
     )
   )
 )
 IF %arg1% EQU 0 (ECHO Input zero no ISQRT)
 IF %arg1% LSS 0 (ECHO Input negative ISQRT irrational)
GOTO :EOF

:CONVERTTIMESECONDS
 ECHO %0
 SET T=!%1!
 SET T=!T::0=:!
 SET T=!T:.0=.!
   FOR /F "TOKENS=1-4 DELIMS=:." %%W IN ("!T!") DO (
     SET /A %2=%%W * 360000 + %%X * 6000 + %%Y * 100 + %%Z
   )
GOTO :EOF

:GETELAPSED
 ECHO %0
   SET /A ELAPSED=TIMEFINISHSEC - TIMESTARTSEC
   SET /A WHOLES=ELAPSED / 100
   SET MILLIS=!ELAPSED:~-2!0
   IF "!ELAPSED!" LSS "0" (
      SET /A ELAPSED=ELAPSED + (24 * 360000)
      )
   ECHO TimeElapsed=!WHOLES!.!MILLIS! Seconds
GOTO :EOF

:END
