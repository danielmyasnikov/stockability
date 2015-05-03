require_relative '../../test_helper'

class Admin::SessionsControllerTest < ActionController::TestCase

  def setup
    # TODO: login as admin user
    @session = sessions(:default)
  end

  def test_get_index
    get :index
    assert_response :success
    assert assigns(:sessions)
    assert_template :index
  end

  def test_get_show
    get :show, :id => @session
    assert_response :success
    assert assigns(:session)
    assert_template :show
  end

  def test_get_show_failure
    get :show, :id => 'invalid'
    assert_response :redirect
    assert_redirected_to :action => :index
    assert_equal 'Session not found', flash[:danger]
  end

  def test_get_new
    get :new
    assert_response :success
    assert assigns(:session)
    assert_template :new
    assert_select "form[action='/admin/sessions']"
  end

  def test_get_edit
    get :edit, :id => @session
    assert_response :success
    assert assigns(:session)
    assert_template :edit
    assert_select "form[action='/admin/sessions/#{@session.id}']"
  end

  def test_creation
    assert_difference 'Session.count' do
      post :create, :session => {
        :name => 'test name',
      }
      session = Session.last
      assert_response :redirect
      assert_redirected_to :action => :show, :id => session
      assert_equal 'Session created', flash[:success]
    end
  end

  def test_creation_failure
    assert_no_difference 'Session.count' do
      post :create, :session => { }
      assert_response :success
      assert_template :new
      assert_equal 'Failed to create Session', flash[:danger]
    end
  end

  def test_update
    put :update, :id => @session, :session => {
      :name => 'Updated'
    }
    assert_response :redirect
    assert_redirected_to :action => :show, :id => @session
    assert_equal 'Session updated', flash[:success]
    @session.reload
    assert_equal 'Updated', @session.name
  end

  def test_update_failure
    put :update, :id => @session, :session => {
      :name => ''
    }
    assert_response :success
    assert_template :edit
    assert_equal 'Failed to update Session', flash[:danger]
    @session.reload
    refute_equal '', @session.name
  end

  def test_destroy
    assert_difference 'Session.count', -1 do
      delete :destroy, :id => @session
      assert_response :redirect
      assert_redirected_to :action => :index
      assert_equal 'Session deleted', flash[:success]
    end
  end
end