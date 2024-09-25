namespace :one_offs do
  desc "replace commas with markdown syntax"

  task oneoff_update_markdown_format: :environment do
    User.find_each do |user|
      if user.skills_and_projects.present?
        new_skills = user.skills_and_projects.split(",").map(&:strip).map { |s| "- #{s}" }.join("\n")
        user.update_column(:skills_and_projects, new_skills)
      end

      if user.career_highlights.present?
        new_highlights = user.career_highlights.split(",").map(&:strip).map { |h| "- #{h}" }.join("\n")
        user.update_column(:career_highlights, new_highlights)
      end

      if user.education.present?
        new_education = user.education.split(",").map(&:strip).map { |e| "- #{e}" }.join("\n")
        user.update_column(:education, new_education)
      end

      if user.languages.present?
        new_languages = user.languages.split(",").map(&:strip).map { |l| "- #{l}" }.join("\n")
        user.update_column(:languages, new_languages)
      end
      
    end

    Enrollment.find_each do |enrollment|
      if enrollment.skills_development.present?
        new_skills_development = enrollment.skills_development.split(",").map(&:strip).map { |s| "- #{s}" }.join("\n")
        enrollment.update_column(:skills_development, new_skills_development)
      end
    end

    puts "One-off task: All comma-separated fields updated to markdown list format!"
  end

end