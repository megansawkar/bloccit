class AddCommentableToComments < ActiveRecord::Migration
  def change
    change_table(:comments) do |t|
      t.belongs_to :commentable, polymorphic: true
    end 
  end
end
