<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
{
  "versionList": {
    "versions": [
      <c:forEach items="${versions}" var="version" varStatus="status">{ "id":"${version.id}","label":"${version.name}" }
        <c:if test="${!status.last}">,</c:if>
      </c:forEach>
    ]
  }
}