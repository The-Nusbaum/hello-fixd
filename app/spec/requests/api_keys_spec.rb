require 'swagger_helper'

RSpec.describe 'api_keys', type: :request do

  path '/api-keys' do
    post('create api_key') do
      produces 'application/json'
      security [basic: []]
      
      response(201, 'with credentials, successful') do
        before do
          @user = FactoryBot::build(:user, password: 'foo'); 
          @user.save
        end
        let(:Authorization) { "Basic #{::Base64.strict_encode64("#{@user.email}:foo")}"}
        schema '$ref' => '#/definitions/api_key'
        run_test!
      end

      response(401, 'without credentials, unsuccessful') do
        let(:Authorization) { "Bearer foo" }
        run_test! 
      end
    end
  end

  path '/api-keys/{id}' do
    parameter name: :id, in: :path, type: :string
    # parameter name: :Authorization, :in => :header, :type => :string
    delete('delete api_key') do
      security [bearer: []]
      

      response(204, 'successful') do
        before do
          @user = FactoryBot::build(:user, password: 'foo'); 
          @user.save
          @token = SecureRandom.hex 
          @user.api_keys.create! token: @token
          @api_key_count = ApiKey.all.size
        end

        let(:Authorization) { "Bearer #{@token}"}
        let(:id) { @user.api_keys.last.id }

        run_test! do
          expect(ApiKey.all.count).to be < @api_key_count
        end
      end
    end
  end
end
