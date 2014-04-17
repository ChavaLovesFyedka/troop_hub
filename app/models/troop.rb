class Troop < ActiveRecord::Base
  has_many :troop_events


  has_and_belongs_to_many :users

  has_many :events, through: :troop_events
  has_many :photos, as: :photoable
  has_many :newsletters
  belongs_to :age_level
  validates_uniqueness_of :number

  geocoded_by :full_address
  after_validation :geocode

  def on_page_photo
    photos.find_by(:on_page => "true")
  end

  def profile_url
    if url = on_page_photo
      url = url.pic_url
    else
      url = "default_photo.jpg"
    end
    url
  end

  AgeLevel.all.each do |age_level|
    define_singleton_method "all_#{age_level.name}" do
      joins(:age_level).where("age_levels.name = \"#{age_level.name}\" ")
    end
  end

  def troop_type
    type = "Daisy"
    if age_level
      type = age_level.name
    end
    type
  end

  def full_address
    "#{city}, #{state} #{zip_code}"
  end

end
