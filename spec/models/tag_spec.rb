require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(Tag.new(name: 'example')).to be_valid
    end

    it 'is not valid without a name' do
      tag = Tag.new(name: nil)
      expect(tag).not_to be_valid
    end
  end
end
