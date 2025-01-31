namespace :one_offs do
  desc "set staff_only to false for all impressions"
  task set_staff_only_false_for_impressions: :environment do

    puts "Updating impressions"

    Impression.find_each do |impression|
        puts "updating impression #{impression.id} with staff_only: 'false'"
        impression.update(staff_only: false)
    end

    puts "task completed!"
    
  end
end
