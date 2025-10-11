<%@ tag description="Form field component" pageEncoding="UTF-8" %>
<%@ attribute name="id" required="true" %>
<%@ attribute name="name" required="true" %>
<%@ attribute name="label" required="true" %>
<%@ attribute name="type" required="false" %>
<%@ attribute name="placeholder" required="false" %>
<%@ attribute name="required" required="false" type="java.lang.Boolean" %>
<%@ attribute name="autocomplete" required="false" %>
<%@ attribute name="minlength" required="false" %>
<%@ attribute name="value" required="false" %>
<%@ attribute name="autofocus" required="false" type="java.lang.Boolean" %>
<div class="c-field">
  <label for="${id}" class="c-field__label">${label}</label>
  <input
    type="${type != null ? type : 'text'}"
    id="${id}"
    name="${name}"
    class="c-field__input"
    placeholder="${placeholder != null ? placeholder : ''}"
    ${required ? 'required' : ''}
    ${autocomplete != null ? 'autocomplete="'.concat(autocomplete).concat('"') : ''}
    ${minlength != null ? 'minlength="'.concat(minlength).concat('"') : ''}
    ${value != null ? 'value="'.concat(value).concat('"') : ''}
    ${autofocus ? 'autofocus' : ''}
  />
  <p
    class="c-field__error"
    data-error-for="${id}"
    aria-live="polite"
  ></p>
</div>
