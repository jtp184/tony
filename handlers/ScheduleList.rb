class ScheduleList < QueryHandler
	def initialize()
		@handler_name = "schedule-list"
		@patterns = ["list\\s((people)|(who\\sis))\\son\\s(?<day>\\w+)\\s(?<event_key>\\w+\\??)", "who\\sis\\sdoing\\s(?<day>\\w+)\\s(?<event_key>.+)\\?"].map! { |e| Regexp.new(e, Regexp::IGNORECASE) }
		@data = {"day" => "", "event_key" => ""}
	end

	def activate_handler! query, vi
		parse query
		return HandledResponse.new("", nil)
	end

	def activate_handler query, vi
		parse query
		return "I will return people doing #{@data["event_key"]} on #{@data["day"].capitalize}."
	end
end