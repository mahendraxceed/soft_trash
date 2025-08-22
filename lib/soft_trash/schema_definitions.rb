module SoftTrash
  module SchemaDefinitions
    def soft_trash
      column :deleted_at, :datetime, default: nil
      index :deleted_at
    end
  end
end
