class Signup
  include ActiveModel::Conversion,
    ActiveModel::Validations, Virtus.model
  extend ActiveModel::Naming

  FIELDS = {
    account: {
      name: :account_name
    },
    user: {
      email: :email,
      password: :password
    }
  }.freeze

  attribute :account_name, String
  attribute :email, String
  attribute :password, String

  def initialize(*args)
    super
    @check_password = true
  end

  def persisted?
    false
  end

  def save
    if valid?
      begin
        persist!
        true
      rescue ActiveRecord::RecordInvalid
        delegate_errors
        false
      end
    else
      false
    end
  end

  def account
    @account ||= Account.new
  end

  def user
    existing_user || new_user
  end

  def user=(signed_in_user)
    @check_password = false
    @existing_user  = signed_in_user
  end

  def valid?
    errors.clear
    validate
    errors.empty?
  end

  private

  def new_user
    @new_user ||= User.new
  end

  def existing_user
    @existing_user ||= User.find_by_email(email)
  end

  def membership
    @membership ||= Membership.new(
      user: user,
      account: account
    )
  end

  def delegate_and_populate
    delegate_attributes_for(:account)
    populate_additional_account_fields

    if !existing_user
      delegate_attributes_for(:user)
      populate_additional_user_fields
    end
  end

  def populate_additional_account_fields
    account.name = account_name.blank? ? short_name : account_name
  end

  def populate_additional_user_fields
    user.name ||= short_name
  end

  def delegate_attributes_for(model_name)
    FIELDS[model_name].each do |target, source|
      send(model_name).send(:"#{target}=", send(source))
    end
  end

  def delegate_errors_for(model_name)
    fields = FIELDS[model_name]
    send(model_name).errors.each do |field, message|
      errors.add(fields[field], message) if fields[field]
    end
  end

  def validate
    delegate_and_populate
    account.valid?
    delegate_errors_for(:account)
    if existing_user
      validate_existing_user
    else
      validate_new_user
    end
  end

  def validate_new_user
    new_user.valid?
    delegate_errors_for(:user)
  end

  def validate_existing_user
    if @check_password && !existing_user.authenticated?(password)
      errors.add(:password, "is incorrect")
    end
  end

  def delegate_errors
    delegate_errors_for(:account)
    delegate_errors_for(:user)
  end

  def persist!
    Account.transaction do
      account.save!
      user.save!
      membership.save!
    end
  end

  def short_name
    if email.present?
      email.split(/@/).first.parameterize
    elsif user && user.email.present?
      existing_user.email.split(/@/).first.parameterize
    end
  end
end
