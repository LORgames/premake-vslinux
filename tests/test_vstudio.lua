--
-- tests/test_vstudio.lua
-- Validate functions in the premake.vstudio namespace
-- Copyright (c) 2016-2017 Samuel Surtees and the Premake project
--

	local suite = test.declare("vslinux_vstudio")
	local vstudio = premake.vstudio

--
-- Setup
--

	local wks, prj

	function suite.setup()
		premake.action.set("vs2015")
		wks, prj = test.createWorkspace()
		system "Linux"
	end

	local function prepare()
		cfg = test.getconfig(prj, "Debug")
	end

--
-- Emit x86 on Linux, instead of Win32
--

	function suite.archFromConfigx86_onLinux()
		prepare()
		test.isequal(vstudio.archFromConfig(cfg), "x86")
	end
