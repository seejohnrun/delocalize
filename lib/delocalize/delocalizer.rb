require 'rubygems'
require 'nokogiri'

module Delocalize

  class Delocalizer

    def initialize(original)
      @original = original
      @scoped_data = {}
      @base_data = {}
      delocalize
    end

    def delocalized_content
      @delocalized
    end

    def stripped_scoped_translation
      @scoped_data
    end

    def stripped_base_translation
      @base_data
    end

    private

    def delocalize
      @delocalized = @original.dup # don't be silly
      @delocalized.gsub!(/<\s*t[^\/]+\/t>/) do |tag|
        ng = Nokogiri::parse(tag) # TODO shouldn't really need nokogiri at all - kinda a waste
        trans = ng.css('t').first
        # get the text and ID
        attrs = {}
        trans.attribute_nodes.each { |an| attrs[an.name] = an.text }
        # set up the id and text
        key = attrs.delete('key')
        text = attrs.delete('yml') == 'true' ? YAML::load(trans.text) : trans.text 
        # get the id from the content if we don't have one
        text_s = text.is_a?(Hash) ? text.values.join(' ') : text
        key = text_s.downcase.split(/[^a-zA-Z0-9_]/).reject { |s| s.empty? }.slice(0, 3).join('_') if key.nil?

        if key[0] == '.'
          @scoped_data[key[1..-1]] = text
        else
          @base_data[key] = text
        end
        
        "<%= t('#{key}'#{attrs.map { |k, v| ", :#{k} => #{v}" }.join('')}) %>"
      end
    end

  end

end
