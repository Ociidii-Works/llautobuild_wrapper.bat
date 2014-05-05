@echo off
echo.
echo Linden Lab autobuild wrapper :3
echo Copyright (c) 2014 Matthew "Mezmenir" Ruggieri
echo.

rem :: The MIT License (MIT)
rem ::
rem :: Copyright (c) 2014 Matthew "Mezmenir" Ruggieri
rem ::
rem :: Permission is hereby granted, free of charge, to any person obtaining a copy
rem :: of this software and associated documentation files (the "Software"), to deal
rem :: in the Software without restriction, including without limitation the rights
rem :: to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
rem :: copies of the Software, and to permit persons to whom the Software is
rem :: furnished to do so, subject to the following conditions:
rem ::
rem :: The above copyright notice and this permission notice shall be included in
rem :: all copies or substantial portions of the Software.
rem ::
rem :: THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
rem :: IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
rem :: FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
rem :: AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
rem :: LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
rem :: OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
rem :: THE SOFTWARE.

setlocal

rem :: Process the command line arguments passed to the script.
	if /i "%~1"=="/?" goto :SyntaxDescription
	for %%A in ( %* ) do (
		for /f "tokens=1,* delims=:" %%B in ("%%~A") do (

			rem  :: Paths that point to the Microsoft Visual Studio command line build utility scripts.
			if /i "%%~B"=="/MSVC" (
				if /i "%%~C"=="2010" ( set "MSVCVERS=2010" && set "MSVCENVS=C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\vcvarsall.bat" )
				if /i "%%~C"=="2012" ( set "MSVCVERS=2012" && set "MSVCENVS=C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\vcvarsall.bat" )
			)

			rem :: Processor architecture selection variables, these are passed to the Visual Studio command line script when invoking the environment.
			if /i "%%~B"=="/ARCH" (
				if /i "%%~C"=="32" ( set "MSVCARCH=x86" )
				if /i "%%~C"=="64" ( set "MSVCARCH=x86_amd64" )
			)

			rem :: Type flag for the autobuild utility. This is case sensitive, and the checking is not enforced. This method of setting the variable will
			rem :: ensure that the case is always correct before calling the autobuild binary.
			if /i "%%~B"=="/TYPE" (
				if /i "%%~C"=="ReleaseOS" ( set "ABLDTYPE=ReleaseOS" )
				if /i "%%~C"=="RelWithDebugOS" ( set "ABLDTYPE=RelWithDebugOS" )
				if /i "%%~C"=="DebugOS" ( set "ABLDTYPE=DebugOS" )
			)

		)
	)

rem :: Simple sanity check.
	if /i "%MSVCVERS%"=="" ( echo /MSVC switch was invalid or unspecified. && exit /b 1 )
	if /i "%MSVCARCH%"=="" ( echo /ARCH switch was invalid or unspecified. && exit /b 1 )
	if /i "%ABLDTYPE%"=="" ( echo /TYPE switch was invalid or unspecified. && exit /b 1 )

rem :: Invoke MSVC Environment
	call "%MSVCENVS%" %MSVCARCH%

rem :: Set variables for the autobuild utility. If you want the PLATFORM_OVERRIDE to be unset entirely, change the command to  ' set "AUTOBUILD_PLATFORM_OVERRIDE=" '.
	if /i "%MSVCVERS%"=="2010" (
		if /i "%MSVCARCH%"=="x86" (
			set "AUTOBUILD_CONFIG_FILE=autobuild.xml"
			set "AUTOBUILD_PLATFORM_OVERRIDE=windows"
		)
	)
	if /i "%MSVCVERS%"=="2012" (
		if /i "%MSVCARCH%"=="x86" (
			set "AUTOBUILD_CONFIG_FILE=autobuild_vs2012.xml"
			set "AUTOBUILD_PLATFORM_OVERRIDE=windows"
		)
		if /i "%MSVCARCH%"=="x86_amd64" (
			set "AUTOBUILD_CONFIG_FILE=autobuild_vs2012.xml"
			set "AUTOBUILD_PLATFORM_OVERRIDE=windows64"
		)
	)
	rem Build sanity check.
	if "%AUTOBUILD_CONFIG_FILE%"=="" ( echo Invalid build type was specified. && exit /b 1 )

rem :: Invoke the autobuild.
	autobuild build -c %ABLDTYPE%

endlocal
exit /b 0

:SyntaxDescription
	echo.
	echo Command Syntax Help
rem  :: This FOR loop is a hacky fix to echoing something that Windows will generally not let you echo.
	for %%A in ("%~NX0 /msvc:[2010|2012] /arch:[32|64] /type:[ReleaseOS|DebugOS|RelWithDebugOS]") do (
	echo %%~A
	)
	echo.
	echo MSVC: Specifies which version of Microsoft Visual Studio should be used.
	echo ARCH: Specifies the target build architecture.
	echo TYPE: Specifies which release type should be used for autobuild.
	echo.
exit /b 0