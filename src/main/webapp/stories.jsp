<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<div id="myTable" class="span-24">
  <div class="span-24">
    <div class="span-24">
      <div id="stories" class="span-24">
        <div class="span-3">
          &nbsp;
        </div>
        <c:forEach items="${stories}" var="story" varStatus="status">
          <div class="span-4 story ${story.status}">
            <p>
              <span><strong>${story.key}: </strong></span> ${story.summary}<br/>
              <span><strong>${story.status}</strong></span>
              &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>/
              <c:forEach items="${story.customFieldValues}" var="customFieldValue">
                <c:if test="${'customfield_10042' == customFieldValue.customfieldId}">
                  <c:forEach items="${customFieldValue.values}" var="value">
                    ${value}
                  </c:forEach>
                </c:if>
              </c:forEach>
              </i>
            </p>
            <p>
              <span class="${story.environment} user">
                <i>${fn:replace(story.assignee, "@certifydatasystems.com", "")}</i>
              </span>
            </p>
          </div>
        </c:forEach>
      </div>
    </div>
  </div>
  <hr/>
  <div class="span-24">
    <div class="span-24">
      <div id="stories" class="span-24">
        <div class="span-3">
          <h3>Not started</h3>
        </div>
        <c:forEach items="${stories}" var="story" varStatus="status">
          <div class="span-4 storyDetail">
            <c:forEach items="${tasks}" var="task">
              <c:if test="${story.key == task.parentKey}">
                <c:if test="${task.status == 'Open'}">
                  <div class="span-1">
                    <img src="post-it-note-l.jpg" width="30px" />
                  </div>
                </c:if>
                <c:if test="${task.status == 'Reopened'}">
                  <div class="span-1">
                    <img src="post-it-note-l.jpg" width="30px" />
                  </div>
                </c:if>
              </c:if>
            </c:forEach>
            &nbsp;
          </div>
        </c:forEach>
      </div>
    </div>
  </div>
  <hr/>
  <div class="span-24">
    <div class="span-24">
      <div id="stories" class="span-24">
        <div class="span-3">
          <h3>In progress</h3>
        </div>
        <c:forEach items="${stories}" var="story" varStatus="status">
          <div class="span-4 storyDetail">
            <c:forEach items="${tasks}" var="task">
              <c:if test="${story.key == task.parentKey}">
                <c:if test="${task.status == 'In Progress'}">
                  <div class="span-1">
                    <img src="post-it-note-l.jpg" width="30px" />
                  </div>
                </c:if>
              </c:if>
            </c:forEach>
            &nbsp;
          </div>
        </c:forEach>
      </div>
    </div>
  </div>
  <hr/>
  <div class="span-24">
    <div class="span-24">
      <div id="stories" class="span-24">
        <div class="span-3">
          <h3>To Verify</h3>
        </div>
        <c:forEach items="${stories}" var="story" varStatus="status">
          <div class="span-4 storyDetail">
            <c:forEach items="${tasks}" var="task">
              <c:if test="${story.key == task.parentKey}">
                <c:if test="${task.status == 'Resolved'}">
                  <div class="span-1">
                    <img src="post-it-note-l.jpg" width="30px" />
                  </div>
                </c:if>
              </c:if>
            </c:forEach>
            &nbsp;
          </div>
        </c:forEach>
      </div>
    </div>
  </div>
  <hr/>
  <div class="span-24">
    <div class="span-24">
      <div id="stories" class="span-24">
        <div class="span-3">
          <h3>Done</h3>
        </div>
        <c:forEach items="${stories}" var="story" varStatus="status">
          <div class="span-4 storyDetail">
            <c:forEach items="${tasks}" var="task">
              <c:if test="${story.key == task.parentKey}">
                <c:if test="${task.status == 'Closed'}">
                  <div class="span-1">
                    <img src="post-it-note-l.jpg" width="30px" />
                  </div>
                </c:if>
              </c:if>
            </c:forEach>
            &nbsp;
          </div>
        </c:forEach>
      </div>
    </div>
  </div>
</div>
