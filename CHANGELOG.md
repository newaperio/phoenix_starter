# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased

## v2.0 - 2022-02-24

### Added

- GitHub pull request template
- Dialyzer for type-checking (via dialyxir)

### Changed

- Target Elixir v1.13.2
- Target Erlang v24.2.1
- Target Node.js v16.13.2
- Update Phoenix to v1.6.6
- Update Phoenix LiveView to v0.17.6
- Update various dependencies to satisfy new Phoenix/LiveView version constraints
  - credo
  - phoenix_ecto
  - phoenix_html
  - phoenix_live_dashboard
  - phoenix_live_reload
  - telemetry_metrics
  - telemetry_poller
- Update EEx and LEEx templates to the new HEEx templating engine
- Run tests with `--warnings-as-errors` in CI
- Replace Bamboo with Swoosh for emails
- Update Sobelow skips
- Parallelize GitHub Actions CI workflow

## v1.1 - 2021-05-27

### Added

- Add LICENSE (#48)
- Add CODE_OF_CONDUCT (#49)
- Add configuration to allow app to run on AWS ECS Fargate (#74)
- Add CHANGELOG and version scripts (#83)
- Add LiveView uploads, refactor User Settings to LiveView (#186)

### Changed

- Bump dependencies (various PRs)
- Update CSP for Alpinejs (#85)
- Update configuration for deploy (#84)
- Update GitHub Actions CI Config (#158)
- Update NodeJS to 16.x (#185)

## v1.0 - 2020-11-11

### Added

- Add and configure Oban and setup email job
- Refactor ContentSecurityPolicy plug
- Add Plug to check user permissions to protect LiveDashboard
- Add seeds to create users for testing
- Add UserRole struct and type for starter authz permission system
- Add Bamboo for email sending and configure auth emails
- Add and configure Bamboo for sending emails
- Add phx_gen_auth for user authentication
- Remove unused configuration
- Add alert helpers
- Remove Phoenix default page content
- Update phoenix.css to use Tailwind CSS @apply
- Add custom migration template to specify id and timestamp defaults
- Enable PG stats in LiveDashboard
- Configure OS data for PhoenixLiveDashboard
- Add CSP Plug to set headers correctly (#29)
- Add template README for apps generated from the starter
- Add preflight script to check if all system deps are installed
- Add init script to rename starter app and setup base app
- Build assets on CI to catch errors
- Add dependabot config for auto mix, npm, and docker dep updates
- Update config to use new Elixir 1.11 runtime.exs file
- Add linters to CI run
- Add and set up AlpineJS
- Setup and configure TypeScript
- Add Tailwind CSS and PostCSS
- Add and configure ESLint, Stylint, Credo, Sobelow for various linting
- Add and configure Prettier for JS and CSS formatting
- Add Sentry for exception tracking and configure
- Add GitHub CI config
- Add .editorconfig for universal editor settings
- Add ExDoc and configure with defaults
- Add Repo/Schema add-ons
- Add Dockerfile to build container
- Remove SASS dependency from Phoenix assets
- Setup Mix releases for deploying app
- Remove some comments from generated files
- Remove username/password from Ecto PG configuration for dev/test
- Add assert_identity for test helpers
- Add .tool-versions to manage runtime versions with asdf
- Initial Phoenix generator skeleton
