# Dashboard

![Domain Model](erd.png?raw=true "Domain Model")

rails generate devise user canvas_last_first:string
rails generate scaffold cohort name:string year:integer generation:integer number:integer piazza_course_number:string
rails generate scaffold enrollment role:string user:references cohort:references
rails generate scaffold piazza_activity_breakdown enrollment:references emails:string role:string groups:string days_online:integer posts:integer edits_to_posts:integer answers:integer edits_to_answers:integer followups:integer replies_to_followups:integer instructor_good_question:integer instructor_good_answer:integer instructor_good_comment:integer student_good_question:integer student_thanks_on_answer:integer student_helpful_on_followups:integer good_question_given:integer thanks_on_answers_given:integer helpful_on_followups_given:integer post_views:integer live_qa_upvotes:integer piazza_activity_download:references
rails generate scaffold canvas_assignment exclude:boolean points_possible:float
rails generate scaffold canvas_submission assignment:references enrollment:references points:float exported_at:datetime
rails generate scaffold piazza_activity_download activity_from:datetime activity_until:datetime cohort:references
