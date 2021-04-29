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
docker-compose -f docker-compose.yml -f docker-compose-override.yml up
```

In another terminal you can type:

```
docker-compose exec web bash

```


