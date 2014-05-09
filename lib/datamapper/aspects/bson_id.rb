# encoding: utf-8

module DataMapper
  module Aspects
    module BSONID
      def self.included(base)
        base.property :id, String, length: 24, key: true, default: Moped::BSON::ObjectId.new.to_s
        base.validates_with_method :id, method: :id_is_valid?

        def id_generation_time
          Moped::BSON::ObjectId.from_string(@id).generation_time
        end

        def id_is_valid?
          Moped::BSON::Objectid.legal?(@id)
        end
      end
    end
  end
end
