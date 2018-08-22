local ROOT_DIR = path.getdirectory(_SCRIPT) .. "/"

-- Load the OpenSSL extension
include "modules/openssl/openssl.lua"
local openssl = premake.extensions.openssl

-- Configure the OpenSSL build
openssl_config = {
	src_dir = ROOT_DIR .. "openssl-1.0.2p/",
	include_dir = ROOT_DIR .. "include/",
	excluded_libs = {
		"jpake",
		"rc5",
		"md2",
		"store",
		"engine",
	},
}

--
-- Generate public OpenSSL header files
-- 
print "Generating header files"
premake.extensions.openssl.copy_public_headers(openssl_config)

--
-- Generate a solution with crypto/ssl Static Library projects
--
--[[
solution "libssl"
	configurations {
		"debug",
		"release",
	}

	language "C"
	kind "StaticLib"

	location (ROOT_DIR .. "../../Build/")
	objdir (ROOT_DIR .. "../../Build/obj/")

	configuration {"debug"}
		targetdir (ROOT_DIR .. "../../Build/lib/debug/")

	configuration {"release"}
		optimize "Speed"
		targetdir (ROOT_DIR .. "../../Build/lib/release/")

	configuration {}
--]]

project "crypto"
	configurations {
		"Debug",
		"Release",
	}

	filter { 'system:windows' }
		platforms   { 'x86', 'x64' }

	language "C"
	kind "StaticLib"

	location (ROOT_DIR .. "../../Build/")

	--location (ROOT_DIR .. "../../Build/")
	--objdir (ROOT_DIR .. "../../Build/Bin/")

	--configuration {"Debug"}
		--targetdir (ROOT_DIR .. "../../Build/Bin/Debug/")

	configuration {"Release"}
		optimize "Speed"
		--targetdir (ROOT_DIR .. "../../Build/Bin/Release/")

	configuration {}
	openssl.crypto_project(openssl_config)

project "ssl"
	configurations {
		"Debug",
		"Release",
	}

	filter { 'system:windows' }
		platforms   { 'x86', 'x64' }

	language "C"
	kind "StaticLib"

	location (ROOT_DIR .. "../../Build/")

	--location (ROOT_DIR .. "../../Build/")
	--objdir (ROOT_DIR .. "../../Build/obj/")

	--configuration {"Debug"}
	--	targetdir (ROOT_DIR .. "../../Build/Bin/Debug/")

	configuration {"Release"}
		optimize "Speed"
	--	targetdir (ROOT_DIR .. "../../Build/Bin/Release/")

	configuration {}
	openssl.ssl_project(openssl_config)
