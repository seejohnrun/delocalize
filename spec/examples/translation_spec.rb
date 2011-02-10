require File.dirname(__FILE__) + '/../spec_helper'
require 'yaml'
require 'i18n'
require 'erb'

describe Delocalize do

  it 'should detect single Delocalizes with ids inline' do
    content = "<t key='hello_world'>hello world</t>"
    de = Delocalize::Delocalizer.new(content)
    # and verify
    de.delocalized_content.should == "<%= t('hello_world') %>"
    de.stripped_translation.should == { 'hello_world' => 'hello world' }
  end

  it 'should be able to skip an id and autobuild it' do
    content = "<t>hello world</t>"
    de = Delocalize::Delocalizer.new(content)
    # and verify
    de.delocalized_content.should == "<%= t('hello_world') %>"
    de.stripped_translation.should == { 'hello_world' => 'hello world' }
  end

  it 'should be able to parse a Delocalize block in the middle of erb' do
    content = "<label> <t key='name_label'>Name</t> </label>"
    de = Delocalize::Delocalizer.new(content)
    # and verify
    de.delocalized_content.should == "<label> <%= t('name_label') %> </label>"
    de.stripped_translation.should == { 'name_label' => 'Name' }
  end

  it 'should be ablt to keep variables around when moving a Delocalize - erb' do
    content = "<strong> <t key='name_label' name='name'>Your name is: %{name}</t> </strong>"
    de = Delocalize::Delocalizer.new(content)
    # and verify
    de.delocalized_content.should == "<strong> <%= t('name_label', :name => name) %> </strong>"
    de.stripped_translation.should == { 'name_label' => 'Your name is: %{name}' }
  end

  it 'should be ablt to keep variables around when moving a Delocalize - string' do
    content = "<strong> <t key='name_label' name='\"name\"'>Your name is: %{name}</t> </strong>"
    de = Delocalize::Delocalizer.new(content)
    # and verify
    de.delocalized_content.should == "<strong> <%= t('name_label', :name => \"name\") %> </strong>"
    de.stripped_translation.should == { 'name_label' => 'Your name is: %{name}' }
  end

  it 'should be able to deal with two Delocalize tags in the same document' do
    content = "<li><t key='name' name='name'>your name is: %{name}</t><br/><t key='rname' rname='name.reverse'>your name in reverse: %{rname}</t></li>"
    de = Delocalize::Delocalizer.new(content)
    # and verify
    de.delocalized_content.should == "<li><%= t('name', :name => name) %><br/><%= t('rname', :rname => name.reverse) %></li>"
    de.stripped_translation.should == { 'name' => 'your name is: %{name}', 'rname' => 'your name in reverse: %{rname}' }
  end

  it 'should be actually able to parse a generated template with I18n' do
    content = "<li><t key='name' name='name'>your name is: %{name}</t><br/><t key='rname' rname='name.reverse'>your name in reverse: %{rname}</t></li>"
    de = Delocalize::Delocalizer.new(content)
    # and try to actually run the Delocalize
    f = File.new('en.yml', 'w')
    f.write YAML::dump('en' => de.stripped_translation)
    f.close
    # load the Delocalize
    I18n.backend = I18n::Backend::Simple.new
    I18n.load_path = ['en.yml']
    # test the real Delocalize
    binding = BindToMe.new('name' => 'john')
    erb = ERB.new(de.delocalized_content)
    erb.result(binding.get_binding).should == "<li>your name is: john<br/>your name in reverse: nhoj</li>"
  end

  it 'should be able to play with pluralization like a champ' do
    content = "<li><t key='repo_count' count='\"3\"' yml='true'>one: %{count} repository\nother: %{count} repositories</t></li>"
    de = Delocalize::Delocalizer.new(content)

    de.delocalized_content.should == "<li><%= t('repo_count', :count => \"3\") %></li>"
    de.stripped_translation.should == { 'repo_count' => { 'one' => '%{count} repository', 'other' => '%{count} repositories' } }
  end

  it 'should be able to use pluralization and autorecognize ids' do
    content = "<li><t count='\"3\"' yml='true'>one: %{count} repository\nother: %{count} repositories</t></li>"
    de = Delocalize::Delocalizer.new(content)

    de.delocalized_content.should == "<li><%= t('count_repository_count', :count => \"3\") %></li>"
    de.stripped_translation.should == { 'count_repository_count' => { 'one' => '%{count} repository', 'other' => '%{count} repositories' } }
  end

end

# Used to make I18n able to translate
class BindToMe
  def initialize(data)
    @data = data
  end

  def get_binding
    return binding
  end

  def t(t, options = {})
    I18n.translate(t, options)
  end

  def method_missing(mthd, *args)
    mthd_str = mthd.to_s
    @data.has_key?(mthd_str) ? @data[mthd_str] : nil
  end
end
