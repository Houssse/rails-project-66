# frozen_string_literal: true

class AuthControllerTest < ActionDispatch::IntegrationTest
  test 'check github auth' do
    post auth_request_path('github')

    assert_response :redirect
  end

  test 'create' do
    auth_hash = {
      provider: 'github',
      uid: '12345',
      info: {
        email: Faker::Internet.email,
        name: Faker::Name.first_name,
        nickname: Faker::Internet.username,
        image: Faker::Avatar.image
      },
      credentials: {
        token: 'fake-oauth-token'
      }
    }

    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash::InfoHash.new(auth_hash)

    get callback_auth_url('github')

    assert_response :redirect

    user = User.find_by(email: auth_hash[:info][:email].downcase)

    assert user

    assert_predicate self, :signed_in?
  end

  test 'logout check' do
    user = users(:one)
    sign_in(user)

    delete logout_path

    assert_nil session[:user_id]
    assert_redirected_to root_path
  end
end
