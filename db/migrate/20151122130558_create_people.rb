class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.date :hired_on, null: false
      t.text :bio
      t.belongs_to :account, index: true, null: false
      t.timestamps null: false
    end
  end
end
