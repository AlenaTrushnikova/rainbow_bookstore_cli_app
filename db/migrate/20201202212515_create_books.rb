class CreateBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :books do |t|
      t.string :title
      t.string :category
      t.string :author
      t.float :price
      t.string :language
    end
  end
end
