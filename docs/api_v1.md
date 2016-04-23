### API V1 Documentation.

Please note, that this description is in prototype state.

-------------------------------------------------------

## <a name="resource-comment">Comment</a>

Stability: `prototype`

Comments description

### Attributes

| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **content** | *string* | unique name of comment | `"Some comment"` |
| **id** | *number* | unique identifier of comment | `"42"` |

### Comment Info

Info for existing comment.

```
GET /comments/{comment_id}
```


#### Curl Example

```bash
$ curl -n https://mysterious.com/api/v1/comments/$COMMENT_ID
```


#### Response Example

```
HTTP/1.1 200 OK
```

```json
{
  "comment" : {
    "id" : "42",
    "content" : "Some comment",
    "post" : {
      "id" : "some-post"
    },
    "user" : {
      "login" : "user-login"
    }
  }
}
```

### Comment List

List existing comments.

```
GET /comments
```


#### Curl Example

```bash
$ curl -n https://mysterious.com/api/v1/comments
 -G \
  -d page=1
```


#### Response Example

```
HTTP/1.1 200 OK
```

```json
{
  "comments" : [
    {
      "id" : "42",
      "content" : "Some comment",
      "post" : {
        "id" : "some-post"
      },
      "user" : {
        "login" : "user-login"
      }
    }
  ],
  "meta" : {
    "current_page" : 1,
    "next_page" : 2,
    "prev_page" : 1,
    "total_pages" : 5,
    "total_count" : 10
  }
}
```

### Comment Update

Update an existing comment.

```
PUT /comments/{comment_id}
```


#### Curl Example

```bash
$ curl -n -X PUT https://mysterious.com/api/v1/comments/$COMMENT_ID \
  -d '{
  "comment" : {
    "content" : "Some comment"
  }
}' \
  -H "Content-Type: application/json"
```


#### Response Example

```
HTTP/1.1 200 OK
```

```json
{
  "comment" : {
    "id" : "42",
    "content" : "Some comment"
  }
}
```

### Comment Delete

Delete an existing comment.

```
DELETE /comments/{comment_id}
```


#### Curl Example

```bash
$ curl -n -X DELETE https://mysterious.com/api/v1/comments/$COMMENT_ID \
  -H "Content-Type: application/json"
```


#### Response Example

```
HTTP/1.1 200 OK
```

```json
{
  "success" : true
}
```

### Comment List

List existing comments for existing post.

```
GET /posts/{post_id_or_slug}/comments
```


#### Curl Example

```bash
$ curl -n https://mysterious.com/api/v1/posts/$POST_ID_OR_SLUG/comments
 -G \
  -d page=1
```


#### Response Example

```
HTTP/1.1 200 OK
```

```json
{
  "comments" : [
    {
      "id" : "42",
      "content" : "Some comment",
      "post" : {
        "id" : "some-post"
      },
      "user" : {
        "login" : "user-login"
      }
    }
  ],
  "meta" : {
    "current_page" : 1,
    "next_page" : 2,
    "prev_page" : 1,
    "total_pages" : 5,
    "total_count" : 10
  }
}
```

### Comment Create

Create a new comment for post.

```
POST /posts/{post_id_or_slug}/comments
```


#### Curl Example

```bash
$ curl -n -X POST https://mysterious.com/api/v1/posts/$POST_ID_OR_SLUG/comments \
  -d '{
  "comment" : {
    "content" : "Some comment"
  }
}' \
  -H "Content-Type: application/json"
```


#### Response Example

```
HTTP/1.1 201 Created
```

```json
{
  "comment" : {
    "id" : "42",
    "content" : "Some comment"
  }
}
```


## <a name="resource-post">Post</a>

Stability: `prototype`

FIXME

### Attributes

| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **content** | *string* | post content | `"Lorem ipsum dolor sit amet, consectetur adipiscing elit ..."` |
| **id** | *string* | unique identifier of post | `"some-post"` |
| **meta_desc** | *string* | post meta description | `"Meta description"` |
| **meta_keywords** | *string* | post meta keywords | `"Meta keywords"` |
| **slug** | *string* | name of the post | `"post-title"` |
| **status** | *string* | status of the post<br/> **one of:**`"published"` or `"unpublished"` | `"published"` |
| **title** | *string* | name of the post | `"Post title"` |

### Post Create

Create a new post.

```
POST /posts
```


#### Curl Example

```bash
$ curl -n -X POST https://mysterious.com/api/v1/posts \
  -d '{
  "post" : {
    "title" : "Post title",
    "slug" : "post-title",
    "status" : "published",
    "content" : "Lorem ipsum dolor sit amet, consectetur adipiscing elit ...",
    "meta_keywords" : "Meta keywords",
    "meta_desc" : "Meta description"
  }
}' \
  -H "Content-Type: application/json"
```


#### Response Example

```
HTTP/1.1 201 Created
```

```json
{
  "post" : {
    "id" : "some-post",
    "title" : "Post title",
    "slug" : "post-title",
    "status" : "published",
    "content" : "Lorem ipsum dolor sit amet, consectetur adipiscing elit ...",
    "meta_keywords" : "Meta keywords",
    "meta_desc" : "Meta description"
  }
}
```

### Post Follow

Follow post.

```
POST /posts/{post_id_or_slug}/follow
```


#### Curl Example

```bash
$ curl -n -X POST https://mysterious.com/api/v1/posts/$POST_ID_OR_SLUG/follow \
  -H "Content-Type: application/json"
```


#### Response Example

```
HTTP/1.1 200 OK
```

```json
{
  "post" : {
    "id" : "some-post",
    "title" : "Post title",
    "slug" : "post-title",
    "status" : "published",
    "content" : "Lorem ipsum dolor sit amet, consectetur adipiscing elit ...",
    "meta_keywords" : "Meta keywords",
    "meta_desc" : "Meta description"
  }
}
```

### Post Unfollow

Unfollow post.

```
POST /posts/{post_id_or_slug}/unfollow
```


#### Curl Example

```bash
$ curl -n -X POST https://mysterious.com/api/v1/posts/$POST_ID_OR_SLUG/unfollow \
  -H "Content-Type: application/json"
```


#### Response Example

```
HTTP/1.1 200 OK
```

```json
{
  "post" : {
    "id" : "some-post",
    "title" : "Post title",
    "slug" : "post-title",
    "status" : "published",
    "content" : "Lorem ipsum dolor sit amet, consectetur adipiscing elit ...",
    "meta_keywords" : "Meta keywords",
    "meta_desc" : "Meta description"
  }
}
```

### Post Publish

Publish post.

```
POST /posts/{post_id_or_slug}/publish
```


#### Curl Example

```bash
$ curl -n -X POST https://mysterious.com/api/v1/posts/$POST_ID_OR_SLUG/publish \
  -H "Content-Type: application/json"
```


#### Response Example

```
HTTP/1.1 200 OK
```

```json
{
  "post" : {
    "id" : "some-post",
    "title" : "Post title",
    "slug" : "post-title",
    "status" : "published",
    "content" : "Lorem ipsum dolor sit amet, consectetur adipiscing elit ...",
    "meta_keywords" : "Meta keywords",
    "meta_desc" : "Meta description"
  }
}
```

### Post Unpublish

Unpublish post.

```
POST /posts/{post_id_or_slug}/unpublish
```


#### Curl Example

```bash
$ curl -n -X POST https://mysterious.com/api/v1/posts/$POST_ID_OR_SLUG/unpublish \
  -H "Content-Type: application/json"
```


#### Response Example

```
HTTP/1.1 200 OK
```

```json
{
  "post" : {
    "id" : "some-post",
    "title" : "Post title",
    "slug" : "post-title",
    "status" : "published",
    "content" : "Lorem ipsum dolor sit amet, consectetur adipiscing elit ...",
    "meta_keywords" : "Meta keywords",
    "meta_desc" : "Meta description"
  }
}
```

### Post Delete

Delete an existing post.

```
DELETE /posts/{post_id_or_slug}
```


#### Curl Example

```bash
$ curl -n -X DELETE https://mysterious.com/api/v1/posts/$POST_ID_OR_SLUG \
  -H "Content-Type: application/json"
```


#### Response Example

```
HTTP/1.1 200 OK
```

```json
{
  "success" : true
}
```

### Post Info

Info for existing post.

```
GET /posts/{post_id_or_slug}
```


#### Curl Example

```bash
$ curl -n https://mysterious.com/api/v1/posts/$POST_ID_OR_SLUG
```


#### Response Example

```
HTTP/1.1 200 OK
```

```json
{
  "post" : {
    "id" : "some-post",
    "title" : "Post title",
    "slug" : "post-title",
    "status" : "published",
    "content" : "Lorem ipsum dolor sit amet, consectetur adipiscing elit ...",
    "meta_keywords" : "Meta keywords",
    "meta_desc" : "Meta description",
    "owner" : {
      "login" : "user-login"
    }
  }
}
```

### Post List

List existing posts.

```
GET /posts
```


#### Curl Example

```bash
$ curl -n https://mysterious.com/api/v1/posts
 -G \
  -d page=1
```


#### Response Example

```
HTTP/1.1 200 OK
```

```json
{
  "posts" : [
    {
      "id" : "some-post",
      "title" : "Post title",
      "slug" : "post-title",
      "status" : "published",
      "content" : "Short content",
      "meta_keywords" : "Meta keywords",
      "meta_desc" : "Meta description",
      "owner" : {
        "login" : "user-login"
      }
    }
  ],
  "meta" : {
    "current_page" : 1,
    "next_page" : 2,
    "prev_page" : 1,
    "total_pages" : 5,
    "total_count" : 10
  }
}
```

### Post Update

Update an existing post.

```
PUT /posts/{post_id_or_slug}
```


#### Curl Example

```bash
$ curl -n -X PUT https://mysterious.com/api/v1/posts/$POST_ID_OR_SLUG \
  -d '{
  "post" : {
    "title" : "Post title",
    "slug" : "post-title",
    "status" : "published",
    "content" : "Lorem ipsum dolor sit amet, consectetur adipiscing elit ...",
    "meta_keywords" : "Meta keywords",
    "meta_desc" : "Meta description"
  }
}' \
  -H "Content-Type: application/json"
```


#### Response Example

```
HTTP/1.1 200 OK
```

```json
{
  "post" : {
    "id" : "some-post",
    "title" : "Post title",
    "slug" : "post-title",
    "status" : "published",
    "content" : "Lorem ipsum dolor sit amet, consectetur adipiscing elit ...",
    "meta_keywords" : "Meta keywords",
    "meta_desc" : "Meta description"
  }
}
```


## <a name="resource-shared">Shared</a>

Stability: `prototype`

Shared data for our schemas


## <a name="resource-token">Token</a>

Stability: `prototype`

Token description

### Attributes

| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **access_token** | *string* | unique token identifier of user | `"example"` |

### Token Update

Get a new token.

```
PUT /tokens
```


#### Curl Example

```bash
$ curl -n -X PUT https://mysterious.com/api/v1/tokens \
  -d '{}' \
  -H "Content-Type: application/json"
```


#### Response Example

```
HTTP/1.1 200 OK
```

```json
{
  "access_token" : "example"
}
```


## <a name="resource-user">User</a>

Stability: `prototype`

Something about user resource

### Attributes

| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **email** | *email* | unique email of user | `"aa@bb.ru"` |
| **id** | *integer* | unique identifier of user | `44` |
| **login** | *string* | unique login of user | `"user-login"` |
| **role** | *string* | role of user<br/> **one of:**`"guest"` or `"user"` or `"admin"` | `"guest"` |

### User Create

Create a new user.

```
POST /users
```


#### Curl Example

```bash
$ curl -n -X POST https://mysterious.com/api/v1/users \
  -d '{
  "user" : {
    "login" : "user-login",
    "email" : "aa@bb.ru",
    "role" : "guest"
  }
}' \
  -H "Content-Type: application/json"
```


#### Response Example

```
HTTP/1.1 201 Created
```

```json
{
  "user" : {
    "id" : 44,
    "login" : "user-login",
    "email" : "aa@bb.ru",
    "role" : "guest"
  }
}
```

### User Delete

Delete an existing user.

```
DELETE /users/{user_id_or_login}
```


#### Curl Example

```bash
$ curl -n -X DELETE https://mysterious.com/api/v1/users/$USER_ID_OR_LOGIN \
  -H "Content-Type: application/json"
```


#### Response Example

```
HTTP/1.1 200 OK
```

```json
{
  "success" : true
}
```

### User Info

Info for existing user.

```
GET /users/{user_id_or_login}
```


#### Curl Example

```bash
$ curl -n https://mysterious.com/api/v1/users/$USER_ID_OR_LOGIN
```


#### Response Example

```
HTTP/1.1 200 OK
```

```json
{
  "user" : {
    "id" : 44,
    "login" : "user-login",
    "email" : "aa@bb.ru",
    "role" : "guest",
    "followings" : [
      {
        "id" : "some-post",
        "title" : "Post title",
        "slug" : "post-title",
        "status" : "published",
        "content" : "Short content"
      }
    ]
  }
}
```

### User List

List existing users.

```
GET /users
```


#### Curl Example

```bash
$ curl -n https://mysterious.com/api/v1/users
 -G \
  -d page=1
```


#### Response Example

```
HTTP/1.1 200 OK
```

```json
{
  "users" : [
    {
      "id" : 44,
      "login" : "user-login",
      "email" : "aa@bb.ru",
      "role" : "guest"
    }
  ],
  "meta" : {
    "current_page" : 1,
    "next_page" : 2,
    "prev_page" : 1,
    "total_pages" : 5,
    "total_count" : 10
  }
}
```

### User Update

Update an existing user.

```
PUT /users/{user_id_or_login}
```


#### Curl Example

```bash
$ curl -n -X PUT https://mysterious.com/api/v1/users/$USER_ID_OR_LOGIN \
  -d '{
  "user" : {
    "login" : "user-login",
    "email" : "aa@bb.ru",
    "role" : "guest"
  }
}' \
  -H "Content-Type: application/json"
```


#### Response Example

```
HTTP/1.1 200 OK
```

```json
{
  "user" : {
    "id" : 44,
    "login" : "user-login",
    "email" : "aa@bb.ru",
    "role" : "guest"
  }
}
```


