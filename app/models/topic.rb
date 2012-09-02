class Topic < ActiveRecord::Base
  paginates_per 50 if self.respond_to?(:paginates_per)
  has_many   :posts, include: :attachments
  has_many   :topic_categories
  has_many   :categories, through: :topic_categories

  belongs_to :last_user, class_name: 'User', foreign_key: 'last_user_id'
  belongs_to :user, counter_cache: true
  belongs_to :messageboard, counter_cache: true, touch: true

  delegate :name, :name=, :email, :email=, to: :user, prefix: true

  validates_presence_of [:last_user_id, :messageboard_id]
  validates_numericality_of :posts_count

  attr_accessible :category_ids, :last_user, :locked, :messageboard,
    :posts_attributes, :sticky, :type, :title, :user, :usernames

  accepts_nested_attributes_for :posts, reject_if: :updating?
  accepts_nested_attributes_for :categories

  default_scope order('updated_at DESC')

  def self.stuck
    where('sticky = true')
  end

  def self.unstuck
    where('sticky = false OR sticky IS NULL')
  end

  accepts_nested_attributes_for :posts, :reject_if => :updating?
  accepts_nested_attributes_for :categories

  def self.full_text_search(query, messageboard_id)
    sql = <<-SQL
      SELECT tops.*, pork.score * 100 as posts_count
        FROM (
          SELECT meat.id as id, sum(meat.rank) as score
            FROM (
              SELECT t.id as id, ts_rank(setweight(to_tsvector(p.content), 'B'), pquery) as rank
                FROM topics t, posts p, to_tsquery('english', ?) as pquery
               WHERE t.messageboard_id = ?
                 AND t.id              = p.topic_id
                 AND to_tsvector('english', p.content) @@ pquery
               UNION ALL
              SELECT t.id as id, ts_rank( setweight(to_tsvector('english', t.title), 'A'), tquery ) as rank
                FROM topics t, to_tsquery('english', ?) as tquery
               WHERE t.messageboard_id = ?
                 AND to_tsvector('english', t.title) @@ tquery
                 ) meat
           GROUP BY meat.id
           ORDER BY score desc LIMIT 50 OFFSET 0
             ) pork, topics tops
           where pork.id = tops.id
    SQL

    search_words = query.gsub(' ', '&' )
    find_by_sql [sql, search_words, messageboard_id, search_words, messageboard_id]
  end

  def public?
    true
  end

  def private?
    false
  end

  def css_class
    classes = []
    classes << 'locked' if locked
    classes << 'sticky' if sticky
    classes << 'private' if private?
    classes.empty? ?  '' : "class=\"#{classes.join(' ')}\"".html_safe
  end

  def users
    []
  end

  def users_to_sentence
    ''
  end

  def self.inherited(child)
    child.instance_eval do
      def model_name
        Topic.model_name
      end
    end
    super
  end

  def self.select_options
    subclasses.map{ |c| c.to_s }.sort
  end

  def updating?
    self.id.present?
  end

  def categories_to_sentence
    self.categories.map{ |c| c.name }.to_sentence if self.categories
  end
end
