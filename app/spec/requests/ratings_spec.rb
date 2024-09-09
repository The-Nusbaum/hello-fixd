require 'swagger_helper'

RSpec.describe 'ratings', type: :request do
  before :each do
    @rating = FactoryBot.create(:rating, rating: 3)
    @user = @rating.user
    @rater = @rating.rater

    @token_u = SecureRandom.hex
    @user.api_keys.create! token: @token_u

    @token_r = SecureRandom.hex
    @rater.api_keys.create! token: @token_r

    @rating_count = Rating.all.count
  end

  # this spec fails, based on all the docs it should work as far as I can tell. 
  # there seems to be a number of issues with rswag specs not sending post data
  # but there is very little documentation on it, also rswag does not appear to 
  # support OpenApi 3.0 requestBody?
  path '/ratings' do
    # parameter name: :Authorization, :in => :header, :type => :string
   
    post('create rating') do
      produces 'application/json'
      security [bearer: []]

      parameter name: 'rating[user_id]', in: :query, type: :number, description: 'Title'
      parameter name: 'rating[rating]', in: :query, type: :string, description: 'Body'

      response(201, 'successful') do
        let(:Authorization) { "Bearer #{@token_u}" }
        let('rating[user_id]') { @user.id }
        let('rating[rating]') { 5 }

        schema '$ref' => '#/definitions/rating'
        run_test! do
          expect(Rating.all.count).to be > @rating_count
        end
      end
    end
  end

  path '/ratings/{id}' do
    # parameter name: :Authorization, :in => :header, :type => :string
    parameter name: 'id', in: :path, type: :string, description: 'id'
  
    get('show rating') do
      security [bearer: []]
      
      response(200, 'successful') do            
        let(:Authorization) { "Bearer #{@token_r}" }
        let(:id) { @rating.id }
        schema '$ref' => '#/definitions/rating'
        run_test! 
      end
    end

    patch('update rating') do
      security [bearer: []]
      parameter name: 'rating[rating]', in: :query, type: :string, description: 'rating'
      
      response(200, 'successful') do            
        let(:Authorization) { "Bearer #{@token_r}" }
        let(:id) { @rating.id }
        let('rating[rating]') { 5 }
        schema '$ref' => '#/definitions/rating'
        run_test! do
          expect(@rating.reload.rating).to eq 5
        end
      end

      response(403, 'forbidden when different user') do             
        let(:Authorization) { "Bearer #{@token_u}" }
        let(:id) { @rating.id }
        let('rating[rating]') { 5 }
        
        run_test! do
          expect(@rating.reload.rating).to eq 3
        end
      end
    end

    delete('delete rating') do
      security [bearer: []]
      response(204, 'no content') do             
        let(:Authorization) { "Bearer #{@token_r}" }
        let(:id) { @rating.id }
                
        run_test! do
          expect(Rating.all.count).to be < @rating_count
        end
      end

      response(403, 'not authorized when different user') do             
        let(:Authorization) { "Bearer #{@token_u}" }
        let(:id) { @rating.id }
                
        run_test! do
          expect(Rating.all.count).to eq @rating_count
        end
      end
    end
  end
end
