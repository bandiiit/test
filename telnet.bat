@echo off
setlocal enabledelayedexpansion

:: Define the host:port pairs
set HOSTS=google.com:80 localhost:22 invalidhost:1234 127.0.0.1:8080

:: Output file
set OUTPUT_FILE=telnet_results.txt

:: Clear the output file
> %OUTPUT_FILE%

echo Starting telnet tests...

:: Loop through each host:port pair
for %%H in (%HOSTS%) do (
    :: Split the host and port
    for /f "tokens=1,2 delims=:" %%A in ("%%H") do (
        set HOST=%%A
        set PORT=%%B

        echo Testing !HOST!:!PORT!...

        :: Test connectivity using telnet
        (
            echo open !HOST! !PORT! & timeout /t 2 >nul & echo exit
        ) | telnet >nul 2>&1

        :: Check the exit code
        if errorlevel 1 (
            echo !HOST!:!PORT! - Failed
            echo !HOST!:!PORT! - Failed >> %OUTPUT_FILE%
        ) else (
            echo !HOST!:!PORT! - Success
            echo !HOST!:!PORT! - Success >> %OUTPUT_FILE%
        )
    )
)

echo Telnet tests completed. Results saved to %OUTPUT_FILE%.
pause
