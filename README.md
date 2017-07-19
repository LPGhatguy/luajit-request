# LuaJIT-Request
![shield_license]
![shield_release_version]

A simple HTTP(S) request module in pure LuaJIT. Requires libcurl binaries with SSL support, which come preinstalled on macOS and many Linux distributions. On Windows, binaries can be obtained from https://curl.haxx.se/download.html

## Usage

### Simple GET
```lua
local request = require("luajit-request")
local response = request.send("https://example.com")

print(response.code)
print(response.body)
```

### Digest Authentication and Cookies
```lua
local request = require("luajit-request")

local response = request.send("https://example.com", {
	cookies = {
		hello = "world"
	},

	auth_type = "digest",
	username = "user",
	password = "pass"
})

print(response.body)
print(response.set_cookies)
```

### Forms
```lua
local request = require("luajit-request")

local response = request.send("https://example.com", {
	method = "POST",
	data = {
		hello = "world"
	}
})

print(response.code)
print(response.body)
```

### Stream file (2.3+)
```lua
local request = require("luajit-request")

local result, err, message = request.send("https://www.posttestserver.com/post.php", {
	method = "POST",
	files = {
		readme = "README.md"
	}
})

if (not result) then
	print(err, message)
end

print(result.body)
```

[shield_license]: https://img.shields.io/badge/license-zlib/libpng-333333.svg?style=flat-square
[shield_release_version]: https://img.shields.io/badge/release-2.4.0-brightgreen.svg?style=flat-square
