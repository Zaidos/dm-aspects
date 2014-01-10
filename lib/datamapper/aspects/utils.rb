# encoding: utf-8

module Aspects
  module Utils
    def self.included(base)
      def base.next_id(sequence)
        repository.adapter.select("select nextval('#{sequence}')").first
      end

      def base.select_options
        all(order: [:updated_at.desc]).map do |object|
          { label: object.name, value: object.id }
        end
      end
    end

    def changed?(property)
      dirty_attribute_names.include?(property)
    end

    def attributes_json
      @attributes_json ||= Oj.dump(self.attributes, mode: :compat)
    end

    private

    def dirty_attribute_names
      dirty_attributes.keys.map { |p| p.name }
    end
  end
end
