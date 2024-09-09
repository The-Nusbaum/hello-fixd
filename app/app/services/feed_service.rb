class FeedService
  def initialize(user_id: nil, per: 15, page: 1)
    @user_id = user_id
    @user = nil
    @user = User.find(@user_id) unless user_id.nil?
    @per = per
    @page = page - 1
    @events = []
  end

  def events
    _posts
    _comments
    _rating_threshold
    _github unless @user.github_username.blank?

    record_count = @events.size

    {
      user: @user.name,
      events: @events.sort{ |a, b| 
        b[:date] <=> a[:date]
      }.slice(@page, @per),
      page: @page + 1,
      total_records: record_count,
      last_page: @page * @per > record_count
    }  
  end

  def _posts
    posts = Post.includes(:comments)
    posts = posts.where user: @user unless @user.nil?
    @events += posts.order('posted_at desc')
      .offset(@page * @per + 1)
      .limit(@per)
      .map{ |post|
      _format_event(
        id: post.id,
        event_type: :post,
        date: post.posted_at,
        title: post.title,
        comment_count: post.comments.size,
        link: "/post/#{post.id}"
      )
    }
  end

  def _comments
    comments = Comment.includes(post: :user)
    comments = comments.where user: @user unless @user.nil?
    @events += comments.order('commented_at desc')
      .offset(@page * @per + 1)
      .limit(@per).map{|comment|
      _format_event(
        id: comment.id,
        event_type: :comment,
        date: comment.commented_at,
        title: "Commented on a post by #{comment.post.user.name}",
        link: "/post/#{comment.post.id}"
      )
    }
  end

  def _rating_threshold
    if @user.present?
      ratings = @user.ratings.order(:rated_at)
      average = ratings.pluck(:rating).sum.to_f / ratings.size

      if average >= 4
        running = 0
        ratings.each_with_index do |rating, index|
          running += rating.rating / (index+1)
          if running >= 4
            return _format_event(
              id: rating.id,
              event_type: :rating_threshold,
              date: rating.rated_at,
              title: "Passed 4 Stars!",
              link: "/ratings/#{@user_id}"
            )
          end
        end
      end
    end
  end

  def _github
    #TODO: cache this, perhaps offload it somewhere. potentially blocking
    response = ::HTTParty.get("https://api.github.com/users/#{@user.github_username}/events/public?per_page=100")

    return unless response.code == 200

    acceptable_types = %w[CreateEvent PullRequestEvent PushEvent]

    events = response.parsed_response.map do |event|
      link = event["repo"]["url"]
      body = event["repo"]["name"]

      case event["type"]
      when "CreateEvent"
        next unless event["payload"]["reftype"] == "repository"
        title = "Created a Repository"
      when "PushEvent"
        if event["payload"]["size"] > 1
          title = "Pushed #{event["payload"]["size"]} commits to"
        else
          title = "Pushed a commit to"
        end
      when "PullRequestEvent"
        link = event["payload"]["pull_request"]["link"]
        if event["payload"]["action"] == "closed" && event["payload"]["pull_request"]["merged"]
          title = "Merged \##{event["payload"]["number"]} into"
        elsif event["payload"]["action"] == "opened"
          title = "Opened a new Pull Request \##{event["payload"]["number"]} for"
        else
          next
        end    
      else
        next
      end

      @events << _format_event(
        id: event["id"],
        event_type: :github,
        title: title,
        body: body,
        link: link, 
        date: DateTime.iso8601(event["created_at"])
      )
    end
  end

  def _format_event(id:, event_type:, title:, body: nil, comment_count: nil, link: nil, date:)
    {
        id: id,
        event_type: event_type,
        title: title,
        body: body,
        comment_count: comment_count,
        link: link, 
        date: date
      }
  end
end