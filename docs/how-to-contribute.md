# How to contribute

## Setup

1. `bin/setup`
1. `rails s`

## Git flow

[Use this Git flow](https://thoughtbot.com/playbook/developing/code-reviews) to make contributions.

1. Create an issue for work to be done (no matter how small)
2. Create a branch starting with that number
3. Create a PR including "resolves"
4. Pushing the tip commit to main closes the PR and the Issue.


## Credentials

Get the `config/credentials/development.key` from the team lead.

### Show
`rails credentials:show --environment development`

### Edit
`EDITOR="code --wait" rails credentials:edit --environment development`

This will create `config/credentials/development.yml.enc` and `config/credentials/development.key` unless they already exist.

Same for `production` (just swap --environment)

