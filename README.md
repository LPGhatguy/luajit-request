# LuaJIT-Request
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