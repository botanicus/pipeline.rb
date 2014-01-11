# About

# Settings

Pipeline.rb uses JSON for configuration.

The cool thing is it supports global and local configuration. That means for instance if you want to configure a database, you're probably going to use the same database drivers on either development machine or on production server.

So first let's create a global configuration file `config/database.json`:

```json
{
  "adapter":  "mysql",
  "username": "mysql",
  "database": "example"
}
```

And now the local `config/database.local.json`:

```json
{
  "password": "ae28cd87adb5c385117f89e9bd452d18"
}
```

Don't forget to ignore the local settings `.gitignore`:

```
config/*.local.json
```

# Start

`config/amqp.json`

```json
{
  "vhost": "example",
  "user":  "example",
}
```

`config/amqp.local.json`

```json
{
  "password": "ae28cd87adb5c385117f89e9bd452d18"
}
```

`.gitignore`

```
config/*.local.json
```