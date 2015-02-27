require File.expand_path '../spec_helper.rb', __FILE__
require 'yaml'

describe 'app' do
	before :each do 
		# テスト用の設定ファイルを読み込み
		# 作成されていない場合は作成してください。
		setting_path = File.expand_path '../setting.yml', __FILE__
		setting = YAML.load_file(setting_path)
		@api_key = setting['api_key']
		@space_id = setting['space_id']
		@project_id = setting['project_id']
	end

	describe "login" do
	  it "be_ok" do
	    get '/login'
	    expect(last_response).to be_ok
	  end
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

	describe "api" do
		before :each do 
			# ログイン
			post '/do_login', api_key: @api_key, space_id: @space_id
		end

		describe "get_projects" do
			it "should be ok" do
				get '/get_projects'
				expect(last_response).to be_ok
			end
		end

		describe "get_statuses" do
			it "should be ok" do
				get '/get_statuses'
				expect(last_response).to be_ok
			end
		end
	end
end