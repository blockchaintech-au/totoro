class UpdateTotoroFailedMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :totoro_failed_messages, :group, :string
    Totoro::TotoroFailedMessage.all.update(group: 'enqueue')
  end
end
