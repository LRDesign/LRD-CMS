require 'builder'

class Sitemap

  class << self
    def create!(domain = SITE_DOMAIN)
      @bad_pages = []
      @pages_to_visit = []
      @domain = domain
      @url_domain = domain[/([a-z0-9-]+)\.([a-z.]+)/i]

      @pages_to_visit = Page.published

      generate_sitemap
      update_search_engines if Rails.env.production?
    end

    private
    def generate_sitemap
      xml_str = ""
      xml = Builder::XmlMarkup.new(:target => xml_str, :indent => 2)

      xml.instruct!
      xml.urlset(:xmlns=>'http://www.sitemaps.org/schemas/sitemap/0.9') {
        STATIC_PATHS_FOR_SITEMAP.each do |path|
          xml.url {
            xml.loc(@domain + path)
            xml.lastmod(Time.now.utc.iso8601)
          }
        end
        @pages_to_visit.each do |page|
          unless @domain == page.permalink
            path = page.permalink.gsub(/\A\//,'') # strip leading /, if it exists
            xml.url {
              xml.loc(@domain + '/' + path)
              xml.lastmod(page.updated_at.iso8601)
             }
          end
        end
      }

      save_file(xml_str)
    end

    def save_file(xml)
      File.open("#{ Rails.root }/public/sitemap.xml", "w+") do |f|
        f.write(xml)
      end
    end

    # Notify popular search engines of the updated sitemap.xml
    def update_search_engines
      sitemap_uri = @domain + '/sitemap.xml'
      # puts "sitemap uri is #{sitemap_uri}"
      escaped_sitemap_uri = CGI.escape(sitemap_uri)
      Rails.logger.info "Notifying Google"
      res = Net::HTTP.get_response('www.google.com', '/webmasters/tools/ping?sitemap=' + escaped_sitemap_uri)
      Rails.logger.info res.class
      Rails.logger.info "Notifying Yahoo"
      res = Net::HTTP.get_response('search.yahooapis.com', '/SiteExplorerService/V1/updateNotification?appid=SitemapWriter&url=' + escaped_sitemap_uri)
      Rails.logger.info res.class
      Rails.logger.info "Notifying Bing"
      res = Net::HTTP.get_response('www.bing.com', '/webmaster/ping.aspx?siteMap=' + escaped_sitemap_uri)
      Rails.logger.info res.class
      Rails.logger.info "Notifying Ask"
      res = Net::HTTP.get_response('submissions.ask.com', '/ping?sitemap=' + escaped_sitemap_uri)
      Rails.logger.info res.class
    end
  end
end
