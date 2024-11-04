namespace :one_offs do
  desc "replace commas with HTML list syntax"
  task update_html_format: :environment do
    User.find_each do |user|
      if user.skills_and_projects.present? && !user.skills_and_projects.strip.start_with?("<ul>")
        new_skills = "<ul>" + user.skills_and_projects.split(",").map(&:strip).map { |s| "<li>#{s}</li>" }.join + "</ul>"
        user.update_column(:skills_and_projects, new_skills)
      end

      if user.career_highlights.present? && !user.career_highlights.strip.start_with?("<ul>")
        new_highlights = "<ul>" + user.career_highlights.split(",").map(&:strip).map { |h| "<li>#{h}</li>" }.join + "</ul>"
        user.update_column(:career_highlights, new_highlights)
      end

      if user.education.present? && !user.education.strip.start_with?("<ul>")
        new_education = "<ul>" + user.education.split(",").map(&:strip).map { |e| "<li>#{e}</li>" }.join + "</ul>"
        user.update_column(:education, new_education)
      end

      if user.languages.present? && !user.languages.strip.start_with?("<ul>")
        new_languages = "<ul>" + user.languages.split(",").map(&:strip).map { |l| "<li>#{l}</li>" }.join + "</ul>"
        user.update_column(:languages, new_languages)
      end
    end

    Enrollment.find_each do |enrollment|
      if enrollment.skills_development.present? && !enrollment.skills_development.strip.start_with?("<ul>")
        new_skills_development = "<ul>" + enrollment.skills_development.split(",").map(&:strip).map { |s| "<li>#{s}</li>" }.join + "</ul>"
        enrollment.update_column(:skills_development, new_skills_development)
      end
    end

    puts "One-off task: All comma-separated fields updated to HTML list format!"
  end
end
