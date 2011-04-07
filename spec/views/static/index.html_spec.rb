require 'spec_helper'

describe "/static/index" do
  before { activate_authlogic }
  it "should succeed" do
    render
  end
end

