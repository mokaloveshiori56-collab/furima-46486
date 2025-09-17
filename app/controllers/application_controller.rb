class ApplicationController < ActionController::Base
  # 開発環境とテスト環境でのみBasic認証を有効にする場合
  # production環境でもBasic認証が必要なら if Rails.env.production? に変更
  before_action :basic_auth unless Rails.env.test?

  private

  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV['BASIC_AUTH_USER'] && password == ENV['BASIC_AUTH_PASSWORD']
    end
  end

  # Deviseのログイン・ログアウト後のリダイレクト先 (既存のものであれば変更不要)
  def after_sign_in_path_for(resource)
    root_path
  end

  def after_sign_out_path_for(resource)
    root_path
  end
end
