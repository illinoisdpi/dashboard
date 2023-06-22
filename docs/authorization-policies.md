# Authorization policies

Using the [pundit gem](https://github.com/varvet/pundit),  [latest documentation](https://www.rubydoc.info/gems/pundit)

Existing roles: ```:admin :instructor :ta :student```

For each model below, there is a corresponding policy document in `app/policies/`

Models && policies:
- `ApplicationPolicy` 
    - parent class methods provide a default CRUD deny
- `Cohort` 
    - CUD: admin
    - R: admin, instructor, ta, student
- `Enrollment` 
    - CUD: admin, instructor
    - R: admin, instructor, ta if not also a student in this cohort 
- `User`
    - TODO
- `Role` 
    - CUD: admin
    - R: admin, instructor, ta
- `Impression`
    - CUD: admin, instructor, ta 
    - R: admin, instructor, ta  
- `CanvasAssignment`
    - CUD: admin
    - R: admin, instructor, ta
- `CanvasGradebookSnapshot`
    - CUD: admin
    - R: admin, instructor, ta
- `PiazzaActivityBreakdown`
    - CUD: admin
    - R: admin, instructor, ta
- `PiazzaActivityReport`
    - CUD: admin
    - R: admin, instructor, ta
