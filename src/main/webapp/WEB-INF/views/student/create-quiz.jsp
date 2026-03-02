<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>

<layout:student-dashboard pageTitle="Quiz" activePage="quizzes">
     
           <style>
      .quiz-container {
        max-width: 1200px;
        margin: 0 auto;
        display: grid;
        grid-template-columns: 1fr 320px;
        gap: var(--space-6);
        align-items: start;
      }

      .quiz-main {
        min-width: 0;
      }

      .quiz-sidebar {
        position: sticky;
        top: var(--space-6);
      }

      .quiz-form-card {
        background: var(--color-white);
        border: 1px solid var(--color-border);
        border-radius: var(--radius-xl);
        padding: var(--space-8);
        margin-bottom: var(--space-6);
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.02);
      }

      .quiz-form-header {
        display: flex;
        align-items: flex-start;
        justify-content: space-between;
        margin-bottom: var(--space-8);
        padding-bottom: var(--space-6);
        border-bottom: 2px solid var(--color-surface);
      }

      .quiz-form-header-content h2 {
        font-size: var(--fs-2xl);
        font-weight: 700;
        color: var(--color-text);
        margin: 0 0 var(--space-2) 0;
        letter-spacing: -0.03em;
      }

      .quiz-form-header-content p {
        font-size: var(--fs-sm);
        color: var(--color-text-muted);
        margin: 0;
        line-height: 1.6;
      }

      .section-badge {
        display: inline-flex;
        align-items: center;
        gap: var(--space-2);
        padding: var(--space-2) var(--space-4);
        background: linear-gradient(
          135deg,
          rgba(84, 44, 245, 0.1) 0%,
          rgba(84, 44, 245, 0.05) 100%
        );
        border: 1px solid rgba(84, 44, 245, 0.2);
        border-radius: var(--radius-full);
        font-size: var(--fs-xs);
        font-weight: 600;
        color: var(--color-brand);
        white-space: nowrap;
      }

      .section-badge i {
        width: 14px;
        height: 14px;
      }

      .questions-section {
        margin-bottom: var(--space-6);
      }

      .questions-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-bottom: var(--space-6);
        padding: var(--space-5) var(--space-6);
        background: var(--color-surface);
        border-radius: var(--radius-lg);
        border: 2px solid var(--color-brand);
      }

      .questions-header h3 {
        font-size: var(--fs-lg);
        font-weight: 700;
        color: var(--color-text);
        margin: 0;
        letter-spacing: -0.01em;
      }

      .questions-count {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        min-width: 32px;
        height: 32px;
        padding: 0 var(--space-3);
        background: var(--color-brand);
        color: white;
        border-radius: var(--radius-full);
        font-size: var(--fs-sm);
        font-weight: 700;
      }

      .question-card {
        background: var(--color-white);
        border: 2px solid var(--color-border);
        border-radius: var(--radius-xl);
        padding: 0;
        margin-bottom: var(--space-5);
        transition: all 0.3s ease;
        overflow: hidden;
      }

      .question-card:hover {
        border-color: var(--color-brand);
        box-shadow: 0 8px 24px rgba(84, 44, 245, 0.12);
        transform: translateY(-2px);
      }

      .question-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: var(--space-6);
        background: linear-gradient(
          135deg,
          var(--color-surface) 0%,
          rgba(84, 44, 245, 0.02) 100%
        );
        border-bottom: 2px solid var(--color-border);
      }

      .question-number {
        display: flex;
        align-items: center;
        gap: var(--space-4);
        font-size: var(--fs-lg);
        font-weight: 700;
        color: var(--color-text);
        letter-spacing: -0.01em;
      }

      .question-badge {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        width: 48px;
        height: 48px;
        background: linear-gradient(
          135deg,
          var(--color-brand) 0%,
          #6d4ef7 100%
        );
        color: white;
        border-radius: var(--radius-lg);
        font-weight: 700;
        font-size: var(--fs-lg);
        box-shadow: 0 4px 12px rgba(84, 44, 245, 0.25);
      }

      .question-content {
        padding: var(--space-6) var(--space-8);
      }

      .question-actions {
        display: flex;
        gap: var(--space-2);
      }

      .btn-icon {
        width: 40px;
        height: 40px;
        padding: 0;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        border: 1.5px solid var(--color-border);
        background: var(--color-white);
        border-radius: var(--radius-lg);
        color: var(--color-text-muted);
        cursor: pointer;
        transition: all 0.25s ease;
      }

      .btn-icon:hover {
        background: #ef4444;
        border-color: #ef4444;
        color: white;
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(239, 68, 68, 0.3);
      }

      .btn-icon i {
        width: 18px;
        height: 18px;
      }

      .answer-options-wrapper {
        background: var(--color-surface);
        border-radius: var(--radius-lg);
        padding: var(--space-5);
        margin-bottom: var(--space-5);
      }

      .answer-option {
        display: flex;
        align-items: center;
        gap: var(--space-4);
        margin-bottom: var(--space-3);
        padding: var(--space-4);
        background: var(--color-white);
        border: 2px solid var(--color-border);
        border-radius: var(--radius-lg);
        transition: all 0.25s ease;
        position: relative;
      }

      .answer-option:last-child {
        margin-bottom: 0;
      }

      .answer-option:hover {
        border-color: var(--color-brand);
        box-shadow: 0 2px 8px rgba(84, 44, 245, 0.1);
        transform: translateX(4px);
      }

      .answer-option.is-correct {
        background: rgba(16, 185, 129, 0.05);
        border-color: #10b981;
      }

      .answer-option input[type="text"] {
        flex: 1;
        padding: var(--space-3) var(--space-4);
        border: 1.5px solid var(--color-border);
        background: var(--color-white);
        border-radius: var(--radius-md);
        font-size: var(--fs-base);
        transition: all 0.2s ease;
      }

      .answer-option input[type="text"]:focus {
        outline: none;
        border-color: var(--color-brand);
        box-shadow: 0 0 0 4px rgba(84, 44, 245, 0.08);
      }

      .answer-option input[type="radio"] {
        width: 22px;
        height: 22px;
        cursor: pointer;
        accent-color: var(--color-brand);
        flex-shrink: 0;
      }

      .answer-label {
        display: flex;
        align-items: center;
        justify-content: center;
        width: 40px;
        height: 40px;
        background: var(--color-white);
        border: 2px solid var(--color-border);
        border-radius: 50%;
        font-weight: 700;
        font-size: var(--fs-base);
        color: var(--color-text);
        flex-shrink: 0;
      }

      .btn-add-option {
        display: flex;
        align-items: center;
        gap: var(--space-3);
        padding: var(--space-4) var(--space-5);
        border: 2px dashed var(--color-border);
        background: transparent;
        border-radius: var(--radius-lg);
        font-size: var(--fs-base);
        font-weight: 600;
        color: var(--color-text-muted);
        cursor: pointer;
        transition: all 0.25s ease;
        width: 100%;
        justify-content: center;
        margin-top: var(--space-2);
      }

      .btn-add-option:hover {
        border-color: var(--color-brand);
        border-style: solid;
        background: rgba(84, 44, 245, 0.05);
        color: var(--color-brand);
        transform: translateY(-2px);
      }

      .btn-add-option i {
        width: 18px;
        height: 18px;
      }

      .btn-add-question {
        display: flex;
        align-items: center;
        gap: var(--space-4);
        padding: var(--space-6);
        border: 2px dashed var(--color-border);
        background: var(--color-white);
        border-radius: var(--radius-xl);
        font-size: var(--fs-lg);
        font-weight: 700;
        color: var(--color-text);
        cursor: pointer;
        transition: all 0.3s ease;
        width: 100%;
        justify-content: center;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.02);
      }

      .btn-add-question:hover {
        border-color: var(--color-brand);
        border-style: solid;
        background: var(--color-brand);
        color: white;
        transform: translateY(-4px);
        box-shadow: 0 8px 20px rgba(84, 44, 245, 0.25);
      }

      .btn-add-question i {
        width: 24px;
        height: 24px;
      }

      /* Sidebar Styles */
      .progress-card {
        background: var(--color-white);
        border: 1px solid var(--color-border);
        border-radius: var(--radius-xl);
        padding: var(--space-6);
        margin-bottom: var(--space-4);
      }

      .progress-card h3 {
        font-size: var(--fs-base);
        font-weight: 600;
        color: var(--color-text);
        margin: 0 0 var(--space-5) 0;
        display: flex;
        align-items: center;
        gap: var(--space-2);
      }

      .progress-card h3 i {
        width: 18px;
        height: 18px;
        color: var(--color-brand);
      }

      .progress-item {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: var(--space-3) 0;
        border-bottom: 1px solid var(--color-surface);
      }

      .progress-item:last-child {
        border-bottom: none;
      }

      .progress-label {
        font-size: var(--fs-sm);
        color: var(--color-text-muted);
      }

      .progress-value {
        font-size: var(--fs-base);
        font-weight: 700;
        color: var(--color-text);
      }

      .progress-value.is-complete {
        color: #10b981;
      }

      .progress-value.is-incomplete {
        color: #f59e0b;
      }

      .tips-card {
        background: linear-gradient(
          135deg,
          rgba(84, 44, 245, 0.05) 0%,
          rgba(84, 44, 245, 0.02) 100%
        );
        border: 1px solid rgba(84, 44, 245, 0.1);
        border-radius: var(--radius-xl);
        padding: var(--space-6);
      }

      .tips-card h3 {
        font-size: var(--fs-base);
        font-weight: 600;
        color: var(--color-brand);
        margin: 0 0 var(--space-4) 0;
        display: flex;
        align-items: center;
        gap: var(--space-2);
      }

      .tips-card h3 i {
        width: 18px;
        height: 18px;
      }

      .tip-item {
        font-size: var(--fs-sm);
        color: var(--color-text-muted);
        line-height: 1.6;
        margin-bottom: var(--space-3);
        padding-left: var(--space-5);
        position: relative;
      }

      .tip-item:before {
        content: "•";
        position: absolute;
        left: 0;
        color: var(--color-brand);
        font-weight: 700;
      }

      .tip-item:last-child {
        margin-bottom: 0;
      }

      .quiz-actions {
        display: flex;
        gap: var(--space-4);
        margin-top: var(--space-6);
      }

      .quiz-actions .c-btn {
        flex: 1;
        padding: var(--space-4) var(--space-6);
        font-size: var(--fs-base);
        font-weight: 600;
        border-radius: var(--radius-lg);
        transition: all 0.25s ease;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: var(--space-2);
      }

      .quiz-actions .c-btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 16px rgba(0, 0, 0, 0.12);
      }

      .quiz-actions .c-btn i {
        width: 18px;
        height: 18px;
      }

      .correct-answer-hint {
        font-size: var(--fs-sm);
        color: var(--color-text-muted);
        margin-top: var(--space-5);
        padding: var(--space-4) var(--space-5);
        background: linear-gradient(
          135deg,
          rgba(84, 44, 245, 0.06) 0%,
          rgba(84, 44, 245, 0.02) 100%
        );
        border: 1px solid rgba(84, 44, 245, 0.2);
        border-radius: var(--radius-md);
        display: flex;
        align-items: center;
        gap: var(--space-3);
        line-height: 1.6;
      }

      .correct-answer-hint i {
        width: 16px;
        height: 16px;
        color: var(--color-brand);
        flex-shrink: 0;
      }

      .c-field {
        margin-bottom: var(--space-5);
      }

      .c-field .c-label {
        font-weight: 600;
        font-size: var(--fs-sm);
        margin-bottom: var(--space-3);
        color: var(--color-text);
        display: flex;
        align-items: center;
        gap: var(--space-2);
      }

      .c-field .c-input,
      .c-field textarea {
        font-size: var(--fs-base);
        padding: var(--space-4);
        border: 2px solid var(--color-border);
        border-radius: var(--radius-md);
        transition: all 0.2s ease;
      }

      .c-field .c-input:focus,
      .c-field textarea:focus {
        border-color: var(--color-brand);
        box-shadow: 0 0 0 4px rgba(84, 44, 245, 0.08);
      }

      .field-row {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: var(--space-5);
      }

      @media (max-width: 1024px) {
        .quiz-container {
          grid-template-columns: 1fr;
        }

        .quiz-sidebar {
          position: static;
          order: -1;
        }

        .field-row {
          grid-template-columns: 1fr;
        }
      }

      @media (max-width: 768px) {
        .quiz-form-card {
          padding: var(--space-6);
        }

        .question-card {
          padding: var(--space-6);
        }

        .question-header {
          flex-direction: column;
          align-items: flex-start;
          gap: var(--space-4);
        }

        .quiz-actions {
          flex-direction: column;
          padding-top: var(--space-6);
          margin-top: var(--space-6);
        }

        .quiz-actions .c-btn {
          width: 100%;
        }

        .answer-option {
          padding: var(--space-4);
        }

        .btn-add-question {
          padding: var(--space-5);
          font-size: var(--fs-base);
        }
      }
    </style>
    <header class="c-page__header">
        <nav class="c-breadcrumbs" aria-label="Breadcrumb">
            <a href="${pageContext.request.contextPath}/student/dashboard">Home</a>
            <span class="c-breadcrumbs__sep">/</span>
            <a href="${pageContext.request.contextPath}/student/quizzes">Quizzes</a>
            <span class="c-breadcrumbs__sep">/</span>
            <span aria-current="page">Create Quiz</span>
        </nav>
        <div>
            <h1 class="c-page__title">Create Quiz</h1>
            <p class="c-page__subtitle u-text-muted">
              Create interactive quizzes to help your peers practice and learn.
            </p>
          </div>
       
    </header>

    <c:if test="${not empty error}">
        <div class="c-alert c-alert--danger" role="alert">
            <p>${error}</p>
        </div>
    </c:if>

        <div class="quiz-container">
          <!-- Main Content -->
          <div class="quiz-main">
            <!-- Quiz Details -->
            <div class="quiz-form-card">
              <div class="quiz-form-header">
                <div class="quiz-form-header-content">
                  <h2>Quiz Details</h2>
                  <p>Set up the basic information for your quiz</p>
                </div>
                <span class="section-badge">
                  <i data-lucide="info"></i>
                  Step 1
                </span>
              </div>

              <form id="quiz-form" action="${pageContext.request.contextPath}/student/quizzes/create" method="POST">
                <div class="c-field">
                  <label for="quiz-title" class="c-label">
                    <i
                      data-lucide="file-text"
                      style="width: 16px; height: 16px"
                    ></i>
                    Quiz Title <span class="u-text-danger">*</span>
                  </label>
                  <input
                    type="text"
                    id="quiz-title"
                    name="title"
                    class="c-input c-input--soft c-input--rect"
                    placeholder="e.g., Data Structures & Algorithms - Mid-Term Practice"
                    required
                  />
                </div>

                <div class="c-field">
                  <label for="quiz-description" class="c-label">
                    <i
                      data-lucide="align-left"
                      style="width: 16px; height: 16px"
                    ></i>
                    Description
                  </label>
                  <textarea
                    id="quiz-description"
                    name="description"
                    class="c-input c-input--soft c-input--rect"
                    rows="4"
                    placeholder="Provide a brief overview of what this quiz covers, difficulty level, and any prerequisites..."
                  ></textarea>
                </div>

                <div class="field-row">
                  <div class="c-field">
                    <label for="quiz-subject" class="c-label">
                      <i
                        data-lucide="book-open"
                        style="width: 16px; height: 16px"
                      ></i>
                      Subject <span class="u-text-danger">*</span>
                    </label>
                    <select
                      id="quiz-subject"
                      name="subjectId"
                      class="c-input c-input--soft c-input--rect"
                      required
                    >
                      <option value="">Select subject</option>
                      <c:forEach var="subject" items="${subjects}">
                        <option value="${subject.subjectId}">${subject.name}</option>
                      </c:forEach>
                    </select>
                  </div>

                  <div class="c-field">
                    <label for="quiz-duration" class="c-label">
                      <i
                        data-lucide="clock"
                        style="width: 16px; height: 16px"
                      ></i>
                      Duration (minutes)
                    </label>
                    <input
                      type="number"
                      id="quiz-duration"
                      name="duration"
                      class="c-input c-input--soft c-input--rect"
                      placeholder="30"
                      value="30"
                      min="1"
                      max="180"
                    />
                  </div>
                </div>

                <!-- Questions Section -->
                <div class="questions-section">
                  <div class="questions-header">
                    <h3>Questions</h3>
                    <span class="questions-count" id="questions-count">0</span>
                  </div>

                  <div id="questions-container">
                    <!-- Questions will be added here -->
                  </div>

                  <!-- Add Question Button -->
                  <button
                    type="button"
                    class="btn-add-question"
                    onclick="addQuestion()"
                  >
                    <i data-lucide="plus-circle"></i>
                    Add New Question
                  </button>
                </div>
              </form>
          </div>

          <!-- Sidebar -->
          <div class="quiz-sidebar">
            <!-- Progress Card -->
            <div class="progress-card">
              <h3>
                <i data-lucide="list-checks"></i>
                Quiz Progress
              </h3>
              <div class="progress-item">
                <span class="progress-label">Title</span>
                <span class="progress-value" id="progress-title">—</span>
              </div>
              <div class="progress-item">
                <span class="progress-label">Subject</span>
                <span class="progress-value" id="progress-subject">—</span>
              </div>
              <div class="progress-item">
                <span class="progress-label">Questions</span>
                <span class="progress-value" id="progress-questions">0</span>
              </div>
              <div class="progress-item">
                <span class="progress-label">Status</span>
                <span class="progress-value is-incomplete" id="progress-status"
                  >Incomplete</span
                >
              </div>
            </div>

            <!-- Tips Card -->
            <div class="tips-card">
              <h3>
                <i data-lucide="lightbulb"></i>
                Quick Tips
              </h3>
              <div class="tip-item">Write clear, concise questions</div>
              <div class="tip-item">Add at least 4 answer options</div>
              <div class="tip-item">Mark the correct answer</div>
              <div class="tip-item">Review before publishing</div>
            </div>

            <!-- Actions -->
            <div class="quiz-actions">
              <button
                type="button"
                class="c-btn c-btn--ghost"
                onclick="saveDraft()"
              >
                <i data-lucide="save"></i>
                Draft
              </button>
              <button type="button" class="c-btn" onclick="publishQuiz()">
                <i data-lucide="send"></i>
                Publish
              </button>
            </div>
          </div>
        </div>
<script src="${pageContext.request.contextPath}/static/q.js"></script>
</layout:student-dashboard>
