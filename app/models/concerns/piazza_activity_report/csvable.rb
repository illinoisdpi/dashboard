module PiazzaActivityReport::Csvable
  extend ActiveSupport::Concern

  included do
    attr_accessor :csv_file
    validates :csv_file, presence: true
    after_create :process_csv
  end

  private

  def process_csv
    ActiveRecord::Base.transaction do
      self.update(csv_filename: csv_file.original_filename)

      options = { key_mapping: { "live_q&a_upvotes": :live_qa_upvotes } }

      csv = SmarterCSV.process(csv_file, options)

      csv.each do |row|
        emails = row.fetch(:emails).split(";").map(&:strip)

        user = User.where(email: emails).first

        if user.blank?
          # TODO: throw error?
          user = User.new(email: emails.first, password: SecureRandom.hex(16))
        end

        user.piazza_full = row.fetch(:name, "None provided")
        user.save

        enrollment = Enrollment.find_or_create_by(user: user, cohort: cohort) do |the_enrollment|
          the_enrollment.role = row.fetch(:role)
        end

        piazza_activity_breakdown = piazza_activity_breakdowns.
          create(enrollment:, **row)
      end
    end
  end
end
