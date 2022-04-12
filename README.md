# Description

This is a Delphi REST API example, using [HashLoad]( https://github.com/HashLoad "HashLoad") components.

Source code was created on Delphi Rio (10.3).

### Getting started
BOSS dependency manager for Delphi and Lazarus installation: 
 * Download [setup](https://github.com/hashload/boss/releases)
 * Just type `boss` in cmd
 * (Optional) Install a [Boss Delphi IDE complement](https://github.com/hashload/boss-ide)

### > Update
This command update installed dependencies. Must be executed on folder (src\) where is located boss.json 
```
boss update
```


##### So, that's it! Now the project can be compiled!


#### > Payload examples

------------
127.0.0.1:9000/api/login
```json
{
  "name": "prova",
  "username": "prova",
  "password": "seventh"
}
```

------------


127.0.0.1:9000/api/servers
```json
{
  "id": "{FC7D04A5-9AE1-43EE-B4F3-67D2C133E2E5}",
  "name": "Servidor 1",
  "ip": "127.0.0.1",
  "port": 9000
}
```

------------
127.0.0.1:9000/api/servers/:server_id/videos
```json
{
  "description": "Video 1"
}
```

------------
127.0.0.1:9000/api/servers/:server_id/videos
```json
{
    "content": ""
}
```

------------
