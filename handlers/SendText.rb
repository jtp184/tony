class SendText < QueryHandler
	def initialize()
		@handler_name = "send-text"
		@verbs = ["send", "text"]
		@patterns = ["(?:(?:send a? ?(?:message|text))|(?:message|text))\s?(?:to)?\s?(?<destination>\d{10}|(?:\w| )+) (?:saying|that says) (?<message>.+)"].map! { |e| Regexp.new(e, Regexp::IGNORECASE) }
		@data = {"destination" => "", "message" => ""}
	end

	def lookup_name str
		# TODO: integrate with address book
	end

	def format_number str
		return "+1" + str
	end

	def activate_handler! query
		parse query
	end

	def activate_handler query
		parse query
		return "I will message #{@data["destination"]} and say \"#{@data["message"]}\""
	end
end