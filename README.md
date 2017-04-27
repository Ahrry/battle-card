# Quick start

Compile and generate default cards

```
  bundle install
  bundle exec rake card_type:generate_card_types
  bundle exec rake card_to_play:generate_default_card
```

Run sever

```
  bundle exec rails s
```

Custom cards

- You can define all objects in `card_objects.yml`
- You can define all types in `card_types.yml`
- You can define default cards in `card_to_play.yml`

Custom fight rules

- You can custom the fight rules in `lib fight_rules.rb`
