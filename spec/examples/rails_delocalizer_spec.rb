require File.dirname(__FILE__) + '/../spec_helper'
require 'active_support/core_ext/string/access'
require 'action_controller'

describe Delocalize::RailsDelocalizer do

  class Sample < ActionController::Base
  end

  def test_render(code)
    file = File.open('spec/sample/temporary.html.erb', 'w') { |f| f.write code }
    c = Sample.new
    Sample.view_paths = File.dirname(__FILE__) + '/..'
    begin
      c.render :action => 'temporary'
    rescue RuntimeError
      c.response_body.is_a?(Array) ? c.response_body.first : c.response_body
    end
  end

  before(:each) do
    I18n.backend = I18n::Backend::Simple.new
    Delocalize::RailsDelocalizer.natural_locale = I18n.locale = :en
  end

  it 'should be able to delocalize a view to the native language' do
    text = test_render "<t key='.hi'>hello</t>"
    text.should == 'hello'
  end

  it 'should be able to delocalize a view to the native language with partial scoping' do
    text = test_render "<t key='.world'>hello</t>"
    text.should == 'hello'
  end

  it 'should be able to delocalize a view to a different language' do
    I18n.locale = :es
    I18n.backend.store_translations :es, { 'hello' => 'hola' }
    text = test_render "<t>hello</t>"
    text.should == 'hola'
  end
  
  it 'should be able to delocalize a view with variables in place' do
    text = test_render "<t key='.name' name=\"'john'\">my name is %{name}</t>"
    text.should == 'my name is john'
  end

  it 'should naturally have a default locale' do
    I18n.default_locale.should == Delocalize::RailsDelocalizer.natural_locale
  end

  it 'should be able to change the natural locale and render in german' do
    Delocalize::RailsDelocalizer.natural_locale = :de
    I18n.locale = :de
    text = test_render "<t key='.word'>hi</t>"
    text.should == 'hi'
  end

  it 'should be able to use NON-. and have it put things at the root safely' do
    text = test_render "<t key='named'>your name is john</t>"
    text.should == 'your name is john'
  end

  it 'should be able to put . in a key without an issue'
#    text = test_render "<t key='sub.sample'>something</t>"
#    text.should == 'something'
#    I18n.backend.send(:translations).should == {}
#  end

  it 'should be able to put . in two keys with the same scope'
#    text = test_render "<t key='sub.sample1'>something1</t><t key='sub.sample2'>something2</t>"
#    text.should == 'something1something2'
#    I18n.backend.send(:translations).should == {}
#  end

end
