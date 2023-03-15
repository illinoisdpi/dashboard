module PiazzaActivityDownload::Adminable
  extend ActiveSupport::Concern

  included do
    rails_admin do
      fields do
        read_only true
      end
    end
  end
end
  