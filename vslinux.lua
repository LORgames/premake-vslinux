local p = premake

p.modules.vslinux = {}

local m = p.modules.vslinux
m.elements = {}

dofile("_preload.lua")

--
-- Visual Studio Scope
--

p.override(p.vstudio, "archFromConfig", function(oldfn, cfg, force)
	if _ACTION == "vs2015" and cfg.system == p.LINUX then
		return oldfn(cfg, false)
	else
		return oldfn(cfg, force)
	end
end)

--
-- Project Scope
--

p.override(p.vstudio.vc2010.elements, "project", function(oldfn, prj)
	local elements = oldfn(prj)
	if _ACTION == "vs2015" and prj.system == p.LINUX then
		local index = table.indexof(elements, p.vstudio.vc2010.importExtensionSettings)
		if index ~= nil then
			table.insert(elements, index + 1, m.importShared)
		else
			elements = table.join(elements, {
				m.importShared,
			});
		end
	end
	return elements
end)

function m.importShared(prj)
	if _ACTION == "vs2015" and prj.system == p.LINUX then
		p.w('<ImportGroup Label="Shared" />')
	end
end

p.override(p.vstudio.vc2010, "propertySheetGroup", function(oldfn, prj)
	if _ACTION == "vs2015" and prj.system == p.LINUX then
		p.w('<ImportGroup Label="PropertySheets" />')
	else
		oldfn(prj)
	end
end)

--
-- Globals Scope
--

p.override(p.vstudio.vc2010.elements, "globals", function(oldfn, prj)
	local elements = oldfn(prj)
	if _ACTION == "vs2015" and prj.system == p.LINUX then
		elements = table.join(elements, {
			m.applicationType,
			m.applicationTypeRevision,
			m.targetLinuxPlatform,
			m.minimumVisualStudioVersion,
		});
	end
	return elements
end)

function m.applicationType(prj)
	if _ACTION == "vs2015" and prj.system == p.LINUX then
		p.vstudio.vc2010.element("ApplicationType", nil, "Linux")
	end
end

function m.applicationTypeRevision(prj)
	if _ACTION == "vs2015" and prj.system == p.LINUX then
		p.vstudio.vc2010.element("ApplicationTypeRevision", nil, "1.0")
	end
end

function m.targetLinuxPlatform(prj)
	if _ACTION == "vs2015" and prj.system == p.LINUX then
		p.vstudio.vc2010.element("TargetLinuxPlatform", nil, "Generic")
	end
end

function m.minimumVisualStudioVersion(prj)
	if _ACTION == "vs2015" and prj.system == p.LINUX then
		p.vstudio.vc2010.element("MinimumVisualStudioVersion", nil, "14.0")
	end
end

p.override(p.vstudio.vc2010, "keyword", function(oldfn, prj)
	if _ACTION == "vs2015" and prj.system == p.LINUX then
		p.vstudio.vc2010.element("Keyword", nil, "Linux")
		p.vstudio.vc2010.element("RootNamespace", nil, "%s", prj.name)
	else
		oldfn(prj)
	end
end)

p.override(p.vstudio.vc2010, "characterSet", function(oldfn, cfg)
	if not (_ACTION == "vs2015" and cfg.system == p.LINUX) then
		oldfn(cfg)
	end
end)

p.override(p.vstudio.vc2010, "platformToolset", function(oldfn, cfg)
	if not (_ACTION == "vs2015" and cfg.system == p.LINUX) then
		oldfn(cfg)
	end
end)

--
-- Output Properties Scope
--

p.override(p.vstudio.vc2010.elements, "outputProperties", function(oldfn, cfg)
	if not (_ACTION == "vs2015" and cfg.system == p.LINUX) then
		return oldfn(cfg)
	else
		return {
			m.remoteProjectDir,
			p.vstudio.vc2010.outDir,
			p.vstudio.vc2010.intDir,
			p.vstudio.vc2010.targetName,
		}
	end
end)

function m.remoteProjectDir(cfg)
	p.vstudio.vc2010.element("RemoteProjectDir", nil, "$(RemoteRootDir)/" .. cfg.location:sub(_MAIN_SCRIPT_DIR:len() + 2))
end

--
-- ClCompile Scope
--

p.override(p.vstudio.vc2010.elements, "clCompile", function(oldfn, cfg)
	local elements = oldfn(cfg)
	if _ACTION == "vs2015" and cfg.system == p.LINUX then
		elements = table.join(elements, {
			m.languageStandard,
		})
	end
	return elements
end)

function m.languageStandard(cfg)
	if _ACTION == "vs2015" and cfg.system == p.LINUX then
		if cfg.flags["C++11"] then
			p.vstudio.vc2010.element("CLanguageStandard", nil, "c11")
			p.vstudio.vc2010.element("CppLanguageStandard", nil, "c++11")
		elseif cfg.flags["C++14"] then
			p.vstudio.vc2010.element("CLanguageStandard", nil, "c11")
			p.vstudio.vc2010.element("CppLanguageStandard", nil, "c++14")
		else -- This isn't the default but you can't unspecify C++11 or C++14, yet
			p.vstudio.vc2010.element("CLanguageStandard", nil, "Default")
			p.vstudio.vc2010.element("CppLanguageStandard", nil, "Default")
		end
	end
end

p.override(p.vstudio.vc2010, "warningLevel", function(oldfn, cfg)
	if _ACTION == "vs2015" and cfg.system == p.LINUX and cfg.warnings and cfg.warnings ~= "Off" then
		p.vstudio.vc2010.element("WarningLevel", nil, "EnableAllWarnings")
	elseif (_ACTION == "vs2015" and cfg.system == p.LINUX and cfg.warnings) or not (_ACTION == "vs2015" and cfg.system == p.LINUX) then
		oldfn(cfg)
	end
end)

p.override(p.vstudio.vc2010, "runtimeTypeInfo", function(oldfn, cfg)
	if _ACTION == "vs2015" and cfg.system == p.LINUX then
		if cfg.rtti == p.OFF then
			p.vstudio.vc2010.element("RuntimeTypeInfo", nil, "false")
		elseif cfg.rtti == p.ON then
			p.vstudio.vc2010.element("RuntimeTypeInfo", nil, "true")
		end
	else
		oldfn(cfg)
	end
end)

p.override(p.vstudio.vc2010, "debugInformationFormat", function(oldfn, cfg)
	if _ACTION == "vs2015" and cfg.system == p.LINUX then
		-- Is "Minimal" the same as "FastLink"?
		if cfg.symbols == p.OFF then
			p.vstudio.vc2010.element("DebugInformationFormat", nil, "None")
		elseif cfg.symbols == p.ON then
			p.vstudio.vc2010.element("DebugInformationFormat", nil, "FullDebug")
		end
	else
		oldfn(cfg)
	end
end)

p.override(p.vstudio.vc2010, "exceptionHandling", function(oldfn, cfg)
	if _ACTION == "vs2015" and cfg.system == p.LINUX then
		if cfg.exceptionhandling == p.OFF then
			p.vstudio.vc2010.element("ExceptionHandling", nil, "Disabled")
		elseif cfg.exceptionhandling == p.ON then
			p.vstudio.vc2010.element("ExceptionHandling", nil, "Enabled")
		end
	else
		oldfn(cfg)
	end
end)

--
-- Link Scope
--

p.override(p.vstudio.vc2010, "additionalDependencies", function(oldfn, cfg, explicit)
	if _ACTION == "vs2015" and cfg.system == p.LINUX then
		-- Collect both sets of links
		local links = p.tools.gcc.getlinks(cfg)
		local systemlinks = p.tools.gcc.getlinks(cfg, true)

		-- Prepend non-system links with "$(RemoteRootDir)/" to bypass path bugs in VSLinux,
		-- also fix the folder seperator and fix the path from x86_64 to x64.
		-- This should be removed once VSLinux can handle linking libraries.
		for i, v in ipairs(links) do
			if not table.contains(systemlinks, v) then
				links[i] = path.translate("$(RemoteRootDir)/" .. v, '/'):gsub("x86_64", "x64")
			end
		end

		if #links > 0 then
			links = table.concat(links, ";")
			p.vstudio.vc2010.element("AdditionalDependencies", nil, "%s;%%(AdditionalDependencies)", links)
		end
	else
		oldfn(cfg, explicit)
	end
end)

return m
