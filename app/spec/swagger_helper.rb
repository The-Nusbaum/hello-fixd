# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.openapi_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under openapi_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a openapi_spec tag to the
  # the root example_group in your specs, e.g. describe '...', openapi_spec: 'v2/swagger.json'
  config.openapi_specs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'API V1',
        version: 'v1'
      },
      paths: {},
      servers: [
        {
          url: 'http://{defaultHost}',
          variables: {
            defaultHost: {
              default: 'localhost:3000'
            }
          }
        }
      ],
      components: {
        securitySchemes: {
          basic: {
            description: "Use with POST /api-keys to fetch a token",
            type: :http,
            scheme: :basic
          },
          bearer: {
            description: 'token from POST /api-keys',
            type: :http,
            scheme: :bearer
          }
        }
      },
      api_key: {
        type: :object,
        properties: {
          id: {type: :number},
          user_id: {type: :number},
          token_digest: {type: :string},
          created_at: {type: :string},
          updated_at: {type: :string},
          token: {type: :string}
        }
      },
      api_key_collection: {
        type: :array,
        items: {
          type: :api_key
        }
      },
      feed_event: {
        type: :object,
        properties: {
          id: {type: :number},
          event_type: {type: :string},
          title: {type: :string},
          body: {type: :string},
          comment_count: {type: :number},
          link: {type: :string},
          date: {type: :string},
        }
      },
      feed: {
        type: :object,
        properties: {
          user: {type: :string},
          feed_events: {
            type: :array,
            items: {
              type: :feed_event
            }
          },
          page: {type: :number},
          total_records: {type: :number},
          last_page: {type: :boolean}
        }
      },
      comment: {
        type: :object,
        properties: {
          id: {type: :number},
          post_id: {type: :number},
          user_id: {type: :number},
          message: {type: :string},
          commented_at: {type: :string},
          created_at: {type: :string},
          updated_at: {type: :string},
        }
      },
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The openapi_specs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.openapi_format = :yaml
end
