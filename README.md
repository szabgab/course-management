# Courses


## Docker

```
docker build -t  courses .
```

```
docker run --rm courses prove -l
```

See the `run` file.


## Docker Compose

For development run

```
cp docker-compose.override.yml.example docker-compose.override.yml
docker-compose up
```

In another terminal you can type:

```
docker-compose exec web bash

```

## Features

If a logged in user arrives to the main page or immediately after login
redirect to the list of courses.

## Maybe TODO

If the user is only listed in one course, after login and from the main page redirect to that course.


