require 'rails_helper'

RSpec.describe ReadingList, type: :model do
  describe 'validations' do
    it 'requires a title' do
      reading_list = ReadingList.new(title: nil)
      expect(reading_list.valid?).to be(false)
      expect(reading_list.errors[:title]).to include("can't be blank")
    end

    it 'validates presence of title' do
      reading_list = ReadingList.new(title: 'Example Reading List')
      expect(reading_list.valid?).to be(true)
    end
  end
end
