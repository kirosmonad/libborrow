# README

## Routes

### Sign In and Sing out

```
    POST /api/v1/session
    DELETE /api/v1/session
```

This routes work setting cookies since I'm assuming the FE app will be served from the same origin than the backend and we can rely in the browser cookie jar

### Books
```
    GET /api/v1/books -> list books
    POST /api/v1/books -> create book
    GET /api/v1/books/:id -> Show book
    PUT /api/v1/books/:id -> update book
    DELETE /api/v1/books/:id -> destroy book
```
