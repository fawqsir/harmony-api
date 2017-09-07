# Harmony API!!

Harmony API is a simple server allowing you to query/control multiple local [Harmony
Home Hubs](http://myharmony.com/products/detail/home-hub/) and their devices
over HTTP

With HTTP, you can simply turn on and off activities, check hub status, and send
commands to individual devices with simple HTTP requests from almost any other
project.

## Features

* Control multiple Harmony hubs.
* List activities.
* Get current status, including if everything is off, or what the current
activity is.
* Turn everything off.
* Start a specific activity.
* List devices.
* List device commands.
* Execute discrete commands for each device.

## Settings
#### Note: 
Harmony API will run on port `8282` by default. Use the `PORT` environment
variable to use your own port.

### Config file : 
For Manual Mode :
```json
{
	"enableHTTPserver": true,
	"hubs": [
		{
			"name": "Living",
			"ip": "192.168.5.200"
		}
	]
}
```
For Discovery Mode : 
```json
{
	"enableHTTPserver": true,
}
```
### Docker
Installation with Docker is straightforward. Adjust the following command so that
`/path/to/your/config` points to the folder where your want to store your config and run it:

    $ docker run --name="harmony-api" --net=host -v /path/to/your/config:/config -d adn182/harmony-api

This will launch Harmony API and serve the web interface from port 8282 on your Docker host. Hub
discovery requires host networking (`--net=host`). However, you can specify your Harmony Hubs in
`config.json` e.g.:
```json
  "hubs": [
    {
      "name": "Living Room",
      "ip": "192.168.1.111"
    },
    {
      "name": "Bedroom",
      "ip": "192.168.1.112"
    },
  ]
```

## HTTP API Docs

This is a quick overview of the HTTP service. Read [app.js](app.js) if you need more
info.

### Resources

Here's a list of resources that may be returned in a response.

#### Activity Resource

The Activity resource returns all the information you really need for an
Activity set up in your Harmony Hub.

```json
{
  "id": "15233552",
  "slug": "watch-tv",
  "label": "Watch TV",
  "isAVActivity": true
}
```

#### Device Resource

The Device resource returns all the information you need to know about the
devices set up for the hub.

```json
{
  "id": "38343689",
  "slug": "tivo-premiere",
  "label": "TiVo Premiere"
}
```

#### Command Resource

The Command resource returns all the information you really need for a
Command to let you execute it.

```json
{
  "name": "ChannelDown",
  "slug": "channel-down",
  "label":"Channel Down"
}
```

#### Status Resource

The Status resource returns the current state of your Harmony Hub.

```json
{
  "off": false,
  "current_activity": {
    "id": "15233552",
    "slug": "watch-tv",
    "label": "Watch TV",
    "isAVActivity": true
  }
}
```

### Methods

These are the endpoints you can hit to do things.

#### Info
  Use these endpoints to query the current state of your Harmony Hub.

    GET /hubs => {"hubs": ["family-room", "bedroom"] }
    GET /hubs/:hub_slug/status => StatusResource
    GET /hubs/:hub_slug/commands => {"commands": [CommandResource, CommandResource, ...]}
    GET /hubs/:hub_slug/activities => {"activities": [ActivityResource, ActivityResource, ...]}
    GET /hubs/:hub_slug/activities/:activity_slug/commands => {"commands": [CommandResource, CommandResource, ...]}
    GET /hubs/:hub_slug/devices => {"devices": [DeviceResource, DeviceResource, ...]}
    GET /hubs/:hub_slug/devices/:device_slug/commands => {"commands": [CommandResource, CommandResource, ...]}

#### Control
  Use these endpoints to control your devices through your Harmony Hub.

    PUT /hubs/:hub_slug/off => {message: "ok"}
    POST /hubs/:hub_slug/commands/:command_slug => {message: "ok"}
    POST /hubs/:hub_slug/commands/:command_slug?repeat=3 => {message: "ok"}
    POST /hubs/:hub_slug/activities/:activity_slug => {message: "ok"}
    POST /hubs/:hub_slug/devices/:device_slug/commands/:command_slug => {message: "ok"}
    POST /hubs/:hub_slug/devices/:device_slug/commands/:command_slug?repeat=3 => {message: "ok"}
