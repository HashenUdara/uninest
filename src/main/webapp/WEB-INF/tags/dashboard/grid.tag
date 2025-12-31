<%@ tag description="Grid container for cards" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="columns" required="false" %>
<div class="o-grid ${empty columns ? 'o-grid--cards' : columns == 'auto' ? 'o-grid--auto' : 'o-grid--cards'}">
  <jsp:doBody />
</div>
