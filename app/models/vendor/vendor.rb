require 'mongoid'

require_relative 'pricing'
require_relative 'quality'
require_relative 'scaling'
require_relative 'runtime'
require_relative 'middleware'
require_relative 'framework'
require_relative 'service'
require_relative 'infrastructure'
require_relative 'hosting'

class Vendor
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  # fields
  field :name, type: String
  field :revision, type: DateTime
  field :vendor_verified, type: Date
  field :url, type: String
  field :status, type: String
  field :status_since, type: Date
  field :type, type: String
  field :extensible, type: Boolean
  # relations
  embeds_one :hosting
  embeds_many :pricings, store_as: 'pricing'
  embeds_one :quality, store_as: 'qos'
  embeds_one :scaling
  embeds_many :runtimes
  embeds_many :middlewares, store_as: 'middleware'
  embeds_many :frameworks
  embeds_one :service, store_as: 'services'
  embeds_many :infrastructures
  # validations
  validates :name, presence: true
  validates :revision, presence: true
  validates :url, presence: true, format: {with: /http[s]?:\/\/.*/}
  validates :status, presence: true, inclusion: {in: %w(alpha beta production eol)}
  validates :extensible, presence: true
  validates :hosting, presence: true
  validates :pricings, presence: true, :allow_blank => true
  validates :scaling, presence: true
  validates :runtimes, presence: true
  validates :middlewares, presence: true, :allow_blank => true
  validates :frameworks, presence: true, :allow_blank => true
  validates :service, presence: true, :allow_blank => true
  validates :infrastructures, presence: true, :allow_blank => true # :if => Proc.new { hosting.public && status.eql?('production') }
end