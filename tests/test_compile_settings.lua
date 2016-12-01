--
-- tests/test_compile_settings.lua
-- Validate generation of the output property groups.
-- Copyright (c) 2016-2017 Samuel Surtees and the Premake project
--

	local suite = test.declare("vslinux_compile_settings")
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
		vc2010.clCompile(cfg)
	end

--
-- Check the structure with the default project values.
--

	function suite.defaultSettings_onLinux()
		prepare()
		test.capture [[
<ClCompile>
	<PrecompiledHeader>NotUsing</PrecompiledHeader>
	<Optimization>Disabled</Optimization>
	<CLanguageStandard>Default</CLanguageStandard>
	<CppLanguageStandard>Default</CppLanguageStandard>
</ClCompile>
		]]
	end

--
-- If extra warnings is specified, emit element
--

	function suite.warningLevel_onExtraWarnings_onLinux()
		warnings "Extra"
		prepare()
		test.capture [[
<ClCompile>
	<PrecompiledHeader>NotUsing</PrecompiledHeader>
	<WarningLevel>EnableAllWarnings</WarningLevel>
	<Optimization>Disabled</Optimization>
	<CLanguageStandard>Default</CLanguageStandard>
	<CppLanguageStandard>Default</CppLanguageStandard>
</ClCompile>
		]]
	end

--
-- If the warnings are disabled, emit element
--

	function suite.warningLevel_onNoWarnings_onLinux()
		warnings "Off"
		prepare()
		test.capture [[
<ClCompile>
	<PrecompiledHeader>NotUsing</PrecompiledHeader>
	<WarningLevel>TurnOffAllWarnings</WarningLevel>
	<Optimization>Disabled</Optimization>
	<CLanguageStandard>Default</CLanguageStandard>
	<CppLanguageStandard>Default</CppLanguageStandard>
</ClCompile>
		]]
	end

--
-- Check RTTI
--

	function suite.runtimeTypeInfo_onRTTI_onLinux()
		rtti "On"
		prepare()
		test.capture [[
<ClCompile>
	<PrecompiledHeader>NotUsing</PrecompiledHeader>
	<Optimization>Disabled</Optimization>
	<RuntimeTypeInfo>true</RuntimeTypeInfo>
	<CLanguageStandard>Default</CLanguageStandard>
	<CppLanguageStandard>Default</CppLanguageStandard>
</ClCompile>
		]]
	end

	function suite.runtimeTypeInfo_onNoRTTI_onLinux()
		rtti "Off"
		prepare()
		test.capture [[
<ClCompile>
	<PrecompiledHeader>NotUsing</PrecompiledHeader>
	<Optimization>Disabled</Optimization>
	<RuntimeTypeInfo>false</RuntimeTypeInfo>
	<CLanguageStandard>Default</CLanguageStandard>
	<CppLanguageStandard>Default</CppLanguageStandard>
</ClCompile>
		]]
	end

--
-- Check symbols
--

	function suite.runtimeTypeInfo_onSymbols_onLinux()
		symbols "On"
		prepare()
		test.capture [[
<ClCompile>
	<PrecompiledHeader>NotUsing</PrecompiledHeader>
	<DebugInformationFormat>FullDebug</DebugInformationFormat>
	<Optimization>Disabled</Optimization>
	<CLanguageStandard>Default</CLanguageStandard>
	<CppLanguageStandard>Default</CppLanguageStandard>
</ClCompile>
		]]
	end

	function suite.runtimeTypeInfo_onNoSymbols_onLinux()
		symbols "Off"
		prepare()
		test.capture [[
<ClCompile>
	<PrecompiledHeader>NotUsing</PrecompiledHeader>
	<DebugInformationFormat>None</DebugInformationFormat>
	<Optimization>Disabled</Optimization>
	<CLanguageStandard>Default</CLanguageStandard>
	<CppLanguageStandard>Default</CppLanguageStandard>
</ClCompile>
		]]
	end

--
-- Check exception handling
--

	function suite.runtimeTypeInfo_onExceptions_onLinux()
		exceptionhandling "On"
		prepare()
		test.capture [[
<ClCompile>
	<PrecompiledHeader>NotUsing</PrecompiledHeader>
	<Optimization>Disabled</Optimization>
	<ExceptionHandling>Enabled</ExceptionHandling>
	<CLanguageStandard>Default</CLanguageStandard>
	<CppLanguageStandard>Default</CppLanguageStandard>
</ClCompile>
		]]
	end

	function suite.runtimeTypeInfo_onNoExceptions_onLinux()
		exceptionhandling "Off"
		prepare()
		test.capture [[
<ClCompile>
	<PrecompiledHeader>NotUsing</PrecompiledHeader>
	<Optimization>Disabled</Optimization>
	<ExceptionHandling>Disabled</ExceptionHandling>
	<CLanguageStandard>Default</CLanguageStandard>
	<CppLanguageStandard>Default</CppLanguageStandard>
</ClCompile>
		]]
	end
