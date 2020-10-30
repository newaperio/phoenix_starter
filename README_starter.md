# PhoenixStarter

_Use this introductory section to give the project's elevator pitch. Explain the idea. What are we building? Who is it for? What problems does it solve? What are the primary, proprietary aspects of the technology?_

## Preflight

To develop and run this app, a few dependencies are required. To check if you have them installed, run the preflight script:

```sh
./bin/preflight.sh
```

This will report which dependency, if any, still needs to be installed and configured.

If all dependencies are present, it'll run `asdf` to install language versions.

## Setup

Once you've finished preflight setup, run the setup script:

```sh
mix setup
```

This will do a few things:

1. Run `mix deps.get` to fetch Elixir dependencies
2. Run `ecto.setup`, which creates, migrates, and seeds the DB
3. Run `npm install`, to fetch Node dependencies for the asset pipeline

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
