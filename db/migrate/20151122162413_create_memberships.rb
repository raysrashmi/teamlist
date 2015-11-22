class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.belongs_to :user, null: false, index: true
      t.belongs_to :account, null: false, index: true
      t.timestamps null: false
    end
  end
end
