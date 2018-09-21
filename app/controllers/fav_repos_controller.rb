require 'octokit'

class FavReposController < ApplicationController

  def github_repos
    begin
      @client ||= Octokit::Client.new()
      puts "params = #{params[:repo_name]}"
      repos = @client.search_repos(params[:repo_name], {:per_page => 10}).items
      repos.map!{|repo| {name: repo.name, owner: repo.owner.login, html_url: repo.html_url, lang: repo.language, tag: getLatestTag(@client.tags(repo.id))}}
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
