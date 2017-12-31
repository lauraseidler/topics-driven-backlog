class Topic < ApplicationRecord
  belongs_to :course

  validates_presence_of :title, :course_id
  validate :url_is_valid

  private

  def url_is_valid
    parsed_url = URI.parse(url) rescue false
    parsed_url.kind_of?(URI::HTTP) || parsed_url.kind_of?(URI::HTTPS)

    if !parsed_url.kind_of?(URI::HTTP) || !parsed_url.kind_of?(URI::HTTPS)
      errors.add(:url, 'is invalid.')
    end
  end
end
