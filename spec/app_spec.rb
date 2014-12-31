require File.expand_path '../spec_helper.rb', __FILE__
require 'yaml'

describe 'login' do
	before :each do 
		# テスト用の設定ファイルを読み込み
		# 作成されていない場合は作成してください。
		setting_path = File.expand_path '../setting.yml', __FILE__
		setting = YAML.load_file(setting_path)
		@api_key = setting['api_key']
		@space_id = setting['space_id']
		@project_id = setting['project_id']
	end

  it "be_ok" do
    get '/login'
    expect(last_response).to be_ok
  end

	describe 'do_login' do
	  it "be_ok" do
	    post '/do_login', api_key: @api_key, space_id: @space_id
	    expect(last_response).to be_redirect
	    expect(session[:user_name]).not_to be_nil
	  end

	  it "not authorized" do
	    post '/do_login'
	    expect(last_response).to be_ok
	    expect(session[:user_name]).to be_nil
	  end
	end
end