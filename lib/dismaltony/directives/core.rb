require 'duration'

module DismalTony::Directives
  class SendTextMessageDirective < DismalTony::Directive
    include DismalTony::DirectiveHelpers::DataRepresentationHelpers
    set_name :send_text
    set_group :core
    
    add_param :sendto
    add_param :sendmsg

    add_criteria do |qry|
      qry << keyword { |q| q =~ /text/i }
      qry << should { |q| q.root =~ /text/i }
      qry << should { |q| q.children_of(q.verb).any? { |w| w.pos == 'NUM' } }
      qry << could { |q| q =~ /send/i }
      qry << could { |q| q =~ /message/i }
    end

    def get_tel
      parameters[:sendto] = query.raw_text
      DismalTony::HandledResponse.then_do(directive: self, method: :get_msg, message: "~e:speechbubble Okay, what shall I say to them?", parse_next: false, data: parameters)
    end

    def get_msg
      parameters[:sendmsg] = query.raw_text
      vi.say_through(DismalTony::SMSInterface.new(parameters[:sendto]), parameters[:sendmsg])
      DismalTony::HandledResponse.finish("~e:speechbubble Okay! I sent the message.")
    end

    def run
      resp = nil
      parameters[:sendto] = query['pos', 'NUM'].first&.to_s
      if parameters[:sendto].nil?
        parameters[:sendto] = if query.children_of(query.verb)&.first =~ /^me$/i
          query.user[:phone]
        elsif query.children_of(query.verb)&.first =~ /[a-z]*/i
                              # Code for if it's a name
                              nil
                            else
                              # If it's really nonexistent
                              nil
                            end
                          else
                            if (parameters[:sendto] =~ /^\d{10}$/) == nil
                              resp = DismalTony::HandledResponse.finish("~e:frown That isn't a valid phone number!") 
                            end
                          end

                          return resp if resp

                          if parameters[:sendto].nil?
                            resp = DismalTony::HandledResponse.then_do(directive: self, method: :get_tel, message: "~e:pound Okay, to what number should I send the message?", parse_next: false, data: parameters) if parameters[:sendto].nil?
                          else
                            parameters[:sendmsg] = query.raw_text.split(query['pos', 'VERB'].select { |w| w.any_of?(/says/i, /say/i) }.first.to_s << " ")[1]
                            vi.say_through(DismalTony::SMSInterface.new(parameters[:sendto]), parameters[:sendmsg])
                            resp = DismalTony::HandledResponse.finish("~e:thumbsup Okay! I sent the message.")
                          end
                          resp
                        end
                      end

  class UserInfoDirective < DismalTony::Directive
    include DismalTony::DirectiveHelpers::DataRepresentationHelpers
    include DismalTony::DirectiveHelpers::ConversationHelpers
    include DismalTony::DirectiveHelpers::EmojiHelpers
    set_name :whoami
    set_group :info

    add_criteria do |qry|
      qry << must { |q| q.contains?(/who/i, /what/i) }
      qry << must { |q| q.contains?(/\bi\b/i, /\bmy\b/i) }
      qry << should { |q| q.contains?(/\bis\b/i, /\bare\b/i, /\bam\b/i)}
      qry << could { |q| q.contains?(/phone|number/i, /\bname\b/i, /birthday/i, /\bemail\b/i, ) }
    end

    def run
      if query =~ /who am i/i
        moj = random_emoji('think','magnifyingglass','crystalball','smile')
        return_data(query.user)
        DismalTony::HandledResponse.finish("~e:#{moj} You're #{query.user[:nickname]}! #{query.user[:first_name]} #{query.user[:last_name]}.")
      elsif query =~ /what('| i)?s my/i
        seek = query.children_of(query.root).select { |w| w.rel == 'nsubj' }&.first.to_s.downcase
        moj = case seek
        when /phone/i, /number/i
          'phone'
        when /name/i
          'speechbubble'
        when /birthday/i
          'calendar'
        when /age/i
          'clockface'
        when /email/i
          'envelope'
        else
          random_emoji('magnifyingglass', 'key')
        end

        return_data("#{query.user[:first_name]} #{query.user[:last_name]}") and return DismalTony::HandledResponse.finish("~e:#{moj} You're #{query.user[:nickname]}! #{query.user[:first_name]} #{query.user[:last_name]}.") if (seek == 'name')
        age_in_years = Duration.new(Time.now - query.user[:birthday]).weeks / 52
        return_data(age_in_years) and return DismalTony::HandledResponse.finish("~e:#{moj} You are #{age_in_years} years old, #{query.user[:nickname]}!") if (seek == 'age')

        ky = seek.gsub(" ", "_").to_sym
        ky = :phone if ky == :number

        if query.user[ky]
          return_data(query.user[ky])
          DismalTony::HandledResponse.finish("~e:#{moj} Your #{seek} is #{query.user[ky]}")
        else
          return_data(nil)
          DismalTony::HandledResponse.finish("~e:frown I'm sorry, I don't know your #{seek}")
        end
      else
        DismalTony::HandledResponse.finish("~e:frown I'm not quite sure how to answer that.")
      end
    end
  end

  class SelfDiagnosticDirective < DismalTony::Directive
    include DismalTony::DirectiveHelpers::ConversationHelpers
    include DismalTony::DirectiveHelpers::EmojiHelpers
    
    set_name :selfdiagnostic
    set_group :debug

    add_criteria do |qry|
      qry << keyword { |q| q =~ /diagnostic/i }
      qry << must { |q| q.contains?(/run/i, /execute/i, /perform/i) }
    end

    def run
      begin
        good_moj = random_emoji('tophat', 'thumbsup', 'star', 'checkbox', 'chartup') if ParseyParse.run_parser('Diagnostic successful')
        return_string = "Diagnostic Successful!\n\n"
        return_string << "    Time: #{Time.now.strftime('%F %l:%M%P')}\n"
        return_string << "    VI: #{vi.name}\n"
        return_string << "    Version: #{DismalTony::VERSION}\n"
        return_string << "    User: #{vi.user['nickname']}\n"
        return_string << "    Directives: #{vi.directives.length}\n"
        return DismalTony::HandledResponse.finish("~e:#{good_moj} #{return_string}")
      rescue
        bad_moj = random_emoji('cancel','caution', 'alarmbell', 'thumbsdown', 'thermometer', 'worried')
        return DismalTony::HandledResponse.finish("~e:#{bad_moj} Something went wrong!")
      end
    end
  end
end