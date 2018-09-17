$(document).ready ->

  #pagination
#  $('#search-table').dataTable "pageLength": 10
#  $('#fav-repos-table').dataTable "pageLength": 10
#  $('search-table').DataTable()

  #search button click handler
  $('.search-btn').on 'click', ->
    repoNam = $('#search-field').val() ;
    getGitHubRepos(repoNam)

  #enter click handler
  window.onkeypress = (e) ->
    key = if e.keyCode then e.keyCode else e.which
    if key == 13
      repoNam = $('#search-field').val() ;
      getGitHubRepos(repoNam)

  $("#search-table").on "click","button#add-row-button", ->
      tr = $(this).closest("tr").clone()
      tr.find('button#add-row-button').prop('id', 'remove-row-button').html('Remove')
      $("#fav-repos-table").append(tr)

  $("#fav-repos-table").on "click","button#remove-row-button", ->
      $(this).closest("tr").remove()


getRowHtml = (repo) ->
  console.log(repo)
  """
    <tr>
      <td>#{repo.name}/#{repo.owner}</td>
      <td>#{repo.lang}</td>
      <td></td>
      <td><button type="button" class="btn btn-link" id="add-row-button">Add</button></td>
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

