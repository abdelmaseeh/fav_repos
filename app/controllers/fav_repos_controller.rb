require 'octokit'

class FavReposController < ApplicationController

  def github_repos
    begin
      @client ||= Octokit::Client.new(:login => 'abdelmaseeh', :password => '01226738563se7a')
      repos = @client.repos (params[:repo_name])
      repos = repos.first(10)
      repos.map!{|repo| {name: repo.name, owner: repo.owner.login, lang: repo.language, tag: getLatestTag(@client.tags(repo.id))}}
      render json: { repos: repos }, status: :ok
    rescue
      render json: { repos: [] }, status: :ok
    end
  end

  def index
  end

  private

  def getLatestTag (tags)
    tags.present? ? tags.sort_by{ |hsh| hsh[:name] }.first.name : '-'
  end
end
