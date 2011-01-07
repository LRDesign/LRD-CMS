require 'sitemap'

class Page < ActiveRecord::Base

  attr_accessible :title, :permalink, :content, :edited_at, :description,
    :headline, :keywords, :published

  validates_presence_of :title, :permalink
  validates_uniqueness_of :title, :permalink

  after_create :regenerate_sitemap
  after_update :regenerate_sitemap
  before_destroy :regenerate_sitemap

  scope :published, where(:published => true)
  scope :unpublished, where(:published => false)

  def regenerate_sitemap
    Sitemap.create! unless Rails.env.test?
  end
end
