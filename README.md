## nginx-php70-cron

Docker image for running cronjobs. This image has php70 installed. This docker image is designed to be run as user www-data. So no root needed.


## More on non-root launch.

* As you can see in the Dockerfile the user within the container is www-data (typical user for this type of thing). It has UID 33. Which happens to be the default user in most Ubuntu installs. This also matches up with www-data group which is GUID 33 as well. When mounting volumes make sure you have a user on your system with an UID 33 and GUID 33 (or update the Dockerfile to meet your needs).

* Here is a sample docker-compose.yml. Notice we pass in our own crontab file?

```
version: '2.1'

services:

  cron:

    image: cloudmanic/nginx-php70-cron
 
    volumes:
      - ./crontab:/crontabs/www-data
```