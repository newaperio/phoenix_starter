# Phoenix Starter

![CI](https://github.com/newaperio/phoenix_starter/workflows/CI/badge.svg)

This repo contains the base app we use to get our Elixir / Phoenix apps started at [NewAperio].

The goal of this repo is to enable our development teams to start fast with a solid foundation. This app is updated with new releases and includes the boilerplate configuration we typically use when bootstrapping new products.

## Technologies

The following technologies are included and configured with our defaults:

- [Phoenix], the web framework
- [Phoenix LiveView] for server-rendered reactive UI
- [Ecto] for database integration
- [ExUnit] for testing
- [ExDoc] for rendering Elixir code documentation
- [AssertIdentity] for easy Ecto identity assertions in tests
- [phx_gen_auth] for a user authentication system
- [Swoosh] for sending emails
- [Oban] for background jobs
- [asdf] for managing runtime versions
- [Docker] for building release containers
- [Mix Releases] for compiling release binaries
- [Sentry] for error reporting
- [GitHub Actions] for CI
- [GitHub Dependabot] for automated security patches and weekly dep updates
- [PostCSS] for building CSS
- [Tailwind], a CSS framework
- [TypeScript] for type-safe JS
- [Alpine], a component JS framework that integrates with LiveView
- [Sobelow] for Phoenix security static analysis
- [Dialyzer] for Erlang/Elixir static analysis, including type-checking
- A suite of linters: [Credo] for Elixir, [ESLint] for JS, [Stylelint] for CSS, and [Prettier] for JS formatting

## Usage

The repo is setup as a [GitHub template] to make it easy to get started.

1. Click the ["Use this template" button]. This will setup a new repo with a clean history.
2. Clone the new repo locally.
3. Run the init script to rename the starter project and do some other housekeeping: `$ ./bin/init.sh MyApp my_app`.
4. Commit the result: `$ git add --all . && git commit -m "Initalize starter project"`.

## Updating

To update a Phoenix app generated from this repo, you need to compare the changes between the version that initialized your repo and the current version.

You can find your current version in the `.starter-version` file. This is the git tag that generated your app.

You can find changes in the [CHANGELOG](/CHANGELOG.md).

You can also check the diff on GitHub between your version and the latest version. There's a helpful script that will grab the version information and print out the URLs.

```sh
./bin/starter-version-info.sh
```

After updating make sure to update the version in `.starter-version` with the tag you updated to.

## License

Phoenix Starter is Copyright © 2020 NewAperio. It is free software, and may be redistributed under the terms specified in the [LICENSE](/LICENSE) file.

## About NewAperio

PhoenixStarter is built by NewAperio, LLC.

NewAperio is a web and mobile design and development studio. We offer [expert
Elixir and Phoenix][services] development as part of our portfolio of services.
[Get in touch][contact] to see how our team can help you.

[newaperio]: https://newaperio.com?utm_source=github
[phoenix]: https://github.com/phoenixframework/phoenix
[phoenix liveview]: https://github.com/phoenixframework/phoenix_live_view
[ecto]: https://github.com/elixir-ecto/ecto
[exunit]: https://hexdocs.pm/ex_unit/master/ExUnit.html
[exdoc]: https://github.com/elixir-lang/ex_doc
[assertidentity]: https://github.com/newaperio/assert_identity/
[phx_gen_auth]: https://github.com/aaronrenner/phx_gen_auth
[swoosh]: https://github.com/swoosh/swoosh
[oban]: https://github.com/sorentwo/oban
[asdf]: https://asdf-vm.com/
[docker]: https://docs.docker.com/
[mix releases]: https://hexdocs.pm/mix/Mix.Tasks.Release.html
[sentry]: https://sentry.io/welcome/
[github actions]: https://github.com/features/actions
[github dependabot]: https://docs.github.com/en/free-pro-team@latest/github/administering-a-repository/enabling-and-disabling-version-updates
[postcss]: https://postcss.org/
[tailwind]: https://tailwindcss.com/
[typescript]: https://www.typescriptlang.org/
[alpine]: https://github.com/alpinejs/alpine/
[sobelow]: https://github.com/nccgroup/sobelow
[credo]: https://github.com/rrrene/credo
[eslint]: https://eslint.org/
[stylelint]: https://stylelint.io/
[prettier]: https://prettier.io/
[github template]: https://docs.github.com/en/free-pro-team@latest/github/creating-cloning-and-archiving-repositories/creating-a-repository-from-a-template#creating-a-repository-from-a-template
["use this template" button]: https://github.com/newaperio/phoenix_starter/generate
[services]: https://newaperio.com/services#elixir?utm_source=github
[contact]: https://newaperio.com/contact?utm_source=github
