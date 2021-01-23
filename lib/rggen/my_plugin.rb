# frozen_string_literal: true

require_relative 'my_plugin/version'

module RgGen
  module MyPlugin
    extend Core::Plugin

    setup_plugin :'rggen-my-plugin' do |plugin|
      plugin.files [
        'my_plugin/bit_field/type/foo'
      ]
    end
  end
end
