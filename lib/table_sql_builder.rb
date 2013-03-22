class TableSqlBuilder
  attr_accessor :binds

  def initialize(query, messageboard)
    @terms = SearchParser.new(query).parse

    @select = 'SELECT t.id'
    @from = 'FROM topics t'
    @where = ['t.messageboard_id = ?']
    @binds = [messageboard.id]

    @search_categories = []
    @search_users = []
    @search_text = []
  end

  def sql
    build_by_user
    build_in_category
    build_text_search

    [@select,
     @from,
     'WHERE', @where.join(' AND '),
    ].join(' ')
  end

  private

  def is_quoted(term)
    term.count('"') == 2
  end

  def categories
    if @terms['in']
      @terms['in'].each do |category_name|
        category = Category
          .where('lower(name) = ?', category_name.downcase).first
        if category
          @search_categories << category.id
        end
      end
    end

    @search_categories
  end

  def users
    if @terms['by']
      @terms['by'].each do |username|
        user = User.where('lower(name) = ?', username.downcase).first
        if user
          @search_users << user.id
        end
      end
    end

    @search_users
  end

  def text
    @terms['text']
  end

  def build_by_user
    raise "SubclassResponsibility"
  end

  def build_in_category
    raise "SubclassResponsibility"
  end

  def build_text_search
    raise "SubclassResponsibility"
  end

  def add_from(table)
      if @from.exclude? table
        @from = "#{@from}, #{table}"
      end
  end

  def add_where(where, binds=nil)
    if @where.exclude? where
      @where << where
      if (binds)
        @binds.push(binds)
      end
    end
  end
end
