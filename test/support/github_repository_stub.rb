# frozen_string_literal: true

class GithubRepositoryStub
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def id
    params[:id] || params['id']
  end

  def full_name
    params[:full_name] || params['full_name']
  end

  def language
    params[:language] || params['language']
  end

  def name
    params[:name] || params['name']
  end

  def clone_url
    params[:clone_url] || params['clone_url']
  end

  def ssh_url
    params[:ssh_url] || params['ssh_url']
  end
end
