class SearchSqlBuilder

  def initialize(query, messageboard)
    @query = query
    @terms = SearchParser.new(query).parse

    @post_select = 'SELECT t.id'
    @post_from = 'FROM topics t'
    @post_where = ['t.messageboard_id = ?']
    @post_binds = [messageboard.id]

    @topic_select = 'SELECT t.id'
    @topic_from = 'FROM topics t'
    @topic_where = ['t.messageboard_id = ?']
    @topic_binds = [messageboard.id]

    @order_by = 'ORDER BY updated_at DESC'
  end

  def build
    build_by_user
    build_in_category
    build_text_search

    ['SELECT * FROM topics WHERE id IN (',
      @post_select, @post_from, 'WHERE', @post_where.join(' AND '),
      'UNION',
      @topic_select, @topic_from, 'WHERE', @topic_where.join(' AND '),
      ')', @order_by, 'LIMIT 50'
    ].join(' ')
  end

  def binds
    @post_binds.concat(@topic_binds)
  end

  private

  def is_quoted(term)
    term.count('"') == 2
  end

  def build_in_category
    search_categories = []

    if @terms['in']
      @terms['in'].each do |category_name|
        category = Category
          .where('lower(name) = ?', category_name.downcase).first
        if category
          search_categories << category.id
        end
      end

      if search_categories.present?
        category_from = 'topic_categories tc'
        if @post_from.exclude? category_from
          @post_from = "#{@post_from}, #{category_from}"
        end

        if @topic_from.exclude? category_from
          @topic_from = "#{@topic_from}, #{category_from}"
        end

        category_where = 'tc.category_id in (?)'
        category_join = 'tc.topic_id = t.id'
        if @post_where.exclude? category_where
          @post_where << category_where
          @post_binds.push(search_categories)
        end

        if @post_where.exclude? category_join
          @post_where << category_join
        end

        if @topic_where.exclude? category_where
          @topic_where << category_where
          @topic_binds.push(search_categories)
        end
        if @topic_where.exclude? category_join
          @topic_where << category_join
        end
      end
    end
  end

  def build_text_search
    if @terms['text'].present?
      search_text = @terms['text']
      post_from = 'posts p'
      if @post_from.exclude? post_from
        @post_from = "#{@post_from}, #{post_from}"
      end

      post_join = 't.id = p.topic_id'
      if @post_where.exclude? post_join
        @post_where << post_join
      end

      post_where = "to_tsvector('english', p.content) @@ plainto_tsquery('english', ?)"
      if @post_where.exclude? post_where
        @post_where << post_where
        @post_binds.push(search_text.uniq.join(' '))
      end

      topic_where = "to_tsvector('english', t.title) @@ plainto_tsquery('english', ?)"
      if @topic_where.exclude? topic_where
        @topic_where << topic_where
        @topic_binds.push(search_text.uniq.join(' '))
      end

      search_text.each do |term|
        if (is_quoted(term))
          post_where = 'p.content like ?'
          if @post_where.exclude? post_where
            @post_where << post_where
            @post_binds.push(term.gsub('"', '%'))
          end

          topic_where = 't.title like ?'
          if @topic_where.exclude? topic_where
            @topic_where << topic_where
            @topic_binds.push(term.gsub('"', '%'))
          end
        end
      end
    end
  end

  def build_by_user
    search_users = []

    if @terms['by']
      @terms['by'].each do |username|
        user = User.where('lower(name) = ?', username.downcase).first

        if user
          search_users << user.id
        end
      end

      if search_users.present?
        post_table = 'posts p'
        if @post_from.exclude? post_table
          @post_from = "#{@post_from}, #{post_table}"
        end

        post_where = 'p.user_id in (?)'
        if @post_where.exclude? post_where
          @post_where << post_where
          @post_binds.push(search_users)
        end

        topic_where = 't.user_id in (?)'
        if @topic_where.exclude? topic_where
          @topic_where << topic_where
          @topic_binds.push(search_users)
        end
      end
    end
  end
end
