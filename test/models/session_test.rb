require_relative '../test_helper'

class SessionTest < ActiveSupport::TestCase

  def test_fixtures_validity
    Session.all.each do |session|
      assert session.valid?, session.errors.inspect
    end
  end

  def test_validation
    session = Session.new
    assert session.invalid?
    assert_errors_on session, :name
  end

  def test_creation
    assert_difference 'Session.count' do
      Session.create(
        :name => 'test name',
      )
    end
  end

end