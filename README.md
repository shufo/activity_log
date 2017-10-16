# ActivityLog

Logging activities with [Activitiy Streams](https://www.w3.org/TR/activitystreams-core/) like format (not the same, but inspired).

## Installation

```elixir
def deps do
  [
    {:activity_log, "~> 0.1.0"}
  ]
end
```

## Usage

Define your activities.

```elixir
defmodule MyApp.Activity.Article do
  use ActivityLog

  activity "create" do
    actor  :user
    object :article
  end

  def name(actor, object), do: "#{actor.name} created #{object.name}"
end
```

Create activity.


```elixir
iex> alias MyApp.Activity.Article
iex> activity = %Article{actor: %Article.Actor{id: 1, name: "foo"}, object: %Article.Object{id: 1, name: "My article"}}
iex> ActivityLog.add(activity)
# outputs
05:29:32.128 [info]  {"type":"create","target":null,"object":{"type":"article","name":"My article","id":1},"name":"foo createed My article","actor":{"type":"user","name":"foo","id":1},"@timestamp":"2017-10-15T20:29:32.128192Z","@context":"https://github.com/shufo/activity_log"}
:ok
```

## How to

### Define target

If you want to add the `target` property, define target in your activity module.

```elixir
defmodule MyApp.Activity.Comment do
  use ActivityLog

  activity "add" do
    actor  :user
    object :comment
    target :article
  end

  def name(actor, object, target), do: "#{actor.name} commented #{object.name} to #{target.name}"
end

iex> alias MyApp.Activity.Comment
# create activity
iex> activity = %Comment{actor: %Comment.Actor{id: 1, name: "foo"}, object: %Comment.Object{id: 2, name: "Nice article!"}, target: %Comment.Target{id: 3, name: "My article"}}
iex> ActivityLog.add(activity)
# => 05:27:34.877 [info]  {"type":"add","target":{"type":"article","name":"My article","id":3},"object":{"type":"comment","name":"Nice article!","id":2},"name":"foo commented Nice article! to My article","actor":{"type":"user","name":"foo","id":1},"@timestamp":"2017-10-15T20:27:34.877639Z","@context":"https://github.com/shufo/activity_log"}
:ok
```

### Change Logger

Default logger is Elixir's built-in [Logger](https://hexdocs.pm/logger/Logger.html).

If you want to change the logging backend, define your logger and configuration.

```elixir
config :activity_log, backends: [YourApp.Logger]
```

You need to implement the `Activity.Logger` behaviour. (`add/2`)

```elixir
defmodule YourApp.Logger do
  def add(activity, opts \\ []) do
    # do something
  end
end
```