class ApplicationSerializer < ActiveModel::Serializer
  def is_admin?
    current_user.admin?
  end
end
