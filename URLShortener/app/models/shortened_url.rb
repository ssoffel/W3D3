class ShortenedUrl < ApplicationRecord 
    validates :short_url, presence: true, uniqueness: true
    validates :long_url, presence: true, uniqueness: true
    validates :user_id, presence: true
    
  belongs_to :submitter,
   class_name: 'User', 
   primary_key: :id, 
   foreign_key: :user_id 
     
   has_many :visits, 
    class_name: 'Visit', 
    primary_key: :id, 
    foreign_key: :short_url_id
    
  has_many :visitors,
    through: :visits,
    source: :visitor
     
  def self.random_code
    url = SecureRandom.urlsafe_base64(16)
    while ShortenedUrl.exists?(short_url: url)
      url = SecureRandom.urlsafe_base64(16)
    end
    url
  end
  
  def self.create_short_url(user, long_url)
    idx =  long_url =~ (/.com/)
    short_url_first = long_url[0..idx + 4]
    short_url = short_url_first + self.random_code
    ShortenedUrl.create!(
      short_url: short_url,
      long_url: long_url, 
      user_id: user.id
    )
  end
    
  def num_clicks
    self.visits.count
  end
  
  def num_uniques
    #self.visitors.uniq.count
    self.visits.select(:visitor_id).distinct.count
  end
  
  def num_recent_uniques
    recents = self.visitors.uniq.select do |click|
      click.updated_at.to_date == DateTime.now.to_date
    end
    recents.count
  end
end

