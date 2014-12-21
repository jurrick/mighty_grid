class UsersGrid < MightyGrid::Base
  scope { User }

  filter :name
  filter :role, :enum, collection: [:user, :publisher, :moderator, :admin].map { |r| [r.capitalize, r] }
  filter :is_banned, :boolean
end
