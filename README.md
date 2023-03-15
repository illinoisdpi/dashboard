# Dashboard

> **You make what you measure**.... _Corollary: be careful what you measure._
>
> [— Paul Graham](http://www.paulgraham.com/13sentences.html#:~:text=7.%20You%20make%20what,careful%20what%20you%20measure.)

An application that helps students, instructors, administrators, employers, and other stakeholders understand progress.

---

## How to upload a Piazza activity report

![](docs/images/piazza-activity-1.png?raw=true)

![](docs/images/piazza-activity-11.png?raw=true)

![](docs/images/piazza-activity-2.png?raw=true)

![](docs/images/piazza-activity-3.png?raw=true)

![](docs/images/piazza-activity-4.png?raw=true)

![](docs/images/piazza-activity-5.png?raw=true)

![](docs/images/piazza-activity-6.png?raw=true)

![](docs/images/piazza-activity-7.png?raw=true)

![](docs/images/piazza-activity-8.png?raw=true)

## How to provide feedback

### Create an Issue

If you notice something that can be improved:

- First search [open and closed Issues](https://github.com/dpi-pttl/we-dashboard/issues?q=is%3Aissue) to make sure it hasn't already been discussed.
- If not, create a new issue.

### Providing review

When providing review on an in-progress feature:

- Use the Review App to explore the work-in-progress.
    - A link to the review app will appear in the Pull Request:

        ![](docs/images/view-deployment.png?raw=true)
    - Sign in with `alice@example.com`, `bob@example.com`, `carol@example.com`, or your own email address if you are one of [the seed users](https://github.com/dpi-pttl/we-dashboard/blob/main/db/seeds.rb#L9). Passwords on review apps are all `password`.
- Help the author by trying to find edge cases and bugs that they didn't think of.
- Screenshots and GIFs are worth a thousand words.
- Resources for code review best practices:
    - [5 Tips for More Helpful Code Reviews](https://thoughtbot.com/blog/five-tips-for-more-helpful-code-reviews)
    - [[Video] Tips For Code Review](https://thoughtbot.com/upcase/videos/tips-for-code-review)
    - [[Video] RailsConf 2015 - Implementing a Strong Code-Review Culture](https://www.youtube.com/watch?v=PJjmw9TRB7s)

## How to contribute

### Setup

1. `bin/setup`
1. `rails s`

### Git flow

[Use this Git flow](https://thoughtbot.com/playbook/developing/code-reviews) to make contributions.

## Domain model

![Domain Model](erd.png?raw=true "Domain Model")
