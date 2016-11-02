--
-- tests/test_link.lua
-- Validate linking and project references in Linux projects.
-- Copyright (c) 2016-2017 Samuel Surtees and the Premake project
--

	local suite = test.declare("vslinux_link")
	local vc2010 = premake.vstudio.vc2010

--
-- Setup
--

	local wks, prj

	function suite.setup()
		premake.action.set("vs2015")
		wks, prj = test.createWorkspace()
		system "Linux"
		kind "ConsoleApp"
	end

	local function prepare()
		cfg = test.getconfig(prj, "Debug")
		vc2010.linker(cfg)
	end

--
-- Any system libraries specified in links() should be listed as
-- additional dependencies.
--

	function suite.additonalDependencies_onSystemLinks_onLinux()
		links { "lua" }
		prepare()
		test.capture [[
<Link>
	<SubSystem>Console</SubSystem>
	<AdditionalDependencies>-llua;%(AdditionalDependencies)</AdditionalDependencies>
		]]
	end

--
-- Sibling projects need to be listed in additional dependencies, as VSLinux
-- won't link them implicitly.
--

	function suite.includeSiblings_onLinux()
		links { "MyProject2" }
		test.createproject(wks)
		kind "SharedLib"
		prepare()
		test.capture [[
<Link>
	<SubSystem>Console</SubSystem>
	<AdditionalDependencies>$(RemoteRootDir)/bin/Debug/MyProject2.lib;%(AdditionalDependencies)</AdditionalDependencies>
		]]
	end
