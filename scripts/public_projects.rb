#!/usr/bin/env ruby

#
# This script lists all public projects in CF GitHub orgs, then filters those already mentioned
# on the website. Can be used to update the site with new projects periodically.
#

require 'json'
require 'kramdown'
require 'net/http'

class GitHub
	def initialize(organization)
		@organization = organization
	end

	def is_private?(repo_name)
		result = fetch_json("repos/#{@organization}/#{repo_name}")
		result['private']
	end

	def repos
		fetch_json("orgs/#{@organization}/repos", all_pages = true).map do |repo|
			repo['name']
		end
	end

	private

	def base_path
		"https://api.github.com/"
	end

	def fetch_json(path, all_pages = false)
		headers = {}
		if ENV['GITHUB_API_TOKEN']
			headers['Authorization'] = "token #{ENV['GITHUB_API_TOKEN']}"
		end

		desired_uri = URI(base_path + path)
		http = Net::HTTP.new(desired_uri.host, desired_uri.port)
		http.use_ssl = desired_uri.scheme == 'https'
		response = http.get2("#{desired_uri.path}?#{desired_uri.query}", headers)
		result = JSON.parse(response.body)

		link = response.response['Link']
		if link && link.split(',').first.end_with?('next"') && all_pages
			link = link.gsub(/<(.*?)>.*/, '\1').gsub(base_path, '')
			result += fetch_json(link, all_pages)
		end

		result
	end
end

def all_links
	['examples.md', 'libraries.md', 'tools.md'].map do |md|
		doc = Kramdown::Document.new(File.new("documentation/#{md}").read())
		links(doc.root)
	end.flatten.map { |link| link.split('/')[-1] }
end

def links(element, all_links = [])
	element.children.each do |child|
		if child.type == :a
			all_links << child.attr()['href']
		end

		links(child, all_links)
	end

	all_links
end

##########################################################################

already_documented = all_links
not_documented_repos = ['contentful', 'contentful-labs'].map do |org_name|
	gh = GitHub.new(org_name)
	gh.repos.reject { |repo_name| gh.is_private?(repo_name) }
end.flatten.reject { |repo_name| already_documented.include?(repo_name) }
puts not_documented_repos.sort
