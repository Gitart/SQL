## Remotely access to database

```sh
ssh -L 12341:127.0.0.1:3306 root@myServer &
$ mysql -h 127.0.0.1 -p 12341
```
