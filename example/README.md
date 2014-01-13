# About

# Setup

## Set Up and Run RabbitMQ

```bash
rabbitmqctl add_user example ae28cd87adb5c385117f89e9bd452d18
rabbitmqctl add_vhost example
rabbitmqctl set_permissions -p example example '.*' '.*' '.*'
```

## Fill In Your Gmail Details

`config/smtp.local.json`

```json
{
  "user_name": "you@gmail.com",
  "password": "password",
}
```

## Run Bundler

`bundle install`

## Declare Queues

`./tasks.rb declare`

## Run `mail_queue` Consumer

`bundle exec mail_queue.rb`

## Run The App

`./app.rb`
