# app/uploaders/user/headshot_uploader.rb
class User::HeadshotUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Sets folder in Cloudinary
  def public_id
    store_dir
  end

  process tags: ["headshot"]

  # Validate file size before uploading
  def cache!(new_file)
    if new_file.size > 10.megabytes
      raise CarrierWave::ProcessingError, "File size exceeds the 10 MB limit. Please upload a smaller file."
    else
      super(new_file)
    end
  end
end
