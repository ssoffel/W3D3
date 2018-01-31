class Visit < ApplicationRecord 
  validates :visitor_id, presence: true         
  validates :short_url_id, presence: true  
  
  belongs_to :visitor, 
    class_name: 'User',
    primary_key: :id, 
    foreign_key: :visitor_id
    
  belongs_to :url, 
    class_name: 'ShortenedUrl',
    primary_key: :id, 
    foreign_key: :short_url_id
    
  def self.record_visit(user, shortened_url)
    Visit.create!(
      visitor_id: user.id,
      short_url_id: shortened_url.id
    )
  end
end 