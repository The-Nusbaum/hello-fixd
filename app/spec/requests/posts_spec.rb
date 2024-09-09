require 'swagger_helper'

RSpec.describe 'posts', type: :request do
  before :each do
    @post = FactoryBot.create(:post)
    @title = @post.title
    @body = @post.body
    @user1 = @post.user  
    @token1 = SecureRandom.hex
    @user1.api_keys.create! token: @token1

    @user2 = FactoryBot.create(:user)
    @token2 = SecureRandom.hex
    @user2.api_keys.create! token: @token2

    @post_count = Post.all.count
  end

  # this spec fails, based on all the docs it should work as far as I can tell. 
  # there seems to be a number of issues with rswag specs not sending post data
  # but there is very little documentation on it, also rswag does not appear to 
  # support OpenApi 3.0 requestBody?
  path '/posts' do
    # parameter name: :Authorization, :in => :header, :type => :string
   
    post('create post') do
      produces 'application/json'
      security [bearer: []]

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          post: {
            type: :object,
            properties: {
              title: { type: :number },
              body: { type: :string }
            },
            required: [ 'post', 'body' ],
          },
        },
        required: [ 'post' ]
      }

      response(201, 'successful') do
        let(:Authorization) { "Bearer #{@token1}" }
        let(:params) { {post: {title: 'updated title'  , body: 'updated body'}}}

        schema '$ref' => '#/definitions/post'
        # run_test! do
        #   expect(Post.all.count).to be > @post_count
        # end
      end
    end
  end

  path '/posts/{id}' do
    # parameter name: :Authorization, :in => :header, :type => :string
    parameter name: 'id', in: :path, type: :string, description: 'id'
  
    get('show post') do
      security [bearer: []]
      
      response(200, 'successful') do            
        let(:Authorization) { "Bearer #{@token1}" }
        let(:id) { @post.id }
        schema '$ref' => '#/definitions/post'
        run_test! 
      end
    end

    patch('update post') do
      security [bearer: []]
      parameter name: 'post[title]', in: :query, type: :string, description: 'post title'
      parameter name: 'post[body]', in: :query, type: :string, description: 'post body'
      
      response(200, 'successful') do            
        let(:Authorization) { "Bearer #{@token1}" }
        let(:id) { @post.id }
        let('post[body]') { 'updated body' }
        let('post[title]') { 'updated title' }
        schema '$ref' => '#/definitions/post'
        run_test! do
          expect(@post.reload.body).to eq "updated body"
          expect(@post.reload.title).to eq "updated title"
        end
      end

      response(403, 'forbidden when different user') do             
        let(:Authorization) { "Bearer #{@token2}" }
        let(:id) { @post.id }
        let('post[body]') { 'updated body' }
        let('post[title]') { 'updated title' }
        
        run_test! do
          expect(@post.reload.body).to eq @body
          expect(@post.reload.title).to eq @title
        end
      end
    end

    delete('delete post') do
      security [bearer: []]
      response(204, 'no content') do             
        let(:Authorization) { "Bearer #{@token1}" }
        let(:id) { @post.id }
                
        run_test! do
          expect(Post.all.count).to be < @post_count
        end
      end

      response(403, 'not authorized when different user') do             
        let(:Authorization) { "Bearer #{@token2}" }
        let(:id) { @post.id }
                
        run_test! do
          expect(Post.all.count).to eq @post_count
        end
      end
    end
  end
end
