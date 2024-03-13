namespace :one_offs do
  desc "Add first_name and last_name to users imported from canvas"
  task fix_canvas_imported_usernames: :environment do
    puts "Updating users with canvas_full"
    users = User.where.not(canvas_full: nil).where(first_name: nil)
      .or(User.where.not(canvas_full: nil).where(last_name: nil))
    puts "There are #{users.count} users to update."

    users.each do |user|
      puts "updating user #{users.index(user) + 1} with canvas_full: '#{user.canvas_full}'"
      last_name, first_name = user.canvas_full.split(", ")
      user.update(first_name: first_name, last_name: last_name)
      puts "updated to first_name: '#{user.first_name}', last_name: '#{user.last_name}', user_id: '#{user.id}'"
      puts "-----------------"
    end
    puts "task completed!"
  end
end
