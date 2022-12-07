@ECHO off & SETLOCAL EnableDelayedExpansion

CALL :MAIN
EXIT /B

:MAIN
CALL :WINDOWSETTINGS
CALL :SETINPUT %1
SET TIMESTART=%TIME%
CALL :FLOORINTSQRT %NMAX%
CALL :SIEVE
REM CALL :LISTPRIMES
REM CALL :COUNTPRIMES
SET TIMEFINISH=%TIME%
CALL :CONVERTTIMESECONDS TIMESTART TIMESTARTSEC
CALL :CONVERTTIMESECONDS TIMEFINISH TIMEFINISHSEC
CALL :GETELAPSED
EXIT /B

:WINDOWSETTINGS
	CLS
	color 02
	TITLE NoFocusEngineer
EXIT /B

:SETINPUT
	REM Set the default value of NMAX to 1000
	SET NMAX=10000
	REM Check if the first command-line argument is provided
	IF "%1" NEQ "" (
		REM Check if the argument is a positive integer
		IF 1%1 EQU +1%1 (
			REM Set NMAX to the value of the first command-line argument
			SET NMAX=%1
		) ELSE (
		ECHO [ERROR] CMD argument %1 is invalid
		ECHO [RECOVERING] Using default %NMAX%
		)
	)
	REM                 Use this ruler to verify 80 character max line width
	REM          10        20        30        40        50        60        70        80
	REM  12345678901234567890123456789012345678901234567890123456789012345678901234567890
	Echo  ==============================================================================
	Echo  ^|                     BATCH CMD SIEVE OF ERATOSTHENES                        ^|
	Echo  ^|                                  WITH                                      ^|
	Echo  ^|                  SQUAREROOT AND COMPOSITE OPTIMIZATIONS                    ^|
	Echo  ==============================================================================
	ECHO.
EXIT /B

:SIEVE
   ECHO %0 OF ERATOSTHENES RUNNING...
   CALL :BANNERCHAR ..PLEASE.. 2>NUL
   CALL :BANNERCHAR ..STAND... 2>NUL
   CALL :BANNERCHAR ....BY.... 2>NUL
   ECHO 	GENERATING COMPOSITES
   FOR /L %%L IN (3,2,!isqrt!) DO (
      <NUL SET /P "_PRINT=%%L "
	  IF NOT DEFINED %%L (
         SET /A START=%%L * %%L
         SET /A STEP=%%L * 2
         FOR /L %%V IN (!START!,!STEP!,!NMAX!) DO SET %%V=~
       )
    )
	ECHO.
EXIT /B

:LISTPRIMES
   ECHO %0
   <NUL SET /P "_PRINT=2 "
   REM ECHO 2
   FOR /L %%L IN (3,2,!NMAX!) DO (
      IF NOT DEFINED %%L (
		<NUL SET /P "_PRINT=%%L "
		REM ECHO %%L
		)
    )
	ECHO.
EXIT /B

:COUNTPRIMES
   ECHO %0
   SET COMPCOUNT=0
   FOR /F "TOKENS=*" %%A IN ('SET ^| FINDSTR /R "=~" ^| FIND /V /C ""') DO SET COMPCOUNT=%%A
   SET /A PRIMECOUNT=((%NMAX% + 1) / 2) - %COMPCOUNT%
   ECHO 	PRIMECOUNT=!PRIMECOUNT!
EXIT /B
   
:FLOORINTSQRT
 ECHO %0 RUNNING SQRT OPTIMIZATION
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
       ECHO 	FLOORISQRT(%arg1%^)=!isqrt!
     )
   )
 )
EXIT /B

:CONVERTTIMESECONDS
 SET T=!%1!
 SET T=!T::0=:!
 SET T=!T:.0=.!
   FOR /F "TOKENS=1-4 DELIMS=:." %%W IN ("!T!") DO (
     SET /A %2=%%W * 360000 + %%X * 6000 + %%Y * 100 + %%Z
   )
EXIT /B

:GETELAPSED
 ECHO %0
   SET /A ELAPSED=TIMEFINISHSEC - TIMESTARTSEC
   SET /A WHOLES=ELAPSED / 100
   SET MILLIS=!ELAPSED:~-2!0
   IF "!ELAPSED!" LSS "0" (
      SET /A ELAPSED=ELAPSED + (24 * 360000)
      )
   ECHO 	TimeElapsed=!WHOLES!.!MILLIS! Seconds
EXIT /B

:BANNERCHAR
SETLOCAL
IF [%1] NEQ [] goto s_start
Echo   Syntax  
Echo       BANNER string
Echo           Where string is the text or numbers to be displayed
Echo.
EXIT /B
   :s_start
      SET _length=0
      SET _sentence=%*

      REM Get the length of the sentence
      SET _substring=%_sentence%
   :s_loop
      IF not defined _substring GOTO :s_result
      REM remove the first char from _substring (until it is null)
      SET _substring=%_substring:~1%
      SET /A _length+=1
      GOTO s_loop
      
   :s_result
      SET /A _length-=1

      REM Truncate text to fit the window size
      REM assuming average char is 6 digits wide
      for /f "tokens=2" %%G in ('mode ^|find "Columns"') do set/a _window=%%G/6
      IF %_length% GTR %_window% set _length=%_window% 

      REM Step through each digit of the sentence and store in a set of variables
      FOR /L %%G IN (0,1,%_length%) DO call :s_build %%G
	  
		REM Now Echo all the variables
		ECHO.
		ECHO.%_1%
		ECHO.%_2%
		ECHO.%_3%
		ECHO.%_4%
		ECHO.%_5%
		ECHO.%_6%
		ECHO.%_7%
		REM ECHO.
   EXIT /B

   :s_build
      REM get the next character
      CALL SET _digit=%%_sentence:~%1,1%%%
      REM Add the graphics for this digit to the variables
      IF "%_digit%"==" " (CALL :s_space) ELSE (CALL :s_%_digit%)
   EXIT /B
   
   REM  Pad digits to -->
   :s_0
      (SET _1=%_1% ####)
      (SET _2=%_2% #  #)
      (SET _3=%_3% #  #)
      (SET _4=%_4% #  #)
      (SET _5=%_5% #  #)
      (SET _6=%_6% #  #)
      (SET _7=%_7% ####)
   EXIT /B
   
   :s_1
   REM  Pad digits to -->
      (SET _1=%_1%  ## )
      (SET _2=%_2%   # )
      (SET _3=%_3%   # )
      (SET _4=%_4%   # )
      (SET _5=%_5%   # )
      (SET _6=%_6%   # )
      (SET _7=%_7% ####)
   EXIT /B
   
   :s_2
   REM  Pad digits to -->
      (SET _1=%_1% ####)
      (SET _2=%_2% #  #)
      (SET _3=%_3%    #)
      (SET _4=%_4% ####)
      (SET _5=%_5% #   )
      (SET _6=%_6% #  #)
      (SET _7=%_7% ####)
   EXIT /B
   
   :s_3
   REM  Pad digits to -->
      (SET _1=%_1% ####)
      (SET _2=%_2%    #)
      (SET _3=%_3%    #)
      (SET _4=%_4% ####)
      (SET _5=%_5%    #)
      (SET _6=%_6%    #)
      (SET _7=%_7% ####)
   EXIT /B
   
   :s_4
   REM  Pad digits to -->
      (SET _1=%_1% #  #)
      (SET _2=%_2% #  #)
      (SET _3=%_3% #  #)
      (SET _4=%_4% ####)
      (SET _5=%_5%    #)
      (SET _6=%_6%    #)
      (SET _7=%_7%    #)
   EXIT /B
   
   :s_5
   REM  Pad digits to -->
      (SET _1=%_1% ####)
      (SET _2=%_2% #   )
      (SET _3=%_3% #   )
      (SET _4=%_4% ####)
      (SET _5=%_5%    #)
      (SET _6=%_6% #  #)
      (SET _7=%_7% ####)
   EXIT /B
   
   :s_6
   REM  Pad digits to -->
      (SET _1=%_1% ##  )
      (SET _2=%_2% #   )
      (SET _3=%_3% #   )
      (SET _4=%_4% ####)
      (SET _5=%_5% #  #)
      (SET _6=%_6% #  #)
      (SET _7=%_7% ####)
   EXIT /B
   
   :s_7
   REM  Pad digits to -->
      (SET _1=%_1% ####)
      (SET _2=%_2% #  #)
      (SET _3=%_3%    #)
      (SET _4=%_4%   ##)
      (SET _5=%_5%   # )
      (SET _6=%_6%   # )
      (SET _7=%_7%   # )
   EXIT /B
   
   :s_8
   REM  Pad digits to -->
      (SET _1=%_1% ####)
      (SET _2=%_2% #  #)
      (SET _3=%_3% #  #)
      (SET _4=%_4% ####)
      (SET _5=%_5% #  #)
      (SET _6=%_6% #  #)
      (SET _7=%_7% ####)
   EXIT /B
   
   :s_9
   REM  Pad digits to -->
      (SET _1=%_1% ####)
      (SET _2=%_2% #  #)
      (SET _3=%_3% #  #)
      (SET _4=%_4% ####)
      (SET _5=%_5%    #)
      (SET _6=%_6%    #)
      (SET _7=%_7%    #)
   EXIT /B
   
   :s_-
   REM  Pad digits to -->
      (SET _1=%_1%     )
      (SET _2=%_2%     )
      (SET _3=%_3%     )
      (SET _4=%_4% ####)
      (SET _5=%_5%     )
      (SET _6=%_6%     )
      (SET _7=%_7%     )
   EXIT /B
   
   :s_.
   REM  Pad digits to -->
      (SET _1=%_1%     )
      (SET _2=%_2%     )
      (SET _3=%_3%     )
      (SET _4=%_4%     )
      (SET _5=%_5%     )
      (SET _6=%_6%     )
      (SET _7=%_7%  #  )
   EXIT /B
   
   :s_a
   REM  Pad digits to -->
      (SET _1=%_1%  ## )
      (SET _2=%_2% #  #)
      (SET _3=%_3% #  #)
      (SET _4=%_4% ####)
      (SET _5=%_5% #  #)
      (SET _6=%_6% #  #)
      (SET _7=%_7% #  #)
   EXIT /B
   
   :s_b
   REM  Pad digits to -->
      (SET _1=%_1% ### )
      (SET _2=%_2% #  #)
      (SET _3=%_3% #  #)
      (SET _4=%_4% ####)
      (SET _5=%_5% #  #)
      (SET _6=%_6% #  #)
      (SET _7=%_7% ### )
   EXIT /B
   
   :s_c
   REM  Pad digits to -->
      (SET _1=%_1%  ## )
      (SET _2=%_2% #  #)
      (SET _3=%_3% #   )
      (SET _4=%_4% #   )
      (SET _5=%_5% #   )
      (SET _6=%_6% #  #)
      (SET _7=%_7%  ## )
   EXIT /B
   
   :s_d
   REM  Pad digits to -->
      (SET _1=%_1% ### )
      (SET _2=%_2% #  #)
      (SET _3=%_3% #  #)
      (SET _4=%_4% #  #)
      (SET _5=%_5% #  #)
      (SET _6=%_6% #  #)
      (SET _7=%_7% ### )
   EXIT /B
   
   :s_e
   REM  Pad digits to -->
      (SET _1=%_1% ####)
      (SET _2=%_2% #   )
      (SET _3=%_3% #   )
      (SET _4=%_4% ### )
      (SET _5=%_5% #   )
      (SET _6=%_6% #   )
      (SET _7=%_7% ####)
   EXIT /B
   
   :s_f
   REM  Pad digits to -->
      (SET _1=%_1% ####)
      (SET _2=%_2% #   )
      (SET _3=%_3% #   )
      (SET _4=%_4% ### )
      (SET _5=%_5% #   )
      (SET _6=%_6% #   )
      (SET _7=%_7% #   )
   EXIT /B

   :s_g
   REM  Pad digits to -->
      (SET _1=%_1%  ## )
      (SET _2=%_2% #  #)
      (SET _3=%_3% #   )
      (SET _4=%_4% #   )
      (SET _5=%_5% # ##)
      (SET _6=%_6% #  #)
      (SET _7=%_7%  ## )
   EXIT /B

   :s_h
   REM  Pad digits to -->
      (SET _1=%_1% #  #)
      (SET _2=%_2% #  #)
      (SET _3=%_3% #  #)
      (SET _4=%_4% ####)
      (SET _5=%_5% #  #)
      (SET _6=%_6% #  #)
      (SET _7=%_7% #  #)
   EXIT /B

   :s_i
   REM  Pad digits to -->
      (SET _1=%_1%  # )
      (SET _2=%_2%  # )
      (SET _3=%_3%  # )
      (SET _4=%_4%  # )
      (SET _5=%_5%  # )
      (SET _6=%_6%  # )
      (SET _7=%_7%  # )
   EXIT /B

   :s_j
   REM  Pad digits to -->
      (SET _1=%_1% ####)
      (SET _2=%_2%   # )
      (SET _3=%_3%   # )
      (SET _4=%_4%   # )
      (SET _5=%_5%   # )
      (SET _6=%_6%   # )
      (SET _7=%_7% ##  )
   EXIT /B

   :s_k
   REM  Pad digits to -->
      (SET _1=%_1% #   )
      (SET _2=%_2% #  #)
      (SET _3=%_3% # # )
      (SET _4=%_4% ##  )
      (SET _5=%_5% ##  )
      (SET _6=%_6% # # )
      (SET _7=%_7% #  #)
   EXIT /B

   :s_l
   REM  Pad digits to -->
      (SET _1=%_1% #   )
      (SET _2=%_2% #   )
      (SET _3=%_3% #   )
      (SET _4=%_4% #   )
      (SET _5=%_5% #   )
      (SET _6=%_6% #   )
      (SET _7=%_7% ####)
   EXIT /B

   :s_m
   REM  Pad digits to --->
      (SET _1=%_1% #   #)
      (SET _2=%_2% ## ##)
      (SET _3=%_3% # # #)
      (SET _4=%_4% # # #)
      (SET _5=%_5% #   #)
      (SET _6=%_6% #   #)
      (SET _7=%_7% #   #)
   EXIT /B

   :s_n
   REM  Pad digits to --->
      (SET _1=%_1% #   #)
      (SET _2=%_2% ##  #)
      (SET _3=%_3% ##  #)
      (SET _4=%_4% # # #)
      (SET _5=%_5% #  ##)
      (SET _6=%_6% #  ##)
      (SET _7=%_7% #   #)
   EXIT /B

   :s_o
   REM  Pad digits to -->
      (SET _1=%_1%  ## )
      (SET _2=%_2% #  #)
      (SET _3=%_3% #  #)
      (SET _4=%_4% #  #)
      (SET _5=%_5% #  #)
      (SET _6=%_6% #  #)
      (SET _7=%_7%  ## )
   EXIT /B

   :s_p
   REM  Pad digits to -->
      (SET _1=%_1% ### )
      (SET _2=%_2% #  #)
      (SET _3=%_3% #  #)
      (SET _4=%_4% ### )
      (SET _5=%_5% #   )
      (SET _6=%_6% #   )
      (SET _7=%_7% #   )
   EXIT /B

   :s_q
   REM  Pad digits to -->
      (SET _1=%_1%  ## )
      (SET _2=%_2% #  #)
      (SET _3=%_3% #  #)
      (SET _4=%_4% #  #)
      (SET _5=%_5% #  #)
      (SET _6=%_6% # ##)
      (SET _7=%_7%  # #)
   EXIT /B

   :s_r
   REM  Pad digits to -->
      (SET _1=%_1% ### )
      (SET _2=%_2% #  #)
      (SET _3=%_3% #  #)
      (SET _4=%_4% ### )
      (SET _5=%_5% # # )
      (SET _6=%_6% #  #)
      (SET _7=%_7% #  #)
   EXIT /B

   :s_s
   REM  Pad digits to -->
      (SET _1=%_1%  ###)
      (SET _2=%_2% #   )
      (SET _3=%_3% #   )
      (SET _4=%_4%  ## )
      (SET _5=%_5%    #)
      (SET _6=%_6%    #)
      (SET _7=%_7% ### )
   EXIT /B

   :s_t
   REM  Pad digits to -->
      (SET _1=%_1% ###)
      (SET _2=%_2%  # )
      (SET _3=%_3%  # )
      (SET _4=%_4%  # )
      (SET _5=%_5%  # )
      (SET _6=%_6%  # )
      (SET _7=%_7%  # )
   EXIT /B

   :s_u
   REM  Pad digits to -->
      (SET _1=%_1% #  #)
      (SET _2=%_2% #  #)
      (SET _3=%_3% #  #)
      (SET _4=%_4% #  #)
      (SET _5=%_5% #  #)
      (SET _6=%_6% #  #)
      (SET _7=%_7%  ## )
   EXIT /B

   :s_v
   REM  Pad digits to --->
      (SET _1=%_1% #   #)
      (SET _2=%_2% #   #)
      (SET _3=%_3% #   #)
      (SET _4=%_4% #   #)
      (SET _5=%_5% #   #)
      (SET _6=%_6%  # # )
      (SET _7=%_7%   #  )
   EXIT /B

   :s_w
   REM  Pad digits to ----->
      (SET _1=%_1% #  #  #)
      (SET _2=%_2% #  #  #)
      (SET _3=%_3% #  #  #)
      (SET _4=%_4% #  #  #)
      (SET _5=%_5% #  #  #)
      (SET _6=%_6% #  #  #)
      (SET _7=%_7%  ## ## )
   EXIT /B

   :s_x
   REM  Pad digits to -->
      (SET _1=%_1%      )
      (SET _2=%_2% #   #)
      (SET _3=%_3%  # # )
      (SET _4=%_4%   #  )
      (SET _5=%_5%   #  )
      (SET _6=%_6%  # # )
      (SET _7=%_7% #   #)
   EXIT /B

   :s_y
   REM  Pad digits to --->
      (SET _1=%_1% #   #)
      (SET _2=%_2%  # # )
      (SET _3=%_3%   #  )
      (SET _4=%_4%   #  )
      (SET _5=%_5%   #  )
      (SET _6=%_6%   #  )
      (SET _7=%_7%   #  )
   EXIT /B

   :s_z
   REM  Pad digits to --->
      (SET _1=%_1% #####)
      (SET _2=%_2%     #)
      (SET _3=%_3%    # )
      (SET _4=%_4%   #  )
      (SET _5=%_5%  #   )
      (SET _6=%_6% #    )
      (SET _7=%_7% #####)
   EXIT /B

   :s_space
   REM  Pad digits to --->
      (SET _1=%_1%      )
      (SET _2=%_2%      )
      (SET _3=%_3%      )
      (SET _4=%_4%      )
      (SET _5=%_5%      )
      (SET _6=%_6%      )
      (SET _7=%_7%      )
   EXIT /B
EXIT /B
