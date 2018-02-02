class AddSprintPlanning < ActiveRecord::Migration[5.1]
  def change
    create_table :sprint_plannings do |t|
      t.boolean :planned, default: false
      t.references :project, foreign_key: {on_delete: :cascade}
      t.references :sprint, foreign_key: {on_delete: :nullify}
      t.index([:sprint_id, :project_id], unique: true)
    end
  end
end
