<%@ tag description="Section with title for dashboard content" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="title" required="true" %>
<section>
  <h2 class="c-section-title">${title}</h2>
  <jsp:doBody />
</section>
