--
-- tests/test_globals.lua
-- Validate generation of the Globals property group.
-- Copyright (c) 2016-2017 Samuel Surtees and the Premake project
--

	local suite = test.declare("vslinux_globals")
	local vc2010 = premake.vstudio.vc2010

--
-- Setup
--

	local wks, prj

	function suite.setup()
		premake.action.set("vs2015")
		wks = test.createWorkspace()
		system "Linux"
	end

	local function prepare()
		prj = test.getproject(wks, 1)
		vc2010.globals(prj)
	end

--
-- Emit Keyword, RootNamespace, ApplicationType, ApplicationTypeRevision,
-- TargetLinuxPlatform, MinimumVisualStudioVersion for Linux projects.
--

	function suite.includeElements_onLinux()
		prepare()
		test.capture [[
<PropertyGroup Label="Globals">
	<ProjectGuid>{42B5DBC6-AE1F-903D-F75D-41E363076E92}</ProjectGuid>
	<IgnoreWarnCompileDuplicatedFilename>true</IgnoreWarnCompileDuplicatedFilename>
	<Keyword>Linux</Keyword>
	<RootNamespace>MyProject</RootNamespace>
	<ApplicationType>Linux</ApplicationType>
	<ApplicationTypeRevision>1.0</ApplicationTypeRevision>
	<TargetLinuxPlatform>Generic</TargetLinuxPlatform>
	<MinimumVisualStudioVersion>14.0</MinimumVisualStudioVersion>
</PropertyGroup>
		]]
	end

--
-- Omit CharacterSet for Linux projects.
--

	function suite.excludeCharacterSet_onLinux()
		characterset "MBCS"
		prepare()
		test.capture [[
<PropertyGroup Label="Globals">
	<ProjectGuid>{42B5DBC6-AE1F-903D-F75D-41E363076E92}</ProjectGuid>
	<IgnoreWarnCompileDuplicatedFilename>true</IgnoreWarnCompileDuplicatedFilename>
	<Keyword>Linux</Keyword>
	<RootNamespace>MyProject</RootNamespace>
	<ApplicationType>Linux</ApplicationType>
	<ApplicationTypeRevision>1.0</ApplicationTypeRevision>
	<TargetLinuxPlatform>Generic</TargetLinuxPlatform>
	<MinimumVisualStudioVersion>14.0</MinimumVisualStudioVersion>
</PropertyGroup>
		]]
	end
