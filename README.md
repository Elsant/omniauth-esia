# OmniAuth Esia (OAuth2)

This is the unofficial OmniAuth strategy for authenticating via OAuth2 to [ESIA (GosUslugi)](https://esia.gosuslugi.ru). Read more [here](http://minsvyaz.ru/ru/activity/directions/13/)

Built using [omniauth-oauth2](https://github.com/intridea/omniauth-oauth2).


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'omniauth-esia'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install omniauth-esia

## Usage

`OmniAuth::Strategies::Esia` is simply a Rack middleware.

In Your Rails application:

```ruby
# Gemfile
gem 'omniauth-esia'
```
```ruby
# config/initializers/omniauth.rb
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :esia, ENV['ESIA_ID'],
    scope:    'fullname email',
    key_path: "#{Rails.root}/config/keys/private.key",
    crt_path: "#{Rails.root}/config/keys/certificate.crt"
end
```

or in Your Rails application with Devise. See full instruction [here](https://github.com/plataformatec/devise/wiki/OmniAuth:-Overview)

```ruby
# config/initializers/devise.rb
Devise.setup do |config|
  config.omniauth :esia, ENV['ESIA_ID'],
    scope:    'fullname email',
    key_path: "#{Rails.root}/config/keys/private.key",
    crt_path: "#{Rails.root}/config/keys/certificate.crt"
end
```

## Configuring

[Read the ESIA docs for more details](http://minsvyaz.ru/ru/documents/4243/)
You can configure several options, which you pass in to the `provider` method via a `Hash`:

* `client_id`: ESIA identifier
* `scope`: a space-separated list of access permissions you want to request from the user. Example `'fullname gender email'`
* `key_path`: path to private key. Default to `config/keys/private.key`
* `crt_path`: path to certificate. Default to `config/keys/certificate.crt`
* `client_options`: path to certificate. Default to `https://esia.gosuslugi.ru`. For ESIA's test environment set to `https://esia-portal1.test.gosuslugi.ru`
```ruby
client_options: {
        site:          'https://esia-portal1.test.gosuslugi.ru',
        authorize_url: '/aas/oauth2/ac',
        token_url:     '/aas/oauth2/te'
      }
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/elsant/omniauth-esia.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
