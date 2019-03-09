require 'securerandom'
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :participations
  has_many :events, through: :participations
  has_many :comments

  mount_uploader :avatar, AvatarUploader

  has_many :skills
  has_many :sports, through: :skills

  accepts_nested_attributes_for :skills, :allow_destroy => true


  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.username = auth.info.first_name
      user.email = auth.info.email
      user.password = SecureRandom.urlsafe_base64
      user.save!
    end
  end

rescue ActiveRecord::RecordInvalid
  ::NewRelic::Agent.add_custom_attributes(auth)
  raise
end


def create_event_as_owner(attributes)
  event = events.create(attributes)
  event.tap {|event| event.participations.find_by(user: self)&.owner!}
end

def skill_level(sport_name)
  self.skills.joins(:sport).find_by("sports.name = ?", sport_name)&.level
end



