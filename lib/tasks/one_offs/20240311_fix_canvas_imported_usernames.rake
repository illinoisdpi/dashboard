namespace :one_offs do
  desc "Add first_name and last_name to users imported from canvas"
  task fix_canvas_imported_usernames: :environment do
    puts "Updating users with canvas_full"
    users = User.where.not(canvas_full: nil).where(first_name: nil)
      .or(User.where.not(canvas_full: nil).where(last_name: nil))
    puts "There are #{users.count} users to update."

    printf "\033[31mWARNING -  press 'y' to continue: \033[0m"
    prompt = gets.chomp.downcase
    return unless prompt == "y"

    users.each_with_index do |user, i|
      puts "#{i}. updating user #{user.id} with canvas_full: '#{user.canvas_full}'"

      last_name, first_name = user.canvas_full.split(", ")

      puts "#{i}. updating user #{user.id} to first_name: '#{first_name}', last_name: '#{last_name}'"

      printf "\033[31mWARNING -  press 'y' to continue: \033[0m"
      prompt = gets.chomp.downcase
      next unless prompt == "y"

      user.update(first_name: first_name, last_name: last_name)
      puts "updated to first_name: '#{user.first_name}', last_name: '#{user.last_name}', user_id: '#{user.id}'"
      puts "-----------------"
    end
    puts "task completed!"
  end
end
