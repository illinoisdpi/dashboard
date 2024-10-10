class User::HeadshotUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Sets folder in cloudinary
  def public_id
    store_dir
  end

  process tags: [ "headshot" ]
end
