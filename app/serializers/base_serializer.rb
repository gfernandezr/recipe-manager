class BaseSerializer < ActiveModel::Serializer
  # Define common methods and attributes here
  def created_at
    object.created_at.iso8601 if object.created_at
  end
  
  def updated_at
    object.updated_at.iso8601 if object.updated_at
  end
end
