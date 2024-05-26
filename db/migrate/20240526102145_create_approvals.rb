class CreateApprovals < ActiveRecord::Migration[5.0]
  def change
    create_table :approvals do |t|
      t.string :type
      t.references :created_by, foreign_key: {to_table: :users}
      t.datetime :period_from
      t.datetime :period_to
      t.text :comment
      t.string :status
      t.references :status_last_change_by, foreign_key: {to_table: :users}
      t.datetime :status_last_changed_at
      t.text :status_comment

      t.timestamps
    end
  end
end
