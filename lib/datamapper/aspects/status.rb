# encoding: utf-8

module Aspects
  module Status
    def self.included(base)
      base.property :status, String, length: 9, default: 'draft'
      base.validates_within :status, set: %w(draft published archived)
    end
  end
end
