# frozen_string_literal: true

require_relative 'my_plugin/version'

RgGen.setup_plugin :'rggen-my-plugin' do |plugin|
  plugin.version RgGen::MyPlugin::VERSION
  plugin.files [
    'my_plugin/bit_field/type/foo'
  ]
end
