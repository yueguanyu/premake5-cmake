--
-- Name:        cmake/cmake_workspace.lua
-- Purpose:     Generate a cmake workspace.
-- Author:      Ryan Pusztai
-- Modified by: Andrea Zanellato
--              Manu Evans
-- Created:     2013/05/06
-- Copyright:   (c) 2008-2015 Jason Perkins and the Premake project
--

	local p = premake
	local project = p.project
	local workspace = p.workspace
	local tree = p.tree
	local cmake = p.modules.cmake

	cmake.workspace = {}
	local m = cmake.workspace

--
-- Generate a cmake workspace
--
	function m.generate(wks)
		p.utf8()

		--
		-- Header
		--

		p.w('cmake_minimum_required (VERSION 3.4.1)')
		p.w([=[
	# You can tweak some common (for all subprojects) stuff here. For example:

	#set(CMAKE_DISABLE_IN_SOURCE_BUILD ON)
	#set(CMAKE_DISABLE_SOURCE_CHANGES  ON)

	if ("${CMAKE_SOURCE_DIR}" STREQUAL "${CMAKE_BINARY_DIR}")
	message(SEND_ERROR "In-source builds are not allowed.")
	endif ()

	#set(CMAKE_VERBOSE_MAKEFILE ON)
	#set(CMAKE_COLOR_MAKEFILE   ON)

		]=])

		local tagsdb = ""
	--		local tagsdb = "./" .. wks.name .. ".tags"
		--p.push('<cmake_Workspace Name="%s" Database="%s" SWTLW="No">', wks.name, tagsdb)

		--
		-- Project list
		--

		p.w("project ('%s')", wks.name)

		p.w([=[
	# When done tweaking common stuff, configure the components (subprojects).
	# NOTE: The order matters! The most independent ones should go first.

		]=])

		local tr = workspace.grouptree(wks)
		tree.traverse(tr, {
			onleaf = function(n)
				local prj = n.project

				-- Build a relative path from the workspace file to the project file
				local prjpath = p.filename(prj, ".project")
				prjpath = path.getrelative(prj.workspace.location, prjpath)

				-- p.w("include(%s.cmake)",prj.name)
				p.w("add_subdirectory( \"%s\" )", path.getrelative( path.getabsolute(wks.location), prj.location))
				-- if (prj.name == wks.startproject) then
				-- 	p.w('<Project Name="%s" Path="%s" Active="Yes"/>', prj.name, prjpath)
				-- else
				-- 	p.w('<Project Name="%s" Path="%s"/>', prj.name, prjpath)
				-- end
			end,

			onbranchenter = function(n)
				--p.push('<VirtualDirectory Name="%s">', n.name)
			end,

			onbranchexit = function(n)
				--p.pop('</VirtualDirectory>')
			end,
		})

		--
		-- Configurations
		--

		-- count the number of platforms
		local platformsPresent = {}
		local numPlatforms = 0

		for cfg in workspace.eachconfig(wks) do
			local platform = cfg.platform
			if platform and not platformsPresent[platform] then
				numPlatforms = numPlatforms + 1
				platformsPresent[platform] = true
			end
		end

		if numPlatforms >= 2 then
			cmake.workspace.multiplePlatforms = true
		end

		-- for each workspace config
		--p.push('<BuildMatrix>')
		for cfg in workspace.eachconfig(wks) do

			local cfgname = cmake.cfgname(cfg)
			--p.push('<WorkspaceConfiguration Name="%s" Selected="yes">', cfgname)

			local tr = workspace.grouptree(wks)
			tree.traverse(tr, {
				onleaf = function(n)
					local prj = n.project
					--p.w('<Project Name="%s" ConfigName="%s"/>', prj.name, cfgname)
				end
			})
			--p.pop('</WorkspaceConfiguration>')

		end
		--p.pop('</BuildMatrix>')

		--p.pop('</cmake_Workspace>')
	end
