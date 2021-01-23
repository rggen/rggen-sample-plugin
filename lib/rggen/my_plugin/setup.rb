# frozen_string_literal: true

require File.expand_path('../my_plugin', __dir__)

RgGen.register_plugin RgGen::MyPlugin do |builder|
  builder.enable :bit_field, :type, [:foo]
end
