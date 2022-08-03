# class GitHubService < BaseService
#   def self.get_repo_data
#     response = conn('https://api.github.com').get('/repos/aspeth/bulk-discounts')
#     get_json(response)
#   end
  
#   def self.get_pull_data
#     response = conn('https://api.github.com').get('/repos/alexGrandolph/little-esty-shop/pulls')
#     get_json(response)
#   end
# end