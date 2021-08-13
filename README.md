# WIP!!  DO NOT USE, WORK IN PROGRESS
## oletools verify over TCP socket in a Docker container

(From [Mailcow](https://github.com/mailcow/mailcow-dockerized/tree/master/data/Dockerfiles/olefy) and [Heinlein Support](https://github.com/HeinleinSupport/olefy))

## Environment Variables
| Name                 | Desription                             | Default     |
| -------------------- | -------------------------------------- | ----------- |
| OLEFY_BINDPORT       | Port that olefy listens on             | 10050       |
| OLEFY_TMPDIR         | Temporary folder                       | /tmp        |
| OLEFY_PYTHON_PATH    | Path of the python interpreter    | /usr/bin/python3 |
| OLEFY_LOGLVL         | 10:DEBUG,20:INFO,30:WARNING,40:ERROR,50:CRITICAL | 20|
| OLEFY_MINLENGTH      | Minimum size of file to scan           | 500         |
| OLEFY_DEL_TMP        | Delete temp files after use            | 1           |
| OLEFY_DEL_TMP_FAILED | Delete temp files on failure           | 1           |
| TIMEZONE             | For container, eg Europe/London        | unset       |

## Run
docker run -p 10050:10050 --name olefy neomediatech/olefy
