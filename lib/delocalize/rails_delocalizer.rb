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
      de = Delocalize::Delocalizer.delocalize!(template.source)

      paths = "#{args[0]}/#{args[1]}".split('/').compact.reverse # TODO separate
      I18n.backend.store_translations natural_locale, scoped_translation(de.stripped_scoped_translation, paths)
      I18n.backend.store_translations natural_locale, scoped_translation(de.stripped_base_translation, [])
      template
    end

    private

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
      @nat_locale ||= I18n.default_locale
    end

  end

end
