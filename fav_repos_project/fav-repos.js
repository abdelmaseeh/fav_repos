var getGitHubRepos, getRowHtml, getLatestTag, getSortedTags;

$(document).ready(function() {
  $('#search-field').on('input', function(e) {
    var input;
    input = $('#search-field').val();
    if (!input) {
      return $('#search-body').empty();
    }
  });
  $('.search-btn').on('click', function() {
    var repoNam;
    repoNam = $('#search-field').val();
    return getGitHubRepos(repoNam);
  });
  window.onkeypress = function(e) {
    var key, repoNam;
    key = e.keyCode ? e.keyCode : e.which;
    if (key === 13) {
      repoNam = $('#search-field').val();
      return getGitHubRepos(repoNam);
    }
  };
  $("#search-table").on("click", "button#add-row-button", function() {
    var tr;
    tr = $(this).closest("tr").clone();
    tr.find('button#add-row-button').prop('id', 'remove-row-button').html('Remove');
    return $("#fav-repos-table").append(tr);
  });
  return $("#fav-repos-table").on("click", "button#remove-row-button", function() {
    return $(this).closest("tr").remove();
  });
});

getRowHtml = function(repo) {
  return "<tr><td><a href=\"" + repo.html_url + "\">" + repo.name + "/" + repo.owner.login + "</a></td><td>"
  + repo.language + "</td><td>" + getLatestTag(repo.tags_url)
  + "</td><td><button type=\"button\" class=\"btn btn-link\" id=\"add-row-button\">Add</button></td></tr>";
};

getGitHubRepos = function(repoName) {
  repoName = repoName.trim();
  if (repoName) {
    $('#search-body').empty();
    var url = "https://api.github.com/search/repositories?q=" + repoName + "&per_page=10"
    $.get(url).done(function (data) {
      var repos = data.items ;
      repos.forEach(function(repo) {
        $('#search-table > tbody:last-child').append(getRowHtml(repo));
      });
    });
  }
};


getLatestTag = function(url) {
  var versions = getTags(url);
  var semver = require('semver-extra');
  versions.sort(function (v1, v2) {
    return semver.compare(v2.name, v1.name)
  });

  return versions.length > 0 ? versions[0].name : "-" ;
};

getTags = function(url){
  var jqXHR = $.ajax({
    url: url,
    async: false
  });
  return JSON.parse(jqXHR.responseText);
};

$(document).ajaxStart(function() {
  return $(document.body).css({
    'cursor': 'wait'
  });
});

$(document).ajaxStop(function() {
  return $(document.body).css({
    'cursor': 'default'
  });
});
