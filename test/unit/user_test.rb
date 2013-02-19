require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "queueing" do
    users = User.all[:10]
  end
end
