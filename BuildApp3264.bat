@echo off
rem
rem $Id: BuildApp3264.bat $
rem

if /I "%1"=="/c" "%~dp0.\BuildApp.bat" %1 HM3264 %2 %3 %4 %5 %6 %7 %8 %9
if /I not "%1"=="/c" "%~dp0.\BuildApp.bat" HM3264 %1 %2 %3 %4 %5 %6 %7 %8 %9
