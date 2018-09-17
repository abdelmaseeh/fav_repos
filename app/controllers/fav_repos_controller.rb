require 'octokit'

class FavReposController < ApplicationController

  def github_repos
    @client ||= Octokit::Client.new
    repos = @client.repos (params[:repo_name])
    repos = repos.first(10)
    repos.map!{|repo| {name: repo.name, owner: repo.owner.login, lang: repo.language}}
    # byebug
    render json: { repos: repos }, status: :ok
  end

  def index
  end
end
