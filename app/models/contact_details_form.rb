class ContactDetailsForm
  include ActiveModel::Model

  attr_reader :full_name, :telephone_number

  validates :full_name, presence: true, length: { minimum: 2 }
  validates :telephone_number, presence: true

  def initialize(hash = {})
    @full_name = hash[:full_name]
    @telephone_number = hash[:telephone_number]
  end
end
