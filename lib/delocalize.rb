module Delocalize

  require File.dirname(__FILE__) + '/delocalize/delocalizer'
  require File.dirname(__FILE__) + '/delocalize/rails_delocalizer'

  ActionView::PathSet.send(:extend, RailsDelocalizer)

end
