class CreateWidgets < ActiveRecord::Migration
  def change
    create_table :widgets do |t|
    	t.string :name, limit: 50
    	t.string :model, null: false
    	t.text :description
    	t.integer :wheels, null: false
    	t.integer :doors, limit: 2
    	t.decimal :price, precision: 6, scale: 2
    	t.decimal :cost, precision: 4, scale: 2, null: false
    	t.decimal :completion, precision: 3, scale: 3
    	t.float :rating
    	t.float :score, null: false
    	t.datetime :published_at
    	t.date :invented_on
    	t.time :startup_time
    	t.time :shutdown_time, null: false
    	t.boolean :enabled
    	t.binary :data
    end
  end
end
