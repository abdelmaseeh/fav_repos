$(document).ready ->

  $('.search-btn').on 'click', ->
    repoNam = $('#search-field').val() ;
    getGitHubRepos(repoNam)

  window.onkeypress = (e) ->
    key = if e.keyCode then e.keyCode else e.which
    if key == 13
      repoNam = $('#search-field').val() ;
      getGitHubRepos(repoNam)

getRowHtml = (repo, id) ->
  console.log(repo)
  """
    <tr id="search-row-#{id}">
      <td>#{repo.name}/#{repo.owner}</td>
      <td>#{repo.lang}</td>
      <td></td>
      <td></td>
    </tr>
  """

getGitHubRepos = (repoName) ->
  repoName = repoName.trim()
  if (repoName)
    console.log(window.location.href + 'github_repos')
    $.ajax window.location.href + 'github_repos',
    type: 'GET'
    data:
      repo_name: repoName
    dataType: 'json',
    success: (data) ->
      repos = data.repos
      id = 1
      $('#search-body').empty()
      for repo in repos
        $('#search-table > tbody:last-child').append(getRowHtml(repo, id))

