# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

### Changed

- Bump dependencies (#41, #42, #43, #44, #45, #46, #47, #50, #51, #52, #53, #54, #57, #58, #59, #61, #62, #76)
- Add LICENSE (#48)
- Add CODE_OF_CONDUCT (#49)
- Add configuration to allow app to run on AWS ECS Fargate (#74)

### Deprecated

### Removed

### Fixed

### Security

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
