module MightyGrid
  module MgHash
    class << self
      # A deep merge of two hashes.
      # That is, if both hashes have the same key and the values are hashes, these two hashes should also be merged.
      # Used for merging two sets of params.
      def rec_merge(hash, other)  #:nodoc:
        res = hash.clone
        other.each do |key, other_value|
          value = res[key]
          if value.is_a?(Hash) && other_value.is_a?(Hash)
            res[key] = rec_merge value, other_value
          else
            res[key] = other_value
          end
        end
        res
      end
    end
  end

  module MgHTML
    class << self
      def join_html_classes(html_options, *html_classes)
        html_options[:class] ||= ''
        html_options[:class] = ([html_options[:class]] + html_classes).reject(&:blank?).map do |h_classes|
          h_classes.split(' ')
        end.flatten.uniq.join(' ')
        html_options
      end
    end
  end
end
