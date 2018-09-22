$(document).ready ->

  #clear search-table when search-text is cleared
  $('#search-field').on 'input', (e) ->
    input = $('#search-field').val()
    if (!input)
      $('#search-body').empty()

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

  #add button event handler clone row from the search-table to fav-table
  $("#search-table").on "click","button#add-row-button", ->
      tr = $(this).closest("tr").clone()
      tr.find('button#add-row-button').prop('id', 'remove-row-button').html('Remove')
      $("#fav-repos-table").append(tr)

  #remove button event handler remove row from the fav-table
  $("#fav-repos-table").on "click","button#remove-row-button", ->
      $(this).closest("tr").remove()

#convert repo date to table row html
getRowHtml = (repo) ->
  """
    <tr>
      <td><a href="#{repo.html_url}">#{repo.name}/#{repo.owner}</a></td>
      <td>#{repo.lang}</td>
      <td>#{repo.tag}</td>
      <td><button type="button" class="btn btn-link" id="add-row-button">Add</button></td>
    </tr>
  """

#ajax call to get All repos with the repoName
getGitHubRepos = (repoName) ->
  repoName = repoName.trim()
  if (repoName)
    $('#search-body').empty()
    $.ajax window.location.href + 'github_repos',
    type: 'GET'
    data:
      repo_name: repoName
    dataType: 'json',
    success: (data) ->
      repos = data.repos
      if repos.length > 0
        for repo in repos
          $('#search-table > tbody:last-child').append(getRowHtml(repo))
      else
        alert("there is no repos with that name : #{repoName}")

#change cursor to progress
$(document).ajaxStart ->
  $(document.body).css 'cursor': 'wait'
$(document).ajaxStop ->
  $(document.body).css 'cursor': 'default'
