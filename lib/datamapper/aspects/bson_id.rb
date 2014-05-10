# encoding: utf-8

module DataMapper
  module Aspects
    # Public: Provides a valid BSON Object ID key property.
    # Also validates that BSON IDs are valid object ids.
    #
    # Examples
    #
    #   my_obj.id.id_is_valid?
    #   # => true
    #
    #   my_obj.id.id_generation_time
    #   # => 2014-05-09 06:07:00 UTC
    module BSONID
      def self.included(base)
        # Public: Provides the default aspect's attributes.
        base.property :id, String,
          length: 24,
          key: true,
          unique: true,
          default: proc { Moped::BSON::ObjectId.new.to_s }

        # Internal: Validates that the BSON ID is a valid object id.
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
          if Moped::BSON::ObjectId.legal?(@id)
            true
          else
            [false, 'Id must be a valid BSON ObjectId']
          end
        end
      end
    end
  end
end
