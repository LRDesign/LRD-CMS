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

  validates_presence_of :title, :permalink
  validates_uniqueness_of :title, :permalink
  validates_inclusion_of :layout, :in => PAGE_LAYOUTS.values

  after_create :regenerate_sitemap
  after_update :regenerate_sitemap
  before_destroy :regenerate_sitemap

  has_many :locations

  scope :brochure, -> do
    where(:layout => nil)
  end

  scope :blog, -> do
    where(:layout => "blog")
  end

  scope :published, -> do
    where("(publish_start IS NULL OR publish_start < :now) AND (publish_end IS NULL OR publish_end > :now)", :now => Time.zone.now)
  end

  scope :unpublished, -> do
    where("NOT ((publish_start IS NULL OR publish_start < :now) AND (publish_end IS NULL OR publish_end > :now))", :now => Time.zone.now)
  end

  scope :most_recent, -> do
    order(:updated_at => :desc).limit(5)
  end

  def published?
    (publish_start.nil? || publish_start <= Time.zone.now) && (publish_end.nil? || publish_end >= Time.zone.now)
  end

  def regenerate_sitemap
    Sitemap.create! unless Rails.env.test?
  end
end
