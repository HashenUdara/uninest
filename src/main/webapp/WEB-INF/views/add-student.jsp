<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:dashboard-new title="Add Student" active="add" breadcrumb="Add Student">
  <jsp:body>
    <div class="c-section">
      <div class="c-card" style="max-width: 600px; margin: 0 auto;">
        <div class="c-card__body">
          <h2 class="c-card__title">Add New Student</h2>
          <p class="c-card__meta">Enter the student's information below</p>
          
          <form method="post" action="${pageContext.request.contextPath}/students/add" class="c-auth__form" style="margin-top: var(--space-6);">
            <div class="c-field">
              <label class="c-field__label" for="name">Full Name</label>
              <input 
                class="c-field__input" 
                id="name" 
                name="name" 
                type="text" 
                placeholder="Enter student's full name"
                required
              />
              <div class="c-field__error"></div>
            </div>
            
            <div class="c-field">
              <label class="c-field__label" for="email">Email Address</label>
              <input 
                class="c-field__input" 
                id="email" 
                name="email" 
                type="email" 
                placeholder="Enter student's email address"
                required
              />
              <div class="c-field__error"></div>
            </div>
            
            <div style="display: flex; gap: var(--space-3); margin-top: var(--space-6);">
              <button class="c-btn" type="submit">Add Student</button>
              <a href="${pageContext.request.contextPath}/students" class="c-btn c-btn--ghost">Cancel</a>
            </div>
          </form>
        </div>
      </div>
    </div>
  </jsp:body>
</layout:dashboard-new>
