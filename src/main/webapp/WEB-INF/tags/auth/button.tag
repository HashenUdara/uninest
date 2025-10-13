<%@ tag description="Primary button component" pageEncoding="UTF-8" %>
<%@ attribute name="text" required="true" %>
<%@ attribute name="type" required="false" %>
<button type="${type != null ? type : 'submit'}" class="c-btn c-btn--primary c-auth__submit">
  ${text}
</button>
