# WIP!!  DO NOT USE, WORK IN PROGRESS
## oletools verify over TCP socket in a Docker container

(From [Mailcow](https://github.com/mailcow/mailcow-dockerized/tree/master/data/Dockerfiles/olefy) and [Heinlein Support](https://github.com/HeinleinSupport/olefy))

## Run
docker run -p 10050:10050 -e OLEFY_BINDADDRESS=0.0.0.0 --name olefy neomediatech/olefy
