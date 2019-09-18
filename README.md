# ExBin

A pastebin clone written in Phoenix/Elixir. Live [here](https://exbin.call-cc.be). 

I work on this project from time to time, so the development pace is slow. If you want to dive in, feel free. The codebase is quite small, because, well, it's a simple application.

## Features

 * Post pastes publicly and privatley 
 * List of all public pastes 
 * Use `nc` to pipe text and get the URL. 
   (e.g., `cat file.txt | nc exbin.call-cc.be 9999`)
 * Raw view of snippets.

## Todo

## Docker 

First of all, create an `.env` file in the folder of the `docker-compose.yml` file and change the contents to your liking.

```
TCP_PORT=9999
HTTP_PORT=4001
DB_NAME=exbindb
DB_PASS=supersecretpassword
DB_USER=postgres
```

To run this entire thing in Docker:

```
docker-compose up -d
```

At this point you should be able to navigate to the site at `http://localhost:4001`.


## Develop 

```
git clone https://github.com/m1dnight/exbin.git
cd exbin
mix deps.get
mix compile
cd assets 
npm install
node_modules/brunch/bin/brunch build
cd ..
./scripts/db.sh # Creates a docker database.
mix ecto.create 
mix ecto.migrate
mix phx.server
```

## Deploy

Compile:

```
git clone https://github.com/m1dnight/exbin.git
cd exbin
export MIX_ENV=prod
mix deps.get --only prod
mix compile
cd assets 
npm install
node_modules/brunch/bin/brunch build --production
cd ..
mix phx.digest 
mix ecto.create 
mix ecto.migrate
```

Run:

```
MIX_ENV=prod TCP_PORT=6666 TCP_IP=0.0.0.0 mix phx.server
```
