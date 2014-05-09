# encoding: utf-8

module DataMapper
  module Aspects
    module BSONID

      def self.included(base)
        base.property :id, String, length: 24, key: true, default: Moped::BSON::ObjectId.new.to_s
        base.validates_with_method :id, method: :id_is_valid?

        # Public: Retrieves the generation time of the BSON Object ID.
        #
        # Examples
        #
        #   id_generation_time()
        #   # => 2014-05-09 06:07:00 UTC
        #
        # Returns the generation time of the BSON Object ID as a String.
        def id_generation_time
          Moped::BSON::ObjectId.from_string(@id).generation_time
        end

        # Public: Checks if the ID is a valid BSON Object ID.
        #
        # Examples
        #
        #   id_is_valid?()
        #   # => true
        #
        # Returns true if ID is valid, false if not.
        def id_is_valid?
          Moped::BSON::ObjectId.legal?(@id)
        end
      end
    end
  end
end
