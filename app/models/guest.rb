# == Schema Information
#
# Table name: guests
#
#  id                       :bigint           not null, primary key
#  additional_phone_numbers :text             default([]), is an Array
#  email                    :string
#  first_name               :string
#  last_name                :string
#  phone_numbers            :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
class Guest < ApplicationRecord
  validates :email, uniqueness: true
  has_many :reservations
  accepts_nested_attributes_for :reservations
end
