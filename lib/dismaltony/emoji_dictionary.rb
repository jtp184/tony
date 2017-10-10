module DismalTony # :nodoc:
  # Used to assist with use of emojis. Mostly just a wrapper for a Hash table
  class EmojiDictionary
    # The crux of the class, this function returns the Hash of emojis
    def self.emoji_table
      {
        '0' => '0️⃣',
        '1' => '1️⃣',
        '10' => '🔟',
        '100' => '💯',
        '2' => '2️⃣',
        '3' => '3️⃣',
        '4' => '4️⃣',
        '5' => '5️⃣',
        '6' => '6️⃣',
        '7' => '7️⃣',
        '8' => '8️⃣',
        '9' => '9️⃣',
        'alarmbell' => '🔔',
        'alarmclock' => '⏰',
        'americanflag' => '🇺🇸',
        'anchor' => '⚓️',
        'angry' => '😡',
        'beer' => '🍺',
        'birthdaycake' => '🎂',
        'bolt' => '⚡️',
        'bomb' => '💣',
        'burger' => '🍔',
        'bus' => '🚌',
        'calendar' => '📅',
        'camera' => '📷',
        'cancel' => '🚫',
        'car' => '🚗',
        'cat' => '😺',
        'caution' => '⚠️',
        'champagne' => '🍾',
        'chartdown' => '📉',
        'chartup' => '📈',
        'checkbox' => '✅',
        'cheeky' => '😜',
        'cheers' => '🍻',
        'chili' => '🌶',
        'clockface' => '🕓',
        'coffee' => '☕️',
        'computer' => '🖥',
        'cookie' => '🍪',
        'cool' => '😎',
        'creditcard' => '💳',
        'crystalball' => '🔮',
        'dice' => '🎲',
        'dog' => '🐶',
        'egg' => '🍳',
        'envelope' => '✉️',
        'envelopearrow' => '📩',
        'envelopeheart' => '💌',
        'exclamationmark' => '❗️',
        'fire' => '🔥',
        'fish' => '🐠',
        'flower' => '🌺',
        'fries' => '🍟',
        'frown' => '🙁',
        'game' => '🎮',
        'gate' => '🚧',
        'gem' => '💎',
        'hourglass' => '⏳',
        'key' => '🔑',
        'knifefork' => '🍴',
        'laptop' => '💻',
        'lightbulb' => '💡',
        'lock' => '🔒',
        'magnifyingglass' => '🔎',
        'mailbox' => '📫',
        'martini' => '🍸',
        'medal' => '🏅',
        'megaphone' => '📢',
        'moneybag' => '💰',
        'moneywing' => '💸',
        'moon' => '🌙',
        'moviecamera' => '📽',
        'nobell' => '🔕',
        'octo' => '🐙',
        'package' => '📦',
        'pencil' => '✏️',
        'phone' => '📞',
        'pickaxe' => '⛏',
        'pill' => '💊',
        'pineapple' => '🍍',
        'pizza' => '🍕',
        'popcorn' => '🍿',
        'pound' => '#️⃣',
        'present' => '🎁',
        'questionmark' => '❓',
        'raincloud' => '🌧',
        'rocket' => '🚀',
        'scroll' => '📜',
        'shower' => '🚿',
        'siren' => '🚨',
        'sleepy' => '😴',
        'sly' => '😏',
        'smile' => '🙂',
        'snail' => '🐌',
        'snake' => '🐍',
        'snowflake' => '❄️',
        'spaceinvader' => '👾',
        'speechbubble' => '💬',
        'star' => '⭐️',
        'stopwatch' => '⏱',
        'sun' => '☀️',
        'taco' => '🌮',
        'thebird' => '🖕',
        'thermometer' => '🌡',
        'think' => '🤔',
        'thumbsdown' => '👎',
        'thumbsup' => '👍',
        'ticket' => '🎟',
        'toast' => '🥂',
        'tophat' => '🎩',
        'trophy' => '🏆',
        'tropicaldrink' => '🍹',
        'tv' => '📺',
        'unlock' => '🔓',
        'watch' => '⌚️',
        'wave' => '👋',
        'whiskey' => '🥃',
        'wineglass' => '🍷',
        'wink' => '😉',
        'worried' => '🤕',
        'zzz' => '💤'
      }
    end

    # Allows hash syntax on the class itself for finding Emoji with the key +search+
    def self.[](search)
      emoji_table[search] || emoji_table['smile']
    end

    def self.to_h # :nodoc:
      emoji_table
    end

    # Inverse lookup of Emoji. Finds the name given to the emoji +moj+
    def self.name(moj)
      emoji_table.key(moj) || 'emoji'
    end
  end
end
