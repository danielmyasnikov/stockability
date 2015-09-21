require 'rails_helper'

RSpec.describe 'Token management', type: :request do

  describe '.create' do
    it 'creates a token when the user successfully authenticated' do
      client = FactoryGirl.create(:admin, :company_admin)
      post '/api/v1/tokens', client: { login: client.login, password: client.password }
      expect(json['client']['token']).to eq(client.token)
    end

    context 'when the user authentication fails' do
      context 'wrong email provided' do
        it 'fails with the correct message' do
          post '/api/v1/tokens', client: { login: '', password: '' }
          expect(json['text']).to eq('Wrong Email or Login')
        end
      end

      context 'wrong login provided' do
        it 'fails with the correct message' do
          post '/api/v1/tokens', client: { login: '', password: '' }
          expect(json['text']).to eq('Wrong Email or Login')
        end
      end

      context 'wrong password provided' do
        it 'fails with the correct message' do
          company_admin = FactoryGirl.create(:admin, :company_admin)
          post '/api/v1/tokens', client: { login: company_admin.login, password: 'mySuperWrongPassword' }
          expect(json['text']).to eq('Wrong Password')
        end
      end
    end
  end
end
