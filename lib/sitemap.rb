require 'builder'
 
class Sitemap
 
  STATIC_URLS = ['/',
                 '/about_us',
                 '/contact_us'
                  ]
 
  class << self
    def create!(url)
      @bad_pages = []
      @pages_to_visit = []
      @url = url
      @url_domain = url[/([a-z0-9-]+)\.([a-z.]+)/i]
      
      @pages_to_visit = Page.published.collect { |p| p.permalink } 
 
      generate_sitemap
      update_search_engines unless (Rails.env.development? || Rails.env.test?)
    end
 
    private
    def generate_sitemap
      xml_str = ""
      xml = Builder::XmlMarkup.new(:target => xml_str, :indent => 2)
 
      xml.instruct!
      xml.urlset(:xmlns=>'http://www.sitemaps.org/schemas/sitemap/0.9') {
        @pages_to_visit.each do |url|
          unless @url == url
            xml.url {
              xml.loc(@url + url)
              xml.lastmod(Time.now.utc.strftime("%Y-%m-%dT%H:%M:%S+00:00"))
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
      sitemap_uri = @url + 'sitemap.xml'
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
