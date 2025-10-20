<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>

<layout:moderator-dashboard pageTitle="Assign Coordinator" activePage="subjects">
    <script>
      document.addEventListener("DOMContentLoaded", function() {
        const form = document.getElementById("assign-form");
        const checkboxes = document.querySelectorAll('input[name="studentIds"]');
        const submitBtn = document.getElementById("submit-btn");
        
        function updateButtonState() {
          const anyChecked = Array.from(checkboxes).some(cb => cb.checked);
          submitBtn.disabled = !anyChecked;
        }
        
        checkboxes.forEach(cb => {
          cb.addEventListener("change", updateButtonState);
        });
        
        updateButtonState();
      });
    </script>

    <header class="c-page__header">
      <nav class="c-breadcrumbs" aria-label="Breadcrumb">
        <a href="${pageContext.request.contextPath}/moderator/dashboard">Moderator</a>
        <span class="c-breadcrumbs__sep">/</span>
        <a href="${pageContext.request.contextPath}/moderator/subjects">Subjects</a>
        <span class="c-breadcrumbs__sep">/</span>
        <a href="${pageContext.request.contextPath}/moderator/subject-coordinators?subjectId=${subject.subjectId}">Coordinators</a>
        <span class="c-breadcrumbs__sep">/</span>
        <span aria-current="page">Assign</span>
      </nav>
      <div class="c-page__titlebar">
        <div>
          <h1 class="c-page__title">Assign Coordinator</h1>
          <p class="c-page__subtitle u-text-muted">${subject.code} - ${subject.name}</p>
        </div>
      </div>
    </header>

    <section>
      <c:choose>
        <c:when test="${empty students}">
          <div class="o-panel" style="text-align: center; padding: var(--space-10);">
            <i data-lucide="users" style="width: 64px; height: 64px; color: var(--text-muted); margin-bottom: var(--space-4);"></i>
            <p class="u-text-muted" style="margin-bottom: var(--space-4);">No available students to assign as coordinators. All students are either already coordinators or not part of this community.</p>
            <a href="${pageContext.request.contextPath}/moderator/subject-coordinators?subjectId=${subject.subjectId}" class="c-btn c-btn--ghost">
              <i data-lucide="arrow-left"></i> Back to Coordinators
            </a>
          </div>
        </c:when>
        <c:otherwise>
          <form method="post" action="${pageContext.request.contextPath}/moderator/subject-coordinators/assign" id="assign-form">
            <input type="hidden" name="subjectId" value="${subject.subjectId}" />
            <input type="hidden" name="returnTo" value="${returnTo}" />
            
            <div class="c-table-toolbar">
              <div class="c-table-toolbar__left">
                <span class="u-text-muted">
                  Select one or more students to assign as coordinators for this subject
                </span>
              </div>
              <div class="c-table-toolbar__right">
                <a href="${pageContext.request.contextPath}/moderator/subject-coordinators?subjectId=${subject.subjectId}" class="c-btn c-btn--ghost">
                  Cancel
                </a>
                <button type="submit" class="c-btn c-btn--primary" id="submit-btn">
                  <i data-lucide="user-plus"></i> Assign Selected
                </button>
              </div>
            </div>
            
            <div class="c-table-wrap">
              <table class="c-table c-table--sticky" aria-label="Available Students">
                <thead>
                  <tr>
                    <th style="width: 50px;">
                      <input type="checkbox" id="select-all" aria-label="Select all students" />
                    </th>
                    <th>Student</th>
                    <th>Email</th>
                    <th>Academic Year</th>
                    <th>University</th>
                  </tr>
                </thead>
                <tbody>
                  <c:forEach items="${students}" var="student">
                    <tr>
                      <td>
                        <input type="checkbox" name="studentIds" value="${student.id}" aria-label="Select ${student.name != null ? student.name : student.email}" />
                      </td>
                      <td>
                        <div class="c-user-cell">
                          <span class="c-user-cell__avatar" aria-hidden="true"></span>
                          <div class="c-user-cell__meta">
                            <span class="c-user-cell__name">${student.name != null ? student.name : student.email}</span>
                            <span class="c-user-cell__sub u-text-muted">ID: ${student.id}</span>
                          </div>
                        </div>
                      </td>
                      <td>${student.email}</td>
                      <td>
                        <c:choose>
                          <c:when test="${not empty student.academicYear}">Year ${student.academicYear}</c:when>
                          <c:otherwise>-</c:otherwise>
                        </c:choose>
                      </td>
                      <td>
                        <c:choose>
                          <c:when test="${not empty student.universityName}">${student.universityName}</c:when>
                          <c:otherwise>-</c:otherwise>
                        </c:choose>
                      </td>
                    </tr>
                  </c:forEach>
                </tbody>
              </table>
            </div>
          </form>
          
          <script>
            // Select all functionality
            document.getElementById("select-all").addEventListener("change", function(e) {
              const checkboxes = document.querySelectorAll('input[name="studentIds"]');
              checkboxes.forEach(cb => cb.checked = e.target.checked);
              
              // Trigger change event to update button state
              const event = new Event('change');
              if (checkboxes.length > 0) checkboxes[0].dispatchEvent(event);
            });
          </script>
        </c:otherwise>
      </c:choose>
    </section>
</layout:moderator-dashboard>
