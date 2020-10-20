# API Documentation

  * [SnitchApiWeb.UserController](#snitchapiweb-usercontroller)
    * [update](#snitchapiweb-usercontroller-update)
    * [change_password](#snitchapiweb-usercontroller-change_password)

## SnitchApiWeb.UserController
### <a id=snitchapiweb-usercontroller-update></a>update
#### User info update updates user account information
##### Request
* __Method:__ PATCH
* __Path:__ /api/v1/users/1
* __Request headers:__
```
accept: application/vnd.api+json
content-type: application/vnd.api+json
authorization: Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJzbml0Y2hfYXBpIiwiZXhwIjoxNjA1NTY4ODQ2LCJpYXQiOjE2MDMxNDk2NDYsImlzcyI6InNuaXRjaF9hcGkiLCJqdGkiOiJlMjFjYjM5NC0xOWM3LTQxNGItYWJkZC01NDdkMzljMjA4MWIiLCJuYmYiOjE2MDMxNDk2NDUsInN1YiI6IjEiLCJ0eXAiOiJhY2Nlc3MifQ.J28UaLJSYH9ZLHv_X_WXZDWtK1mD75FtulcDSqTTUDTzSYQoOZ4zAMOi-EkEITG5EZY-sIZdGWg_1LCvc4w6zw
```
* __Request body:__
```json
{
  "last_name": "Names",
  "first_name": "Changed"
}
```

##### Response
* __Status__: 200
* __Response headers:__
```
content-type: application/vnd.api+json; charset=utf-8
cache-control: max-age=0, private, must-revalidate
x-request-id: Fj-IHAyCcjBcmAwAAAOi
```
* __Response body:__
```json
{
  "jsonapi": {
    "version": "1.0"
  },
  "data": {
    "type": "user",
    "links": {
      "self": "/users/1"
    },
    "id": "1",
    "attributes": {
      "name": "Changed Names",
      "last_name": "Names",
      "first_name": "Changed",
      "email": "minion-0@snitch.com"
    }
  }
}
```

#### User info update tries to update with empty fields
##### Request
* __Method:__ PATCH
* __Path:__ /api/v1/users/3
* __Request headers:__
```
accept: application/vnd.api+json
content-type: application/vnd.api+json
authorization: Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJzbml0Y2hfYXBpIiwiZXhwIjoxNjA1NTY4ODQ2LCJpYXQiOjE2MDMxNDk2NDYsImlzcyI6InNuaXRjaF9hcGkiLCJqdGkiOiIwYTg5MTdmMi1hODY1LTRlNGEtYjU1NC1kYjVlOTI1NzljMjEiLCJuYmYiOjE2MDMxNDk2NDUsInN1YiI6IjMiLCJ0eXAiOiJhY2Nlc3MifQ.pE6UhtRTZAcNWoShIYDLy-80lSvZqd9WCgb1QCfvvrllDkB47e13ouSsRRfzO7NEYriwgkU8QhgZ24nPrkjNDQ
```
* __Request body:__
```json
{
  "last_name": "",
  "first_name": "Changed"
}
```

##### Response
* __Status__: 422
* __Response headers:__
```
content-type: application/json; charset=utf-8
cache-control: max-age=0, private, must-revalidate
x-request-id: Fj-IHBKGq1KhQM8AAAhB
```
* __Response body:__
```json
{
  "errors": {
    "last_name": [
      "should be at least 1 character(s)"
    ]
  }
}
```

#### User info update tries to update email
##### Request
* __Method:__ PATCH
* __Path:__ /api/v1/users/10
* __Request headers:__
```
accept: application/vnd.api+json
content-type: application/vnd.api+json
authorization: Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJzbml0Y2hfYXBpIiwiZXhwIjoxNjA1NTY4ODQ2LCJpYXQiOjE2MDMxNDk2NDYsImlzcyI6InNuaXRjaF9hcGkiLCJqdGkiOiI3MGVmNTY2NS1kNmE4LTQyYzItYjM5NC0wMzNlMzU3NDllMTQiLCJuYmYiOjE2MDMxNDk2NDUsInN1YiI6IjEwIiwidHlwIjoiYWNjZXNzIn0.9KfgscYGE8-nA0FzX0A0yuEgQNX2x4HLbKNKldQVcujVHSWMqUDYuc35cYdwfjZXSwJSh8nRMyfEgG-mm7tO_w
```
* __Request body:__
```json
{
  "email": "change@email.test"
}
```

##### Response
* __Status__: 200
* __Response headers:__
```
content-type: application/vnd.api+json; charset=utf-8
cache-control: max-age=0, private, must-revalidate
x-request-id: Fj-IHBm1hhScLSEAAAmh
```
* __Response body:__
```json
{
  "jsonapi": {
    "version": "1.0"
  },
  "data": {
    "type": "user",
    "links": {
      "self": "/users/10"
    },
    "id": "10",
    "attributes": {
      "name": "Snitch-13 Elixir-13",
      "last_name": "Elixir-13",
      "first_name": "Snitch-13",
      "email": "minion-13@snitch.com"
    }
  }
}
```

### <a id=snitchapiweb-usercontroller-change_password></a>change_password
#### Change password when logged in changes user password
##### Request
* __Method:__ PATCH
* __Path:__ /api/v1/users/7/change_password
* __Request headers:__
```
accept: application/vnd.api+json
content-type: application/vnd.api+json
authorization: Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJzbml0Y2hfYXBpIiwiZXhwIjoxNjA1NTY4ODQ2LCJpYXQiOjE2MDMxNDk2NDYsImlzcyI6InNuaXRjaF9hcGkiLCJqdGkiOiI4Njc3Y2Q2ZS0zZWMzLTQ2N2YtYTEzNS05ODcyNjU5ZGM5YzYiLCJuYmYiOjE2MDMxNDk2NDUsInN1YiI6IjciLCJ0eXAiOiJhY2Nlc3MifQ.-8UXK_0A80mQGQaejp7KS29_ApbxXsltJgQIzWA85t4d9kEbQ-tY4oylu6Tgx8PIQKf0mBmZ0N2z0GmATVRQWA
```
* __Request body:__
```json
{
  "password_confirmation": "new_password",
  "password": "new_password"
}
```

##### Response
* __Status__: 200
* __Response headers:__
```
content-type: application/vnd.api+json; charset=utf-8
cache-control: max-age=0, private, must-revalidate
x-request-id: Fj-IHBfNBQ1_lSYAAAAj
```
* __Response body:__
```json
{
  "jsonapi": {
    "version": "1.0"
  },
  "data": {
    "type": "user",
    "links": {
      "self": "/users/7"
    },
    "id": "7",
    "attributes": {
      "name": "Snitch-10 Elixir-10",
      "last_name": "Elixir-10",
      "first_name": "Snitch-10",
      "email": "minion-10@snitch.com"
    }
  }
}
```

#### Change password when logged in enters too short password
##### Request
* __Method:__ PATCH
* __Path:__ /api/v1/users/5/change_password
* __Request headers:__
```
accept: application/vnd.api+json
content-type: application/vnd.api+json
authorization: Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJzbml0Y2hfYXBpIiwiZXhwIjoxNjA1NTY4ODQ2LCJpYXQiOjE2MDMxNDk2NDYsImlzcyI6InNuaXRjaF9hcGkiLCJqdGkiOiIxYzc4ZTUzMS02OGNlLTRlY2EtYWUwMS00ZWYyOGM3NTE2NDciLCJuYmYiOjE2MDMxNDk2NDUsInN1YiI6IjUiLCJ0eXAiOiJhY2Nlc3MifQ.57DNE4KqdPofDRQK9UK482pj9UJNm7HvaCWZiQx8H6Q_Agd67JV-kd0KoifKTr8qZyPZyaXgZLdkiOCuvGzX5A
```
* __Request body:__
```json
{
  "password_confirmation": "short",
  "password": "short"
}
```

##### Response
* __Status__: 422
* __Response headers:__
```
content-type: application/json; charset=utf-8
cache-control: max-age=0, private, must-revalidate
x-request-id: Fj-IHBZ5fYhMC2EAAAlB
```
* __Response body:__
```json
{
  "errors": {
    "password": [
      "should be at least 8 character(s)"
    ]
  }
}
```

#### Change password when logged in passwords don't match
##### Request
* __Method:__ PATCH
* __Path:__ /api/v1/users/9/change_password
* __Request headers:__
```
accept: application/vnd.api+json
content-type: application/vnd.api+json
authorization: Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJzbml0Y2hfYXBpIiwiZXhwIjoxNjA1NTY4ODQ2LCJpYXQiOjE2MDMxNDk2NDYsImlzcyI6InNuaXRjaF9hcGkiLCJqdGkiOiJlMWM1YzAxMS1lMmIzLTQ0NDMtOGNlZi0wNWU0MTFmZjIxOTUiLCJuYmYiOjE2MDMxNDk2NDUsInN1YiI6IjkiLCJ0eXAiOiJhY2Nlc3MifQ.YB8eNPtXSqq5OnZwhwEJJht8wF2OHptxKF7pPV49bB13rlWWW3bwM5-GBK1qwI83xWatGZewxqaJh4pL52QE7Q
```
* __Request body:__
```json
{
  "password_confirmation": "mismatch_password",
  "password": "new_password"
}
```

##### Response
* __Status__: 422
* __Response headers:__
```
content-type: application/json; charset=utf-8
cache-control: max-age=0, private, must-revalidate
x-request-id: Fj-IHBkJyQ05W2kAAAGk
```
* __Response body:__
```json
{
  "errors": {
    "password_confirmation": [
      "does not match confirmation"
    ]
  }
}
```

