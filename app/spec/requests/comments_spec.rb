require 'swagger_helper'

RSpec.describe 'comments', type: :request do

  before :each do
    @comment = FactoryBot.create(:comment)
    @message = @comment.message
    @user1 = @comment.user
    @user2 = @comment.post.user

    @post = @comment.post

    @token1 = SecureRandom.hex
    @user1.api_keys.create! token: @token1

    @token2 = SecureRandom.hex
    @user2.api_keys.create! token: @token2

    @comment_count = Comment.all.count
  end

  # this spec fails, based on all the docs it should work as far as I can tell. 
  # there seems to be a number of issues with rswag specs not sending post data
  # but there is very little documentation on it, also rswag does not appear to 
  # support OpenApi 3.0 requestBody?
  path '/comments' do
   
    post('create comment') do
      produces 'application/json'
      security [bearer: []]

      parameter name: 'comment[message]', in: :query, type: :string, description: 'message'
      parameter name: 'comment[post_id]', in: :query, type: :number, description: 'post_id'
  
      response(201, 'successful') do
        let(:Authorization) { "Bearer #{@token1}" }
        let(:params) { {comment: {post_id: @post.id  , message: 'foo'}}}
        let('comment[message]') { 'message' }
        let('comment[post_id]') { @post.id }

        schema '$ref' => '#/definitions/comment'
        run_test! do
          expect(Comment.all.count).to be > @comment_count
        end
      end
    end
  end

  path '/comments/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'id'
  
    get('show comment') do
      security [bearer: []]
      
      response(200, 'successful') do
        before do
          @comment = FactoryBot.create(:comment, post: @post, user: @user2)
        end
              
        let(:Authorization) { "Bearer #{@token1}" }
        let(:id) { @comment.id }
        schema '$ref' => '#/definitions/comment'
        run_test! 
      end
    end

    patch('update comment') do
      security [bearer: []]
      parameter name: 'comment[message]', in: :query, type: :string, description: 'message'
      
      response(200, 'successful') do            
        let(:Authorization) { "Bearer #{@token1}" }
        let(:id) { @comment.id }
        let('comment[message]') { 'changed' }
        schema '$ref' => '#/definitions/comment'
        run_test! do
          expect(@comment.reload.message).to eq('changed')
        end
      end

      response(403, 'forbidden when different user') do            
        let(:Authorization) { "Bearer #{@token2}" }
        let(:id) { @comment.id }
        let('comment[message]') { 'changed' }
        
        run_test! do
          expect(@comment.reload.message).to eq @message
        end
      end
    end

    delete('delete comment') do
      security [bearer: []]
      
      response(204, 'no content') do              
        let(:Authorization) { "Bearer #{@token1}" }
        let(:id) { @comment.id }
                
        run_test! do
          expect(Comment.all.count).to be < @comment_count
        end
      end

      response(403, 'not authorized when different user') do              
        let(:Authorization) { "Bearer #{@token2}" }
        let(:id) { @comment.id }
                
        run_test! do
          expect(Comment.all.count).to eq @comment_count
        end
      end
    end
  end
end
