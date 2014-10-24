# LuaJIT-Request
A simple HTTP(S) request module in pure LuaJIT. Requires libcurl binaries with SSL support, which can be obtained from the curl website. Alternatively, you can download them from the GitHub releases section.

## Usage

### Simple GET
```lua
local request = require("luajit-request")

print(request.send("https://example.com"))
```

### Digest Authentication and Cookies
```lua
local request = require("luajit-request")

print(request.send("https://example.com", {
	cookies = {
		hello = "world"
	},

	auth_type = "digest",
	username = "user",
	password = "pass"
}))
```

### Forms
```lua
local request = require("luajit-request")

print(request.send("https://example.com", {
	method = "POST",
	data = {
		hello = "world"
	}
}))
```