# LuaJIT-Request
![shield_license]
![shield_release_version]
![shield_prerelease_version]
![shield_dev_version]

A simple HTTP(S) request module in pure LuaJIT. Requires libcurl binaries with SSL support, which can be obtained from the curl website. Alternatively, you can download them from the GitHub releases section.

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

[shield_license]: https://img.shields.io/badge/license-zlib/libpng-333333.svg?style=flat-square
[shield_release_version]: https://img.shields.io/badge/release-2.0-brightgreen.svg?style=flat-square
[shield_prerelease_version]: https://img.shields.io/badge/prerelease-none-lightgrey.svg?style=flat-square
[shield_dev_version]: https://img.shields.io/badge/in_development-none-lightgrey.svg?style=flat-square