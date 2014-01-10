# encoding: utf-8

module DataMapper
  module Aspects
    module Status

      def self.statuses
        %w(draft published archived).freeze
      end

      def self.included(base)
        base.property :status, String, default: ->(r,p) { self.statuses.first }
        base.validates_within :status, set: self.statuses
      end
    end
  end
end
