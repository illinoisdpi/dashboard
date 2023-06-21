# Authorization policies

Using the [pundit gem](https://github.com/varvet/pundit)

Existing roles: ```:admin :instructor :ta :student```

For each model below, there is a corresponding policy document in `app/policies/`

Models && policies:
- `ApplicationPolicy` 
    - parent class methods provide a default CRUD deny
- `Cohort` 
    - CUD: admin
    - R: admin, instructor, ta
- `Enrollment` 
    - CUD: admin, instructor
    - R: admin, instructor, ta if not also a student in this cohort 
- User
- `Role` 
    - CUD: admin
    - R: admin, instructor, ta
- Impression
- CanvasAssignment
- CanvasGradebookSnapshot
- PiazzaActivityBreakdown
- PiazzaActivityReport
