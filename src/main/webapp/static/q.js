let questions = [];
let questionIdCounter = 1;

document.addEventListener("DOMContentLoaded", function () {
  if (window.lucide) window.lucide.createIcons();
  // Add first question by default
  addQuestion();

  // Update progress on input changes
  document
    .getElementById("quiz-title")
    .addEventListener("input", updateProgress);
  document
    .getElementById("quiz-subject")
    .addEventListener("change", updateProgress);
});

function addQuestion() {
  const question = {
    id: questionIdCounter++,
    text: "",
    options: [
      { id: 1, text: "", isCorrect: false },
      { id: 2, text: "", isCorrect: false },
      { id: 3, text: "", isCorrect: false },
      { id: 4, text: "", isCorrect: false },
    ],
  };
  questions.push(question);
  renderQuestions();
}

function removeQuestion(id) {
  if (questions.length === 1) {
    alert("You must have at least one question!");
    return;
  }
  questions = questions.filter((q) => q.id !== id);
  renderQuestions();
}

function addOption(questionId) {
  const question = questions.find((q) => q.id === questionId);
  if (question.options.length >= 6) {
    alert("Maximum 6 options per question");
    return;
  }
  const newId = Math.max(...question.options.map((o) => o.id)) + 1;
  question.options.push({ id: newId, text: "", isCorrect: false });
  renderQuestions();
}

function removeOption(questionId, optionId) {
  const question = questions.find((q) => q.id === questionId);
  if (question.options.length <= 2) {
    alert("You must have at least 2 options!");
    return;
  }
  question.options = question.options.filter((o) => o.id !== optionId);
  renderQuestions();
}

function updateQuestionText(questionId, text) {
  const question = questions.find((q) => q.id === questionId);
  question.text = text;
}

function updateOptionText(questionId, optionId, text) {
  const question = questions.find((q) => q.id === questionId);
  const option = question.options.find((o) => o.id === optionId);
  option.text = text;
}

function setCorrectAnswer(questionId, optionId) {
  const question = questions.find((q) => q.id === questionId);
  question.options.forEach((o) => {
    o.isCorrect = o.id === optionId;
  });
}

function renderQuestions() {
  const container = document.getElementById("questions-container");
  container.innerHTML = questions
    .map(
      (question, index) => `
          <div class="question-card">
            <div class="question-header">
              <div class="question-number">
                <span class="question-badge">${index + 1}</span>
                <span>Question ${index + 1}</span>
              </div>
              <div class="question-actions">
                <button 
                  type="button" 
                  class="btn-icon" 
                  onclick="removeQuestion(${question.id})"
                  title="Delete question"
                >
                  <i data-lucide="trash-2"></i>
                </button>
              </div>
            </div>

            <div class="question-content">
              <div class="c-field">
                <label class="c-label">
                  <i data-lucide="help-circle" style="width: 14px; height: 14px;"></i>
                  Question <span class="u-text-danger">*</span>
                </label>
                <textarea
                  name="q${index + 1}_text"
                  class="c-input c-input--soft c-input--rect"
                  rows="3"
                  placeholder="Write a clear and concise question that tests student understanding..."
                  onchange="updateQuestionText(${question.id}, this.value)"
                  required
                >${question.text}</textarea>
              </div>

              <div class="field-row">
                <div class="c-field">
                  <label class="c-label">Points</label>
                  <input type="number" name="q${index + 1}_points" class="c-input" value="1" min="1" max="10">
                </div>
              </div>

              <div class="c-field">
                <label class="c-label">
                  <i data-lucide="list" style="width: 14px; height: 14px;"></i>
                  Answer Options <span class="u-text-danger">*</span>
                </label>
                <div class="answer-options-wrapper">
                  ${question.options
                    .map(
                      (option, optIdx) => `
                    <div class="answer-option ${
                      option.isCorrect ? "is-correct" : ""
                    }">
                      <span class="answer-label">${String.fromCharCode(
                        65 + optIdx
                      )}</span>
                      <input
                        type="text"
                        name="q${index + 1}_opt${optIdx + 1}_text"
                        placeholder="Enter option ${String.fromCharCode(
                          65 + optIdx
                        )}"
                        value="${option.text}"
                        onchange="updateOptionText(${question.id}, ${
                        option.id
                      }, this.value)"
                        required
                      />
                      <input
                        type="radio"
                        name="q${index + 1}_correct"
                        value="opt${optIdx + 1}"
                        ${option.isCorrect ? "checked" : ""}
                        onchange="setCorrectAnswer(${question.id}, ${
                        option.id
                      })"
                        title="Mark as correct answer"
                        required
                      />
                      ${
                        question.options.length > 2
                          ? `<button 
                          type="button" 
                          class="btn-icon" 
                          onclick="removeOption(${question.id}, ${option.id})"
                          style="margin-left: auto"
                        >
                          <i data-lucide="x"></i>
                        </button>`
                          : ""
                      }
                    </div>
                  `
                    )
                    .join("")}
                  
                  ${
                    question.options.length < 6
                      ? `<button type="button" class="btn-add-option" onclick="addOption(${question.id})">
                      <i data-lucide="plus"></i>
                      Add Option
                    </button>`
                      : ""
                  }
                </div>

                <div class="correct-answer-hint">
                  <i data-lucide="info"></i>
                  <span>Select the radio button next to the correct answer option. Each question must have exactly one correct answer.</span>
                </div>
              </div>
            </div>
          </div>
        `
    )
    .join("");

  // Update count
  document.getElementById("questions-count").textContent = questions.length;

  if (window.lucide) window.lucide.createIcons();
  updateProgress();
}

function updateProgress() {
  const title = document.getElementById("quiz-title").value;
  const subject = document.getElementById("quiz-subject").value;
  const subjectText =
    document.querySelector(`#quiz-subject option[value="${subject}"]`)
      ?.textContent || "—";

  document.getElementById("progress-title").textContent = title || "—";
  document.getElementById("progress-subject").textContent = subjectText;
  document.getElementById("progress-questions").textContent = questions.length;

  const isComplete = title && subject && questions.length > 0;
  const statusEl = document.getElementById("progress-status");
  statusEl.textContent = isComplete ? "Ready" : "Incomplete";
  statusEl.className = `progress-value ${
    isComplete ? "is-complete" : "is-incomplete"
  }`;
}

function saveDraft() {
  const quizData = {
    title: document.getElementById("quiz-title").value,
    description: document.getElementById("quiz-description").value,
    subject: document.getElementById("quiz-subject").value,
    duration: document.getElementById("quiz-duration").value,
    questions: questions,
    status: "draft",
    createdAt: new Date().toISOString(),
  };

  localStorage.setItem("quiz-draft", JSON.stringify(quizData));
  showToast("Draft saved successfully!", "success");
}

function publishQuiz() {
  const form = document.getElementById("quiz-form");
  const title = document.getElementById("quiz-title").value;
  const subject = document.getElementById("quiz-subject").value;

  if (!title || !subject) {
    showToast("Please fill in all required fields!", "error");
    return;
  }

  if (questions.length === 0) {
    showToast("Please add at least one question!", "error");
    return;
  }

  // Validate all questions
  for (let i = 0; i < questions.length; i++) {
    const q = questions[i];
    if (!q.text) {
      showToast(`Question ${i + 1} is empty!`, "error");
      return;
    }
    if (q.options.some((o) => !o.text)) {
      showToast(`Question ${i + 1} has empty options!`, "error");
      return;
    }
    if (!q.options.some((o) => o.isCorrect)) {
      showToast(`Question ${i + 1} has no correct answer selected!`, "error");
      return;
    }
  }

  showToast("Publishing quiz...", "info");
  form.submit();
}

function showToast(message, type = "success") {
  const toast = document.createElement("div");
  toast.className = "c-toast";
  toast.style.cssText = `
          position: fixed;
          bottom: 24px;
          right: 24px;
          background: ${type === "success" ? "#10b981" : "#ef4444"};
          color: white;
          padding: 16px 24px;
          border-radius: 8px;
          box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
          z-index: 1000;
          animation: slideIn 0.3s ease;
        `;
  toast.textContent = message;
  document.body.appendChild(toast);

  setTimeout(() => {
    toast.remove();
  }, 3000);
}
