# API Documentation

  * [SnitchApiWeb.UserController](#snitchapiweb-usercontroller)
    * [update](#snitchapiweb-usercontroller-update)
    * [change_password](#snitchapiweb-usercontroller-change_password)

## SnitchApiWeb.UserController
### <a id=snitchapiweb-usercontroller-update></a>update
#### User info update updates user account information
##### Request
* __Method:__ PATCH
* __Path:__ /api/v1/users/419
* __Request headers:__
```
accept: application/vnd.api+json
content-type: application/vnd.api+json
authorization: Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJzbml0Y2hfYXBpIiwiZXhwIjoxNjA1NTY4NTM4LCJpYXQiOjE2MDMxNDkzMzgsImlzcyI6InNuaXRjaF9hcGkiLCJqdGkiOiI1YzUwMTI5YS02NDhiLTQyYmYtOTAxOS1iYjY4ZDIzM2FlZGEiLCJuYmYiOjE2MDMxNDkzMzcsInN1YiI6IjQxOSIsInR5cCI6ImFjY2VzcyJ9.ej5CizWRWDfGt31aoocEkVy8t_FslzHhkqRXxYpitz6T4-grDPpIwBjzNrEfPlGuSVKPVSbZIzRwYcgAI6KV0g
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
x-request-id: Fj-H1EBP6O9MC2EAAAyh
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
      "self": "/users/419"
    },
    "id": "419",
    "attributes": {
      "name": "Changed Names",
      "last_name": "Names",
      "first_name": "Changed",
      "email": "minion-8@snitch.com"
    }
  }
}
```

#### User info update tries to update with empty fields
##### Request
* __Method:__ PATCH
* __Path:__ /api/v1/users/415
* __Request headers:__
```
accept: application/vnd.api+json
content-type: application/vnd.api+json
authorization: Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJzbml0Y2hfYXBpIiwiZXhwIjoxNjA1NTY4NTM3LCJpYXQiOjE2MDMxNDkzMzcsImlzcyI6InNuaXRjaF9hcGkiLCJqdGkiOiJlYmZhNmYzMy1mYTg0LTQ0ZTItYWRkNy1kZTY0YTQ2MDJmNDgiLCJuYmYiOjE2MDMxNDkzMzYsInN1YiI6IjQxNSIsInR5cCI6ImFjY2VzcyJ9.p2lsAbw4R1Cfktq4-ZLZZUw16MnDtFoU-nLyfBLLiJbryJmD1hY2ebGF9QdioR_9p1lrwLEXZo1SSVK0rOyg9A
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
x-request-id: Fj-H1DlIVVQ7bFQAAAvB
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
* __Path:__ /api/v1/users/418
* __Request headers:__
```
accept: application/vnd.api+json
content-type: application/vnd.api+json
authorization: Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJzbml0Y2hfYXBpIiwiZXhwIjoxNjA1NTY4NTM4LCJpYXQiOjE2MDMxNDkzMzgsImlzcyI6InNuaXRjaF9hcGkiLCJqdGkiOiI3NWVjODRjNS04NTJkLTQ4MDgtODliYS1hMTNjN2RmYWY3M2QiLCJuYmYiOjE2MDMxNDkzMzcsInN1YiI6IjQxOCIsInR5cCI6ImFjY2VzcyJ9.vlPYSBj1YKgb97sHwX_TDC8fn35MBMH9Mlkd8p3WHrWQXpqI0jMddcPsNJj0R3iG0lIB3tm6jbb_3QaQDpMSfw
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
x-request-id: Fj-H1D_fnC3bwzAAAAyB
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
      "self": "/users/418"
    },
    "id": "418",
    "attributes": {
      "name": "Snitch-7 Elixir-7",
      "last_name": "Elixir-7",
      "first_name": "Snitch-7",
      "email": "minion-7@snitch.com"
    }
  }
}
```

### <a id=snitchapiweb-usercontroller-change_password></a>change_password
#### Change password when logged in changes user password
##### Request
* __Method:__ PATCH
* __Path:__ /api/v1/users/416/change_password
* __Request headers:__
```
accept: application/vnd.api+json
content-type: application/vnd.api+json
authorization: Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJzbml0Y2hfYXBpIiwiZXhwIjoxNjA1NTY4NTM3LCJpYXQiOjE2MDMxNDkzMzcsImlzcyI6InNuaXRjaF9hcGkiLCJqdGkiOiJhOTUxMjk5MS00NWNiLTQyZGItOGVlNi1jYmUxYTVlMTk5MWMiLCJuYmYiOjE2MDMxNDkzMzYsInN1YiI6IjQxNiIsInR5cCI6ImFjY2VzcyJ9.sc6r_vvWkZHpNVfz-sKYMyf3ILoFp0lZzKfsPw3OHSh-QH8h1TRcPBcfu3_sY3mJNyLb9OY0IpcJw9wggEp4zg
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
x-request-id: Fj-H1DtwaGE5bMQAAAEl
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
      "self": "/users/416"
    },
    "id": "416",
    "attributes": {
      "name": "Snitch-4 Elixir-4",
      "last_name": "Elixir-4",
      "first_name": "Snitch-4",
      "email": "minion-4@snitch.com"
    }
  }
}
```

#### Change password when logged in enters too short password
##### Request
* __Method:__ PATCH
* __Path:__ /api/v1/users/417/change_password
* __Request headers:__
```
accept: application/vnd.api+json
content-type: application/vnd.api+json
authorization: Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJzbml0Y2hfYXBpIiwiZXhwIjoxNjA1NTY4NTM4LCJpYXQiOjE2MDMxNDkzMzgsImlzcyI6InNuaXRjaF9hcGkiLCJqdGkiOiI1ZWRlY2MwYS01OWE1LTQzYTQtYTBjZS1hMjVlMjIxZmU2NDgiLCJuYmYiOjE2MDMxNDkzMzcsInN1YiI6IjQxNyIsInR5cCI6ImFjY2VzcyJ9.3ra04IoXPIvVoTe2cr27oX-p6wyS_mTOLTnVk6eRqcInQKP92kuTd4LnyfNK5YaY9bEsCh8d6jfqUjgjDWDjNg
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
x-request-id: Fj-H1D9AKBv_ZKcAAAxh
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
* __Path:__ /api/v1/users/424/change_password
* __Request headers:__
```
accept: application/vnd.api+json
content-type: application/vnd.api+json
authorization: Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJzbml0Y2hfYXBpIiwiZXhwIjoxNjA1NTY4NTM4LCJpYXQiOjE2MDMxNDkzMzgsImlzcyI6InNuaXRjaF9hcGkiLCJqdGkiOiJkMmJiZTAxNS02ZTY4LTQyYmMtYWQwMC0zYjk2MGM3MmVjZDQiLCJuYmYiOjE2MDMxNDkzMzcsInN1YiI6IjQyNCIsInR5cCI6ImFjY2VzcyJ9.6XADKEHNQdYHkmck6ZA4Gdst6bD6rw4odMxhfYjCbSO3hi_yGZbBIgntR-4UFRt8tPUNyPX8TfP6YPV2eElx3A
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
x-request-id: Fj-H1EOggxucLSEAAANi
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

