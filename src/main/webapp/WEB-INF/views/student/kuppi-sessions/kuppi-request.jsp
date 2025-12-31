<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>

<layout:student-dashboard pageTitle="Kuppi Sessions" activePage="kuppi-sessions">
         <link rel="stylesheet" href="${pageContext.request.contextPath}/static/community.css" />
      
    <header class="c-page__header">
        <nav class="c-breadcrumbs" aria-label="Breadcrumb">
            <a href="${pageContext.request.contextPath}/student/dashboard">Home</a>
            <span class="c-breadcrumbs__sep">/</span>
            <a href="${pageContext.request.contextPath}/student/kuppi-sessions">Kuppi Sessions </a>
            <span class="c-breadcrumbs__sep">/</span>
            <span aria-current="page">Request Session</span>
        </nav>
       <div
            class="o-inline"
            style="
              display: flex;
              justify-content: space-between;
              align-items: center;
              gap: var(--space-4);
            "
          >
            <div>
              <h1 class="c-page__title">Request Kuppi Session</h1>
              <p class="c-page__subtitle u-text-muted">
                Organize a study session and invite your peers to join.
              </p>
            </div>
            <a href="${pageContext.request.contextPath}/student/kuppi-sessions" class="c-btn c-btn--ghost"
              ><i data-lucide="arrow-left"></i> Back to Sessions</a
            >
          </div>
          
        
    </header>

    <c:if test="${not empty error}">
        <div class="c-alert c-alert--danger" role="alert">
            <p>${error}</p>
        </div>
    </c:if>

       <section class="u-stack-4">
          <form
            id="kuppi-form"
            style="
              display: grid;
              grid-template-columns: 1fr 1fr;
              gap: var(--space-5);
            "
          >
            <h2
              class="c-section-title"
              style="margin-top: 0; grid-column: 1 / -1"
            >
              Session Details
            </h2>

            <!-- Subject -->
            <div class="c-field">
              <label for="subject" class="c-label"
                >Subject <span class="u-text-danger">*</span></label
              >
              <select
                id="subject"
                name="subject"
                class="c-input c-input--soft c-input--rect"
                required
              >
                <option value="">Select a subject</option>
                <option value="CS204">CS204 - Data Structures</option>
                <option value="CS301">CS301 - Algorithms</option>
                <option value="CS123">CS123 - Programming Fundamentals</option>
                <option value="CS205">CS205 - Operating Systems</option>
                <option value="MA201">MA201 - Calculus II</option>
                <option value="ENG101">ENG101 - English Composition</option>
                <option value="PHY110">PHY110 - Physics I</option>
              </select>
            </div>

            <!-- Topic -->
            <div class="c-field">
              <label for="topic" class="c-label"
                >Session Topic <span class="u-text-danger">*</span></label
              >
              <input
                id="topic"
                name="topic"
                class="c-input c-input--soft c-input--rect"
                type="text"
                placeholder="e.g., Binary Search Trees and Traversal"
                required
              />
            </div>

            <!-- Description -->
            <div class="c-field" style="grid-column: 1 / -1">
              <label for="description" class="c-label"
                >Description <span class="u-text-danger">*</span></label
              >
              <textarea
                id="description"
                name="description"
                class="c-textarea c-textarea--soft"
                rows="6"
                placeholder="Describe what will be covered in this session, any prerequisites, and what participants should prepare..."
                required
              ></textarea>
            </div>

            <!-- Tags -->
            <div class="c-field" style="grid-column: 1 / -1">
              <label for="tags" class="c-label"
                >Tags <span class="u-text-danger">*</span></label
              >
              <input
                id="tags"
                name="tags"
                class="c-input c-input--soft c-input--rect"
                type="text"
                placeholder="e.g., exam-prep, beginner-friendly, group-study"
                required
              />
              <small
                class="u-text-muted"
                style="display: block; margin-top: var(--space-2)"
              >
                Separate tags with commas
              </small>
            </div>

            <!-- Actions -->
            <div class="c-form-actions" style="grid-column: 1 / -1">
              <a  href="${pageContext.request.contextPath}/student/kuppi-sessions" class="c-btn c-btn--ghost" role="button">Cancel</a>
              <button class="c-btn" type="submit">
                <i data-lucide="check"></i> Submit Request
              </button>
            </div>
          </form>
        </section>
     <!-- Toast Container -->
    <div class="c-toasts" aria-live="polite"></div>

     <script>
      document.addEventListener("DOMContentLoaded", function () {
        if (window.lucide) window.lucide.createIcons();

        const form = document.getElementById("kuppi-form");
        const toasts = document.querySelector(".c-toasts");

        // Form submission
        form.addEventListener("submit", (e) => {
          e.preventDefault();

          // Basic validation
          if (!form.checkValidity()) {
            form.reportValidity();
            return;
          }

          // Get form data
          const formData = new FormData(form);
          const data = Object.fromEntries(formData.entries());

          console.log("Kuppi Session Request:", data);

          showToast("Kuppi session request submitted successfully!");

          // Reset form and redirect after delay
          setTimeout(() => {
            form.reset();
            // In real app, redirect to sessions list
            // window.location.href = "kuppi-sessions.html";
          }, 1500);
        });

        function showToast(msg) {
          if (!toasts) return;
          const item = document.createElement("div");
          item.className = "c-toast";
          item.textContent = msg;
          toasts.appendChild(item);
          setTimeout(() => {
            item.remove();
          }, 2500);
        }
      });
    </script>
</layout:student-dashboard>
