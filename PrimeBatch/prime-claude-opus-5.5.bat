@ECHO off & SETLOCAL EnableDelayedExpansion

REM Empty the inherited environment (restored on exit): every variable lookup
REM in cmd scans the whole environment, so fewer variables means a faster sieve.
FOR /F "delims==" %%V IN ('SET') DO SET "%%V="
CALL :MAIN %1
EXIT /B

:MAIN
	CALL :SETINPUT %1
	SET "PASSES=0"
	SET "ALLVALID=true"
	CALL :GETTIME_CS TIMESTART

	REM Each pass: instantiate, runSieve, query, destroy.
	REM SETLOCAL/ENDLOCAL is the stand-in for a class instance; every
	REM sieve_*, w* and t variable exists only between the two and is freed
	REM by ENDLOCAL.
	REM Always completes at least one pass, then repeats until 5 seconds.
	REM Progress (one dot per pass) goes to stderr so stdout holds only results.
:BENCHMARK_LOOP
	SET /A PASSES+=1
	SETLOCAL
	CALL :SIEVE_NEW %NMAX%
	CALL :SIEVE_RUNSIEVE
	CALL :SIEVE_COUNTPRIMES
	CALL :SIEVE_VALIDATE
	ENDLOCAL & SET "COUNT=%sieve_count%" & SET "VALID=%sieve_valid%"
	>&2 <NUL SET /P "=."
	IF NOT "%VALID%"=="true" SET "ALLVALID=%VALID%"
	CALL :GETELAPSED TIMESTART ELAPSED
	IF %ELAPSED% LSS 500 GOTO BENCHMARK_LOOP
	>&2 ECHO.

	CALL :PRINTRESULTS
EXIT /B

:SETINPUT
	REM Default NMAX is 10000 because batch is too slow for 1000000
	SET NMAX=10000
	IF "%1" NEQ "" (
		REM Check if the argument is a positive integer
		IF 1%1 EQU +1%1 (
			SET NMAX=%1
		) ELSE (
			>&2 ECHO [ERROR] CMD argument %1 is invalid
			>&2 ECHO [RECOVERING] Using default !NMAX!
		)
	)
EXIT /B

REM ===========================================================================
REM  Sieve "class". Odd-only 1-bit array sized at runtime from the limit:
REM  bit i represents 2*i+1 and lives in word w(i>>5) at bit (i&31).
REM  0 = prime, 1 = composite. cmd gets slower with every environment
REM  variable, so packing 32 flags per variable is the main speedup.
REM  The word array (w*) and scratch (t) keep one-letter names because cmd
REM  parses and looks them up on every mark.
REM ===========================================================================

:SIEVE_NEW
	SET /A "sieve_size=%~1, sieve_maxIdx=(sieve_size-1)/2, sieve_lastWord=sieve_maxIdx>>5"
	FOR /L %%W IN (0,1,%sieve_lastWord%) DO SET "w%%W=0"
EXIT /B

:SIEVE_RUNSIEVE
	CALL :ISQRT %sieve_size% sieve_q
	SET /A "sieve_lastIdx=(sieve_q-1)/2"
	FOR /L %%I IN (1,1,%sieve_lastIdx%) DO (
		SET /A "t=%%I>>5"
		SET /A "t=(w!t!>>(%%I&31))&1"
		IF !t! EQU 0 (
			REM factor f=2i+1; clear f*f, f*f+2f, ... which is index step f
			SET /A "sieve_f=2*%%I+1, sieve_start=(sieve_f*sieve_f)/2"
			IF !sieve_f! LSS 32 (
				REM Several multiples per word: walk word by word so the word name
				REM is a FOR variable, then one SET /A per multiple. r is the
				REM first multiple's bit within the current word. Measured fastest
				REM below 32; for larger f most words hold no multiple.
				SET /A "sieve_k=sieve_start>>5, r=sieve_start&31"
				FOR /L %%K IN (!sieve_k!,1,%sieve_lastWord%) DO (
					FOR /L %%B IN (!r!,!sieve_f!,31) DO SET /A "w%%K|=1<<%%B"
					SET /A "r=((r-32)%% sieve_f+sieve_f)%% sieve_f"
				)
			) ELSE (
				FOR /L %%M IN (!sieve_start!,!sieve_f!,%sieve_maxIdx%) DO SET /A "t=%%M>>5" & SET /A "w!t!|=1<<(%%M&31)"
			)
		)
	)
EXIT /B

:SIEVE_COUNTPRIMES
	REM Popcount each word to get the odd composites; primes are what's left
	REM of the odd numbers 3..size, plus 2. Index 0 (the number 1) is never set.
	SET "sieve_count=0"
	IF %sieve_size% LSS 2 EXIT /B
	SET "sieve_composites=0"
	REM Word-wise marking can set bits past maxIdx in the last word; drop them
	SET /A "w%sieve_lastWord%&=(2<<(sieve_maxIdx&31))-1"
	FOR /L %%W IN (0,1,%sieve_lastWord%) DO (
		SET /A "sieve_x=w%%W, sieve_x-=(sieve_x>>1)&0x55555555, sieve_x=(sieve_x&0x33333333)+((sieve_x>>2)&0x33333333), sieve_x=(sieve_x+(sieve_x>>4))&0x0F0F0F0F, sieve_composites+=(sieve_x*0x01010101)>>24"
	)
	SET /A "sieve_count=1+sieve_maxIdx-sieve_composites"
EXIT /B

:SIEVE_VALIDATE
	REM Known prime counts used only to verify the result, as in the reference
	SET "sieve_valid=unknown"
	FOR %%P IN (10:4 100:25 1000:168 10000:1229 100000:9592 1000000:78498 10000000:664579) DO (
		FOR /F "tokens=1,2 delims=:" %%A IN ("%%P") DO (
			IF "%%A"=="%sieve_size%" (
				IF "%%B"=="!sieve_count!" (SET "sieve_valid=true") ELSE (SET "sieve_valid=false")
			)
		)
	)
EXIT /B

REM ===========================================================================
REM  Helpers
REM ===========================================================================

:ISQRT
	REM Integer Newton's method: %2 = floor(sqrt(%1))
	SETLOCAL
	SET /A "n=%~1, x=n, y=(x+1)/2"
:ISQRT_LOOP
	IF !y! LSS !x! (
		SET /A "x=y, y=(x+n/x)/2"
		GOTO ISQRT_LOOP
	)
	ENDLOCAL & SET "%~2=%x%"
EXIT /B

:GETTIME_CS
	REM %1 = current time of day in centiseconds. Handles a space-padded hour,
	REM leading zeros (octal) and either "." or "," as the decimal separator.
	SET "_t=%TIME: =0%"
	FOR /F "tokens=1-4 delims=:.," %%A IN ("%_t%") DO (
		SET /A "%~1=((100%%A %% 100 * 60 + 100%%B %% 100) * 60 + 100%%C %% 100) * 100 + 100%%D %% 100"
	)
EXIT /B

:GETELAPSED
	REM %2 = centiseconds since the time stored in variable %1, midnight-safe
	CALL :GETTIME_CS _now
	SET /A "%~2=_now - %~1"
	IF !%~2! LSS 0 SET /A "%~2+=8640000"
EXIT /B

:FORMATSECONDS
	REM %2 = centiseconds %1 formatted as seconds with two decimals
	SET /A "_s=%~1 / 100, _c=%~1 %% 100"
	SET "_c=0%_c%"
	SET "%~2=%_s%.%_c:~-2%"
EXIT /B

:PRINTRESULTS
	CALL :FORMATSECONDS %ELAPSED% DURATION
	SET /A "_avg=ELAPSED / PASSES"
	CALL :FORMATSECONDS %_avg% AVERAGE
	ECHO Passes: %PASSES%, Time: %DURATION%, Avg: %AVERAGE%, Limit: %NMAX%, Count: %COUNT%, Valid: %ALLVALID%
	ECHO.
	ECHO ballganda_batch;%PASSES%;%DURATION%;1;algorithm=base,faithful=no,bits=1
EXIT /B
