class UpdateTotoroFailedMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :totoro_failed_messages, :group, :string
  end
end
