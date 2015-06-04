class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string :name,  null: false    # ユーザー名
      t.string :email, null: false    # メールアドレス
      t.boolean :administrator, null: false, default: false # 管理者フラグ
      t.timestamps
    end
  end
end
