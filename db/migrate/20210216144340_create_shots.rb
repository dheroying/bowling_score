class CreateShots < ActiveRecord::Migration[5.0]
  def change
    create_table :shots do |t|
      t.references :game, foreign_key: true
      t.integer :number, default: 0
      t.integer :frame, default: 0
      t.integer :player, default: 0
      t.integer :pins

      t.timestamps
    end
  end
end
