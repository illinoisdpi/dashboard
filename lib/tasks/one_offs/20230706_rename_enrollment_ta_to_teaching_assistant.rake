namespace :one_offs do
  desc "Rename enrollment 'ta' roles to 'teaching assistant'"
  task rename_enrollment_ta_to_teaching_assistant: :environment do
    Enrollment.where(role: "ta").update_all(role: "teaching assistant")
    puts "Enrollment roles updated successfully!"
  end
end
