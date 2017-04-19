APP_DEFAULT_CARD_TYPES = YAML.load_file("#{Rails.root.to_s}/config/card_types.yml")[Rails.env.to_s]
APP_DEFAULT_CARDS = YAML.load_file("#{Rails.root.to_s}/config/cards.yml")[Rails.env.to_s]
