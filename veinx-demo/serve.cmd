@echo off
title VeinX demo
echo.
echo   VeinX demo - starting local server at http://localhost:8000
echo   (leave this window open; close it to stop)
echo.
start "" http://localhost:8000/present
where py >nul 2>nul && ( py -m http.server 8000 & goto :eof )
where python >nul 2>nul && ( python -m http.server 8000 & goto :eof )
where npx >nul 2>nul && ( npx --yes serve -l 8000 . & goto :eof )
echo Could not find Python or Node.js.
echo Install Node.js (https://nodejs.org) then run:  npx serve -l 8000
pause
