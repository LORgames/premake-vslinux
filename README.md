Premake module to support the VSLinux extension for Visual Studio 2015.

### Features ###

* Support actions: vs2015

### Usage ###

Simply add:
```lua
system "Linux"
```
to your project definition.

### APIs ###

None yet.

### Example ###

The contents of your premake5.lua file would be:

```lua
workspace "MyWorkspace"
    configurations { "Release", "Debug" }

    project "MyLinuxProject"
        kind "ConsoleApp"
        system "Linux"
        files { "src/main.cpp" }
```
