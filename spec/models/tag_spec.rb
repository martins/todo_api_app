require 'rails_helper'

describe Tag do
  describe 'validations' do
    describe 'title uniqueness' do
      it 'is valid when title is unique' do
        instance = described_class.new(title: 'Foobar')
        expect(instance).to be_valid
      end

      it 'is not valid when title is not unique' do
        described_class.create!(title: 'Foobar')

        instance = described_class.new(title: 'Foobar')
        expect(instance).not_to be_valid
        expect(instance.errors).to be_added(:title, :taken)
      end
    end
  end
end
