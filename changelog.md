# LuaJIT-Request Changelog

![2.0](https://img.shields.io/badge/2.0-latest-brightgreen.svg?style=flat-square)
- `stream_callback` parameter is now `body_stream_callback`
- Added `header_stream_callback` parameter for processing headers
- Return format is now a dictionary instead of a string containing the request body.
	- This enables more data to be given back, including headers and the HTTP status code.
	- See the code documentation for more details on this.

![1.1.1](https://img.shields.io/badge/1.1.1-unsupported-red.svg?style=flat-square)
- cURL authentication objects are now pre-casted to reduce generated garbage.

![1.1.0](https://img.shields.io/badge/1.1.0-unsupported-red.svg?style=flat-square)
- `headers` argument.
- Authentication now functions.

![1.0](https://img.shields.io/badge/1.0-unsupported-red.svg?style=flat-square)
- Initial release!