require File.dirname(__FILE__) + "/../test_helper"

class EventTest < ActiveSupport::TestCase
  def test_payload_object
    assert_not_nil events(:event1).payload_object
    assert_not_nil events(:event2).payload_object
  end
end
