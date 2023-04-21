require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.build(:user) }
  let(:post) { FactoryBot.build(:post, user: user) }













  # Use build when you can. This saves on DB writes
  # .create saves records in the database while .build does not
  context 'can use build' do
    it 'does something' do
      expect(user.do_something).to be_truthy
    end
  end

  context 'cannot use build' do
    let(:user) { FactoryBot.create(:user) }

    it 'creates posts for users' do
      expect {
        user.posts.create!
      }.to change { user.posts.count }.from(0).to(1)
    end
  end










  # Use describe when testing specific methods
  # Bad
  it 'does something' do
    expect(user.do_something).to be_truthy
  end

  # Good
  describe '#do_something' do
    it 'does something' do
      expect(user.do_something).to be_truthy
    end
  end








  describe "#do_something" do
    # Bad
    it 'does something wrong' do
      test_user = User.create(username: 'username')
      expect(test_user.do_something).to be_truthy
    end

    # Good
    let(:test_user) { FactoryBot.build(:user) }
    it 'does something right' do
      expect(test_user.do_something).to be_truthy
    end
  end







  # Use context to set expectations
  describe '#can_delete_other_users_posts' do
    # Bad
    it 'allows admin users to delete other users posts' do
      user.update!(is_admin: true)
      expect(user.can_delete_other_users_posts).to be_truthy
    end

    it 'does not allow non-admin users to delete other users posts' do
      user.update!(is_admin: false)
      expect(user.can_delete_other_users_posts).to be_falsey
    end


    # Good
    context 'when user is admin' do
      before do
        user.update!(is_admin: true)
      end

      it 'allows admin users to delete other users posts' do
        expect(user.can_delete_other_users_posts).to be_truthy
      end
    end

    context 'when user is not admin' do
      before do
        user.update!(is_admin: false)
      end

      it 'does not allow non-admin users to delete other users posts' do
        expect(user.can_delete_other_users_posts).to be_falsey
      end
    end
  end











  # If you have several tests related to the same test, it is a good idea to use subject
  describe '#do something' do
    subject(:call) { user.do_something }

    it 'does something' do
      expect(call).to be_truthy
    end

    it 'does something again' do
      expect(call).to be_truthy
    end

    it 'does something a third time' do
      expect(call).to be_truthy
    end
  end











  # Use expect / change code blocks over expressions
  describe '#create_post' do
    let(:user) { FactoryBot.create(:user) }
    # Bad
    it 'creates new post' do
      expect(Post.count).to eq(0)
      user.create_post
      expect(Post.count).to eq(1)
    end

    # Good
    it 'creates new post' do
      expect {
        user.create_post
      }.to change(Post, :count).from(0).to(1)
    end
  end









  # User described_class over class names
  describe '.create' do # Note: denote class methods with ".". Denote instance methods with "#".
    # Bad
    it 'creates a user' do
      expect {
        User.create!(username: 'username')
      }.to change(User, :count).from(0).to(1)
    end

    # Good
    it 'creates a user' do
      expect {
        described_class.create!(username: 'username')
      }.to change(User, :count).from(0).to(1)
    end
  end













  # Test one thing at a time
  describe '.create' do
    # Bad
    it 'sets admin to false' do
      user = described_class.create!(is_admin: true, username: 'username')
      expect(user.is_admin).to be_truthy
      expect(User.count).to eq(1)
    end

    # Good
    it 'creates a user' do
      expect {
        described_class.create!(username: 'username')
      }.to change(User, :count).from(0).to(1)
    end

    it 'creates an admin user' do
      user = described_class.create!(is_admin: true, username: 'username')
      expect(user.is_admin).to be_truthy
    end
  end











  # Don't overuse let!.
  describe '.create' do
    # Bad
    let!(:admin_user) { FactoryBot.build(:user, is_admin: true) }
    let!(:normie_user) { FactoryBot.build(:user, is_admin: false) }

    it 'returns true for admin user is admin' do
      expect(admin_user.is_admin).to be_truthy
    end

    it 'returns false for normal user is admin' do
      expect(normie_user.is_admin).to be_falsey
    end

    # Good
    let(:admin_user) { FactoryBot.build(:user, is_admin: true) }
    let(:normie_user) { FactoryBot.build(:user, is_admin: false) }

    it 'returns true for admin user is admin' do
      expect(admin_user.is_admin).to be_truthy
    end

    it 'returns false for normal user is admin' do
      expect(normie_user.is_admin).to be_falsey
    end
  end











  # Before blocks may not be necessary
  context 'associations' do
    let(:test_user) { FactoryBot.create(:user) }
    let(:test_post) { FactoryBot.create(:post, user: test_user) }

    # Bad
    context 'Unnecessary instantiation calls' do
      before do
        test_user
        test_post
      end

      it "calls user's post" do
        expect(test_user.posts.count).to eq(1)
      end
    end

    # Bad
    context 'Proper instantiation calls' do
      before do
        test_post # This will instantiate test_user
      end

      it "calls user's post" do
        expect(test_user.posts.count).to eq(1)
      end
    end
  end













  # Don't include multiple models / services / jobs functionality in one test
  # It's best to use stubbing and testing models individually
  # However, it is possible to overuse mocks. Make sure whatever your mocking does have adequate tests in the applicable model / service / job
  describe '#has_important_posts?' do
    # Bad
    context 'when important posts exist' do
      let(:user) { FactoryBot.create(:user) }

      before do
        user.posts.create!(is_important: true)
      end

      it 'shows there are important posts' do
        expect(user.important_posts_exist).to be_truthy
      end
    end

    context 'when important posts do not exist' do
      before do
        Post.where(is_important: true).destroy_all
      end

      it 'shows there are not important posts ' do
        expect(user.important_posts_exist).to be_falsey
      end
    end

    # Good
    context 'when important posts exist' do
      before do
        allow(Post).to receive(:are_there_important_posts?).and_return(true)
      end

      it 'shows there are important posts' do
        expect(user.important_posts_exist).to be_truthy
      end
    end

    context 'when important posts do not exist' do
      before do
        allow(Post).to receive(:are_there_important_posts?).and_return(false)
      end

      it 'shows there are not important posts' do
        expect(user.important_posts_exist).to be_falsey
      end
    end
  end









  # Include error message when expecting error
  describe '#validate_username' do
    # Bad
    it 'does not allow username to be bad_man' do
      expect {
        described_class.create!(username: 'bad_man')
      }.to raise_error
    end

    # Bad
    it 'does not allow username to be bad_man' do
      expect {
        described_class.create!(username: 'bad_man')
      }.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Username Invalid username')
    end
  end
end





