# PhoenixStarter

_Use this introductory section to give the project's elevator pitch. Explain the idea. What are we building? Who is it for? What problems does it solve? What are the primary, proprietary aspects of the technology?_

## Preflight

To develop and run this app, a few dependencies are required. To check if you have them installed, run the preflight script:

```sh
./bin/preflight.sh
```

This will report which dependency, if any, still needs to be installed and configured.

If all dependencies are present, it'll run `asdf` to install language versions.

### Prerequisites

If the preflight script reports any missing executables or you run into any other errors, here are the prerequisites for running the app. Check you have all of these installed.

1. asdf, which manages package versions. We recommend [installing with the `git` method][asdf-install]. We also need plugins for the versions specified in `.tool-versions` (the preflight script will install these for you). Don’t forget to [load asdf in your shell][asdf-shell].
2. Docker Desktop (community edition). You can download the Mac version from [Docker Hub]. It's a self-contained install.
3. PostgreSQL, the database. This can be installed with [Homebrew][brew-pg]: `brew install postgresql`. Be sure to follow the post-installation notes to make sure PG is running: `brew info postgresql`. You can start it with `brew services start postgresql`.
4. A few dependencies for installing languages:
   - `autoconf`: [required][erlang-req] to build Erlang; `brew install autoconf`
   - `gnupg`: [required][node-req] to verify NodeJS; `brew install gnupg`
   - For Erlang, it's recommended to skip the Java dependency on macOS. Run this or add to your shell: `export KERL_CONFIGURE_OPTIONS="--without-javac --with-ssl=$(brew --prefix openssl)"`.

[asdf-install]: https://asdf-vm.com/#/core-manage-asdf?id=install
[asdf-shell]: https://asdf-vm.com/#/core-manage-asdf?id=add-to-your-shell
[docker hub]: https://www.docker.com/products/docker-desktop
[brew-pg]: https://formulae.brew.sh/cask/postgres#default
[erlang-req]: https://github.com/asdf-vm/asdf-erlang#osx
[node-req]: https://github.com/asdf-vm/asdf-nodejs#install

## Setup

Once you've finished preflight setup, run the setup script:

```sh
mix setup
```

This will do a few things:

1. Run `mix deps.get` to fetch Elixir dependencies
2. Run `ecto.setup`, which creates, migrates, and seeds the DB
3. Run `npm install --prefix assets`, to fetch Node dependencies for the asset pipeline

## Running

To start the web app, run the server command:

```sh
mix phx.server
```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Contributing

Refer to our [contributing guide] for our current standard practices for contributing new features and opening pull requests.

### Testing

This project uses test-driven development. Tests can be found in the `test/`.
To run the test suite, use Mix:

```sh
mix test
```

Refer to our [testing guide] for our current standard practices on test-driven development.

### Documentation

The codebase is documented where appropriate.

To view the docs in development, run ExDoc:

```sh
mix docs
```

This generates an HTML version available in the `doc/` folder. Open to view:

```sh
open doc/index.html
```

### Linting

The codebase spans Elixir, JS, and CSS, and includes linters for each.

For Elixir, there's the standard formatter, Credo (style) and Sobelow (security):

```sh
mix format --check-formatted
mix sobelow
mix credo
```

For Javascript, there's Prettier (formatting) and ESLint (style):

```sh
cd assets
npx prettier --check .
npx eslint js --ext .js,.jsx,.ts,.tsx
```

For CSS, there's Stylelint (style):

```sh
cd assets
npx stylelint "css/*"
```

## Template

This app is based on the NewAperio [Phoenix Starter] project, which is updated from time to time. Refer to that project for documentation and routine updates.

## About NewAperio

PhoenixStarter is built by [NewAperio], LLC.

[contributing guide]: https://github.com/newaperio/guides/blob/master/contributing/README.md
[testing guide]: https://github.com/newaperio/guides/blob/master/testing/README.md
[phoenix starter]: https://github.com/newaperio/phoenix_starter
[newaperio]: https://newaperio.com
