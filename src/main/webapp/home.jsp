<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <title>Save the PostIts</title>
  <link href='http://fonts.googleapis.com/css?family=Permanent+Marker' rel='stylesheet' type='text/css'>
  <link href='http://fonts.googleapis.com/css?family=Crafty+Girls' rel='stylesheet' type='text/css'>

  <link rel="stylesheet" href="${ctx}/css/screen.css" />
  <link rel="stylesheet" href="${ctx}/css/main.css" />
  <script src="http://ajax.googleapis.com/ajax/libs/prototype/1.7.0.0/prototype.js" type="text/javascript"></script>
  <script type="text/javascript">
    if( typeof window.console == 'undefined'){
        window.console = {
            log:function(){},
            debug:function(){},
            info:function(){},
            warn:function(){},
            error:function(){},
            fatal:function(){}
        };
    }

    var batch = 0;
    var autoscroll = true;
    function selectProject(projectSelected) {
      batch = 0;
      projectId = $F('project');
      if (console) { console.info("Selected project: " + projectId ); }
      new Ajax.Request('home', {
        method: 'get',
        parameters: {
          f:'v',
          p:projectId
        },
        onSuccess: function(transport) {
          versions = transport.responseText.evalJSON();
          if (console) { console.info("Versions available: " + versions ); }
          $('version').options.length = 0;
          $('version').insert(new Element('option', {value: ''}).update('Select Version'));
          versions.versionList.versions.each(function(it){
            $('version').insert(new Element('option', {value: it.id}).update(it.label));
          });
          if (console) { console.info("Versions updated. " ); }
        }
      });
    }

    function loadStories() {
      projectId = $F('project');
      versionId = $F('version');
      new Ajax.Request('home', {
        parameters: { f:'s', p:projectId, v:versionId, b:batch },
        onSuccess: function (transport) {
          $('mybody').innerHTML = transport.responseText;
          $('scrollleft').disabled = (batch == 1 )
          $('scrollright').disabled = ($$('div#myTable div.story').length < 5)
        }
      });
    }
    function scrollleft() {
      batch --;
      loadStories();
    }
    function scrollright() {
      batch ++;
      loadStories();
    }
    function selectVersion(versionSelected) {
      batch = 1;
      versionId = $F('version');
      if (console) { console.info("Selected version: " + versionId ); }
      loadStories();
    }
    new PeriodicalExecuter(function(pe) {
      if (autoscroll) {
        if (batch > 0) {
          if (console) {
            console.debug("Periodic update. Batch="+ batch)
          }
          batch = batch + 1;
          if ($$('div#myTable div.story').length < 5) {
            batch = 1;
          }
          loadStories();
          if ($$('div#myTable div.story').length == 0) {
            batch = 1;
            loadStories();
          }
        } else {
          $('mybody').innerHTML='Select Project and version to see something here!';
        }
      }
    }, 10);

    function toggleAutoscroll() {
      autoscroll = !autoscroll;
      $('autoscrolllink').innerHTML = 'Turn autoscroll ' + (autoscroll ? 'off' : 'on');
    }
  </script>
</head>
<body>
<div class="container">
  <div class="span-20">
    <h1>Save the PostIts</h1>
  </div>
  <div class="span-4 last">
    <div style="text-align: center" class="span-3">
      <a href="#" onclick="toggleAutoscroll();" id="autoscrolllink">Turn autoscroll off</a>
    </div>
    <div  class="span-4">
      <div class="span-2">
      <button onclick="scrollleft();" id="scrollleft">Left</button>
      </div>
      <div class="span-1">
      <button onclick="scrollright();" id="scrollright">Right</button>
      </div>
    </div>
  </div>
  <div class="span-24 last">
    <div class="span-5">
      <label for="project">Project</label>
      <select name="project" id="project"
          onchange="selectProject(this);" onblur="selectProject(this);"
          onclick="selectProject(this);" onkeyup="selectProject(this);">
        <option value="">Select one...</option>
        <c:forEach items="${projects}" var="project">
          <option value="${project.key}">${project.name}</option>
        </c:forEach>
      </select>
    </div>
    <div class="span-5">
      <label for="version">Version</label>
      <select name="version" id="version"
          onchange="selectVersion(this);" onclick="selectVersion(this);"
          onkeyup="selectVersion(this);" onblur="selectVersion(this);">
        <option value="">Select Project</option>
      </select>
    </div>
  </div>
  <hr/>
  <div class="span-24 last" id="mybody">
    &nbsp;
  </div>
  <hr/>
  <div class="span-24 last">
    Save the PostIts is a kanban like board for Jira. It cycles through all stories
    changing pages every 10 seconds. <a href="http://master/cdsng/savepostits/trunk">
    Blame the repository?</a>
  </div>
</div>

</body>
</html>