class SayHello < Tony::QueryHandler
  def initialize
    @handler_name = 'say-hello'
    @patterns = ['^(?:say )?hello ?(?:,?(?:to (?<destination>\\d{10}|.+)))?(?:,?\\s?tony[!.]?)?'].map! { |e| Regexp.new(e, Regexp::IGNORECASE) }
    @data = { 'destination' => '' }
    @vi_name = ''
  end

  def message
    "Hello! I'm #{@vi_name}. I'm a virtual intelligence /
     designed for easy execution and automation of tasks."
  end

  def direct_message(vi)
    if /\d+/ =~ (@data['destination'])
      vi.say_through(Tony::SMSInterface.new(@data['destination']), '~e:wave ' + message)
    else
      error_out
    end
  end

  def activate_handler(query, vi)
    @vi_name = vi.name
    parse query
    if @data['destination'].nil?
      "I'll greet you!"
    else
      "I'll send a greeting to #{@data['destination']}"
    end
  end

  def activate_handler!(query, vi)
    @vi_name = vi.name
    parse query
    if @data['destination'].nil?
      Tony::HandledResponse.new('~e:wave ' + message, nil)
    else
      direct_message vi
      Tony::HandledResponse.new("Okay! I greeted #{@data['destination']}", nil)
    end
  end
end
