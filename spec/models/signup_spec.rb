require 'rails_helper'

describe Signup do
  it "complies with the activemodel api" do
    expect(subject.class).to be_kind_of(ActiveModel::Naming)
    expect(subject).not_to be_persisted
    expect(subject).to be_kind_of(ActiveModel::Conversion)
    expect(subject).to be_kind_of(ActiveModel::Validations)
  end

  context "with attributes in the constructor" do
    it "assigns attributes" do
      signup = Signup.new(
        account_name: 'account-name',
        email: 'person@example.com',
        password: 'password'
      )

      expect(signup.email).to  eq('person@example.com')
      expect(signup.password).to  eq('password')
      expect(signup.account_name).to  eq('account-name')
    end
  end

  context "with nil to the constructor" do
    it "assigns no attributes" do
      signup = Signup.new(nil)

      expect(signup.email).to  be_blank
      expect(signup.password).to  be_blank
      expect(signup.account_name).to  be_blank
    end
  end

  context "with a valid user and account" do
    it "saves the user" do
      email = "user@example.com"
      signup = build(:signup, email: email)

      expect(signup.save).to eq(true)
      expect(signup.user).to be_persisted
      expect(signup.account).to be_persisted
    end

    it "assigns the user to the account" do
      email = "user@example.com"
      signup = build(:signup, email: email)

      expect(signup.save).to eq(true)
      expect(signup.user.reload.accounts).to include(signup.account)
    end

    it "gives a friendly first name" do
      email = "user@example.com"
      signup = build(:signup, email: email)

      expect(signup.save).to eq(true)
      expect(signup.user.name).to eq('user')
    end

    it "gives a friendly account name" do
      email = "user@example.com"
      signup = build(:signup, email: email)

      expect(signup.save).to eq(true)
      expect(signup.account.name).to eq('user')
    end

    it "gives it's user a name that is the first part of it's email" do
      email = "user@example.com"
      signup = build(:signup, email: email)

      expect(signup.save).to eq(true)
      expect(signup.user.name).to eq('user')
    end
  end


  context "valid with an existing user and correct password" do
    it "doesn't create a user" do
      email = "user@example.com"
      password = "test"
      user = create(:user, email: email, password: password)
      signup = build(:signup, email: email)

      expect(signup.save).to eq(false)
      expect(User.count).to eq(1)
      expect(User.last).to eq(user)
    end
  end

  context "with an email with symbols in it" do
    it "gives a friendly account name" do
      signup = build(:signup, email: "user+extra@example.com")

      expect(signup.save).to eq(true)
      expect(signup.account.name).to eq("user-extra")
    end
  end

  context "valid with a signed in user" do
    it "doesn't create a user" do
      email = "user@example.com"
      user = create(:user)
      signup = build(:signup, email: email, password: "")

      expect(signup.save).to eq(false)
      expect(User.count).to eq(1)
      expect(User.last).to eq(user)
    end
  end

  context "with an invalid user" do
    before { @previous_user_count = User.count }

    it "returns false" do
      signup = build(:signup, email: nil)

      expect(signup.save).to eq(false)
    end

    it "doesn't create a user" do
      signup = build(:signup, email: nil)

      expect(signup.save).to eq(false)
      expect(User.count).to eq(@previous_user_count)
    end

    it "doesn't create an account" do
      signup = build(:signup, email: nil)

      expect(signup.save).to eq(false)
      expect(signup.account).to be_new_record
    end

    it "adds error messages" do
      signup = build(:signup, email: nil)

      expect(signup.save).to eq(false)
      expect(signup.errors[:email]).not_to be_empty
    end
  end

  context "valid with an existing user and incorrect password" do
    before { @previous_user_count = User.count }

    it "returns false" do
      email = "user@example.com"
      password = "test"
      create(:user, email: email, password: password)
      signup = build(:signup, email: email, password: 'wrong')

      expect(signup.save).to eq(false)
    end

    it "doesn't create a user" do
      email = "user@example.com"
      password = "test"
      create(:user, email: email, password: password)
      previous_user_count = User.count
      signup = build(:signup, email: email, password: 'wrong')

      expect(signup.save).to eq(false)
      expect(User.count).to eq(previous_user_count)
    end

    it "doesn't create an account" do
      email = "user@example.com"
      password = "test"
      create(:user, email: email, password: password)
      signup = build(:signup, email: email, password: 'wrong')

      expect(signup.save).to eq(false)
      expect(signup.account).to be_new_record
    end

    it "adds error messages" do
      email = "user@example.com"
      password = "test"
      create(:user, email: email, password: password)
      signup = build(:signup, email: email, password: 'wrong')

      expect(signup.save).to eq(false)
      expect(signup.errors.full_messages).to include('Password is incorrect')
    end
  end

  context "with an account that doesn't save" do
    it "doesn't raise the transaction and returns false" do
      signup = build(:signup)
      allow_any_instance_of(Account).to receive(:save!).and_raise(ActiveRecord::RecordInvalid.new(signup))

      expect(signup.save).to eq(false)
    end
  end
end
