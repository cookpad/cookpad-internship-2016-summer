# Uttieku 3

Sample application Cookpad Summer Intern 2016.

## Boot

```
$ cd uttieku3
$ bundle install

$ (cd vendor/ckpd_intern && bundle install && bundle exec rails ckpd_intern:scrape)

$ bundle exec rails db:create db:migrate db:seed
$ bundle exec rails server
```

Visit `http://localhost:3000` on browser or call `curl -s http://localhost:3000/items.json | jq .` with other terminal.

## Thanks
All illustration, name and description of it are made by いらすとや ( http://www.irasutoya.com/ )

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
