# Execute command remotely via SSH 
## Remotely access to database

```sh
ssh -L 12341:127.0.0.1:3306 root@myServer &
$ mysql -h 127.0.0.1 -p 12341
```

## Sample

```sh
SCRIPT="SELECT count(*) FROM users;"
HOST="localhost"
USER="root"
PASSWORD="123"
mysql -h $HOST -u $USER -p$PASSWORD MyAppDB -e $SCRIPT
```

If I put this in a file called `query_user.sh` and grant `execute` permission to it like this

```
chmod +x query_user.sh

```

I can run this shell script like this (assuming that I am in the folder containing the file)

```
./query_user.sh

```

2.  Calling it remotely

---

This is very simple because it looks very similar to how to login via SSH. The syntax is

```
ssh <username>@<host> <command_on_server>

```

In our example, assume that my username is `deploy` and the host is `[example.com](http://example.com)`, my SSH command will be:

```
ssh deploy@example.com ./query_user.sh

```

3.  Executing it in background

---

By default, the SSH session will not be ended until the script on server finishes. To let the SSH session run in background, we can add `-f` option

```
ssh -f deploy@example.com ./query_user.sh
```
