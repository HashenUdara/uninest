<%@ tag description="Card component for dashboard content" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="title" required="true" %>
<%@ attribute name="meta" required="false" %>
<%@ attribute name="mediaClass" required="false" %>
<article class="c-card">
  <div class="c-card__media ${not empty mediaClass ? mediaClass : ''}"></div>
  <div class="c-card__body">
    <h3 class="c-card__title">${title}</h3>
    <c:if test="${not empty meta}">
      <p class="c-card__meta">${meta}</p>
    </c:if>
  </div>
</article>
