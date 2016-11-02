--
-- tests/test_shared.lua
-- Validate generation of the Shared import group.
-- Copyright (c) 2016-2017 Samuel Surtees and the Premake project
--

	local suite = test.declare("vslinux_shared")
	local vslinux = premake.modules.vslinux

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
		vslinux.importShared(cfg)
	end

--
-- Check the structure with the default project values.
--

	function suite.importShared_onLinux()
		prepare()
		test.capture '<ImportGroup Label="Shared" />'
	end
