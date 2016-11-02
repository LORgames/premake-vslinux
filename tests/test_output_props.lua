--
-- tests/test_output_props.lua
-- Validate generation of the output property groups.
-- Copyright (c) 2016-2017 Samuel Surtees and the Premake project
--

	local suite = test.declare("vslinux_output_props")
	local vc2010 = premake.vstudio.vc2010

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
		vc2010.outputProperties(cfg)
	end

--
-- Check the structure with the default project values.
--

	function suite.outputPropertyGroup_onLinux()
		prepare()
		test.capture [[
<PropertyGroup Condition="'$(Configuration)|$(Platform)'=='Debug|x86'">
	<RemoteProjectDir>$(RemoteRootDir)/tests</RemoteProjectDir>
</PropertyGroup>
		]]
	end
