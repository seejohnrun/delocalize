require 'rubygems'
require 'nokogiri'

module Translation

  class Delocalizer

    def initialize(original)
      @original = original
      @data = {}
      delocalize
    end

    def delocalized_content
      @delocalized
    end

    def stripped_translation
      @data
    end

    private

    def delocalize
      @delocalized = @original.dup # don't be silly
      @delocalized.gsub!(/\<\s*t[^\/]+\/t\>/) do |tag|
        ng = Nokogiri::parse(tag)
        trans = ng.css('t').first
        # get the text and ID
        attrs = {}
        trans.attribute_nodes.each { |an| attrs[an.name] = an.text }
        # set up the id and text
        id = attrs.delete('id')
        text = attrs.delete('yml') == 'true' ? YAML::load(trans.text) : trans.text 
        # get the id from the content if we don't have one
        text_s = text.is_a?(Hash) ? text.values.join(' ') : text
        id = text_s.downcase.split(/[^a-zA-Z0-9_]/).reject { |s| s.empty? }.slice(0, 3).join('_') if id.nil?
        @data[id] = text # store for real translation
        "<%= t('#{id}'#{attrs.map { |k, v| ", :#{k} => #{v}" }.join('')}) %>"
      end
    end

  end

end
