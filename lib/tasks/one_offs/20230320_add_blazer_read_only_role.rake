namespace :one_offs do
  desc "Add read only role for blazer queries"
  task add_blazer_read_only_role: :environment do
    sql = %(
      BEGIN;
      CREATE ROLE blazer LOGIN PASSWORD '#{ENV["BLAZER_ROLE_PASSWORD"]}';
      GRANT CONNECT ON DATABASE #{Rails.configuration.database_configuration.dig(Rails.env, "database")} TO blazer;
      GRANT USAGE ON SCHEMA public TO blazer;
      GRANT SELECT ON ALL TABLES IN SCHEMA public TO blazer;
      ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO blazer;
      COMMIT;
    )

    ActiveRecord::Base.connection.execute(sql)
  end
end
