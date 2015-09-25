class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name ,:limit => 2
      t.string :email
      t.string :name

      t.timestamps null: false
    end
  end
end
