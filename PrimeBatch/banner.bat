@Echo off&SETLOCAL
color 0a
CLS
IF [%1] NEQ [] goto s_start
Echo   Syntax  
Echo       BANNER string
Echo           Where string is the text or numbers to be displayed
Echo:
GOTO :eof
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
   Echo:
   Echo:%_1%
   Echo:%_2%
   Echo:%_3%
   Echo:%_4%
   Echo:%_5%
   Echo:%_6%
   Echo:%_7%
   Echo:
   GOTO :EOF

   :s_build
      REM get the next character
      CALL SET _digit=%%_sentence:~%1,1%%%
      REM Add the graphics for this digit to the variables
      IF "%_digit%"==" " (CALL :s_space) ELSE (CALL :s_%_digit%)
   GOTO :EOF
   
   REM  Pad digits to -->
   :s_0
      (SET _1=%_1% ####)
      (SET _2=%_2% #  #)
      (SET _3=%_3% #  #)
      (SET _4=%_4% #  #)
      (SET _5=%_5% #  #)
      (SET _6=%_6% #  #)
      (SET _7=%_7% ####)
   GOTO :EOF
   
   :s_1
   REM  Pad digits to -->
      (SET _1=%_1%  ## )
      (SET _2=%_2%   # )
      (SET _3=%_3%   # )
      (SET _4=%_4%   # )
      (SET _5=%_5%   # )
      (SET _6=%_6%   # )
      (SET _7=%_7% ####)
   GOTO :EOF
   
   :s_2
   REM  Pad digits to -->
      (SET _1=%_1% ####)
      (SET _2=%_2% #  #)
      (SET _3=%_3%    #)
      (SET _4=%_4% ####)
      (SET _5=%_5% #   )
      (SET _6=%_6% #  #)
      (SET _7=%_7% ####)
   GOTO :EOF
   
   :s_3
   REM  Pad digits to -->
      (SET _1=%_1% ####)
      (SET _2=%_2%    #)
      (SET _3=%_3%    #)
      (SET _4=%_4% ####)
      (SET _5=%_5%    #)
      (SET _6=%_6%    #)
      (SET _7=%_7% ####)
   GOTO :EOF
   
   :s_4
   REM  Pad digits to -->
      (SET _1=%_1% #  #)
      (SET _2=%_2% #  #)
      (SET _3=%_3% #  #)
      (SET _4=%_4% ####)
      (SET _5=%_5%    #)
      (SET _6=%_6%    #)
      (SET _7=%_7%    #)
   GOTO :EOF
   
   :s_5
   REM  Pad digits to -->
      (SET _1=%_1% ####)
      (SET _2=%_2% #   )
      (SET _3=%_3% #   )
      (SET _4=%_4% ####)
      (SET _5=%_5%    #)
      (SET _6=%_6% #  #)
      (SET _7=%_7% ####)
   GOTO :EOF
   
   :s_6
   REM  Pad digits to -->
      (SET _1=%_1% ##  )
      (SET _2=%_2% #   )
      (SET _3=%_3% #   )
      (SET _4=%_4% ####)
      (SET _5=%_5% #  #)
      (SET _6=%_6% #  #)
      (SET _7=%_7% ####)
   GOTO :EOF
   
   :s_7
   REM  Pad digits to -->
      (SET _1=%_1% ####)
      (SET _2=%_2% #  #)
      (SET _3=%_3%    #)
      (SET _4=%_4%   ##)
      (SET _5=%_5%   # )
      (SET _6=%_6%   # )
      (SET _7=%_7%   # )
   GOTO :EOF
   
   :s_8
   REM  Pad digits to -->
      (SET _1=%_1% ####)
      (SET _2=%_2% #  #)
      (SET _3=%_3% #  #)
      (SET _4=%_4% ####)
      (SET _5=%_5% #  #)
      (SET _6=%_6% #  #)
      (SET _7=%_7% ####)
   GOTO :EOF
   
   :s_9
   REM  Pad digits to -->
      (SET _1=%_1% ####)
      (SET _2=%_2% #  #)
      (SET _3=%_3% #  #)
      (SET _4=%_4% ####)
      (SET _5=%_5%    #)
      (SET _6=%_6%    #)
      (SET _7=%_7%    #)
   GOTO :EOF
   
   :s_-
   REM  Pad digits to -->
      (SET _1=%_1%     )
      (SET _2=%_2%     )
      (SET _3=%_3%     )
      (SET _4=%_4% ####)
      (SET _5=%_5%     )
      (SET _6=%_6%     )
      (SET _7=%_7%     )
   GOTO :EOF
   
   :s_.
   REM  Pad digits to -->
      (SET _1=%_1%     )
      (SET _2=%_2%     )
      (SET _3=%_3%     )
      (SET _4=%_4%     )
      (SET _5=%_5%     )
      (SET _6=%_6%     )
      (SET _7=%_7%  #  )
   GOTO :EOF
   
   :s_a
   REM  Pad digits to -->
      (SET _1=%_1%  ## )
      (SET _2=%_2% #  #)
      (SET _3=%_3% #  #)
      (SET _4=%_4% ####)
      (SET _5=%_5% #  #)
      (SET _6=%_6% #  #)
      (SET _7=%_7% #  #)
   GOTO :EOF
   
   :s_b
   REM  Pad digits to -->
      (SET _1=%_1% ### )
      (SET _2=%_2% #  #)
      (SET _3=%_3% #  #)
      (SET _4=%_4% ####)
      (SET _5=%_5% #  #)
      (SET _6=%_6% #  #)
      (SET _7=%_7% ### )
   GOTO :EOF
   
   :s_c
   REM  Pad digits to -->
      (SET _1=%_1%  ## )
      (SET _2=%_2% #  #)
      (SET _3=%_3% #   )
      (SET _4=%_4% #   )
      (SET _5=%_5% #   )
      (SET _6=%_6% #  #)
      (SET _7=%_7%  ## )
   GOTO :EOF
   
   :s_d
   REM  Pad digits to -->
      (SET _1=%_1% ### )
      (SET _2=%_2% #  #)
      (SET _3=%_3% #  #)
      (SET _4=%_4% #  #)
      (SET _5=%_5% #  #)
      (SET _6=%_6% #  #)
      (SET _7=%_7% ### )
   GOTO :EOF
   
   :s_e
   REM  Pad digits to -->
      (SET _1=%_1% ####)
      (SET _2=%_2% #   )
      (SET _3=%_3% #   )
      (SET _4=%_4% ### )
      (SET _5=%_5% #   )
      (SET _6=%_6% #   )
      (SET _7=%_7% ####)
   GOTO :EOF
   
   :s_f
   REM  Pad digits to -->
      (SET _1=%_1% ####)
      (SET _2=%_2% #   )
      (SET _3=%_3% #   )
      (SET _4=%_4% ### )
      (SET _5=%_5% #   )
      (SET _6=%_6% #   )
      (SET _7=%_7% #   )
   GOTO :EOF

   :s_g
   REM  Pad digits to -->
      (SET _1=%_1%  ## )
      (SET _2=%_2% #  #)
      (SET _3=%_3% #   )
      (SET _4=%_4% #   )
      (SET _5=%_5% # ##)
      (SET _6=%_6% #  #)
      (SET _7=%_7%  ## )
   GOTO :EOF

   :s_h
   REM  Pad digits to -->
      (SET _1=%_1% #  #)
      (SET _2=%_2% #  #)
      (SET _3=%_3% #  #)
      (SET _4=%_4% ####)
      (SET _5=%_5% #  #)
      (SET _6=%_6% #  #)
      (SET _7=%_7% #  #)
   GOTO :EOF

   :s_i
   REM  Pad digits to -->
      (SET _1=%_1%  # )
      (SET _2=%_2%  # )
      (SET _3=%_3%  # )
      (SET _4=%_4%  # )
      (SET _5=%_5%  # )
      (SET _6=%_6%  # )
      (SET _7=%_7%  # )
   GOTO :EOF

   :s_j
   REM  Pad digits to -->
      (SET _1=%_1% ####)
      (SET _2=%_2%   # )
      (SET _3=%_3%   # )
      (SET _4=%_4%   # )
      (SET _5=%_5%   # )
      (SET _6=%_6%   # )
      (SET _7=%_7% ##  )
   GOTO :EOF

   :s_k
   REM  Pad digits to -->
      (SET _1=%_1% #   )
      (SET _2=%_2% #  #)
      (SET _3=%_3% # # )
      (SET _4=%_4% ##  )
      (SET _5=%_5% ##  )
      (SET _6=%_6% # # )
      (SET _7=%_7% #  #)
   GOTO :EOF

   :s_l
   REM  Pad digits to -->
      (SET _1=%_1% #   )
      (SET _2=%_2% #   )
      (SET _3=%_3% #   )
      (SET _4=%_4% #   )
      (SET _5=%_5% #   )
      (SET _6=%_6% #   )
      (SET _7=%_7% ####)
   GOTO :EOF

   :s_m
   REM  Pad digits to --->
      (SET _1=%_1% #   #)
      (SET _2=%_2% ## ##)
      (SET _3=%_3% # # #)
      (SET _4=%_4% # # #)
      (SET _5=%_5% #   #)
      (SET _6=%_6% #   #)
      (SET _7=%_7% #   #)
   GOTO :EOF

   :s_n
   REM  Pad digits to --->
      (SET _1=%_1% #   #)
      (SET _2=%_2% ##  #)
      (SET _3=%_3% ##  #)
      (SET _4=%_4% # # #)
      (SET _5=%_5% #  ##)
      (SET _6=%_6% #  ##)
      (SET _7=%_7% #   #)
   GOTO :EOF

   :s_o
   REM  Pad digits to -->
      (SET _1=%_1%  ## )
      (SET _2=%_2% #  #)
      (SET _3=%_3% #  #)
      (SET _4=%_4% #  #)
      (SET _5=%_5% #  #)
      (SET _6=%_6% #  #)
      (SET _7=%_7%  ## )
   GOTO :EOF

   :s_p
   REM  Pad digits to -->
      (SET _1=%_1% ### )
      (SET _2=%_2% #  #)
      (SET _3=%_3% #  #)
      (SET _4=%_4% ### )
      (SET _5=%_5% #   )
      (SET _6=%_6% #   )
      (SET _7=%_7% #   )
   GOTO :EOF

   :s_q
   REM  Pad digits to -->
      (SET _1=%_1%  ## )
      (SET _2=%_2% #  #)
      (SET _3=%_3% #  #)
      (SET _4=%_4% #  #)
      (SET _5=%_5% #  #)
      (SET _6=%_6% # ##)
      (SET _7=%_7%  # #)
   GOTO :EOF

   :s_r
   REM  Pad digits to -->
      (SET _1=%_1% ### )
      (SET _2=%_2% #  #)
      (SET _3=%_3% #  #)
      (SET _4=%_4% ### )
      (SET _5=%_5% # # )
      (SET _6=%_6% #  #)
      (SET _7=%_7% #  #)
   GOTO :EOF

   :s_s
   REM  Pad digits to -->
      (SET _1=%_1%  ###)
      (SET _2=%_2% #   )
      (SET _3=%_3% #   )
      (SET _4=%_4%  ## )
      (SET _5=%_5%    #)
      (SET _6=%_6%    #)
      (SET _7=%_7% ### )
   GOTO :EOF

   :s_t
   REM  Pad digits to -->
      (SET _1=%_1% ###)
      (SET _2=%_2%  # )
      (SET _3=%_3%  # )
      (SET _4=%_4%  # )
      (SET _5=%_5%  # )
      (SET _6=%_6%  # )
      (SET _7=%_7%  # )
   GOTO :EOF

   :s_u
   REM  Pad digits to -->
      (SET _1=%_1% #  #)
      (SET _2=%_2% #  #)
      (SET _3=%_3% #  #)
      (SET _4=%_4% #  #)
      (SET _5=%_5% #  #)
      (SET _6=%_6% #  #)
      (SET _7=%_7%  ## )
   GOTO :EOF

   :s_v
   REM  Pad digits to --->
      (SET _1=%_1% #   #)
      (SET _2=%_2% #   #)
      (SET _3=%_3% #   #)
      (SET _4=%_4% #   #)
      (SET _5=%_5% #   #)
      (SET _6=%_6%  # # )
      (SET _7=%_7%   #  )
   GOTO :EOF

   :s_w
   REM  Pad digits to ----->
      (SET _1=%_1% #  #  #)
      (SET _2=%_2% #  #  #)
      (SET _3=%_3% #  #  #)
      (SET _4=%_4% #  #  #)
      (SET _5=%_5% #  #  #)
      (SET _6=%_6% #  #  #)
      (SET _7=%_7%  ## ## )
   GOTO :EOF

   :s_x
   REM  Pad digits to -->
      (SET _1=%_1%      )
      (SET _2=%_2% #   #)
      (SET _3=%_3%  # # )
      (SET _4=%_4%   #  )
      (SET _5=%_5%   #  )
      (SET _6=%_6%  # # )
      (SET _7=%_7% #   #)
   GOTO :EOF

   :s_y
   REM  Pad digits to --->
      (SET _1=%_1% #   #)
      (SET _2=%_2%  # # )
      (SET _3=%_3%   #  )
      (SET _4=%_4%   #  )
      (SET _5=%_5%   #  )
      (SET _6=%_6%   #  )
      (SET _7=%_7%   #  )
   GOTO :EOF

   :s_z
   REM  Pad digits to --->
      (SET _1=%_1% #####)
      (SET _2=%_2%     #)
      (SET _3=%_3%    # )
      (SET _4=%_4%   #  )
      (SET _5=%_5%  #   )
      (SET _6=%_6% #    )
      (SET _7=%_7% #####)
   GOTO :EOF

   :s_space
   REM  Pad digits to --->
      (SET _1=%_1%      )
      (SET _2=%_2%      )
      (SET _3=%_3%      )
      (SET _4=%_4%      )
      (SET _5=%_5%      )
      (SET _6=%_6%      )
      (SET _7=%_7%      )
   GOTO :EOF
