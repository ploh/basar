module ControllerHelpers
  def mock_sign_in(role = :seller)
    user = User.new(email: "test@test.host", password: "secret", role: role)
    allow(request.env['warden']).to receive(:authenticate!).and_return(user)
    allow(controller).to receive(:current_user).and_return(user)
  end
end

RSpec.configure do |config|
  config.include Devise::TestHelpers, :type => :controller
  config.include ControllerHelpers, :type => :controller
end
