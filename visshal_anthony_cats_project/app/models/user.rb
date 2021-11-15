class User < ApplicationRecord
    validates :user_name, :password_digest, :session_token, presence: true
    validates :user_name, :session_token, uniqueness: true
    validates :password, length: {minimum: 6, allow_nil: true}

    after_initialize :ensure_session_token

    has_many :cats,
    class_name: :Cat,
    primary_key: :id,
    foreign_key: :user_id

    has_many :requests,
    class_name: :CatRentalRequest,
    primary_key: :id,
    foreign_key: :user_id

    attr_reader :password

    def self.find_by_credentials(user_name, password)
        user = User.find_by(user_name: user_name)

        return nil if user.nil?

        user.is_password?(password) ? user : nil
    end

    def owns_cat?(cat)
        cat.user_id == self.id
    end
    def is_password?(password)
        BCrypt::Password.new(self.password_digest).is_password?(password)
    end
    
    def password=(password)
        @password = password
        self.password_digest = BCrypt::Password.create(password)
    end

    def reset_session_token!
        self.session_token = SecureRandom.urlsafe_base64(16)
        self.save!
        self.session_token
    end

    private
    def ensure_session_token
        self.session_token ||= SecureRandom.urlsafe_base64(16)
    end
end