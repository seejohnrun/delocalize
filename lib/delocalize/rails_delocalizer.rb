require 'action_view'

module Delocalize

  module RailsDelocalizer

    def self.extended(base)
      base.module_eval do
        alias :old_find :find
        def find(*args)
          template = old_find(*args)
          RailsDelocalizer.delocalize_template(template, args)
        end
      end
    end

    def self.delocalize_template(template, args)
      de = Delocalize::Delocalizer.new(template.source)

      prefix = args[1]
      path = args[0]

      paths = []
      paths.concat prefix.split('/') unless prefix.nil?
      paths << path
      h = scoped_translation(de.stripped_translation, paths)

      I18n.backend.store_translations 'en', h
      template.instance_variable_set :'@source', de.delocalized_content
      template
    end

    private

    DEFAULT_LOCALE = :en

    # This method puts an array from
    # [1, 2, 3] to
    # {1 => {2 => {3 => translation}}}
    # This makes building nested translation hashes easy
    def self.scoped_translation(translation, paths)
      h = translation
      until paths.empty?
        h = { paths.pop => h }
      end
      h
    end

    # set the natural locale - default is :en
    def self.natural_locale=(lat)
      @nat_locale = lat.is_a?(Symbol) ? lat : lat.to_sym
    end

    def self.natural_locale
      @nat_locale ||= DEFAULT_LOCALE
    end

  end

end
