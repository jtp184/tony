module DismalTony # :nodoc:
  # The essential class. A VI, or Virtual Intelligence,
  # forms the basis for the DismalTony gem, and is your conversational agents for handling queries
  class VIBase
    # The name of the Intelligence
    attr_reader :name
    # A DialogInterface object representing where to route the VI's speech
    attr_reader :return_interface
    # An Array of QueryHandler objects that the VI can use
    attr_reader :directives
    # A DataStore object representing the VI's memory and userspace
    attr_reader :data_store
    # The UserIdentity corresponding to the current user.
    attr_reader :user

    # Options for +opts+
    # * +:name+ - The name for the VI. Defaults to 'Tony'
    # * +:directives+ - The Array of directives. Defaults to all known.
    # * +:parsing_strategies+ - The Array of Parsing Strategies. Defaults to all known.
    # * +:data_store+ - The data store to use with this VI. Defaults to a generic DataStore object.
    # * +:return_interface+ - The interface to route conversation back through. Defaults to the ConsoleInterface.
    # * +:user+ - the UserIdentity of who is using this VI
    def initialize(**opts)
      @data_store =
        opts.fetch(:data_store, DismalTony::DataStore.new(vi_name: name))
      @user =
        opts.fetch(
          :user, @data_store&.users&.first || DismalTony::UserIdentity::DEFAULT
        )
      @name =
        opts.fetch(:name, @data_store&.opts&.[](:vi_name) || 'Tony').freeze
      @return_interface =
        opts.fetch(:return_interface, DismalTony::ConsoleInterface.new)
      @directives = opts.fetch(:directives, DismalTony::Directives.all)
    end

    # Takes the module level VI and duplicates it, overriding its values with ones from +opts+
    def self.with(**opts)
      DismalTony::VIBase.new(
        user:
          (opts[:user] || DismalTony.vi.user ||
            DismalTony::UserIdentity::DEFAULT),
        name: (opts[:name] || DismalTony.vi.name),
        return_interface:
          (opts[:return_interface] || DismalTony.vi.return_interface),
        directives: (opts[:directives] || DismalTony.vi.directives),
        data_store: (opts[:data_store] || DismalTony.vi.data_store)
      )
    end

    # Sends the message +str+ back through the DialogInterface +interface+, after calling DismalTony::Formatter.format on it.
    def say_through(interface, str)
      say_opts(str, interface.default_format)
    end

    # Sends the message +str+ back through the DialogInterface +interface+, after calling DismalTony::Formatter.format on it, with the options +opts+
    def say_opts(interface, str, opts)
      interface.send(DismalTony::Formatter.format(str, opts))
    end

    # Simplest dialog function. Sends the message +str+ back through VIBase.return_interface
    def say(str)
      say_through(return_interface, str)
    end

    # Simple utility function to combine the input HandledResponse and the
    # default format on the return interface into a single options collection.
    def apply_format(response)
      return_interface.default_format.merge(response.format)
    end

    # The interface method takes in a Query +q+ and uses the QueryResolver#call method to decide what to do with it.
    # Responsible for using the +return_interface+ to send back the text response.
    def call(q)
      result = QueryResolver.call(q, self)
      response = result.response

      @user.modify_state!(response.conversation_state.stamp)
      DismalTony.last_result = result

      unless response.format[:silent]
        if response.format.empty?
          say response.outgoing_message
        else
          say_opts(
            return_interface, response.outgoing_message, apply_format(response)
          )
        end
      end

      dr = nil

      final_result =
        if result.respond_to?(:data_representation)
          dr = result.data_representation
        else
          DismalTony::Formatter.format(response.to_s, apply_format(response))
        end

      data_store.on_query(response: response, user: @user, data: dr)
      final_result
    end
  end
end
