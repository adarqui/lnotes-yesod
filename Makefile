build:
	stack build --fast

clean:
	stack clean

build-watch:
	stack build --fast --file-watch

docs:
	cabal haddock --hyperlink-source

dev: install exec-dev

exec-prod:
	~/.local/bin/lnotes-yesod ./config/settings/production.yml ./config/settings/role/web.yml ./private/settings/production.yml

exec-dev:
	~/.local/bin/lnotes-yesod ./config/settings/dev.yml ./config/settings/role/web.yml ./private/settings/dev.yml

exec-dev-workers-exe:
	~/.local/bin/ln-bg ./config/settings/dev.yml ./config/settings/role/worker.yml ./private/settings/dev.yml

exec-prod-workers-exe:
	~/.local/bin/ln-bg ./config/settings/production.yml ./config/settings/role/worker.yml ./private/settings/production.yml

ghci:
	stack ghci lnotes-yesod --main-is none --fast --allow-different-user

install:
	stack --allow-different-user install

install-yesod:
	stack install yesod-bin cabal-install --install-ghc

# just some simple stuff for my mbp
mbp-postgres:
	postgres -D /usr/local/var/postgres/

mbp-postgres-cli:
	pg leuro

mbp-redis:
	redis-server /usr/local/etc/redis.conf

mbp-rabbitmq:
	/usr/local/sbin/rabbitmq-server

mbp-yesod-bg:
	make exec-dev-workers-exe

mbp-yesod:
	make exec-dev-exe
