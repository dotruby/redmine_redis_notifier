# Redmine Event Notifier

This Redmine Plugin enhances several core models with a Redis PubSub logic. Whenever such objects are created, a message is published on a Redis channel. You could then implement you own subcription logic on Redis and do whatever you'd like with the given message information. Use cases could be something like this:

* On project creation also create a folder structure on the file server
* On user creation add the user to certain lists
* On issue removal also remove a github issue
* etc. (possibilites are endless)

This plugin was developed and tested with Redmine 5.x. Thanks to DOM Digital Online Media GmbH (https://www.dom.de) for allowing us to open source this.

## Install

1. Ensure that Redis is running on your server and the connection is either defined by the default localhost connection or set with the REDIS_URL environment variable, e.g. `export REDIS_URL=redis://localhost:6379`
2. Install the plugin with cloning the code into your `plugin` directory in your Redmine installation, e.g. `git clone https://github.com/dotruby/redmine_event_notifier`
3. Run bundle install to install the redis gem: `bundle install`
4. Run plugin migrations: `bundle exec rake redmine:plugins:migrate NAME=redmine_event_notifier`
5. Restart redmine to pickup the changes

## Events and actions

These models are tracked with the corresponding actions. The information sent to the channels is very minimal, it's basically only the object id.

| Model  | Actions | Redis publish channel | Message Data |
| ------------- | ------------- | ------------- | ------------- |
| Group  | `create\|update\|destroy`  | `redmine/event_notifications/groups/#{action}` | `{"id": 1}` |
| Issue  | `create\|update\|destroy`  | `redmine/event_notifications/issues/#{action}` | `{"id": 1}` |
| Project  | `create\|update\|destroy`  | `redmine/event_notifications/projects/#{action}` | `{"id": 1, identifier: "Project name"}` |
| Role  | `create\|update\|destroy`  | `redmine/event_notifications/roles/#{action}` | `{"id": 1}` |
| TimeEvent  | `create\|update\|destroy`  | `redmine/event_notifications/time_events/#{action}` | `{"id": 1}` |
| User  | `create\|update\|destroy`  | `redmine/event_notifications/users/#{action}` | `{"id": 1}` |


## Usage

Each internal object event is stored in the table `event_notifications`. You can also view the events in Redmine in the admin section. If a message needs to be resend for any reason, you can do so in Redmine.

The subscription logic for the Redis channels is totally up to you. An easy example on how to deal with Redis subscription in Ruby can be found [here](https://github.com/redis/redis-rb/blob/master/examples/pubsub.rb), but you can of course use any language to implement your needs.

## Uninstall

1. Remove this gem by first removing the database table: `bundle exec rake redmine:plugins:migrate NAME=redmine_event_notifier VERSION=0`
2. Remove this plugin by going in the plugins folder and remove the plugin `redmine_event_notifier`: rm -r redmine_event_notifier
3. Restart Redmine to pickup the changes


## Changelog
### HEAD (not yet released)

### v0.0.1
* Initial Release


