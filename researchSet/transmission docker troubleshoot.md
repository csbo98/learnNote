# transmission docker问题解决

transmission docker每天会都会因为>warning: unable to write status file: Socket not connected< 这样一个错误导致docnker容器终止，只需要重新启动即可(或者删除容器再create)，但是因为相应的用户没有chown权限，因此需要手动的更改settings.json文件的权限。

```bash

# 先检测容器状态是否为up
podman ps -a | grep transmission | awk '{print $1}'
# stop状态下，只要删除即可
rm -rf ~/docker/transmission/config/settings.json

# 删除容器
podman rm transmission
# 创建容器
podman create --name=transmission \                                                                
--restart=always \
-v /home/bliu/docker/transmission/config:/config \
-v /home/bliu/docker/transmission/downloads:/downloads \
-v /home/bliu/docker/transmission/watch:/watch \
-e PGID=1001 -e PUID=1001 \
-e TZ=Asia/Shanghai \
-p 9091:9091 -p 51413:51413 \
-p 51413:51413/udp \
linuxserver/transmission

# 启动容器
podman start transmission

# 更改权限,失败一次，因为settings.json文件是abc用户创建的
podman exec -w /config transmission chmod 777 settings.json
```
