<%@ tag description="Sub navigation link for collapsible groups" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="href" required="true" %>
<%@ attribute name="label" required="true" %>
<%@ attribute name="active" required="false" type="java.lang.Boolean" %>
<a href="${href}" class="c-nav__subitem ${active ? 'is-active' : ''}">
  ${label}
</a>
