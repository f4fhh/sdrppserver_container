# sdrppserver_container
Docker container for sdr++ server, a linux I/Q stream server for SDRPlay RSP1, RSP1A, RSP2, RSPDuo, RSPdx

It works with compatible devices including:
* RSP1, RSP1A, RSP2, RSPDuo, RSPdx SDRPlay devices

### Notes
This server is intended to be used with [SDR++](https://github.com/AlexandreRouma/SDRPlusPlus) the bloat-free SDR software by [Alexandre Rouma](https://github.com/AlexandreRouma). Help him on [Patreon](https://www.patreon.com/ryzerth).

At this time (june 2022), this container installs the full SDR++ binary, needing all dependencies as the server mode is part of the desktop client. The debian package comes from the [latest development build](https://github.com/AlexandreRouma/SDRPlusPlus/actions) of SDR++. 

### Defaults
* Port 5259/tcp is used for the I/Q data stream and is exposed by default

### User Configured Environment Variables
* none

#### Example docker run

```
docker run -d \
--restart unless-stopped \
--name='sdrppserver' \
--device=/dev/bus/usb \
--volume=<host_config>:/config \
ghcr.io/f4fhh/sdrppserver_container
```
### HISTORY
 - Version 0.1.0: Initial build

### Credits
 - [SDRPlay](https://github.com/SDRplay) for the SDK of the RSP devices
 - [SDR++](https://github.com/AlexandreRouma/SDRPlusPlus) bloat-free SDR by [Alexandre Rouma](https://github.com/AlexandreRouma)
