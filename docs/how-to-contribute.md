# How to contribute

## Setup

1. `bin/setup`
1. `rails s`

## Git flow

[Use this Git flow](https://thoughtbot.com/playbook/developing/code-reviews) to
make contributions.

1. Create an issue for work to be done (no matter how small)
2. Create a branch with that issue number, your initials, and a brief description (`1-ih-add-readme`)
3. Create a pull request in GitHub including "resolves"
4. Pushing the tip commit to main closes the PR and the Issue.

## Credentials

Get the `config/credentials/development.key` from the team lead.

### Show

`rails credentials:show --environment development`

### Edit

`EDITOR="code --wait" rails credentials:edit --environment development`

This will create `config/credentials/development.yml.enc` and `config/credentials/development.key` unless they already exist.

Same for `production` (just swap --environment)

## Sidekiq

Here's what you'll need to work with jobs in your development environment.

1. Install redis on your dev machine `brew install redis`
2. Now you can start redis server by running `redis-server`
3. Start sidekiq by running `bundle exec sidekiq`

You can access the sidekiq web ui at /sidekiq (if you have admin role)

## Subdomains

Add this to your `/etc/hosts` file so you can access subdomains in your dev environment.

```
127.0.0.1 news.dpi.local
127.0.0.1 dashboard.dpi.local
127.0.0.1 rfp.dpi.local
```