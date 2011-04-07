# == Schema Information
#
# Table name: pages
#
#  id          :integer(4)      not null, primary key
#  title       :string(255)
#  headline    :string(255)
#  permalink   :string(255)
#  content     :text
#  published   :boolean(1)      default(TRUE), not null
#  keywords    :text
#  description :text
#  edited_at   :datetime
#  created_at  :datetime
#  updated_at  :datetime
#

require 'sitemap'

class Page < ActiveRecord::Base

  attr_accessible :title, :permalink, :content, :edited_at, :description,
    :headline, :keywords, :published, :css

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
