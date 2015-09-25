class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  before_create :create_remember_token
  self.per_page = 10
  
  #attr_accessible :name, :email, :password, :password_confirmation
  validates :name,  presence: true, length: { maximum: 50 }
  validates :email, presence: true
  validates :email, presence: true
  has_secure_password
  has_many :microposts, dependent: :destroy
  
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
    has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower
  
  validates :password, length: { minimum: 6 }
  
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end


    def feed
      # このコードは準備段階です。
      # 完全な実装は第11章「ユーザーをフォローする」を参照してください。
      Micropost.where("user_id = ?", id)
    end
  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end
  
  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
  
end
