build:
	stack build --fast

clean:
	stack clean

build-watch:
	stack build --fast --file-watch

docs:
	cabal haddock --hyperlink-source

exec-prod:
	./bin/ln-yesod config/settings/production.yml private/settings/production.yml

exec-prod-sudo:
	sudo ./bin/ln-yesod config/settings/production.yml private/settings/production.yml

exec-dev-sudo:
	sudo stack exec --allow-different-user -- yesod devel -p 80 --tls-port 443

exec-dev-sudo-exe:
	sudo ~/.local/bin/ln-yesod config/settings/dev.yml private/settings/dev.yml

ghci:
	sudo stack ghci ln-yesod --main-is none --fast --allow-different-user

install:
	stack install

install-yesod:
	stack install yesod-bin cabal-install --install-ghc
