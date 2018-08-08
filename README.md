## README


## SETUP
For the first you need to install gems required to start a bot:

```sh
bundle install
```

Then you need to create `secrets.yml` where your bot unique token will be stored.

After this you need to create and migrate your database:

```sh
rake db:create db:migrate
```

### Running the bot
```sh
bin/bot
```