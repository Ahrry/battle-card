APP_CARD_TYPES = YAML.load_file("#{Rails.root.to_s}/config/card_types.yml")[Rails.env.to_s]
