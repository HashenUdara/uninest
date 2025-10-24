<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>

<layout:student-dashboard pageTitle="Kuppi Sessions" activePage="kuppi-sessions">
         <link rel="stylesheet" href="${pageContext.request.contextPath}/static/community.css" />
      <style>
      /* Form Container */
      .k-apply-container {
        max-width: 700px;
        margin: 0 auto;
      }

      .k-apply-card {
        background: var(--color-white);
        border: 1px solid var(--color-border);
        border-radius: var(--radius-lg);
        padding: var(--space-6);
        margin-bottom: var(--space-6);
      }

      .k-apply-header {
        margin-bottom: var(--space-6);
        padding-bottom: var(--space-5);
        border-bottom: 1px solid var(--color-border);
      }

      .k-apply-header__icon {
        width: 48px;
        height: 48px;
        background: var(--color-brand-soft);
        border-radius: var(--radius-lg);
        display: flex;
        align-items: center;
        justify-content: center;
        color: var(--color-brand);
        margin-bottom: var(--space-4);
      }

      .k-apply-header__title {
        font-size: 1.5rem;
        font-weight: 700;
        color: var(--color-text);
        margin: 0 0 var(--space-2) 0;
      }

      .k-apply-header__subtitle {
        font-size: var(--fs-base);
        color: var(--color-text-muted);
        margin: 0;
        line-height: 1.6;
      }

      /* Session Info */
      .k-session-info {
        background: var(--color-surface);
        border: 1px solid var(--color-border);
        border-radius: var(--radius-md);
        padding: var(--space-4);
        margin-bottom: var(--space-6);
      }

      .k-session-info__label {
        font-size: var(--fs-xs);
        text-transform: uppercase;
        letter-spacing: 0.5px;
        color: var(--color-text-muted);
        font-weight: 600;
        margin-bottom: var(--space-2);
      }

      .k-session-info__title {
        font-size: var(--fs-lg);
        font-weight: 600;
        color: var(--color-text);
        margin: 0 0 var(--space-2) 0;
      }

      .k-session-info__meta {
        display: flex;
        align-items: center;
        gap: var(--space-3);
        font-size: var(--fs-sm);
        color: var(--color-text-muted);
      }

      .k-session-info__subject {
        display: inline-flex;
        align-items: center;
        background: var(--color-brand-soft);
        color: var(--color-brand);
        padding: var(--space-1) var(--space-3);
        border-radius: var(--radius-pill);
        font-size: var(--fs-xs);
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.5px;
      }

      /* Form */
      .k-form {
        display: flex;
        flex-direction: column;
        gap: var(--space-5);
      }

      .k-form__group {
        display: flex;
        flex-direction: column;
        gap: var(--space-2);
      }

      .k-form__label {
        font-size: var(--fs-sm);
        font-weight: 600;
        color: var(--color-text);
        display: flex;
        align-items: center;
        gap: var(--space-2);
      }

      .k-form__label--required::after {
        content: "*";
        color: var(--color-danger);
        margin-left: var(--space-1);
      }

      .k-form__hint {
        font-size: var(--fs-sm);
        color: var(--color-text-muted);
        margin-top: calc(-1 * var(--space-1));
      }

      .k-form__input,
      .k-form__textarea,
      .k-form__select {
        width: 100%;
        padding: var(--space-3);
        border: 1px solid var(--color-border);
        border-radius: var(--radius-md);
        font-family: var(--font-sans);
        font-size: var(--fs-base);
        color: var(--color-text);
        transition: all 0.2s;
      }

      .k-form__input:focus,
      .k-form__textarea:focus,
      .k-form__select:focus {
        outline: none;
        border-color: var(--color-brand);
        box-shadow: 0 0 0 3px rgba(84, 44, 245, 0.1);
      }

      .k-form__textarea {
        min-height: 120px;
        resize: vertical;
      }

      .k-form__checkbox-group {
        display: flex;
        flex-direction: column;
        gap: var(--space-3);
      }

      .k-form__checkbox-item {
        display: flex;
        align-items: flex-start;
        gap: var(--space-3);
        padding: var(--space-3);
        background: var(--color-surface);
        border: 1px solid var(--color-border);
        border-radius: var(--radius-md);
        cursor: pointer;
        transition: all 0.2s;
      }

      .k-form__checkbox-item:hover {
        background: var(--color-white);
        border-color: var(--color-brand);
      }

      .k-form__checkbox {
        width: 20px;
        height: 20px;
        border: 2px solid var(--color-border);
        border-radius: 4px;
        flex-shrink: 0;
        cursor: pointer;
        margin-top: 2px;
      }

      .k-form__checkbox:checked {
        accent-color: var(--color-brand);
      }

      .k-form__checkbox-content {
        flex: 1;
      }

      .k-form__checkbox-label {
        font-size: var(--fs-base);
        font-weight: 600;
        color: var(--color-text);
        margin: 0 0 var(--space-1) 0;
        cursor: pointer;
      }

      .k-form__checkbox-description {
        font-size: var(--fs-sm);
        color: var(--color-text-muted);
        margin: 0;
      }

      /* Time Slots */
      .k-time-slots {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(140px, 1fr));
        gap: var(--space-2);
      }

      .k-time-slot {
        display: flex;
        align-items: center;
        gap: var(--space-2);
        padding: var(--space-3);
        background: var(--color-surface);
        border: 1px solid var(--color-border);
        border-radius: var(--radius-md);
        cursor: pointer;
        transition: all 0.2s;
        font-size: var(--fs-sm);
        color: var(--color-text);
      }

      .k-time-slot:hover {
        background: var(--color-white);
        border-color: var(--color-brand);
      }

      .k-time-slot input[type="checkbox"] {
        width: 18px;
        height: 18px;
        cursor: pointer;
      }

      .k-time-slot input[type="checkbox"]:checked {
        accent-color: var(--color-brand);
      }

      /* Character Count */
      .k-form__char-count {
        font-size: var(--fs-xs);
        color: var(--color-text-muted);
        text-align: right;
        margin-top: calc(-1 * var(--space-1));
      }

      /* Info Box */
      .k-info-box {
        background: var(--color-brand-soft);
        border: 1px solid var(--color-brand);
        border-radius: var(--radius-md);
        padding: var(--space-4);
        display: flex;
        gap: var(--space-3);
        margin-bottom: var(--space-5);
      }

      .k-info-box__icon {
        width: 20px;
        height: 20px;
        color: var(--color-brand);
        flex-shrink: 0;
        margin-top: 2px;
      }

      .k-info-box__content {
        flex: 1;
      }

      .k-info-box__title {
        font-size: var(--fs-sm);
        font-weight: 600;
        color: var(--color-brand);
        margin: 0 0 var(--space-1) 0;
      }

      .k-info-box__text {
        font-size: var(--fs-sm);
        color: var(--color-text);
        margin: 0;
        line-height: 1.5;
      }

      /* Actions */
      .k-form__actions {
        display: flex;
        gap: var(--space-3);
        padding-top: var(--space-5);
        border-top: 1px solid var(--color-border);
      }

      .k-form__actions .c-btn {
        flex: 1;
      }

      @media (max-width: 640px) {
        .k-time-slots {
          grid-template-columns: 1fr;
        }

        .k-form__actions {
          flex-direction: column-reverse;
        }

        .k-form__actions .c-btn {
          width: 100%;
        }
      }
    </style>
    <header class="c-page__header">
        <nav class="c-breadcrumbs" aria-label="Breadcrumb">
            <a href="${pageContext.request.contextPath}/student/dashboard">Home</a>
            <span class="c-breadcrumbs__sep">/</span>
            <a href="${pageContext.request.contextPath}/student/kuppi-sessions">Kuppi Sessions </a>
            <span class="c-breadcrumbs__sep">/</span>
            <span aria-current="page">Apply to Be a Conductor</span>
        </nav>
        <div
            style="
              display: flex;
              justify-content: space-between;
              align-items: center;
              gap: var(--space-4);
            "
          >
            <div>
              <h1 class="c-page__title">Apply to Be a Conductor</h1>
              <p class="c-page__subtitle u-text-muted">
                Lead engaging study sessions and help your peers excel.
              </p>
            </div>
            <a href="${pageContext.request.contextPath}/student/kuppi-sessions" class="c-btn c-btn--ghost"
              ><i data-lucide="arrow-left"></i> Back to Session</a
            >
          </div>
          
        
    </header>

    <c:if test="${not empty error}">
        <div class="c-alert c-alert--danger" role="alert">
            <p>${error}</p>
        </div>
    </c:if>

     <div class="k-apply-container">
          <!-- Session Info -->
          <div class="k-session-info">
            <div class="k-session-info__label">Applying for Session</div>
            <h2 class="k-session-info__title">
              Binary Search Trees and Traversal Techniques
            </h2>
            <div class="k-session-info__meta">
              <span class="k-session-info__subject">CS204</span>
              <span>•</span>
              <span>Requested by Kasun Perera</span>
              <span>•</span>
              <span>24 votes</span>
            </div>
          </div>

          <!-- Info Box -->
          <div class="k-info-box">
            <i data-lucide="info" class="k-info-box__icon"></i>
            <div class="k-info-box__content">
              <h3 class="k-info-box__title">About Being a Conductor</h3>
              <p class="k-info-box__text">
                As a conductor, you'll lead this Kuppi session and help fellow
                students learn together. Students will vote on conductors, and
                the most popular choice will host the session. It's
                collaborative learning!
              </p>
            </div>
          </div>

          <!-- Application Form -->
          <div class="k-apply-card">
            <div class="k-apply-header">
              <div class="k-apply-header__icon">
                <i data-lucide="hand" style="width: 24px; height: 24px"></i>
              </div>
              <h2 class="k-apply-header__title">Conductor Application</h2>
              <p class="k-apply-header__subtitle">
                Share why you'd like to conduct this session. Keep it simple –
                just tell us your interest and availability!
              </p>
            </div>

            <form class="k-form" id="conductor-form">
              <!-- Why You Want to Conduct -->
              <div class="k-form__group">
                <label
                  for="message"
                  class="k-form__label k-form__label--required"
                >
                  <i
                    data-lucide="message-square"
                    style="width: 16px; height: 16px"
                  ></i>
                  Why do you want to conduct this session?
                </label>
                <textarea
                  id="message"
                  name="message"
                  class="k-form__textarea"
                  placeholder="Share your interest in this topic and how you can help others learn..."
                  required
                  maxlength="300"
                  style="min-height: 100px"
                ></textarea>
                <div class="k-form__char-count">
                  <span id="message-count">0</span>/300 characters
                </div>
              </div>

              <!-- Availability -->
              <div class="k-form__group">
                <label class="k-form__label k-form__label--required">
                  <i data-lucide="clock" style="width: 16px; height: 16px"></i>
                  When are you available?
                </label>
                <p class="k-form__hint">
                  Select all time slots when you can conduct this session
                </p>
                <div class="k-time-slots">
                  <label class="k-time-slot">
                    <input
                      type="checkbox"
                      name="availability"
                      value="weekday-morning"
                    />
                    <span>Weekday Mornings</span>
                  </label>
                  <label class="k-time-slot">
                    <input
                      type="checkbox"
                      name="availability"
                      value="weekday-afternoon"
                    />
                    <span>Weekday Afternoons</span>
                  </label>
                  <label class="k-time-slot">
                    <input
                      type="checkbox"
                      name="availability"
                      value="weekday-evening"
                    />
                    <span>Weekday Evenings</span>
                  </label>
                  <label class="k-time-slot">
                    <input
                      type="checkbox"
                      name="availability"
                      value="weekend-morning"
                    />
                    <span>Weekend Mornings</span>
                  </label>
                  <label class="k-time-slot">
                    <input
                      type="checkbox"
                      name="availability"
                      value="weekend-afternoon"
                    />
                    <span>Weekend Afternoons</span>
                  </label>
                  <label class="k-time-slot">
                    <input
                      type="checkbox"
                      name="availability"
                      value="weekend-evening"
                    />
                    <span>Weekend Evenings</span>
                  </label>
                </div>
              </div>

              <!-- Actions -->
              <div class="k-form__actions">
                <a href="${pageContext.request.contextPath}/student/kuppi-sessions" class="c-btn c-btn--ghost">
                  Cancel
                </a>
                <button type="submit" class="c-btn">
                  <i data-lucide="send"></i>
                  Submit Application
                </button>
              </div>
            </form>
          </div>
        </div>

    <!-- Toast Container -->
    <div class="c-toasts" aria-live="polite"></div>

    <script>
      document.addEventListener("DOMContentLoaded", function () {
        if (window.lucide) window.lucide.createIcons();

        const form = document.getElementById("conductor-form");
        const messageTextarea = document.getElementById("message");
        const messageCount = document.getElementById("message-count");
        const toasts = document.querySelector(".c-toasts");

        // Character counter
        messageTextarea.addEventListener("input", () => {
          messageCount.textContent = messageTextarea.value.length;
        });

        // Form submission
        form.addEventListener("submit", (e) => {
          e.preventDefault();

          // Validate availability
          const availabilityChecked = document.querySelectorAll(
            'input[name="availability"]:checked'
          );
          if (availabilityChecked.length === 0) {
            showToast("Please select at least one availability time slot");
            return;
          }

          // Collect form data
          const formData = {
            message: messageTextarea.value,
            availability: Array.from(availabilityChecked).map((cb) => cb.value),
          };

          console.log("Application submitted:", formData);

          // Show success message
          showToast("Application submitted successfully!");

          // Redirect after delay
          setTimeout(() => {
            window.location.href = "kuppi-session-detail.html";
          }, 1500);
        });

        // Toast notification
        function showToast(msg) {
          if (!toasts) return;
          const item = document.createElement("div");
          item.className = "c-toast";
          item.textContent = msg;
          toasts.appendChild(item);
          setTimeout(() => {
            item.remove();
          }, 3000);
        }
      });
    </script>
</layout:student-dashboard>
