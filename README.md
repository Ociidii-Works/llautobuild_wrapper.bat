llautobuild_wrapper.bat
=======================

####Batch wrapper for Linden Lab's autobuild

Scripting by Mezmenir, design by Voaxeyr
We wrote this to help building the Second Life viewer.

### Features:
 - Automatically sets the Visual Studio environment, in a regular CMD prompt.
 - Allows automated building of the viewer with multiple compiler versions from a single batch job.
    * you still need to write your own automation script
 - Follows common Microsoft Windows(tm) parameters syntax
 
### Usage examples:

``build.bat /msvc:2010 /arch:32 /type:RelWithDebInfoOS``

``build.bat /msvc:2012 /arch:32 /type:DebugOS``

``build.bat /msvc:2012 /arch:64 /type:ReleaseOS``
