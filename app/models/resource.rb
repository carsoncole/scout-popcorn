class Resource < ApplicationRecord
  belongs_to :event
  validates :name, :url, presence: true
  validates :url, format: { with: URI.regexp }, if: Proc.new { |a| a.url.present? }
end