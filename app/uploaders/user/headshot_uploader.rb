class User::HeadshotUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Sets folder in cloudinary
def public_id
  "#{store_dir}/#{SecureRandom.uuid}"
end

  process tags: ["headshot"]
end
