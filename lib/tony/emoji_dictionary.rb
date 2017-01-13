module Tony
  class EmojiDictionary
    def initialize
      @moji = {
        '0' => '0️⃣',
        '1' => '1️⃣',
        '2' => '2️⃣',
        '3' => '3️⃣',
        '4' => '4️⃣',
        '5' => '5️⃣',
        '6' => '6️⃣',
        '7' => '7️⃣',
        '8' => '8️⃣',
        '9' => '9️⃣',
        '10' => '🔟',
        '#' => '#️⃣',
        'alarmbell' => '🔔',
        'alarmclock' => '⏰',
        'americanflag' => '🇺🇸',
        'anchor' => '⚓️',
        'angry' => '😡',
        'burger' => '🍔',
        'bus' => '🚌',
        'calendar' => '📅',
        'camera' => '📷',
        'cancel' => '🚫',
        'car' => '🚗',
        'caution' => '⚠️',
        'chartdown' => '📉',
        'chartup' => '📈',
        'checkbox' => '✅',
        'cheeky' => '😜',
        'clockface' => '🕓',
        'cool' => '😎',
        'creditcard' => '💳',
        'crystalball' => '🔮',
        'dice' => '🎲',
        'envelope' => '✉️',
        'envelopearrow' => '📩',
        'exclamationmark' => '❗️',
        'fire' => '🔥',
        'frown' => '🙁',
        'game' => '🎮',
        'gate' => '🚧',
        'gem' => '💎',
        'hourglass' => '⏳',
        'key' => '🔑',
        'knifefork' => '🍴',
        'laptop' => '💻',
        'lock' => '🔒',
        'magnifyingglass' => '🔎',
        'mailbox' => '📫',
        'medal' => '🏅',
        'megaphone' => '📢',
        'moneybag' => '💰',
        'moneywing' => '💸',
        'moviecamera' => '📽',
        'nobell' => '🔕',
        'pencil' => '✏️',
        'phone' => '📞',
        'pickaxe' => '⛏',
        'pill' => '💊',
        'pizza' => '🍕',
        'present' => '🎁',
        'questionmark' => '❓',
        'rocket' => '🚀',
        'scroll' => '📜',
        'shower' => '🚿',
        'siren' => '🚨',
        'sly' => '😏',
        'smile' => '🙂',
        'spaceinvader' => '👾',
        'speechbubble' => '💬',
        'star' => '⭐️',
        'stopwatch' => '⏱',
        'sun' => '☀️',
        'thermometer' => '🌡',
        'thebird' => '🖕',
        'think' => '🤔',
        'ticket' => '🎟',
        'trophy' => '🏆',
        'unlock' => '🔓',
        'wave' => '👋',
        'wink' => '😉',
        'worried' => '🤕',
        'zzz' => '💤'
      }
    end

    def to_h
      @moji
    end
  end
end
