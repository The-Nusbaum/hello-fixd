require 'swagger_helper'

RSpec.describe 'feeds', type: :request do

  before :each do
    @user1 = FactoryBot::build(:user, password: 'foo', github_username: 'torvalds'); 
    @user1.save
    2.times do 
      FactoryBot::build(:post, user: @user); 
    end
    
    @user2 = FactoryBot::build(:user, password: 'foo');
    @user2.save
    @token = SecureRandom.hex 
    @user2.api_keys.create! token: @token
  end

  path '/' do
    parameter name: :page, in: :query, type: :number, description: 'Page. defaults to 1'
    parameter name: :per, in: :query, type: :number, description: 'Per Page. defaults to 15'
    get('current user feed') do
      produces 'application/json'
      security [bearer: []]
      
      response(200, 'with credentials, successful') do
        let(:Authorization) { "Bearer #{@token}"}
        let(:page) { 1 }
        let(:per) { 15 }
        
        schema '$ref' => '#/definitions/feed'
        run_test!
      end
    end
  end

  path '/feed/{user_id}' do      
    get('specified user feed') do
      parameter name: :page, in: :query, type: :number, description: 'Page. defaults to 1'
      parameter name: :per, in: :query, type: :number, description: 'Per Page. defaults to 15'
      let(:page) { 1 }
      let(:per) { 15 }
      produces 'application/json'
      parameter name: :user_id, in: :path, type: :string
      security [bearer: []]

      response(200, 'with credentials, successful') do

        let(:Authorization) { "Bearer #{@token}" }
        let(:user_id) { @user1.id }

        schema '$ref' => '#/definitions/feed'
        
        run_test!
      end

      response(401, 'without credentials, unsuccessful') do
        let(:Authorization) { "Bearer foo" }
        let(:user_id) { @user1.id }
        
        run_test! 
      end
    end
  end
end
