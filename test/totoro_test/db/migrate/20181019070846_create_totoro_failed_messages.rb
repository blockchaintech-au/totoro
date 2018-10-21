class CreateTotoroFailedMessages < ActiveRecord::Migration[5.1]
  def change
    enable_extension 'plpgsql'
    create_table :totoro_failed_messages do |t|
      t.string :class_name
      t.string :queue_id
      t.jsonb :payload
      t.timestamps
    end
  end
end
