require 'action_pack'
require 'action_view'

module Delocalize

  module RailsDelocalizer

    def self.extended(base)
      if ActionPack::VERSION::MAJOR == 3
        self._rails_3_delocalize(base)
      elsif ActionPack::VERSION::MAJOR == 2
        self._rails_2_delocalize(base)
      else
        raise "ActionPack #{ActionPack::VERSION::STRING} is not supported by Delocalize!"
      end
    end

    private

    def self._rails_2_delocalize(base)
      base.module_eval do
        alias :old_find_template :find_template
        def find_template(*args)
          template = old_find_template(*args)
          new_source = RailsDelocalizer.delocalize_template(template, args)
          template.instance_variable_set(:@_memoized_source, [new_source])
          template
        end
      end
    end

    def self._rails_3_delocalize(base)
      base.module_eval do
        alias :old_find :find
        def find(*args)
          template = old_find(*args)
          RailsDelocalizer.delocalize_template!(template, args)
          template
        end
      end
    end

    private

    def self.delocalize_template!(template, args)
      de = Delocalize::Delocalizer.delocalize!(template.source)
      place_delocalization(de, args)
      template.source
    end

    def self.delocalize_template(template, args)
      de = Delocalize::Delocalizer.delocalize(template.source)
      place_delocalization(de, args)
      de.delocalized_content
    end

    def self.place_delocalization(de, args)
      paths = "#{args[0]}/#{args[1]}".split('/').compact.reverse # TODO separate

      I18n.backend.store_translations natural_locale, scoped_translation(de.stripped_scoped_translation, paths)
      I18n.backend.store_translations natural_locale, scoped_translation(de.stripped_base_translation, [])
    end

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
