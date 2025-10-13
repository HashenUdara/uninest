<%@ tag description="Auth link component" pageEncoding="UTF-8" %>
<%@ attribute name="href" required="true" %>
<%@ attribute name="text" required="true" %>
<%@ attribute name="muted" required="false" type="java.lang.Boolean" %>
<a href="${href}" class="c-link ${muted ? 'c-link--muted' : ''}">${text}</a>
