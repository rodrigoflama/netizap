class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.text :text
      t.string :result
      t.string :protocol
      t.string :response
      t.string :recipient
      t.string :sender
      t.string :url
      t.string :token
      t.string :appname

      t.timestamps
    end
  end
end
