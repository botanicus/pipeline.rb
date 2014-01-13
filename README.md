# About

Plugin pipeline infrastructure connected **through RabbitMQ**. The plugins are just **normal Ruby gems**.

```
Instance(s) of plugin 1 -> RabbitMQ broker -> Instance(s) of plugin 2
```

It uses `amq.topic` exchange, so **you can use globs** to consume from within a plugin or a custom script. So if you want to see all the messages going through the system, simply create a queue a bind it to `amq.topic` with routing key `#`. Need all the events? `#event#`. Easy as that.

# Why?

It's been proved over and over that splitting app into services and is the way to go, because:

* It's **easier to maintain** such app.
* **Rewriting components** is easy.
* It's **easy to scale** by adding more consumers of given service.
* It's **easy to inspect** what's going on.
* It's much **easier to split work** on the project between multiple developers.
* You can **restart services without losing any data**, as they are kept in RabbitMQ.
* You don't have to introduce any code dependencies: just consume given queue and publish to another one.

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

# HOWTO

Pipeline.rb expects you to provide AMQP configuration, so it knows how to connect to RabbitMQ:

`config/amqp.json`:

```json
{
  "vhost": "example",
  "user":  "example",
}
```

`config/amqp.local.json`:

```json
{
  "password": "ae28cd87adb5c385117f89e9bd452d18"
}
```

Don't forget to ignore the local settings `.gitignore`:

```
config/*.local.json
```

Shop for plugins and add them to your `Gemfile`:

```ruby
source 'https://rubygems.org'

# The app uses pipeline.rb itself.
gem 'pipeline.rb'

# Tasks.
gem 'nake'

# Existing pipeline.rb plugins.
group(:plugins) do
  gem 'mail_queue'
end
```

```ruby
#!/usr/bin/env bundle exec nake

# Load all the plugins.
Bundler.require(:plugins)

require 'pipeline/tasks.rb'
```

Now run `./tasks.rb declare` to declare all the required queues.

And finally create your app:

```ruby
require 'mail_queue'

# This is already loaded,
# but just to make it clear
# that the app is actually
# just another plugin.
require 'pipeline/plugin'

class App < Pipeline::Plugin
  def run
    EM.add_timer(0.5) do
      client.publish("Hello World!", 'emails.random')
    end
  end
end
```

And finally run it all:

1. Start RabbitMQ.
2. Start `bin/mail_queue.rb` to send your emails.
3. Run your app.

# Deployment

TODO: Show example Upstart scripts.
