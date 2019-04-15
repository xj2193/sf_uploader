

<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <title>salesforce-api/README.md at master - xij7005/salesforce-api</title>
    <link rel="icon" href="https://gitbucket.sis.nyp.org/assets/common/images/gitbucket.png?20190325084452" type="image/vnd.microsoft.icon" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://gitbucket.sis.nyp.org/assets/vendors/google-fonts/css/source-sans-pro.css?20190325084452" rel="stylesheet">
    <link href="https://gitbucket.sis.nyp.org/assets/vendors/bootstrap-3.3.7/css/bootstrap.min.css?20190325084452" rel="stylesheet">
    <link href="https://gitbucket.sis.nyp.org/assets/vendors/octicons-4.4.0/octicons.min.css?20190325084452" rel="stylesheet">
    <link href="https://gitbucket.sis.nyp.org/assets/vendors/bootstrap-datetimepicker-4.17.44/css/bootstrap-datetimepicker.min.css?20190325084452" rel="stylesheet">
    <link href="https://gitbucket.sis.nyp.org/assets/vendors/colorpicker/css/bootstrap-colorpicker.min.css?20190325084452" rel="stylesheet">
    <link href="https://gitbucket.sis.nyp.org/assets/vendors/google-code-prettify/prettify.css?20190325084452" type="text/css" rel="stylesheet"/>
    <link href="https://gitbucket.sis.nyp.org/assets/vendors/facebox/facebox.css?20190325084452" rel="stylesheet"/>
    <link href="https://gitbucket.sis.nyp.org/assets/vendors/AdminLTE-2.4.2/css/AdminLTE.min.css?20190325084452" rel="stylesheet">
    <link href="https://gitbucket.sis.nyp.org/assets/vendors/AdminLTE-2.4.2/css/skins/skin-blue-light.min.css?20190325084452" rel="stylesheet">
    <link href="https://gitbucket.sis.nyp.org/assets/vendors/font-awesome-4.7.0/css/font-awesome.min.css?20190325084452" rel="stylesheet">
    <link href="https://gitbucket.sis.nyp.org/assets/vendors/jquery-ui/jquery-ui.min.css?20190325084452" rel="stylesheet">
    <link href="https://gitbucket.sis.nyp.org/assets/vendors/jquery-ui/jquery-ui.structure.min.css?20190325084452" rel="stylesheet">
    <link href="https://gitbucket.sis.nyp.org/assets/vendors/jquery-ui/jquery-ui.theme.min.css?20190325084452" rel="stylesheet">
    <link href="https://gitbucket.sis.nyp.org/assets/common/css/gitbucket.css?20190325084452" rel="stylesheet">
    <script src="https://gitbucket.sis.nyp.org/assets/vendors/jquery/jquery-3.2.1.min.js?20190325084452"></script>
    <script src="https://gitbucket.sis.nyp.org/assets/vendors/jquery-ui/jquery-ui.min.js?20190325084452"></script>
    <script src="https://gitbucket.sis.nyp.org/assets/vendors/dropzone/dropzone.min.js?20190325084452"></script>
    <script src="https://gitbucket.sis.nyp.org/assets/common/js/validation.js?20190325084452"></script>
    <script src="https://gitbucket.sis.nyp.org/assets/common/js/gitbucket.js?20190325084452"></script>
    <script src="https://gitbucket.sis.nyp.org/assets/vendors/bootstrap-3.3.7/js/bootstrap.min.js?20190325084452"></script>
    <script src="https://gitbucket.sis.nyp.org/assets/vendors/bootstrap3-typeahead/bootstrap3-typeahead.min.js?20190325084452"></script>
    <script src="https://gitbucket.sis.nyp.org/assets/vendors/bootstrap-datetimepicker-4.17.44/js/moment.min.js?20190325084452"></script>
    <script src="https://gitbucket.sis.nyp.org/assets/vendors/bootstrap-datetimepicker-4.17.44/js/bootstrap-datetimepicker.min.js?20190325084452"></script>
    <script src="https://gitbucket.sis.nyp.org/assets/vendors/colorpicker/js/bootstrap-colorpicker.min.js?20190325084452"></script>
    <script src="https://gitbucket.sis.nyp.org/assets/vendors/google-code-prettify/prettify.js?20190325084452"></script>
    <script src="https://gitbucket.sis.nyp.org/assets/vendors/elastic/jquery.elastic.source.js?20190325084452"></script>
    <script src="https://gitbucket.sis.nyp.org/assets/vendors/facebox/facebox.js?20190325084452"></script>
    <script src="https://gitbucket.sis.nyp.org/assets/vendors/jquery-hotkeys/jquery.hotkeys.js?20190325084452"></script>
    <script src="https://gitbucket.sis.nyp.org/assets/vendors/jquery-textcomplete-1.8.4/jquery.textcomplete.min.js?20190325084452"></script>
    
      <meta name="go-import" content="gitbucket.sis.nyp.org/xij7005/salesforce-api git https://gitbucket.sis.nyp.org/git/xij7005/salesforce-api.git" />
    
    <script src="https://gitbucket.sis.nyp.org/assets/vendors/AdminLTE-2.4.2/js/adminlte.min.js?20190325084452" type="text/javascript"></script>
  </head>
  <body class="skin-blue-light page-load sidebar-mini ">
    <div class="wrapper">
      <header class="main-header">
        <a href="https://gitbucket.sis.nyp.org/" class="logo">
          <span class="logo-mini"><img src="https://gitbucket.sis.nyp.org/assets/common/images/gitbucket.svg?20190325084452" alt="GitBucket" /></span>
          <span class="logo-lg">
            <img src="https://gitbucket.sis.nyp.org/assets/common/images/gitbucket.svg?20190325084452" alt="GitBucket" />
            <span class="header-title strong">GitBucket</span>
          </span>
        </a>
        <nav class="navbar navbar-static-top" role="navigation">
          <!-- Sidebar toggle button-->
          
            <a href="#" class="sidebar-toggle" data-toggle="push-menu" role="button">
              <span class="sr-only">Toggle navigation</span>
            </a>
          
          <form id="search" action="https://gitbucket.sis.nyp.org/search" method="GET" class="pc navbar-form navbar-left" role="search">
            <div class="form-group">
              <input type="text" name="query" id="navbar-search-input" class="form-control" placeholder="Search repository"/>
            </div>
          </form>
          <ul class="pc nav navbar-nav">
            
            
          </ul>
          <div class="navbar-custom-menu">
            <ul class="nav navbar-nav">
              
                <li>
                  <a href="https://gitbucket.sis.nyp.org/signin?redirect=%2Fxij7005%2Fsalesforce-api%2Fblob%2Fmaster%2FREADME.md" class="pull-right" id="signin">Sign in</a>
                </li>
              
            </ul>
          </div>
        </nav>
      </header>
      
  



<div class="main-sidebar">
  <div class="sidebar">
    <ul class="sidebar-menu">
      
  <li class = "menu-item-hover active">
    
      <a href="https://gitbucket.sis.nyp.org/xij7005/salesforce-api">
        <i class="menu-icon octicon octicon-code"></i>
        <span>Files</span>
        
      </a>
    
  </li>

      
        
  <li class = "menu-item-hover ">
    
      <a href="https://gitbucket.sis.nyp.org/xij7005/salesforce-api/branches">
        <i class="menu-icon octicon octicon-git-branch"></i>
        <span>Branches</span>
        
          <span class="pull-right-container"><span class="label label-primary pull-right">1</span></span>
        
      </a>
    
  </li>

      
      
  <li class = "menu-item-hover ">
    
      <a href="https://gitbucket.sis.nyp.org/xij7005/salesforce-api/releases">
        <i class="menu-icon octicon octicon-tag"></i>
        <span>Releases</span>
        
      </a>
    
  </li>

      
        
  <li class = "menu-item-hover ">
    
      <a href="https://gitbucket.sis.nyp.org/xij7005/salesforce-api/issues">
        <i class="menu-icon octicon octicon-issue-opened"></i>
        <span>Issues</span>
        
      </a>
    
  </li>

        
  <li class = "menu-item-hover ">
    
      <a href="https://gitbucket.sis.nyp.org/xij7005/salesforce-api/pulls">
        <i class="menu-icon octicon octicon-git-pull-request"></i>
        <span>Pull requests</span>
        
      </a>
    
  </li>

        
  <li class = "menu-item-hover ">
    
      <a href="https://gitbucket.sis.nyp.org/xij7005/salesforce-api/issues/labels">
        <i class="menu-icon octicon octicon-tag"></i>
        <span>Labels</span>
        
      </a>
    
  </li>

        
  <li class = "menu-item-hover ">
    
      <a href="https://gitbucket.sis.nyp.org/xij7005/salesforce-api/issues/priorities">
        <i class="menu-icon octicon octicon-flame"></i>
        <span>Priorities</span>
        
      </a>
    
  </li>

        
  <li class = "menu-item-hover ">
    
      <a href="https://gitbucket.sis.nyp.org/xij7005/salesforce-api/issues/milestones">
        <i class="menu-icon octicon octicon-milestone"></i>
        <span>Milestones</span>
        
      </a>
    
  </li>

      
      
        
  <li class = "menu-item-hover ">
    
      <a href="https://gitbucket.sis.nyp.org/xij7005/salesforce-api/wiki">
        <i class="menu-icon octicon octicon-book"></i>
        <span>Wiki</span>
        
      </a>
    
  </li>

      
      
      
    </ul>
  </div>
</div>
<div class="content-wrapper">
  <div class="content body clearfix">
    <div class="headbar">
      <div class="container">
        


        

        <div class="head">
          <div class="pull-right">
            
              
            
            
              
                <a class="btn btn-default btn-sm" href="https://gitbucket.sis.nyp.org/signin?redirect=https%3A%2F%2Fgitbucket.sis.nyp.org%2Fxij7005%2Fsalesforce-api">
                  <span class="strong"><i class="octicon octicon-repo-forked"></i>Fork</span><span class="muted">: 0</span>
                </a>
              
            
            <form id="fork-form" method="post" action="https://gitbucket.sis.nyp.org/xij7005/salesforce-api/fork" style="display: none;">
              <input type="hidden" name="account" value=""/>
            </form>
          </div>
          

  
    <i class="mega-octicon octicon-repo"></i>
  


          <a href="https://gitbucket.sis.nyp.org/xij7005">xij7005</a> / <a href="https://gitbucket.sis.nyp.org/xij7005/salesforce-api" class="strong">salesforce-api</a>

          
            
          
        </div>
      </div>
    </div>
    
    <style>
      .prettyprint {
        tab-size: 8
      }
    </style>
    <div class="head">
      <div class="pull-right hide-if-blame"><div class="btn-group">
        <a href="https://gitbucket.sis.nyp.org/xij7005/salesforce-api/blob/53c361294b9d5dcd342c7e801bdd8bff97e0d8e0/README.md" data-hotkey="y" style="display: none;">Transfer to URL with SHA</a>
        <a href="https://gitbucket.sis.nyp.org/xij7005/salesforce-api/find/master" class="btn btn-sm btn-default" data-hotkey="t">Find file</a>
      </div></div>
      <div class="line-age-legend">
        <span>Newer</span>
        <ol>
            <li class="heat1"></li>
            <li class="heat2"></li>
            <li class="heat3"></li>
            <li class="heat4"></li>
            <li class="heat5"></li>
            <li class="heat6"></li>
            <li class="heat7"></li>
            <li class="heat8"></li>
            <li class="heat9"></li>
            <li class="heat10"></li>
        </ol>
        <span>Older</span>
      </div>
      <div id="branchCtrlWrapper" style="display:inline;">
      


  <div class="btn-group" >
    <button id = "test"
        class="dropdown-toggle btn btn-default btn-sm" data-toggle="dropdown">
      
        
          <span class="muted">branch:</span>
        
        <span class="strong"
              style="display:inline-block; vertical-align:bottom; overflow-x:hidden; max-width:200px; text-overflow:ellipsis">
          master
        </span>
      
      <span class="caret"></span>
    </button>
    <ul class="dropdown-menu">
      
      
  <li><div id="branch-control-title">Switch branches<button id="branch-control-close" class="pull-right">&times</button></div></li>
  <li><input id="branch-control-input" type="text" class="form-control input-sm dropdown-filter-input" placeholder="Find or create branch ..."/></li>
  
        
          <li><a href="https://gitbucket.sis.nyp.org/xij7005/salesforce-api/blob/master/README.md">

  <i class="octicon octicon-check"></i>
 master</a></li>
        
      
  

    </ul>
  </div>
  


<script>
  $(function(){
    $('#branch-control-input').parent().click(function(e) {
      e.stopPropagation();
    });
    $('#branch-control-close').click(function() {
      $('[data-toggle="dropdown"]').parent().removeClass('open');
    });
    $('#branch-control-input').keyup(function() {
      var inputVal = $('#branch-control-input').val();
      $.each($('#branch-control-input').parent().parent().find('a'), function(index, elem) {
        if (!inputVal || !elem.text.trim() || elem.text.trim().toLowerCase().indexOf(inputVal.toLowerCase()) >= 0) {
          $(elem).parent().show();
        } else {
          $(elem).parent().hide();
        }
      });
      
    });
    
    $('.btn-group').click(function() {
      $('#branch-control-input').val('');
      $('.dropdown-menu li').show();
      $('#create-branch').hide();
    });
  });
</script>

      </div>
      <a href="https://gitbucket.sis.nyp.org/xij7005/salesforce-api/tree/master">salesforce-api</a> /
      
        
          README.md
        
      
      
    </div>
    <div class="box-header">
      <a href="https://gitbucket.sis.nyp.org/xij7005" class=""><img src="https://gitbucket.sis.nyp.org/xij7005/_avatar?20190412131401" class="avatar" style="width: 28px; height: 28px;" /></a>
      <a href="https://gitbucket.sis.nyp.org/xij7005" class="username strong">Xinzhuo Jiang</a>
      <span class="muted">
<span data-toggle="tooltip" title="2019-04-12 14:08:37">
  
    2 days ago
  
</span>
</span>
      <span class="label label-default">31 bytes</span>
      <a href="https://gitbucket.sis.nyp.org/xij7005/salesforce-api/commit/53c361294b9d5dcd342c7e801bdd8bff97e0d8e0" class="commit-message">Initial commit</a>
      <div class="btn-group pull-right">
        
        <a class="btn btn-sm btn-default" href="https://gitbucket.sis.nyp.org/xij7005/salesforce-api/raw/53c361294b9d5dcd342c7e801bdd8bff97e0d8e0/README.md">Raw</a>
        
          <a class="btn btn-sm btn-default blame-action" href="https://gitbucket.sis.nyp.org/xij7005/salesforce-api/blame/53c361294b9d5dcd342c7e801bdd8bff97e0d8e0/README.md"
            data-url="https://gitbucket.sis.nyp.org/xij7005/salesforce-api/get-blame/53c361294b9d5dcd342c7e801bdd8bff97e0d8e0/README.md" data-repository="https://gitbucket.sis.nyp.org/xij7005/salesforce-api">Blame</a>
        
        <a class="btn btn-sm btn-default" href="https://gitbucket.sis.nyp.org/xij7005/salesforce-api/commits/master/README.md">History</a>
        
      </div>
    </div>
    
      
        <div class="box-content-bottom  markdown-body  " style="padding-left: 20px; padding-right: 20px;">
          <h1 id="salesforce-api" class="markdown-head"><a class="markdown-anchor-link" href="#salesforce-api"><span class="octicon octicon-link"></span></a><a class="markdown-anchor"></a>salesforce-api</h1>
        </div>
      
    
  
  </div>
</div>
<script>
$(function(){
  $('a[rel*=facebox]').facebox({
    'loadingImage': 'https://gitbucket.sis.nyp.org/assets/vendors/facebox/loading.gif?20190325084452',
    'closeImage': 'https://gitbucket.sis.nyp.org/assets/vendors/facebox/closelabel.png?20190325084452'
  });

  $(document).on("click", ".js-fork-owner-select-target", function() {
    var account = $(this).text().replace("@", "");
    $("#account").val(account);
    $("#fork").submit();
  });
});
</script>




    </div>
    <script>
      $(function(){
        
        
          $(".sidebar-toggle").on('click', function(e){
            $.post('https://gitbucket.sis.nyp.org/sidebar-collapse', { collapse: !$('body').hasClass('sidebar-collapse') });
          });
        
      });
    </script>
    
  </body>
</html>

<script>
$(window).on('load', function(){
  updateHighlighting();

  window.onhashchange = function(){
    updateHighlighting();
  }

  var pre = $('pre.prettyprint');
  function updateSourceLineNum(){
    $('.source-line-num').remove();
    var pos = pre.find('ol.linenums').position();
    if(pos){
      $('<div class="source-line-num">').css({
        height  : pre.height(),
        width   : '48px',
        cursor  : 'pointer',
        position: 'absolute',
        top     : pos.top + 'px',
        left    : pos.left + 'px'
      }).click(function(e){
        var pos = $(this).data("pos");
        if(!pos){
          pos = $('ol.linenums li').map(function(){ return { id: $(this).attr("id"), top: $(this).position().top} }).toArray();
          $(this).data("pos",pos);
        }
        for(var i = 0; i < pos.length-1; i++){
          if(pos[i + 1].top > e.pageY){
            break;
          }
        }
        var line = pos[i].id.replace(/^L/,'');
        var hash = location.hash;
        var commitUrl = 'https://gitbucket.sis.nyp.org/xij7005/salesforce-api/blob/53c361294b9d5dcd342c7e801bdd8bff97e0d8e0/README.md';
        if(e.shiftKey == true && hash.match(/#L\d+(-L\d+)?/)){
          var lines = hash.split('-');
          window.history.pushState('', '', commitUrl + lines[0] + '-L' + line);
        } else {
          var p = $("#L"+line).attr('id',"");
          window.history.pushState('', '', commitUrl + '#L' + line);
          p.attr('id','L'+line);
        }
        $("#branchCtrlWrapper .btn .muted").text("tree:");
        $("#branchCtrlWrapper .btn .strong").text("53c361294b");
        updateHighlighting();
      }).appendTo(pre);
    }
  }
  var repository = $('.blame-action').data('repository');
  $('.blame-action').click(function(e){
    if(history.pushState && $('pre.prettyprint.no-renderable').length){
      e.preventDefault();
      history.pushState(null, null, this.href);
      updateBlame();
    }
  });

  function updateBlame(){
    var m = /\/(blame|blob)(\/.*)$/.exec(location.href);
    var mode = m[1];
    $('.blame-action').toggleClass("active", mode=='blame').attr('href', repository + (m[1] == 'blame' ? '/blob' : '/blame') + m[2]);
    if(pre.parents("div.box-content-bottom").find(".blame").length){
      pre.parent().toggleClass("blame-container", mode == 'blame');
      updateSourceLineNum();
      return;
    }
    if(mode=='blob'){
      updateSourceLineNum();
      return;
    }
    $(document.body).toggleClass('no-box-shadow', document.body.style.boxShadow === undefined);
    $('.blame-action').addClass("active");
    var base = $('<div class="blame">').css({height: pre.height()}).prependTo(pre.parents("div.box-content-bottom"));
    base.parent().addClass("blame-container");
    updateSourceLineNum();
    $.get($('.blame-action').data('url')).done(function(data){
      var blame = data.blame;
      var index = [];
      for(var i = 0; i < blame.length; i++){
        for(var j = 0; j < blame[i].lines.length; j++){
          index[blame[i].lines[j]] = blame[i];
        }
      }
      var blame, lastDiv, now = new Date().getTime();

      $('pre.prettyprint ol.linenums li').each(function(i, e){
        var p = $(e).position();
        var h = $(e).height();
        if(blame == index[i]){
          lastDiv.css("min-height",(p.top + h + 1) - lastDiv.position().top);
        } else {
          $(e).addClass('blame-sep')
          blame = index[i];
          var sha = $('<div class="blame-sha">')
             .append($('<a>').attr("href", data.root + '/commit/' + blame.id).text(blame.id.substr(0,7)));
          if(blame.prev){
             sha.append($('<br />'))
             .append($('<a class="muted-link">').text('prev').attr("href", data.root + '/blame/' + blame.prev + '/' + (blame.prevPath || data.path)));
          }
          lastDiv = $('<div class="blame-info">')
           .addClass('heat' + Math.min(10, Math.max(1, Math.ceil((now - blame.commited) / (24 * 3600 * 1000 * 70)))))
           .toggleClass('blame-last', blame.id == data.last)
           .data('line', (i + 1))
           .css({
             "top"        : p.top + 'px',
             "min-height" : h + 'px'
           })
           .append(sha)
           .append($(blame.avatar).addClass('avatar').css({"float": "left"}))
           .append($('<div class="blame-commit-title">').text(blame.message))
           .append($('<div class="muted">').html(blame.author + " authed " + blame.authed))
           .appendTo(base);
        }
      });
    });
    return false;
  };
  $(document).on('expanded.pushMenu collapsed.pushMenu', function(e){
    setTimeout(updateBlame, 300);
  });
  updateBlame();
});

var scrolling = false;

/**
 * Hightlight lines which are specified by URL hash.
 */
function updateHighlighting(){
  var hash = location.hash;
  if(hash.match(/#L\d+(-L\d+)?/)){
    $('li.highlight').removeClass('highlight');
    var lines = hash.substr(1).split('-');
    if(lines.length == 1){
      $('#' + lines[0]).addClass('highlight');
      if(!scrolling){
        $(window).scrollTop($('#' + lines[0]).offset().top - 40);
      }
    } else if(lines.length > 1){
      var start = parseInt(lines[0].substr(1));
      var end   = parseInt(lines[1].substr(1));
      for(var i = start; i <= end; i++){
        $('#L' + i).addClass('highlight');
      }
      if(!scrolling){
        $(window).scrollTop($('#L' + start).offset().top - 40);
      }
    }
    scrolling = true;
  }
}
</script>
