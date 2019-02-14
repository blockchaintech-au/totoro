# Totoro, a RabbitMQ Util

Totoro is a RabbitMQ util that focuses on samplify queue operation. 
## Dependencies
Please install [Delayed Job active record](https://rubygems.org/gems/delayed_job_active_record) and [Delayed Job recurring](https://rubygems.org/gems/delayed_job_recurring) before use Totoro.
Totoro basically use delayed job to cache and resend falied messages.
## Installation

### Install gem
Add this line to your application's Gemfile:

```ruby
gem 'totoro'
```

And then execute:

    $ bundle

#### Initialize Totoro for Rails app
```
rails g totoro:init
```

This command will generate two files

1. `totoro.yml` (Rabbitmq configuration file)
2. `initilizers/totoro.rb` (Rails initializer)
3. `db/migrate/[tiemstamp]_create_totoro_failed_messages.rb` (DB migration to create messages caching table)

#### Run DB migraion
`rake db:migrate`

## Sample configuration

```yaml
default: &default
  default:
    connect:
      host: rabbitmq
      port: 5672
      user: app
      pass: app
    queue:
      normal_queue_for_both_enqueue_and_subscribe:
        name: default_exchange.queue.name
        durable: true
        clean_start: false
      exchange_queue_for_subscribe:
        name: fanout.exchange.queue
        durable: true
        exchange: fanout.exchange.name
    exchange:
      exchange_for_fanout_enqueue:
        name: fanout.exchange.name

  custom:
    connect:
      host: rabbitmq
      port: 5672
      user: app
      pass: app
    queue:
      custom_queue:
        name: custom.queue.name
        durable: true

development:
  <<: *default

test:
  <<: *default

production:
  <<: *default

```
## Quick Start

### Resend Failed messages daemon

Please run `rake totoro:resend_msg` before you start your app.

### Default rabbitmq server

#### Enqueue

```
Totoro::Queue.enqueue('queue_id', payload)
```

#### BroadCast (Enqueue to fanout exchange)

```
Totoro::Queue.broadcast('exchange_id', payload)
```

#### Dequeue
To create a dequeue daemon, first you need to create a worker
```
rails g totoro:worker <worker_name> <queue_name>
```
after that, add business logic in the process method
```
module Worker
  class WorkerClass < Totoro::BaseWorker
    setup queue_name: <queue_name>
    def process(payload, metadata, delivery_info)
      # worker process
    end
  end
end
```
finally, run the background deamon
```
bundle exec totoro worker_class
```

### Custom rabbitmq server

When you have more than one rabbitmq server to connect, you need to add custom configuration.

To use the custom rabbitmq server you need to add `ServerName` between `Totoro` and `Queue`

For example:

#### Enqueue

```
Totoro::<ServerName>::Queue.enqueue('queue', payload)
```

#### Dequeue
To create a dequeue daemon, first you need to create a worker
```
rails g totoro:wroker <worker_name> <queue_name> <prefix>
```
after that, add business logic in the process method
```
module Worker
  class WorkerClass < Totoro::BaseWorker
    setup queue_name: <queue_name>, prefix: <prefix>
    def process(payload, metadata, delivery_info)
      # worker process
    end
  end
end
```
finally, run the background deamon
```
bundle exec totoro worker_class
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/blockchaintech-au/totoro. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Totoro project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/totoro/blob/master/CODE_OF_CONDUCT.md).
