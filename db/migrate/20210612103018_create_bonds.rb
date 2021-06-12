class CreateBonds < ActiveRecord::Migration[6.1]
  def change
    create_table :bonds do |t|
      t.bigint :user_id
      t.bigint :friend_id
      t.string :state

      t.timestamps
    end

    add_index :bonds, %i[user_id friend_id], unique: true
    add_foreign_key :bonds, # from table
                    :users, # to table
                    column: :user_id # in bounds
    add_foreign_key :bonds, :users, column: :friend_id
  end
end
