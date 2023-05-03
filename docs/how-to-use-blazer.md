# How to Use Blazer: A Guide for DPI Workforce Education Instructors

## Introduction:
Blazer is a powerful tool that allows you to create charts, graphs, and alerts using raw SQL. With Blazer, you can track apprentice progress, monitor assignments, and analyze contributions. This guide will help you get started using Blazer to streamline your work.

## Getting Started:
To access Blazer, click on the 'Blazer' link in the navbar or go directly to [Blazer](https://dashboard.dpi.dev/blazer). Please note that you must have the 'instructor' role to access Blazer.

## Available Reports:
We have created a number of reports to help you track progress, assignments, and contributions. Here are some examples:

- Progress Report: This report allows you to track and compare apprentice progress over time.
- Assignments Report: This report shows you which assignments apprentices are currently working on.
- Contributions Report: This report identifies the most active contributors to Piazza.

## Creating Your Own Reports:
If you would like to create a new report, feel free to write one yourself using raw SQL or tag a developer to help you put it together. Here are some SQL query examples to get you started:

```sql
SELECT count(*) FROM enrollments WHERE role = 'student'
```

## Troubleshooting Tips:
If you encounter any issues or errors while using Blazer, try these troubleshooting tips:

- Check your SQL query for syntax errors.
- Refresh the page and try again.

## Conclusion:
Blazer is a powerful tool that can help you streamline your work and make better decisions based on data. With this guide, you should be able to get started using Blazer in no time.
