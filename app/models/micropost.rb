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
	default_scope -> { order(created_at: :desc) }
	has_many :likes, dependent: :destroy
	has_many :like_users, through: :likes, source: :user
	#リファクタリングできるのではないか
	#フィルターもジャンルもなし
	scope :search_by_content, -> (keyword) {
    where("microposts.content LIKE :keyword", keyword: "%#{sanitize_sql_like(keyword)}%") if keyword.present? }
	scope :search_by_video_title, -> (keyword) {
    where("microposts.video_title LIKE :keyword", keyword: "%#{sanitize_sql_like(keyword)}%") if keyword.present? }
	scope :search_by_channel_title, -> (keyword) {
    where("microposts.channel_title LIKE :keyword", keyword: "%#{sanitize_sql_like(keyword)}%") if keyword.present? }
    #フィルターはあり、ジャンルはなし
	scope :search_by_content_sort_by_like, -> (keyword, micropost_liked_ids) {
    where("microposts.content LIKE :keyword AND id IN (:micropost_liked_ids)",
    		 keyword: "%#{sanitize_sql_like(keyword)}%", micropost_liked_ids: micropost_liked_ids) if keyword.present? }
	scope :search_by_video_title_sort_by_like, -> (keyword, micropost_liked_ids) {
    where("microposts.video_title LIKE :keyword AND id IN (:micropost_liked_ids)",
    		 keyword: "%#{sanitize_sql_like(keyword)}%", micropost_liked_ids: micropost_liked_ids) if keyword.present? }
	scope :search_by_channel_title_sort_by_like, -> (keyword, micropost_liked_ids) {
    where("microposts.channel_title LIKE :keyword AND id IN (:micropost_liked_ids)",
    		 keyword: "%#{sanitize_sql_like(keyword)}%", micropost_liked_ids: micropost_liked_ids) if keyword.present? }
    #フィルターはなし、ジャンルはあり
	scope :search_by_content_sort_by_video_type, -> (keyword, video_type) {
    where("microposts.content LIKE :keyword AND id video_type = :video_type)",
    		 keyword: "%#{sanitize_sql_like(keyword)}%", video_type: video_type) if keyword.present? }
	scope :search_by_video_title_sort_by_video_type, -> (keyword, video_type) {
    where("microposts.video_title LIKE :keyword AND id video_type = :video_type)",
    		 keyword: "%#{sanitize_sql_like(keyword)}%", video_type: video_type) if keyword.present? }
	scope :search_by_channel_title_sort_by_video_type, -> (keyword, video_type) {
    where("microposts.channel_title LIKE :keyword AND id video_type = :video_type)",
    		 keyword: "%#{sanitize_sql_like(keyword)}%", video_type: video_type) if keyword.present? }
    #どっちもあり
	scope :search_by_content_sort_by_like_and_video_type, -> (keyword, micropost_liked_ids, video_type) {
    where("microposts.content LIKE :keyword AND id IN (:micropost_liked_ids) AND video_type = :video_type",
    		 keyword: "%#{sanitize_sql_like(keyword)}%", micropost_liked_ids: micropost_liked_ids, video_type: video_type) if keyword.present? }
	scope :search_by_video_title_sort_by_like_and_video_type, -> (keyword, micropost_liked_ids, video_type) {
    where("microposts.video_title LIKE :keyword AND id IN (:micropost_liked_ids) AND video_type = :video_type",
    		 keyword: "%#{sanitize_sql_like(keyword)}%", micropost_liked_ids: micropost_liked_ids, video_type: video_type) if keyword.present? }
	scope :search_by_channel_title_sort_by_like_and_video_type, -> (keyword, micropost_liked_ids, video_type) {
    where("microposts.channel_title LIKE :keyword AND id IN (:micropost_liked_ids) AND video_type = :video_type",
    		 keyword: "%#{sanitize_sql_like(keyword)}%", micropost_liked_ids: micropost_liked_ids, video_type: video_type) if keyword.present? }
	


	def contributor
		User.find(self.user_id)
	end

	def like(user)
		likes.build(user_id: user.id)
	end

end
