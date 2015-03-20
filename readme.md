

# Mock http server


## Overview

A HTTP server whose responses are controled via a post HTTP request to the 'setup' endpoint



## Installation

- clone this repository

- run `bundle install`

- `rackup` to start the server




## Usage
- send http post setup command with the end_point, the method, and the response body
- currently only get and post are supported

## Example

```
POST /setup HTTP/1.1
Host: localhost:9292
Cache-Control: no-cache

[{"end_point": "verify/api", "method": "get", "response_body": "response body payload"}]
```

When the get verify/api enpoint is called the response will be `response body payload`
```
GET /verify/api HTTP/1.1
Host: localhost:9292
Cache-Control: no-cache
```