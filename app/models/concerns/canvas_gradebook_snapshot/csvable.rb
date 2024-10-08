module CanvasGradebookSnapshot::Csvable
  extend ActiveSupport::Concern

  class InvalidCanvasShortnameError < StandardError; end
  class MissingCsvFileError < StandardError; end

  included do
    attr_accessor :csv_file

    validates :csv_file, presence: true
    validates :csv_filename, uniqueness: true, format: { with: ->(canvas_gradebook_snapshot) { /\A.*#{Regexp.escape(canvas_gradebook_snapshot.cohort.canvas_shortname)}.*\z/ }, message: "must contain canvas shortname belonging to this cohort" }

    before_validation :process_csv_filename
    after_create :process_csv
  end

  class_methods do
    def extract_assignment_name(assignment_name_raw)
      name_array = assignment_name_raw.to_s.split("_")

      name_array.take(name_array.length - 1).join(' ')
    end

    def extract_id_from_canvas(assignment_name_raw)
      assignment_name_raw.to_s.split("_").pop.gsub(/\D/, '')
    end

    def extract_downloaded_at(csv_filename)
      DateTime.strptime(csv_filename.split("_").at(0), '%Y-%m-%dT%H%M')
    end
  end

  private

  def process_csv_filename
    raise MissingCsvFileError.new("Please select a CSV file") if self.csv_file.blank?
    self.csv_filename = csv_file.original_filename
    self.downloaded_at = CanvasGradebookSnapshot.extract_downloaded_at(csv_filename)
    validate_canvas_shortname
  rescue InvalidCanvasShortnameError => e
    errors.add(:csv_filename, e.message)
  rescue MissingCsvFileError => e
    errors.add(:csv_file, e.message)
  rescue Date::Error
    errors.add(:csv_filename, "Invalid format for downloaded_at in CSV filename. Expected format: 'YYYY-MM-DDTHHMM'")
  end

  def validate_canvas_shortname
    raise InvalidCanvasShortnameError.new("Please add canvas shortname to selected cohort") if cohort.canvas_shortname.blank?
    canvas_shortname_regex = Regexp.new(Regexp.escape(cohort.canvas_shortname))
    unless canvas_shortname_regex.match?(csv_filename)
      raise InvalidCanvasShortnameError.new("Invalid canvas shortname in CSV filename. Expected format: '#{cohort.canvas_shortname}'")
    end
  end

  def process_csv
    ActiveRecord::Base.transaction do
      csv = SmarterCSV.process(csv_file)
      Rails.logger.info "CSV processed. Total rows: #{csv.size}"
  
      existing_assignments = cohort.canvas_assignments.index_by(&:id_from_canvas) # Hash key "id_from_canvas" is a string
      existing_users = User.pluck(:email, :id).to_h # Hash key "email" is a string value is the id string 
      existing_enrollments = cohort.enrollments.index_by { |e| e.id_from_canvas.to_s } # Hash key "id_from_canvas" is a string value is the enrollment object
      
      #Create empty arrays to store data
      assignments_data = []
      users_data = []
      enrollments_data = []
      submissions_data = []
  
      # Step 2: Process the first row of the CSV to handle assignments
      first_row = csv.first #Hash with keys as symbols abd values as strings or numbers
      first_row.to_a.each_with_index do |(assignment_name_raw, points_possible), position| 
        next unless points_possible.is_a?(Numeric) #Handle the case where points_possible is not a number
  
        id_from_canvas = CanvasGradebookSnapshot.extract_id_from_canvas(assignment_name_raw.to_s).to_s #string value
        name = CanvasGradebookSnapshot.extract_assignment_name(assignment_name_raw.to_s) # string value of assignment name
  
        debugger


        unless existing_assignments[id_from_canvas]
          debugger #this iss not running
          assignments_data.push({
            id_from_canvas: id_from_canvas,
            name: name,
            points_possible: points_possible,
            position: position,
            cohort_id: cohort.id,
            created_at: Time.current,
            updated_at: Time.current
          })
        end
      end  

       
      # Step 3: Process remaining rows to handle users, enrollments, and submissions
      csv.drop(1).each do |row|
        id_from_canvas = row.fetch(:id).to_s
        email = row.fetch(:sis_login_id, nil)
  
        # Handle Users
        unless existing_users[email]
          canvas_full = row.fetch(:student, "None provided")
          last_name, first_name = canvas_full.split(", ")
          first_name ||= "Unknown"
          last_name ||= "Unknown"
  
          users_data.push({
            email: email,
            encrypted_password: Devise::Encryptor.digest(User, SecureRandom.hex(16)),
            first_name: first_name,
            last_name: last_name,
            created_at: Time.current,
            updated_at: Time.current
          })
        end

        # Handle Enrollments
        unless existing_enrollments[id_from_canvas]
          enrollments_data.push({
            id_from_canvas: id_from_canvas,
            cohort_id: cohort.id,
            role: "student",
            user_email: email,  # Temporarily store email to associate user later
            created_at: Time.current,
            updated_at: Time.current
          })
        end
  
        # Handle Submissions for each assignment
        row.each do |assignment_name_raw, points|
          next unless points.is_a?(Numeric)
  
          assignment_id_from_canvas = CanvasGradebookSnapshot.extract_id_from_canvas(assignment_name_raw).to_s
          canvas_assignment = existing_assignments[assignment_id_from_canvas] #if it doesnt exist we need to create it?
  
          
          if canvas_assignment
            submissions_data.push({
              enrollment_id: existing_enrollments[id_from_canvas]&.id, #its not a hash here :(
              canvas_assignment_id: canvas_assignment.id,
              canvas_gradebook_snapshot_id: self.id,
              points: points,
              created_at: Time.current,
              updated_at: Time.current
            })
          end
        end
      end
    end
  end
  
end
