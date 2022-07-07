# frozen_string_literal: true

RgGen.define_list_item_feature(:bit_field, :type, :counter) do
  register_map do
    read_write
    volatile
    initial_value require: true
    reference use: true, width: 1
  end

  sv_rtl do
    build do
    end

    main_code :bit_field, from_template: true
  end

  sv_ral do
  end
end
