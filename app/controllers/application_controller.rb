class ApplicationController < ActionController::Base
  # サインインしていない場合はユーザをサインインページにリダイレクト
  before_action :authenticate_user!
end
