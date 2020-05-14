class DowngradeUser
  include DomainDefinition

  def initialize(user, downgrade)
    @user = user
    @downgrade = downgrade
  end

  def call
    Rails.logger.info('USER')
    Rails.logger.info(@user.id)
    expires_at = 24.hours.from_now
    {
      auth_token: {
        token: JsonWebToken.encode(user_id: @user.id, exp: expires_at),
        ttl: expires_at.to_i
      },
      user: UserSerializer.new(@user, scope: Ability.new(@user, @downgrade))
    }
  end
end

