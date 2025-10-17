<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:admin-dashboard pageTitle="Add Student" activePage="students">
  <jsp:body>
    <form class="c-form" method="post" action="${pageContext.request.contextPath}/students/add">
      <div class="c-form-card">
        <div class="c-field">
          <label class="c-field__label" for="student-name">Name</label>
          <input class="c-field__input" id="student-name" name="name" type="text" required />
          <div class="c-field__error"></div>
        </div>

        <div class="c-field">
          <label class="c-field__label" for="student-email">Email</label>
          <input class="c-field__input" id="student-email" name="email" type="email" required />
          <div class="c-field__error"></div>
        </div>

        <div class="c-form-actions">
          <a class="c-btn c-btn--ghost" href="${pageContext.request.contextPath}/students">Cancel</a>
          <button type="submit" class="c-btn">Save Student</button>
        </div>
      </div>
    </form>
  </jsp:body>
</layout:admin-dashboard>
