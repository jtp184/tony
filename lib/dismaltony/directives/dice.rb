require 'dismaltony/parsing_strategies/aws_comprehend_strategy'
require 'gaming_dice'

module DismalTony::Directives # :nodoc:
  # Rolls dice using GamingDice
  class DiceRollDirective < DismalTony::Directive
    include DismalTony::DirectiveHelpers::DataRepresentationHelpers
    include DismalTony::DirectiveHelpers::EmojiHelpers

    set_name :diceroll
    set_group :fun

    add_criteria do |qry|
      qry << uniquely { |q| q =~ /\broll\b/i }
      qry << must { |q| q =~ /(((a |\d+)d(\d+)(e)?(\+\d+|\-\d+)?)( \& | \+ )*)/i }
    end

    # Uses a regular expression to detect dice strings and segment the components
    def run
      rolls = query.raw_text.scan(/(((a |\d+)d(\d+)(e)?(\+\d+|\-\d+)?)( \& | \+ )*)/i)
      
      dice_result = rolls.map! { |r| GamingDice.roll(r[0]) }
      return didnt_work if malformed?(dice_result)

      result_string = rolls.one? ? rolls.first : rolls.join(', ')

      resp = '~e:dice '
      resp << "Okay! The result#{rolls.one? ? ' is' : 's are'}: #{result_string}."
      
      return_data(dice_result.one? ? dice_result.first : dice_result)
      
      DismalTony::HandledResponse.finish(resp)
    end

    private

    # Ensures the dice string is not malformed
    def malformed?(dr)
      dr.one? && dr.first.is_a?(Array) && dr.first.empty?
    end

    # A Response for if we knew to roll dice but couldn't resolve the string
    def didnt_work
      DismalTony::HandledResponse.finish("~e:#{negative_emoji} Sorry, I couldn't parse that dice string.")
    end
  end
end
