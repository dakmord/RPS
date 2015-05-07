@echo off
rem ========================================================================== 
rem tiobj2bin.bat - Converts TI object file from COFF or ELF to binary
rem     dump format.  Intended for use as a post-build step in CCS.
rem
rem This code released under a license detailed at the end of this file.
rem
rem Invoke: tiobj2bin file.out file.bin [ofd] [hex] [mkhex]
rem
rem file.out - The TI .out file to convert to binary.  Can be COFF or ELF.
rem file.bin - Name the binary output file
rem ofd      - The object file display (ofd) utility command to invoke, with
rem            path info as needed.  If not given, defaults to ofd470.
rem hex      - The hex utility command to invoke, with path info as needed.
rem            If not given, defaults to hex470.
rem mkhex    - A custom utility which takes XML from OFD and outputs the hex
rem            command file needed for the hex utility.  Path info is given
rem            as needed.  If not given, defaults to mkhex4bin.  
rem
rem You may need to put "quotes" around the parameters.
rem
rem Here is an example of how this file is invoked as a post-build step in
rem CCSv4 (not CCSv3.3):
rem
rem "${CCE_INSTALL_ROOT}/utils/tiobj2bin/tiobj2bin.bat" "${BuildArtifactFileName}" "${BuildArtifactFileBaseName}.bin" "${CG_TOOL_ROOT}/bin/ofd470.exe" "${CG_TOOL_ROOT}/bin/hex470.exe" "${CCE_INSTALL_ROOT}/utils/tiobj2bin/mkhex4bin.exe" 
rem
rem ========================================================================== 

rem ========================================================================== 
rem Automated Revision Information
rem Changed: $Date$
rem Revision: $Revision$
rem ========================================================================== 

rem ========================================================================== 
rem Presumptions: 
rem - Unless directory path info is provided as part of the parameter name, 
rem   ofd470 and friends are in the system path
rem ========================================================================== 

rem ========================================================================== 
rem Do not remember variables set in this batch file
rem ========================================================================== 
setlocal

rem ========================================================================== 
rem Handle command line args
rem ========================================================================== 
if "%~1" == "" (
   echo Usage: %~n0 file.out file.bin [ofd] [hex] [mkhex]
   exit /b
)
set outfile=%1

if "%~2" == "" (
   echo Usage: %~n0 file.out file.bin [ofd] [hex] [mkhex]
   exit /b
)
set binfile=%2

set ofdcmd=ofd470
if not "%~3" == "" set ofdcmd=%3
set hexcmd=hex470
if not "%~4" == "" set hexcmd=%4
set mkhexcmd=mkhex4bin
if not "%~5" == "" set mkhexcmd=%5

rem ========================================================================== 
rem To make testing easier, an additional 6th parameter for specifying running
rem Perl is available.  Now an executable version of the script is not
rem required.  Not documented externally.  Everyone will invoke the full
rem executable version of mkhex4bin.  Serves 2 purposes: Whether to execute
rem perl, and how to execute it.
rem ========================================================================== 
set perlcmd=none
if not "%~6" == "" set perlcmd=%6

rem ========================================================================== 
rem Compose temporary file names used for ofd and hex cmds
rem    Run "set /?" to see documentation of %random%
rem ========================================================================== 
set xmltmp=%TMP%\ofd_%random%_%random%_%random%.xml
set hextmp=%TMP%\hexcmd_%random%_%random%_%random%.tmp

rem ========================================================================== 
rem Paranoid checks on the temp files
rem ========================================================================== 
if exist "%xmltmp%" (
   echo "XML temp file exists. Giving up."
   exit /b
)

if exist "%hextmp%" (
   echo "HEX temp file exists. Giving up."
   exit /b
)

rem ========================================================================== 
rem 1. Create the XML from the .out file
rem 2. Create the hex command file from the XML
rem 3. Create the binary from the .out file and hex file
rem ========================================================================== 
%ofdcmd% -x --xml_indent=0 --obj_display=none,sections,header,segments %outfile% > %xmltmp%

if %perlcmd% == none (
   %mkhexcmd% %xmltmp% > %hextmp%
) else (
   %perlcmd% %mkhexcmd% %xmltmp% > %hextmp%
)

%hexcmd% -q -b -image -o %binfile% %hextmp% %outfile%

rem ========================================================================== 
rem Uncomment to debug
rem ========================================================================== 
rem echo ---- xml ---
rem type %xmltmp%
rem echo ---- hex ---
rem type %hextmp%

rem ========================================================================== 
rem Remove the temp files
rem ========================================================================== 
del %hextmp%
del %xmltmp%

rem /*
rem *
rem * Copyright (C) 2011 Texas Instruments Incorporated - http://www.ti.com/ 
rem * 
rem * 
rem *  Redistribution and use in source and binary forms, with or without 
rem *  modification, are permitted provided that the following conditions 
rem *  are met:
rem *
rem *    Redistributions of source code must retain the above copyright 
rem *    notice, this list of conditions and the following disclaimer.
rem *
rem *    Redistributions in binary form must reproduce the above copyright
rem *    notice, this list of conditions and the following disclaimer in the 
rem *    documentation and/or other materials provided with the   
rem *    distribution.
rem *
rem *    Neither the name of Texas Instruments Incorporated nor the names of
rem *    its contributors may be used to endorse or promote products derived
rem *    from this software without specific prior written permission.
rem *
rem *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
rem *  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
rem *  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
rem *  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
rem *  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
rem *  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
rem *  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
rem *  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
rem *  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
rem *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
rem *  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
rem *
rem */

