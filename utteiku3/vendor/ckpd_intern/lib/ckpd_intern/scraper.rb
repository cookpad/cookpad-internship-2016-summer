require 'ckpd_intern'
require 'uri'
require 'nokogiri'
require 'json'
require_relative 'seed'

module CkpdIntern
  class Scraper
    class << self
      def scrape_all!(out: CkpdIntern::Seed::JSON_PATH)
        seed = data.each_with_object({}) do |(name, category), seed|
          category_image = new(category[:image], image_subdir: 'category').scrape[:image_path]
          items          = category[:items].map {|url| sleep 2; new(url, image_subdir: 'item').scrape }

          seed[name] = {image_path: category_image, items:  items }
        end

        File.write(out, JSON.pretty_generate(seed))
      end

      private

      def data
        {
          '調理器具' => {
            image: 'http://www.irasutoya.com/2014/06/blog-post_1257.html',
            items: %w[
              http://www.irasutoya.com/2013/01/blog-post_22.html
              http://www.irasutoya.com/2013/01/blog-post_25.html
              http://www.irasutoya.com/2013/01/blog-post_19.html
              http://www.irasutoya.com/2012/12/blog-post_28.html
              http://www.irasutoya.com/2012/12/blog-post_29.html
              http://www.irasutoya.com/2013/01/blog-post_3.html
              http://www.irasutoya.com/2013/01/blog-post_8.html
              http://www.irasutoya.com/2013/01/blog-post_14.html
            ],
          },

          '食器' => {
            image: 'http://www.irasutoya.com/2014/05/blog-post_954.html',
            items: %w[
                http://www.irasutoya.com/2013/12/blog-post_8811.html
                http://www.irasutoya.com/2015/09/blog-post_48.html
                http://www.irasutoya.com/2014/05/blog-post_6748.html
            ],
          },

          '食材' => {
            image: 'http://www.irasutoya.com/2016/01/blog-post_90.html',
            items: %w[
              http://www.irasutoya.com/2014/05/blog-post_1080.html
              http://www.irasutoya.com/2016/03/blog-post_754.html
            ],
          }
        }
      end
    end

    attr_reader :url

    def initialize(url, image_subdir: 'item')
      @url = url
      @image_subdir = image_subdir
    end

    def scrape
      puts "Scraping #{url} ..."
      doc = Nokogiri::HTML(Net::HTTP.get(URI(url)))
      image_url  = doc.css('#post .entry img').attr('src')
      image_path = store_image(image_url)

      {
        title:        extract_title(doc.css('#post .title').text),
        description:  doc.css('#post .entry').text.strip.sub(/のイラストです。\z/, 'です。'),
        image_path:   image_path
      }
    end

    private

    def extract_title(title)
      if title =~ /「([^」]+)」/
        $1
      else
        title.sub(/のイラスト/, '').strip
      end
    end

    def store_image(image_url)
      image_name = File.basename(image_url, '.png').scan(/[[[:alnum:]]_\-]+/).join + '.png'
      dir = (CkpdIntern.root + 'app/assets/images/ckpd_intern/' + @image_subdir)
      dir.mkpath

      Dir.chdir(dir.to_s) do
        File.binwrite(image_name, Net::HTTP.get(URI(image_url)))
      end

      "ckpd_intern/#{@image_subdir}/#{image_name}"
    end
  end
end
