<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>

<layout:admin-dashboard pageTitle="Students" activePage="students">
  <header class="c-page__header">
    <nav class="c-breadcrumbs" aria-label="Breadcrumb">
      <a href="${pageContext.request.contextPath}/admin/dashboard">Admin</a>
      <span class="c-breadcrumbs__sep">/</span>
      <span aria-current="page">Students</span>
    </nav>
    <div class="c-page__titlebar">
      <div>
        <h1 class="c-page__title">Students</h1>
        <p class="c-page__subtitle u-text-muted">Manage student accounts and their communities.</p>
      </div>
      <a class="c-btn" href="${pageContext.request.contextPath}/admin/students/add">
        <i data-lucide="plus"></i> Add Student
      </a>
    </div>
    <form method="get" action="${pageContext.request.contextPath}/admin/students" class="c-input-group">
      <div class="c-input-icon">
        <span class="c-input-icon__icon"><i data-lucide="search"></i></span>
        <input class="c-input" name="search" placeholder="Search students by email or university" value="${searchTerm}" />
      </div>
      <button type="submit" class="c-btn c-btn--secondary">
        <span class="c-btn__icon"><i data-lucide="search"></i></span>
        Search
      </button>
      <c:if test="${not empty searchTerm}">
        <a href="${pageContext.request.contextPath}/admin/students" class="c-btn c-btn--ghost">Clear</a>
      </c:if>
    </form>
  </header>

  <section>
    <c:if test="${param.success == 'added'}">
      <div class="c-alert c-alert--success" role="alert">
        <i data-lucide="check-circle"></i>
        <span>Student added successfully!</span>
      </div>
    </c:if>
    <c:if test="${param.success == 'updated'}">
      <div class="c-alert c-alert--success" role="alert">
        <i data-lucide="check-circle"></i>
        <span>Student updated successfully!</span>
      </div>
    </c:if>
    <c:if test="${param.success == 'deleted'}">
      <div class="c-alert c-alert--success" role="alert">
        <i data-lucide="check-circle"></i>
        <span>Student deleted successfully!</span>
      </div>
    </c:if>

    <div class="c-table-toolbar">
      <div class="c-table-toolbar__left">
        <span class="u-text-muted">
          <span class="js-student-count">${students.size()}</span> students
        </span>
      </div>
    </div>
    <div class="c-table-wrap">
      <table class="c-table c-table--sticky" aria-label="Students" id="students-table">
        <thead>
          <tr>
            <th>Student</th>
            <th>Email</th>
            <th>Academic Year</th>
            <th>University</th>
            <th>Community</th>
            <th class="u-text-right">Actions</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach items="${students}" var="student">
            <tr>
              <td>
                <div class="c-user-cell">
                  <span class="c-user-cell__avatar" aria-hidden="true"></span>
                  <div class="c-user-cell__meta">
                    <span class="c-user-cell__name">${student.email}</span>
                    <span class="c-user-cell__sub u-text-muted">ID: U-${student.id}</span>
                  </div>
                </div>
              </td>
              <td>${student.email}</td>
              <td>
                <c:choose>
                  <c:when test="${not empty student.academicYear}">
                    <span class="c-badge">Year ${student.academicYear}</span>
                  </c:when>
                  <c:otherwise>
                    <span class="u-text-muted">N/A</span>
                  </c:otherwise>
                </c:choose>
              </td>
              <td>
                <c:choose>
                  <c:when test="${not empty student.university}">
                    ${student.university}
                  </c:when>
                  <c:otherwise>
                    <span class="u-text-muted">N/A</span>
                  </c:otherwise>
                </c:choose>
              </td>
              <td>
                <c:choose>
                  <c:when test="${not empty student.communityName}">
                    ${student.communityName}
                  </c:when>
                  <c:otherwise>
                    <span class="u-text-muted">Not assigned</span>
                  </c:otherwise>
                </c:choose>
              </td>
              <td class="u-text-right">
                <div class="c-table-actions">
                  <a class="c-icon-btn" aria-label="Edit student" href="${pageContext.request.contextPath}/admin/students/edit?id=${student.id}">
                    <i data-lucide="pencil"></i>
                  </a>
                  <button class="c-icon-btn js-delete-student" aria-label="Delete student" data-id="${student.id}">
                    <i data-lucide="trash"></i>
                  </button>
                </div>
              </td>
            </tr>
          </c:forEach>
          <c:if test="${students.size() == 0}">
            <tr>
              <td colspan="6" class="u-text-center u-text-muted">No students found</td>
            </tr>
          </c:if>
        </tbody>
      </table>
    </div>
  </section>

  <!-- Confirm Modal -->
  <div class="c-modal" id="confirm-modal" role="dialog" aria-modal="true" aria-labelledby="confirm-title" hidden>
    <div class="c-modal__backdrop" data-close></div>
    <div class="c-modal__dialog">
      <div class="c-modal__header">
        <h3 id="confirm-title">Delete Student</h3>
      </div>
      <div class="c-modal__body">
        <p>Are you sure you want to delete this student? This action cannot be undone.</p>
      </div>
      <div class="c-modal__footer">
        <button class="c-btn c-btn--ghost" data-close>Cancel</button>
        <form method="post" action="${pageContext.request.contextPath}/admin/students/delete" id="delete-form" style="display:inline">
          <input type="hidden" name="id" id="delete-id" />
          <button type="submit" class="c-btn c-btn--danger">Delete</button>
        </form>
      </div>
    </div>
  </div>

  <div class="c-toasts" aria-live="polite" aria-atomic="true"></div>

  <jsp:attribute name="scripts">
    <script>
      // Delete confirmation handler
      document.querySelectorAll('.js-delete-student').forEach(btn => {
        btn.addEventListener('click', function() {
          const id = this.dataset.id;
          document.getElementById('delete-id').value = id;
          const modal = document.getElementById('confirm-modal');
          modal.hidden = false;
        });
      });

      // Modal close handlers
      document.querySelectorAll('[data-close]').forEach(btn => {
        btn.addEventListener('click', function() {
          const modal = document.getElementById('confirm-modal');
          modal.hidden = true;
        });
      });
    </script>
  </jsp:attribute>
</layout:admin-dashboard>
