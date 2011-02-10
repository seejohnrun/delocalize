require 'action_view'

module Delocalize

  require File.dirname(__FILE__) + '/delocalize/delocalizer'
  autoload :RailsDelocalizer, File.dirname(__FILE__) + '/delocalize/rails_delocalizer'

  ActionView::PathSet.send(:extend, RailsDelocalizer)

end
