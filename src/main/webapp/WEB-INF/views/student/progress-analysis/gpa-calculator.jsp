<%@ page contentType="text/html;charset=UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
      <%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>

        <layout:student-dashboard pageTitle="Progress Analysis" activePage="progress">
          <jsp:body>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/static/app.css" />
            <style>
              /* Minimal, scoped tweaks for GPA Calculator */

              /* Soft table variant inside panel */
              .c-table--soft thead th {
                font-weight: var(--fw-medium);
                color: var(--color-text-muted);
              }

              .c-table--soft td,
              .c-table--soft th {
                padding: 10px 12px;
              }

              /* Inline inputs within table */
              .c-input--table {
                height: 34px;
                padding: 6px 10px;
                border-radius: var(--radius-md);
              }

              /* Summary GPA boxes */
              .c-gpa-box {
                background: var(--color-surface);
                border: 1px solid var(--color-border);
                border-radius: var(--radius-lg);
                padding: var(--space-6);
                font-size: 1.75rem;
                font-weight: var(--fw-semibold);
              }

              /* Actions */
              .c-actions {
                margin-top: var(--space-6);
                display: flex;
                gap: var(--space-3);
              }

              /* Panel table wrapper spacing */
              .c-table-wrap {
                margin-top: var(--space-3);
                border: 1px solid var(--color-border);
                border-radius: var(--radius-lg);
                overflow: hidden;
              }

              /* Make chips used in milestones usable here if needed */
              .c-chip.is-active {
                background: var(--color-brand-soft);
                color: var(--color-text);
              }

              /* Split layout: table left, summary right */
              .gpa-layout {
                display: grid;
                grid-template-columns: 2fr 1fr;
                gap: var(--space-6);
              }

              @media (max-width: 1000px) {
                .gpa-layout {
                  grid-template-columns: 1fr;
                }
              }

              /* Definition list compact rows */
              .c-definition {
                display: grid;
                gap: var(--space-2);
              }

              .c-definition__row {
                display: grid;
                grid-template-columns: 1fr auto;
                align-items: center;
                padding: 6px 0;
                border-bottom: 1px solid var(--color-border);
              }

              .c-definition__row:last-child {
                border-bottom: 0;
              }

              .c-definition dt {
                color: var(--color-text-muted);
                font-size: var(--fs-sm);
              }

              .c-definition dd {
                margin: 0;
                font-weight: var(--fw-medium);
              }

              /* Donut gauge using conic gradient */
              .c-gauge {
                --gpa-pct: 0%;
                width: 180px;
                height: 180px;
                margin-inline: auto;
                position: relative;
                display: grid;
                place-items: center;
              }

              .c-gauge__ring {
                width: 100%;
                height: 100%;
                border-radius: 50%;
                background: conic-gradient(var(--color-brand) var(--gpa-pct),
                    var(--color-border) 0);
                -webkit-mask: radial-gradient(circle 64px at 50% 50%,
                    transparent 65px,
                    black 66px);
                mask: radial-gradient(circle 64px at 50% 50%, transparent 65px, black 66px);
              }

              .c-gauge__value {
                position: absolute;
                font-size: 1.75rem;
                font-weight: var(--fw-semibold);
              }

              .c-guide {
                margin-top: var(--space-6);
              }

              .c-guide .c-list {
                list-style: none;
                padding: 0;
                padding-left: 0;
                margin-left: 0;
                margin: 0;
                display: grid;
                gap: var(--space-2);
              }

              .c-list li {
                display: grid;
                grid-template-columns: 20px 1fr;
                gap: var(--space-2);
                align-items: start;
              }

              .c-guide .c-list i {
                color: var(--color-brand);
              }

              /* Conversion table styling inside guide */
              .c-guide table {
                border: 1px solid var(--color-border);
                border-radius: var(--radius-xl);
                overflow: hidden;
              }

              .c-guide thead th {
                background: var(--color-surface);
                font-weight: var(--fw-medium);
              }

              .c-guide tbody tr+tr td {
                border-top: 1px solid var(--color-border);
              }
            </style>

            <header class="c-page__header">
              <nav class="c-breadcrumbs" aria-label="Breadcrumb">
                <a href="${pageContext.request.contextPath}/student/dashboard">Home</a>
                <span class="c-breadcrumbs__sep">/</span>
                <a href="${pageContext.request.contextPath}/student/progress-analysis">Progress Analysis</a>
                <span class="c-breadcrumbs__sep">/</span>
                <a href="${pageContext.request.contextPath}/student/progress-analysis">GPA Calculator</a>

              </nav>
            </header>

            <c:if test="${not empty error}">
              <div class="c-alert c-alert--danger" role="alert">
                <p>${error}</p>
              </div>
            </c:if>

            <div class="comm-layout">
              <div class="c-page">
                <header class="c-page__header">

                  <div>
                    <h1 class="c-page__title">GPA Calculator</h1>
                    <p class="c-page__subtitle u-text-muted">
                      Track your academic performance and stay on top of your goals.
                    </p>
                  </div>
                </header>

                <div class="gpa-layout">
                  <!-- Left: Subjects table -->
                  <section class="c-panel">
                    <div class="c-panel__header">
                      <div class="o-inline o-inline--gap-3">
                        <div class="c-field" style="margin: 0">
                          <label class="c-field__label">Year</label>
                          <select class="c-input js-gpa-year"></select>
                        </div>
                        <div class="c-field" style="margin: 0">
                          <label class="c-field__label">Semester</label>
                          <select class="c-input js-gpa-semester"></select>
                        </div>
                      </div>
                    </div>

                    <div class="c-table-wrap">
                      <table class="c-table c-table--soft" id="gpa-table">
                        <thead>
                          <tr>
                            <th style="width: 48px">#</th>
                            <th>Course Name</th>
                            <th>Grade</th>
                            <th>Credits</th>
                            <th>Course Type</th>
                          </tr>
                        </thead>
                        <tbody id="gpa-rows">
                          <!-- Rendered by JS -->
                        </tbody>
                      </table>
                    </div>

                    <div class="c-actions">
                      <button class="c-btn js-save-gpa">
                        <i data-lucide="save"></i> Save GPA Record
                      </button>
                    </div>
                  </section>

                  <!-- Right: Summary + gauge -->
                  <aside class="c-panel" style="height: fit-content">
                    <div class="c-panel__header">
                      <h3 class="c-section-title" style="margin: 0">
                        Current GPA (optional)
                      </h3>
                    </div>
                    <div class="u-stack-4">
                      <dl class="c-definition">
                        <div class="c-definition__row">
                          <dt>Cumulative</dt>
                          <dd><span class="js-cum-gpa">0.00</span></dd>
                        </div>
                        <div class="c-definition__row">
                          <dt>Semester 1</dt>
                          <dd>
                            <span class="js-term-gpa" data-term="Semester 1">0.00</span>
                          </dd>
                        </div>
                        <div class="c-definition__row">
                          <dt>Semester 2</dt>
                          <dd>
                            <span class="js-term-gpa" data-term="Semester 2">0.00</span>
                          </dd>
                        </div>
                      </dl>
                      <div class="c-gauge" role="img" aria-label="Cumulative GPA">
                        <div class="c-gauge__ring"></div>
                        <div class="c-gauge__value">
                          <span class="js-cum-gpa">0.00</span>
                        </div>
                      </div>
                    </div>
                  </aside>
                </div>

                <!-- How to use + Letter grade conversion -->
                <section class="c-panel c-guide">
                  <h2 class="c-section-title" style="margin-top: 0">
                    How to use the GPA Calculator
                  </h2>
                  <div class="o-grid" style="--grid-cols: 2">
                    <div class="u-stack-3">
                      <ul class="c-list">
                        <li>
                          <i data-lucide="check-circle-2" aria-hidden="true"></i>
                          Choose a Year and Semester, then select your letter grade for
                          each subject.
                        </li>
                        <li>
                          <i data-lucide="check-circle-2" aria-hidden="true"></i>
                          Your GPA updates automatically; your selections are saved
                          locally on this device.
                        </li>
                        <li>
                          <i data-lucide="check-circle-2" aria-hidden="true"></i>
                          The conversion table uses your institution’s scale.
                        </li>
                      </ul>
                    </div>
                    <div>
                      <table class="c-table c-table--soft">
                        <thead>
                          <tr>
                            <th>Letter Grade</th>
                            <th>Grade Point</th>
                          </tr>
                        </thead>
                        <tbody id="gpa-scale-body">
                          <!-- Populated by JS -->
                        </tbody>
                      </table>
                    </div>
                  </div>
                </section>
              </div>

            </div>
            <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>


            <script>
              // Inject server-side data (Years, Semesters, Scale)
              window.UniNest = window.UniNest || {};

              // Safe injection with fallback
              var rawData = '${gpaDataJson}';
              if (rawData && rawData.trim() !== '') {
                try {
                  window.UniNest.gpaData = JSON.parse(rawData);
                  console.log("UniqueNest: Loaded server GPA data", window.UniNest.gpaData);
                } catch (e) {
                  console.error("UniqueNest: Failed to parse server GPA data", e);
                }
              } else {
                console.warn("UniqueNest: No server GPA data found (gpaDataJson is empty). using Demo Data.");
              }
            </script>

            <script>
              document.addEventListener("DOMContentLoaded", function () {
                if (window.lucide) window.lucide.createIcons();
                if (window.UniNest && window.UniNest.gpa) {
                  // window.UniNest.gpa.initGpaCalculator(); // Custom logic below handles this
                }
              });
            </script>
            <script>
              document.addEventListener("DOMContentLoaded", function () {
                const yearSel = document.querySelector(".js-gpa-year");
                const semSel = document.querySelector(".js-gpa-semester");
                const tbody = document.getElementById("gpa-rows");
                const saveBtn = document.querySelector(".js-save-gpa");

                // Initialize selectors
                const years = [1, 2, 3, 4];
                const semesters = [1, 2];

                yearSel.innerHTML = years.map(y => '<option value="' + y + '">Year ' + y + '</option>').join("");
                semSel.innerHTML = semesters.map(s => '<option value="' + s + '">Semester ' + s + '</option>').join("");

                // Grade Scale
                const scale = {
                  "A+": 4.0, "A": 4.0, "A-": 3.7,
                  "B+": 3.3, "B": 3.0, "B-": 2.7,
                  "C+": 2.3, "C": 2.0, "C-": 1.7,
                  "D": 1.0, "F": 0.0
                };

                const STORAGE_KEY = "uninest-gpa-grades-dynamic";

                function loadGrades() {
                  try { return JSON.parse(localStorage.getItem(STORAGE_KEY) || "{}"); }
                  catch (e) { return {}; }
                }

                function saveGrades(data) {
                  localStorage.setItem(STORAGE_KEY, JSON.stringify(data));
                }

                function getGradeOptions(selected) {
                  return '<option value="">-</option>' +
                    Object.keys(scale).map(g =>
                      '<option value="' + g + '" ' + (g === selected ? 'selected' : '') + '>' + g + '</option>'
                    ).join("");
                }

                function fetchAndRender() {
                  const y = yearSel.value;
                  const s = semSel.value;
                  if (!y || !s) return;

                  tbody.innerHTML = '<tr><td colspan="5" style="text-align:center;">Loading subjects...</td></tr>';

                  fetch('${pageContext.request.contextPath}/student/api/subjects?year=' + y + '&semester=' + s)
                    .then(res => {
                        if (res.status === 401) {
                            throw new Error("Session expired. Please login again.");
                        }
                        if (!res.ok) {
                            throw new Error("Server returned " + res.status);
                        }
                        return res.text().then(text => {
                            try {
                                return JSON.parse(text);
                            } catch (e) {
                                throw new Error("Invalid response format");
                            }
                        });
                    })
                    .then(subjects => {
                      if (!Array.isArray(subjects) || subjects.length === 0) {
                        tbody.innerHTML = '<tr><td colspan="5" style="text-align:center;">No subjects found for this semester.</td></tr>';
                        return;
                      }

                      const grades = loadGrades();
                      const termKey = y + '-' + s;
                      const termGrades = grades[termKey] || {};

                      tbody.innerHTML = subjects.map((subj, idx) =>
                        '<tr data-code="' + subj.code + '" data-credits="' + subj.credits + '">' +
                        '<td>' + (idx + 1) + '</td>' +
                        '<td>' +
                        '<div style="font-weight:500;">' + subj.code + '</div>' +
                        '<div class="u-text-muted" style="font-size:0.9em;">' + subj.name + '</div>' +
                        '</td>' +
                        '<td>' +
                        '<select class="c-input c-input--table js-grade-select">' +
                        getGradeOptions(termGrades[subj.code]) +
                        '</select>' +
                        '</td>' +
                        '<td>' + subj.credits + '</td>' +
                        '<td>Regular</td>' +
                        '</tr>'
                      ).join("");

                      // Re-bind events
                      tbody.querySelectorAll(".js-grade-select").forEach(sel => {
                        sel.addEventListener("change", () => {
                          saveCurrentState();
                          calcGpa();
                        });
                      });
                      calcGpa();
                    })
                    .catch(err => {
                      console.error(err);
                      let msg = "Error loading subjects.";
                      if (err.message.includes("Session expired")) {
                          msg = 'Session expired. <a href="${pageContext.request.contextPath}/login">Login</a>';
                      } else if (err.message.includes("Server returned")) {
                         msg = err.message;
                      }
                      tbody.innerHTML = '<tr><td colspan="5" style="text-align:center; color:red;">' + msg + '</td></tr>';
                    });
                }

                function saveCurrentState() {
                  const y = yearSel.value;
                  const s = semSel.value;
                  const data = loadGrades();
                  const termKey = y + '-' + s;

                  data[termKey] = {};

                  tbody.querySelectorAll("tr").forEach(tr => {
                    const code = tr.getAttribute("data-code");
                    const val = tr.querySelector(".js-grade-select").value;
                    if (code && val) {
                      data[termKey][code] = val;
                    }
                  });
                  saveGrades(data);
                }

                function calcGpa() {
                  // Simple calculation for current view (demo purpose, can be expanded)
                  let totalPoints = 0;
                  let totalCredits = 0;

                  tbody.querySelectorAll("tr").forEach(tr => {
                    const credits = parseFloat(tr.getAttribute("data-credits")) || 0;
                    const val = tr.querySelector(".js-grade-select").value;
                    const points = scale[val];

                    if (val && points !== undefined) {
                      totalPoints += points * credits;
                      totalCredits += credits;
                    }
                  });

                  const gpa = totalCredits > 0 ? (totalPoints / totalCredits).toFixed(2) : "0.00";

                  // Update display (targeting the specific term span for now)
                  // Note: A full implementation would calculate all terms. 
                  // For this task, we focus on fetching and displaying subjects.
                  console.log("Current Term GPA:", gpa);
                }

                yearSel.addEventListener("change", fetchAndRender);
                semSel.addEventListener("change", fetchAndRender);

                // Initial load
                fetchAndRender();



              });
            </script>
          </jsp:body>

        </layout:student-dashboard>