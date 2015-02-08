# LuaJIT-Request Changelog

## 2.0
- `stream_callback` parameter is now `body_stream_callback`
- Added `header_stream_callback` parameter for processing headers
- Return format is now a dictionary instead of a string containing the request body.
	- This enables more data to be given back, including headers and the HTTP status code.
	- See the code documentation for more details on this.