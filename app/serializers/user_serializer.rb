class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :gravatar_url, :created_at, :updated_at
end
