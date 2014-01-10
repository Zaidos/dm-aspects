# encoding: utf-8

module Aspects
  module Slug
    def self.included(base)
      base.property :slug, String, length: 75, unique: true
      def base.find_by_slug(slug)
        first(slug: slug, order: [:updated_at.desc])
      end
    end
  end
end
