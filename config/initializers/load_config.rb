APP_DEFAULT_CARD_TYPES = YAML.load_file("#{Rails.root.to_s}/config/card_types.yml")[Rails.env.to_s]
APP_DEFAULT_CARD_TO_PLAYS = YAML.load_file("#{Rails.root.to_s}/config/card_to_plays.yml")[Rails.env.to_s]
