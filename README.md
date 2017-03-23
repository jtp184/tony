# Dismal Tony

Dismal Tony is a gem I created that forms the framework for a system by which you can script human-language commands into actions with the Ruby programming language, using a Conversational Agent (called a "VI", or Virtual Intelligence). 

This Gem sets up a set of defaults, and a methodology that allows you to easily drop new commands into your workflow, and have the VI execute them easily. I designed it to be friendly and fun to engage with, while at the same time supporting all of Ruby's programming capability, to allow it to handle complex tasks with ease.


## Quickstart
Here's a snippet to get you started
```ruby
DismalTony::HandlerRegistry.load_handlers! './handlers'

tony = DismalTony::VIBase.new(
  :data_store => DismalTony::LocalStore.new(
    :filepath => './store.yml'
  )
)

@identity = tony.data_store.new_user

tony.query!("Hello", @identity)
```

Add your handlers to that directory, and you should have a working VI. Read on if you're more interested in the nitty-gritty, or skip ahead to **Writing a Handler**.
## Basic VI
A VI is the unit that handles queries and users. A Very basic VI could be called like so:
```ruby
tony = DismalTony::VIBase.new
```
We could then attempt to query the VI
```ruby
result = tony.query!("Hello")
```
But we wouldn't have any success as yet.
```
[🙁]: I'm sorry, I didn't understand that!
``` 

The Handler Registry has to first load in handlers, and a VI will load them in by default.

## Writing a Handler

Handlers are classes that you define in blocks, either one to a file or as many in one file as you'd like, dynamically or in static files that can be loaded in. This is a fairly robust starter one created from the generic QueryHandler class.
```ruby
DismalTony.create_handler do
  def handler_start
    @handler_name = 'initial-setup'
    @patterns = [/(begin|setup|start)/i]
  end

  def get_name(query, user)
    @data['name'] = query
    user['nickname'] = query
    DismalTony::HandledResponse.finish("~e:thumbsup Great! You're all set up, #{user['nickname']}!")
  end

  def message
    "Hello! I'm #{@vi.name}. I'm a virtual intelligence " \
    'designed for easy execution and automation of tasks.' \
    "\n\n" \
    "Let's start simple: What should I call you?"
  end

  def activate_handler(query, user)
    "I'll do initial setup"
  end
  
  def activate_handler!(query, user)
    DismalTony::HandledResponse.then_do(self, 'get_name', message)
  end
end
```
### Subclasses
The subclass handlers let you write less code if you're following common patterns

#### Canned Responses
Canned responses lets you quickly pick between any of a set of options in response to a handler. Simple 1-to-1 call and response.

```ruby
DismalTony.create_handler(DismalTony::CannedResponses) do
  def handler_start
    @handler_name = 'greeter'
    @patterns = ["hello", "hello, #{@vi.name}"]
    @responses = ['~e:wave Hello!', '~e:smile Greetings!', '~e:rocket Hi!', '~e:star Hello!', '~e:snake Greetings!', '~e:cat Hi!', '~e:octo Greetings!', '~e:spaceinvader Hello!']
  end
end
```

#### Result Query
Result Queries can be accessed in the code as well as via direct query, allowing you to stack queries together.
```ruby
DismalTony.create_handler(DismalTony::ResultQuery) do
  def handler_start
    @handler_name = "numtween"
    @patterns = [/print numbers between (?<start>\d+) and (?<end>\d+)/i]
  end

  def apply_format(input)
    result_string = "~e:smile Okay! Here they are: "
    result_string << input.join(', ')
  end

  def query_result(query, uid)
    parse query
    (@data['start'].to_i..@data['end'].to_i).to_a
  end
end
```

#### Query Menu
Query Menus let you present users with a list of options and follow them, allowing near infinite branching since the menu results are simply HandledResponses keyed to short choice strings

```ruby
DismalTony.create_handler(DismalTony::QueryMenu) do
  def handler_start
    @handler_name = 'animal-moji-menu'
    @patterns = [/show me an animal emoji/i]

    add_option(:dog, DismalTony::HandledResponse.finish("~e:dog Woof!"))
    add_option(:cat, DismalTony::HandledResponse.finish("~e:cat Meow!"))
    add_option(:fish, DismalTony::HandledResponse.finish("~e:fish Glub!"))
  end

  def menu(query, user)
    opts = @menu_choices.keys.map { |e| e.to_s.capitalize }
    DismalTony::HandledResponse.then_do(self, "index", "~e:thumbsup Sure! You can choose from the following options: #{opts.join(', ')}")
  end
end
```

## Storing Data
The DismalTony system allows you to store your users and user-data (necessary for multi-stage handlers) in different ways. Currently there are 3 implemented. 

### DataStorage
The base DataStorage class is a non-persistent Data Store that functions fine in IRB or for ephemeral instances, but doesn't save anything.
###LocalStore
The LocalStore class exports the user space as a YAML document.
```ruby
DismalTony::LocalStore.new(
  :filepath => './store.yml'
  )
```

### DBStore
DBStore is designed to let you use ActiveRecord Models (or appropriately duck-typed Model classes), so that you can use a VI in a rails project by creating a Model. Check out [TonyRails](https://github.com/jtp184/tonyrails) for more information, but the DBStore Class is part of the Gem itself.

```ruby
DismalTony::DBStore.new(TheModel)
```
