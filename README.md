# About
Based of the image by cm2network found at: https://hub.docker.com/r/cm2network/mordhau. The config and paks
directories are shared with the container and copied to their respective directories. This means that
changes to files in either of these directories will be applied on container restart.

## Mods
* You can find custom mods to use here: https://mordhau.mod.io/
* The modding community can be found here: https://discord.gg/ZbMnPMY

# How to use
```
git clone https://github.com/thobiasn/mordhau-docker && cd mordhau-docker
```

Adjust the config files found at `/config` and add any custom pak files to the `/paks` folder.

```
docker build -t mordhau-docker .

docker run -d --net=host \
    -v "$PWD":/tmp/mordhau \
    --name=mordhau-docker \
    mordhau-docker
```

## Specifying ports at runtime (for running multiple containers)

```
docker run -d --net=host \
    -v "$PWD":/tmp/mordhau \
    --name=mordhau-docker \
    --env SERVER_PORT=7777 \
    --env SERVER_QUERYPORT=27015 \
    --env SERVER_BEACONPORT=15000 \
    --env SERVER_RCONPORT=0 \
    mordhau-docker
```

To update config files or add new mods, simply make the changes and restart the container.
