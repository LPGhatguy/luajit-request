--[[
LuaJIT-Request
Lucien Greathouse
Wrapper for LuaJIT-cURL for easy HTTP(S) requests.

Copyright (c) 2014 lucien Greathouse

This software is provided 'as-is', without any express
or implied warranty. In no event will the authors be held
liable for any damages arising from the use of this software.

Permission is granted to anyone to use this software for any purpose,
including commercial applications, andto alter it and redistribute it
freely, subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not
claim that you wrote the original software. If you use this software
in a product, an acknowledgment in the product documentation would be
appreciated but is not required.

2. Altered source versions must be plainly marked as such, and must
not be misrepresented as being the original software.

3. This notice may not be removed or altered from any source distribution.
]]

local ffi = require("ffi")
local curl = require("luajit-curl")
local request

local function url_encode(str)
	if (str) then
		str = str:gsub("\n", "\r\n")
		str = str:gsub("([^%w %-%_%.%~])", function(c)
			return string.format ("%%%02X", string.byte(c))
		end)
		str = str:gsub(" ", "%%20")
	end
	return str
end

local function cookie_encode(str, name)
	str = str:gsub("[,;%s]", "")

	if (name) then
		str = str:gsub("=", "")
	end

	return str
end

local auth_map = {
	BASIC = curl.CURLAUTH_BASIC,
	DIGEST = curl.CURLAUTH_DIGEST,
	NEGOTIATE = curl.CURLAUTH_NEGOTIATE
}

request = {
	error = {
		unknown = 0,
		timeout = 1
	},

	--[[
		Send an HTTP(S) request to the URL at 'url' using the HTTP method 'method'.
		Use the 'args' parameter to optionally configure the request:
			- method: HTTP method to use. Defaults to "GET", but can be any HTTP verb like "POST" or "PUT"
			- data: Dictionary or string to send as request body
			- cookies: Dictionary table of cookies to send
			- timeout: How long to wait for the connection to be made before giving up
			- allow_redirects: Whether or not to allow redirection. Defaults to true
			- stream_callback: A method to call with each piece of the response. If not specified, the entire page will be downloaded and returned.
			- auth_type: Authentication method to use. Defaults to "none", but can also be "basic" or "digest"
			- username: A username to use with authentication. 'auth_type' must also be specified.
			- password: A password to use with authentication. 'auth_type' must also be specified.
	]]
	send = function(url, args)
		local handle = curl.curl_easy_init()
		local out
		args = args or {}

		curl.curl_easy_setopt(handle, curl.CURLOPT_URL, url)
		curl.curl_easy_setopt(handle, curl.CURLOPT_SSL_VERIFYPEER, 1)
		curl.curl_easy_setopt(handle, curl.CURLOPT_SSL_VERIFYHOST, 2)

		if (args.method) then
			local method = string.upper(tostring(args.method))

			if (method == "GET") then
				curl.curl_easy_setopt(handle, curl.CURLOPT_HTTPGET, 1)
			elseif (method == "POST") then
				curl.curl_easy_setopt(handle, curl.CURLOPT_POST, 1)
			else
				curl.curl_easy_setopt(handle, curl.CURLOPT_CUSTOMREQUEST, method)
			end
		end

		if (args.auth_type) then
			local auth = string.upper(tostring(args.auth_type))

			if (auth_map[auth]) then
				curl.curl_easy_setopt(handle, curl.CURLOPT_HTTPAUTH, auth_map[auth])
				curl.curl_easy_setopt(handle, curl.CURLOPT_USERNAME, tostring(args.username))
				curl.curl_easy_setopt(handle, curl.CURLOPT_PASSWORD, tostring(args.password or ""))
			else
				error("Unsupported authentication type '" .. auth .. "'")
			end
		end

		if (args.stream_callback) then
			curl.curl_easy_setopt(handle, curl.CURLOPT_WRITEFUNCTION, ffi.cast("curl_callback", function(data, size, nmeb, user)
				args.stream_callback(ffi.string(data, size * nmeb))
				return size * nmeb
			end))
		else
			out = {}

			curl.curl_easy_setopt(handle, curl.CURLOPT_WRITEFUNCTION, ffi.cast("curl_callback", function(data, size, nmeb, user)
				table.insert(out, ffi.string(data, size * nmeb))
				return size * nmeb
			end))
		end

		if (args.follow_redirects == nil) then
			curl.curl_easy_setopt(handle, curl.CURLOPT_FOLLOWLOCATION, true)
		else
			curl.curl_easy_setopt(handle, curl.CURLOPT_FOLLOWLOCATION, not not args.follow_redirects)
		end

		if (args.data) then
			if (type(args.data) == "table") then
				local buffer = {}
				for key, value in pairs(args.data) do
					table.insert(buffer, ("%s=%s"):format(url_encode(key), url_encode(value)))
				end

				curl.curl_easy_setopt(handle, curl.CURLOPT_POSTFIELDS, table.concat(buffer, "&"))
			else
				curl.curl_easy_setopt(handle, curl.CURLOPT_POSTFIELDS, tostring(args.data))
			end
		end

		if (args.cookies) then
			local buffer = {}
			for key, value in pairs(args.cookies) do
				table.insert(buffer, ("%s=%s"):format(cookie_encode(key, true), cookie_encode(value)))
			end

			curl.curl_easy_setopt(handle, curl.CURLOPT_COOKIE, table.concat(buffer, "; "))
		end

		if (tonumber(args.timeout)) then
			curl.curl_easy_setopt(handle, curl.CURLOPT_CONNECTTIMEOUT, tonumber(args.timeout))
		end

		local result = curl.curl_easy_perform(handle)
		curl.curl_easy_cleanup(handle)

		if (result == curl.CURLE_OK) then
			if (out) then
				return table.concat(out)
			else
				return true
			end
		elseif (result == curl.CURLE_OPERATION_TIMEDOUT) then
			return false, request.error.timeout, "Connection timed out"
		else
			return false, request.error.unknown, "Unknown error"
		end
	end,

	init = function()
		curl.curl_global_init(curl.CURL_GLOBAL_ALL)
	end,

	close = function()
		curl.curl_global_cleanup()
	end
}

request.init()

return request