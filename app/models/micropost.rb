class Micropost < ApplicationRecord
	belongs_to :user
	validates :content, 		presence: true, length: { maximum: 140 }
	validates :video_title, 	presence: true
	validates :video_url, 		presence: true
	validates :video_thumbnail, presence: true
	validates :video_type, 		presence: true
	validates :user_id, 		presence: true
	validates :channel_title, 	presence: true
	validates :channel_url,     presence: true
	validates :likes_count,     presence: true

	default_scope -> { order(created_at: :desc) }
	has_many :likes, dependent: :destroy
	has_many :like_users, through: :likes, source: :user
	#リファクタリングできるのではないか
	#フィルターもジャンルもなし
	scope :search_by_parameter, -> (parameter, keyword) {
    where("microposts.#{parameter} LIKE :keyword", keyword: "%#{sanitize_sql_like(keyword)}%") if keyword.present? }
    #フィルターはあり、ジャンルはなし
	#scope :search_by_parameter_sort_by_like, -> (parameter, keyword, micropost_liked_ids) {
    #where("microposts.#{parameter} LIKE :keyword AND id IN (:micropost_liked_ids)",
    #		 keyword: "%#{sanitize_sql_like(keyword)}%", micropost_liked_ids: micropost_liked_ids) if keyword.present? }
    #フィルターはなし、ジャンルはあり
	scope :search_by_parameter_sort_by_video_type, -> (parameter, keyword, video_type) {
    where("microposts.#{parameter} LIKE :keyword AND video_type = :video_type",
    		 keyword: "%#{sanitize_sql_like(keyword)}%", video_type: video_type) if keyword.present? }
    #どっちもあり
	#scope :search_by_parameter_sort_by_like_and_video_type, -> (parameter, keyword, micropost_liked_ids, video_type) {
    #where("microposts.#{parameter} LIKE :keyword AND id IN (:micropost_liked_ids) AND video_type = :video_type",
    #		 keyword: "%#{sanitize_sql_like(keyword)}%", micropost_liked_ids: micropost_liked_ids, video_type: video_type) if keyword.present? }
	
	def contributor
		User.find(self.user_id)
	end

	def like(user)
		likes.build(user_id: user.id)
	end

	def self.search_by_parameter_with_pagination(search_version, keyword, params_page)
		if keyword.empty?
			page(params_page)
		else
			search_by_parameter(search_version, keyword).page(params_page)
		end
	end

	def self.search_by_parameter_sort_by_like_with_pagination(search_version, keyword, params_page)
		if keyword.empty?
			order(likes_count: :desc).page(params_page)
		else
			search_by_parameter(search_version, keyword).order(likes_count: :desc).page(params_page)
		end
	end

	def self.search_by_parameter_sort_by_video_type_with_pagination(search_version, keyword, video_type, params_page)
		if keyword.empty?
			where(video_type: video_type).page(params_page)
		else
			search_by_parameter_sort_by_video_type(search_version, keyword, video_type).page(params_page)
		end
	end

	def self.search_by_parameter_sort_by_like_and_video_type_with_pagination(search_version, keyword, video_type, params_page)
		if keyword.empty?
			where('video_type = ?', video_type).order(likes_count: :desc).page(params_page)
		else
			search_by_parameter_sort_by_video_type(search_version, keyword, video_type).order(likes_count: :desc).page(params_page)
		end
	end

	def self.set_third_counts_of_likes_count
		Micropost.where.not(likes_count: 0).map{ |micropost| micropost.likes_count }.uniq.max(3)
	end

	def self.set_third_likes_counts_microposts
		third_counts_of_likes_count = Micropost.set_third_counts_of_likes_count.last
		Micropost.where('likes_count >= ?', third_counts_of_likes_count).unscope(:order).order(likes_count: :desc)
	end


end
