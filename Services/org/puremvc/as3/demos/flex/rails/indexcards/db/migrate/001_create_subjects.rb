class CreateSubjects < ActiveRecord::Migration
  def self.up
    create_table :subjects do |t|
    end
  end

  def self.down
    drop_table :subjects
  end
end
