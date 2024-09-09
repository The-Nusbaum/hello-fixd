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

  path '/comments' do
   
    post('create comment') do
      produces 'application/json'
      security [bearer: []]

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          comment: {
            type: :object,
            properties: {
              post_id: { type: :number },
              message: { type: :string }
            },
            required: [ 'post_id', 'message' ],
          },
        },
        required: [ 'comment' ]
      }

      response(201, 'successful') do
        let(:Authorization) { "Bearer #{@token1}" }
        let(:params) { {comment: {post_id: @post.id  , message: 'foo'}}}

        schema '$ref' => '#/definitions/comment'
        # run_test! do
        #   expect(Comment.all.count).to be > @comment_count
        # end
      end
    end
  end

  path '/comments/{id}' do
    # parameter name: :Authorization, :in => :header, :type => :string
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
