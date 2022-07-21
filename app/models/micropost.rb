class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :user_id, presence: true

  validates :content, presence: true, length: {maximum: Settings.max.content}

  validates :image, content_type: {in: Settings.micropost.image_path,
                                   message: :mess},
    size: {less_than: Settings.max.img_size.megabytes,
           message: :size_img}

  scope :recent_posts, -> {order created_at: :desc}
  scope :by_user_id, ->(user_id){where user_id: user_id}

  def display_image
    image.variant resize_to_limit: Settings.micropost.resize_to_limit
  end
end
