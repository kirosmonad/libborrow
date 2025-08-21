require 'rails_helper'

RSpec.describe BookPolicy, type: :policy do
  let(:book) { FactoryBot.create(:book) }
  
  context "when regular user" do
    let(:user) { FactoryBot.create(:user) }
    subject { described_class.new(user, book) }  

    it "permit actions" do
      expect(subject.index?).to be true
      expect(subject.show?).to be true
      expect(subject.create?).to be false
      expect(subject.update?).to be false
      expect(subject.destroy?).to be false
    end
  end
  
  context "when librarian user" do
    let(:user) { FactoryBot.create(:user, :librarian) }
    subject { described_class.new(user, book) }  

    it "permit actions" do
      expect(subject.index?).to be true
      expect(subject.show?).to be true
      expect(subject.create?).to be true 
      expect(subject.update?).to be true
      expect(subject.destroy?).to be true
    end
  end
end
