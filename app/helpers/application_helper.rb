module ApplicationHelper

  def content_data(key, attr: nil)
    hash = Contents[key]
    return [] if hash.blank?
    hash = hash[attr.to_s] if attr.present?
    Array.wrap(hash)
  end
end
