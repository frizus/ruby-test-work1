class CreateApprovals < ActiveRecord::Migration[5.0]
  def change
    create_table :approvals do |t|
      t.string :type
      t.references :created_by, foreign_key: {to_table: :users}
      t.date :period_from
      t.date :period_to
      t.text :comment
      t.string :status

      t.timestamps
    end
  end
end
