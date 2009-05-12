require File.dirname(__FILE__) + "/../test_helper"

describe User do
  before do
    User.create :name => "ma", :password => "test"
  end
  
  should "authenticate" do
    User.authenticate("ma", "test").should.be.kind_of(User)
  end

  should "not authenticate unknown user" do
    User.authenticate("nop", "bad").should.be.nil
  end
end