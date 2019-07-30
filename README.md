# About
Based of the image by cm2network found at: https://hub.docker.com/r/cm2network/mordhau.

# How to use
Adjust the `.ini` files to your liking and add any custom maps to the `maps` folder.
```
docker build -t mordhau-docker .
docker run -d --net=host --name=mordhau-docker mordhau-docker
```
